//
//  mgAlimConfigVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAlimConfigVC.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "AppDelegate.h"

@interface mgAlimConfigVC ()

@end

@implementation mgAlimConfigVC
{
    NSURLConnection *conn;
    NSMutableData *_receiveData;
}

@synthesize _swUsageAnsAlarm, _swUsageMsgAlarm, _swUsageProgAlarm, _swUsageLecEndAlarm, _swUsageLecInfoAlarm;
@synthesize alimNavigationBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [alimNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    alimNavigationBar.translucent = NO;
    [alimNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                              [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                              [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    [self DataToView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)DataToView{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    _swUsageAnsAlarm.on = _app._config._bUsageAnsAlarm;
    _swUsageMsgAlarm.on = _app._config._bUsageMsgAlarm;
    _swUsageProgAlarm.on = _app._config._bUsageProgAlarm;
    _swUsageLecEndAlarm.on = _app._config._bUsageLecEndAlarm;
    _swUsageLecInfoAlarm.on = _app._config._bUsageLecInfoAlarm;
}

- (void)SaveToServer
{
    // 서버에 dday 설정을 보낸다.
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_CONFIG_SET];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]                           forKey:@"acc_key"];
    [dic setObject:_app._config._bUsageAnsAlarm ? @"Y":@"N"             forKey:@"noti_ans"];
    [dic setObject:_app._config._bUsageMsgAlarm ? @"Y":@"N"             forKey:@"noti_paper"];
    [dic setObject:_app._config._bUsageProgAlarm ? @"Y":@"N"            forKey:@"noti_progress"];
    [dic setObject:_app._config._bUsageLecEndAlarm ? @"Y":@"N"          forKey:@"noti_chr_end"];
    [dic setObject:_app._config._bUsageLecInfoAlarm ? @"Y":@"N"         forKey:@"noti_class_info"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (nil != conn){
        _receiveData = [[NSMutableData alloc] init];
    }else{
        [_receiveData setLength:0];
    }
}

- (IBAction)toggleUsageAnsAlarm:(id)sender {
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageAnsAlarm:_swUsageAnsAlarm.on];
    [self SaveToServer];
}

- (IBAction)toggleUsageMsgAlarm:(id)sender {
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageMsgAlarm:_swUsageMsgAlarm.on];
    [self SaveToServer];
}

- (IBAction)toggleUsageProgAlarm:(id)sender {
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageProgAlarm:_swUsageProgAlarm.on];
    [self SaveToServer];
}

- (IBAction)toggleUsageLecEndAlarm:(id)sender {
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageLecEndAlarm:_swUsageLecEndAlarm.on];
    [self SaveToServer];
}

- (IBAction)toggleUsageLecInfoAlarm:(id)sender {
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageLecInfoAlarm:_swUsageLecInfoAlarm.on];
    [self SaveToServer];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (NSArray *)generatorParameters:(NSDictionary *)param{
    // 임시 배열을 생성한 후
    // 모든 key 값을 받와 해당 키값으로 값을 반환하고
    // 해당 키와 값을 임시 배열에 저장 후 반환하는 함수
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:[param count]];
    
    NSArray * allKeys = [param allKeys];
    
    for (NSString * key in allKeys){
        NSString * value = [param objectForKey:key];
        [result addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    return result;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection == conn) {
        [_receiveData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == conn) {
        NSString *encodeData = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            //NSLog(@"저장");
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}

//
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

#pragma mark -
#pragma 회전 관련

- (BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end

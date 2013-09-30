//
//  mgSearchMathVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchMathVC.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "mgSearchCategory2VC.h"

@implementation mgSearchMathVC

@synthesize mathTableView;
@synthesize _sLecdomCd;
@synthesize _sLecqOrd;
@synthesize _sLecqCd;
@synthesize _sLecPageType;
@synthesize _sLecTecCd;
@synthesize _naviTitle;
@synthesize _sLecCategory;
@synthesize _sLecSection;
@synthesize mathNavigationBar;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initLoadBar];
    [self startLoadBar];
    
    [mathNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    mathNavigationBar.translucent = NO;
    [mathNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    mathArr = [[NSMutableArray alloc] init];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_SEARCH_LIST];
    //NSLog(@"%@", url);
    //NSLog(@"%@", [_app._account getAcc_key]);
    //NSLog(@"%@", _sLecdomCd);
    //NSLog(@"%@", _sLecqCd);
    //NSLog(@"%@", _sLecqOrd);
    //NSLog(@"%@", _sLecPageType);
    //NSLog(@"%@", _sLecTecCd);
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]               forKey:@"acc_key"];
    [dic setObject:_sLecdomCd                               forKey:@"domCd"];
    [dic setObject:_sLecPageType                            forKey:@"pageType"];
    [dic setObject:_sLecqCd                                 forKey:@"qCd"];
    [dic setObject:_sLecqOrd                                forKey:@"qOrd"];
    [dic setObject:_sLecTecCd                               forKey:@"qTecCd"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnSearchMath = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnSearchMath){
        mathData = [[NSMutableData alloc] init];
    }
}

- (void)viewDidUnload {
    [self setMathTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectIndex = [mathTableView indexPathForSelectedRow];
    [mathTableView deselectRowAtIndexPath:selectIndex animated:YES];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView DataSrouce & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mathArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"mathCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dic = [mathArr objectAtIndex:indexPath.row];
    //NSLog(@"%@", dic);
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = [dic valueForKey:@"qNM"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -
#pragma mark NSURLConnection

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
    if (connection == urlConnSearchMath) {
        [mathData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    connection = nil;
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnSearchMath) {
        NSString *encodeData = [[NSString alloc] initWithData:mathData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", encodeData);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"Math_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"Math_msg : %@", [dic valueForKey:@"msg"]);
        //NSLog(@"Math_dic : %@", dic);
        
        if(dic == nil){
            return;
            
        }
        NSMutableArray *menuDataArr = [dic valueForKey:@"menuData"];
        
        NSDictionary *menuNM = [menuDataArr objectAtIndex:0];
        
        mathArr = [menuNM valueForKey:@"subData"];
        
        [self endLoadBar];
        
        if([mathArr count] == 0){
            return;
        }
        
        [mathTableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([@"sgStep1" isEqualToString:segue.identifier])
    {
        mgSearchCategory2VC* nextVC = (mgSearchCategory2VC*)segue.destinationViewController;
        
        UITableViewCell *tvc = (UITableViewCell*)sender;
        NSIndexPath *selectedIndexPath = [mathTableView indexPathForCell:tvc];
        NSInteger row = selectedIndexPath.row;
    
        NSDictionary *dic = [mathArr objectAtIndex:row];
        
        nextVC._sLecPageType = _sLecPageType;
        nextVC._sLecdomCd = _sLecdomCd;
        nextVC._sLecqCd = [dic valueForKey:@"qCd"];
        nextVC._sLecqOrd = [dic valueForKey:@"qOrd"];
        nextVC._sLecqTecCd = _sLecTecCd;

        _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
        nextVC._naviTitle = _naviTitle;
    }
}

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

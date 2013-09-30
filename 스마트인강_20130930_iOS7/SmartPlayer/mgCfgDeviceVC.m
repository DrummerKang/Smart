//
//  mgDeviceVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 22..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgCfgDeviceVC.h"
#import "SBJsonParser.h"
#import "JSON.h"
#import "mgGlobal.h"
#import "mgCommon.h"

@interface mgCfgDeviceVC ()

@end

@implementation mgCfgDeviceVC

@synthesize deviceTable;
@synthesize _noBgImage;
@synthesize deviceNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        
    }else{
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            
        }else{
            deviceTable.frame = CGRectMake(0, 44, 320, 416);
        }
    }

    [deviceNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    deviceNavigationBar.translucent = NO;
    [deviceNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    deviceArr = [[NSMutableArray alloc] init];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_DEVICE_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnDeviceList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
   
    if (nil != urlConnDeviceList){
        deviceData  = [[NSMutableData alloc] init];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setDeviceTable:nil];
    [self set_noBgImage:nil];
    [super viewDidUnload];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [deviceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"deviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dic = [deviceArr objectAtIndex:indexPath.row];
    
    UILabel *_subjectText = (UILabel*)[cell viewWithTag:1];
    UILabel *_teacherText = (UILabel*)[cell viewWithTag:2];
    UILabel *_titleText = (UILabel*)[cell viewWithTag:3];
    UILabel *_deviceText = (UILabel*)[cell viewWithTag:4];
    
    _subjectText.text = [dic valueForKey:@"dom_nm"];
    _teacherText.text = [dic valueForKey:@"tec_nm"];
    _titleText.text = [dic valueForKey:@"chr_nm"];
    _deviceText.text = [dic valueForKey:@"device_nm"];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69.0f;
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
    if (connection == urlConnDeviceList) {
        [deviceData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //NSLog(@"%@", error);
    connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnDeviceList) {
        NSString *encodeData = [[NSString alloc] initWithData:deviceData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"DeviceList : %@", dic);
        
        deviceArr = [dic valueForKey:@"aData"];
        
        if([deviceArr count] == 0){
            _noBgImage.hidden = NO;
        }
        
        [deviceTable reloadData];
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

//
//  mgLoginVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgLoginVC_iPad.h"
#import "SBJsonParser.h"
#import "mgGlobal.h"

@implementation mgLoginVC_iPad

@synthesize _tfUserID;
@synthesize _tfUserPwd;
@synthesize _btnAutoLogin;

- (void)viewDidLoad{
    [super viewDidLoad];
    [_tfUserID becomeFirstResponder];
}

- (void)viewDidUnload {
    [self set_btnAutoLogin:nil];
    [self set_tfUserID:nil];
    [self set_tfUserID:nil];
    [self set_tfUserPwd:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)autoLogin:(id)sender {
    if(_btnAutoLogin.selected){
        [_btnAutoLogin setSelected:false];
        
    }else{
        [_btnAutoLogin setSelected:true];
    }
}

- (IBAction)touchLogin:(id)sender {
    _tfUserID.tag = 0;
    _tfUserPwd.tag = 1;
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //아이디 입력확인
    if([_tfUserID.text isEqualToString:@""]){
        [self showAlert:@"아이디를 입력해주세요." tag:TAG_MSG_NONE];
        return;
        
    }else if([_tfUserPwd.text isEqualToString:@""]){
        [self showAlert:@"비밀번호를 입력해주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    NSString *autoNum = [NSString stringWithFormat:@"%d", [_app._account getUsageAutoLogin]];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN_LOGIN, URL_LOGIN];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getReq_key]           forKey:@"req_key"];
    [dic setObject:_tfUserID.text                       forKey:@"mem_id"];
    [dic setObject:_tfUserPwd.text                      forKey:@"mem_pwd"];
    [dic setObject:autoNum                              forKey:@"auto_login_flg"];
    [dic setObject:[_app._account getToken]             forKey:@"push_id"];
    [dic setObject:@"2"                                 forKey:@"push_svr"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnection){
        loginData = [[NSMutableData alloc] init];
        
        [self initLoadBar];
        [self startLoadBar];
    }
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
    [loginData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self endLoadBar];
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        //NSLog(@"인터넷 연결 NO : 0");
        [self showAlert:@"네트워크 연결을 확인해주세요." tag:TAG_MSG_NONE];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *encodeData = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    
    NSString *result = [dic objectForKey:@"result"];
    NSString *msg = [dic objectForKey:@"msg"];
    NSArray *aDataArr = [dic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:0];
    NSString *accKey = [aData valueForKey:@"acc_key"];
    NSString *encInfo = [aData valueForKey:@"enc_info"];
    
    accKey = [self encodeURL:accKey];
    encInfo = [self encodeURL:encInfo];
    
    //NSLog(@"로그인_result : %@", result);
    //NSLog(@"로그인_msg : %@", msg);
    //NSLog(@"acc_Key : %@", [aData valueForKey:@"acc_key"]);
    //NSLog(@"enc_info : %@", [aData valueForKey:@"enc_info"]);
    
    if([result isEqualToString:@"0000"] == YES){
        [_app._account setAccKey:accKey];
        [_app._account setEncInfo:encInfo];
        [_app._account setUserID:_tfUserID.text];
        [_app._account setUserPwd:_tfUserPwd.text];
        
        if(_btnAutoLogin.selected){
            [_app._account setUsageAutoLogin:false];
        }else{
            [_app._account setUsageAutoLogin:true];
        }
        
        //자동로그인 할때는 로그인을 FALSE(홈에서 데이터 2번 안읽게 하기 위한 처리)
        if([_app._account getUsageAutoLogin] == TRUE){
            [_app._account setIsLogin:FALSE];
        }else{
            [_app._account setIsLogin:TRUE];
        }
        
        [self endLoadBar];
        
        [self dismissModalViewControllerAnimated:YES];
        
        NSNotificationCenter *login = [NSNotificationCenter defaultCenter];
        [login postNotificationName:@"firstLogin" object:self userInfo:nil];
        
    }else if([result isEqualToString:@"1001"] == YES){
        [self endLoadBar];
        [self showAlert:msg tag:TAG_MSG_NONE];
    }
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_tfUserID resignFirstResponder];
    [_tfUserPwd resignFirstResponder];
    
    return NO;
}

@end

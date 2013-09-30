//
//  mgMessageReviewAnswerVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageReviewAnswerVC.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@interface mgMessageReviewAnswerVC ()
{
    UINavigationBar *navigationBar;
    NSURLConnection *connStorage;
    NSURLConnection *connDelete;
    NSMutableData *dataStorage;
    NSMutableData *dataDelete;
}
@end

@implementation mgMessageReviewAnswerVC

@synthesize answerNavigationBar;
@synthesize _Message;
@synthesize timeText;
@synthesize timeStr;
@synthesize contentStr;

@synthesize tidx;
@synthesize _web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [answerNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    answerNavigationBar.translucent = NO;
    [answerNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    timeText.text = [[NSString alloc]initWithFormat:@"%@", self.timeStr];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initLoadBar];
    [self startLoadBar];
    
    [self loadHTMLView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTimeText:nil];
    [self set_web:nil];
    [super viewDidUnload];
}

- (void)loadHTMLView
{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_VIEW];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:tidx                                 forKey:@"tidx"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];

    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    [_web loadRequest:request];
}

- (void)MessageToStorage{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_ACTION];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:@"SAVE"                              forKey:@"method"];
    [dic setObject:tidx                                 forKey:@"tidx"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    connStorage = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (dataStorage == nil){
        dataStorage = [[NSMutableData alloc] init];
    }else{
        [dataStorage setLength:0];
    }
}

- (void)MessageToDelete{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_ACTION];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:@"DEL"                               forKey:@"method"];
    [dic setObject:tidx                                 forKey:@"tidx"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    connDelete = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (dataDelete == nil){
        dataDelete = [[NSMutableData alloc] init];
    }else{
        [dataDelete setLength:0];
    }
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
    if (connection == connStorage) {
        [dataStorage appendData:data];
    }else if(connection == connDelete){
        [dataDelete appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == connStorage) {
        NSString *encodeData = [[NSString alloc] initWithData:dataStorage encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", encodeData);
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"%@", dic);
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if(connection == connDelete){
        NSString *encodeData = [[NSString alloc] initWithData:dataDelete encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", encodeData);
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"%@", dic);
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark Button Action

- (IBAction)settingBtn:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"장기보관", @"삭제하기", nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //장기보관
    if(buttonIndex == 0){
        [self showAlertChoose:@"쪽지를 장기보관 하시겠습니까?\n장기보관은 30일까지\n가능합니다." tag:TAG_MSG_TALK_STORAGE];
    }
    
    //삭제하기
    if (buttonIndex == 1){
        [self showAlertChoose:@"쪽지를 삭제하시겠습니까?" tag:TAG_MSG_TALK_DEL];
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_TALK_STORAGE){
        if(buttonIndex == 1){
            [self MessageToStorage];
        }
    }
    
    if(alertView.tag == TAG_MSG_TALK_DEL){
        if(buttonIndex == 1){
            [self MessageToDelete];
        }
    }
}

#pragma mark -
#pragma WebView Method

// 웹뷰가 컨텐츠를 읽기 전에 실행된다.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    webView.scalesPageToFit= YES;
    //클릭할 때 마다 실행된다.
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        //NSLog(@"User tapped a link.");
    } else if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        //NSLog(@"User submitted a form.");
    } else if (navigationType == UIWebViewNavigationTypeBackForward) {
        //NSLog(@"User tapped the back or forward button.");
    } else if (navigationType == UIWebViewNavigationTypeReload) {
        //NSLog(@"User tapped the reload button.");
    } else if (navigationType == UIWebViewNavigationTypeFormResubmitted) {
        //NSLog(@"User resubmitted a form.");
    } else if (navigationType == UIWebViewNavigationTypeOther){
        //NSLog(@"Some other action accurred.");
    }
    return YES;
}

// 웹뷰가 컨텐츠를 읽기 시작한 후에 실행된다.
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self initLoadBar];
    [self startLoadBar];
}

// 웹뷰가 컨텐츠를 모두 읽은 후에 실행된다.
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoadBar];
}

// 컨텐츠를 읽는 도중 오류가 발생할 경우 실행된다.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self endLoadBar];
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

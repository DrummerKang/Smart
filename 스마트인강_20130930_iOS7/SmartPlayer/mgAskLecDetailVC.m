//
//  mgAskLecDetailVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecDetailVC.h"

@implementation mgAskLecDetailVC

@synthesize title;
@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;
@synthesize brd_cd;
@synthesize bidx;
@synthesize askDetailWebView;
@synthesize detailNavigationBar;

- (void)viewDidLoad{
    [detailNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    detailNavigationBar.translucent = NO;
    [detailNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@?acc_key=%@&app_no=%@&app_seq=%@&chr_cd=%@&brd_cd=%@&bidx=%@", URL_DOMAIN, URL_QNADETAIL_LIST, [_app._account getAcc_key], app_no, app_seq, chr_cd, brd_cd, bidx];
    
    [self initLoadBar];
    [self startLoadBar];
    
    askDetailWebView.delegate = self;
    [askDetailWebView sizeToFit];
    [askDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [askDetailWebView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:askDetailWebView];
}

- (void)viewDidUnload {
    [self setAskDetailWebView:nil];
    [super viewDidUnload];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

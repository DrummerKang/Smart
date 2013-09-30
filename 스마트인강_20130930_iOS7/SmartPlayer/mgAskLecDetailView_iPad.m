//
//  mgAskLecDetailView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 13..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecDetailView_iPad.h"
#import "mgGlobal.h"
#import "AppDelegate.h"

@implementation mgAskLecDetailView_iPad

- (void)initMethod:(NSString *)app_no app_seq:(NSString *)app_seq chr_cd:(NSString *)chr_cd brd_cd:(NSString *)brd_cd bidx:(NSString *)bidx{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self initLoadBar];
    [self startLoadBar];
    
    [self drawSourceImageV:@"_bg_search_cate1_title.png" frame:CGRectMake(0, 0, 694, 50)];
    
    titleText = [self drawTextR:@"질문상세보기" frame:CGRectMake(0, 0, 694, 50) align:UITextAlignmentCenter fontName:@"Apple SD Gothic Neo" fontSize:18 getColor:@"ffffff"];
    backBtn = [self createButtonR:@"P_btn_prev_normal.png" selImg:@"P_btn_prev_pressed.png" frame:CGRectMake(10, 14, 20, 18) fontName:@"" fontText:@"" fontSize:0 action:@selector(backAction)];
    
    NSString *webURL = [NSString stringWithFormat:@"%@%@?acc_key=%@&app_no=%@&app_seq=%@&chr_cd=%@&brd_cd=%@&bidx=%@", URL_DOMAIN, URL_QNADETAIL_LIST, [_app._account getAcc_key], app_no, app_seq, chr_cd, brd_cd, bidx];
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 48, 694, 607)];
    [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    [detailWebView setDelegate:self];
    [detailWebView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:detailWebView];
}

- (void)backAction{
    self.hidden = YES;
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
    
}

// 웹뷰가 컨텐츠를 모두 읽은 후에 실행된다.
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width]];
    [self endLoadBar];
}

@end

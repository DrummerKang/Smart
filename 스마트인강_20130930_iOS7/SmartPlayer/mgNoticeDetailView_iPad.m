//
//  mgNoticeDetailView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgNoticeDetailView_iPad.h"
#import "mgGlobal.h"
#import "mgCommon.h"

@implementation mgNoticeDetailView_iPad

- (id)initWithData:(NSDictionary *)dicData {
    if (self = [super init]) {
        [self initLoadBar];
        [self startLoadBar];
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            [self drawSourceImageV:@"P_view_tit" frame:CGRectMake(0, 0 + 20, 694, 44)];
            
            titleText = [self drawTextR:[dicData valueForKey:@"title"] frame:CGRectMake(0, 0 + 20, 694, 44) align:UITextAlignmentCenter fontName:@"Apple SD Gothic Neo" fontSize:18 getColor:@"000000"];
            
            contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44 + 20, 694, 611)];
        }else{
            [self drawSourceImageV:@"P_view_tit" frame:CGRectMake(0, 0, 694, 44)];
            
            titleText = [self drawTextR:[dicData valueForKey:@"title"] frame:CGRectMake(0, 0, 694, 44) align:UITextAlignmentCenter fontName:@"Apple SD Gothic Neo" fontSize:18 getColor:@"000000"];
            
            contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 694, 611)];
        }
        
        NSString *webURL = [[NSString alloc]initWithFormat:@"%@%@?gidx=%@", URL_DOMAIN, URL_NOTICE_DETAIL, [dicData valueForKey:@"gidx"]];
        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
        [contentWebView setDelegate:self];
        [contentWebView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentWebView];
        
        closeButton = [self createButtonR:@"P_btn" selImg:@"" frame:CGRectMake(307, 618, 78, 27) fontName:@"Apple SD Gothic Neo" fontText:@"확인" fontSize:13 action:@selector(closeAction)];
    }
    return self;
}

- (void)closeAction{
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

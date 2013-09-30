//
//  mgFaqDetailVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 10..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgFaqDetailVC.h"
#import "mgCommon.h"

@interface mgFaqDetailVC ()

@end

@implementation mgFaqDetailVC

@synthesize _web;
@synthesize fidx;
@synthesize faqTitle;
@synthesize detailNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [detailNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    detailNavigationBar.translucent = NO;
    [detailNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    _web.delegate = self;
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        
    }else{
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            _web.frame = CGRectMake(0, 44, 320, 524);
        }else{
            _web.frame = CGRectMake(0, 44, 320, 436);
        }
    }
    
    [self initLoadBar];
    [self startLoadBar];
    
    [self loadFAQ];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)loadFAQ{
    NSString *addr = [[NSString alloc]initWithFormat:@"%@%@?fidx=%@", URL_DOMAIN, URL_FAQ_DETAIL, fidx];
    NSURL *url = [[NSURL alloc]initWithString:addr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    [_web loadRequest:request];
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

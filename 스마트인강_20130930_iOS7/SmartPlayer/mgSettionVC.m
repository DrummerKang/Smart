//
//  mgSettionVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 1..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSettionVC.h"
#import "mgCfgProfileVC.h"
#import "mgCfgDDayVC.h"
#import "mgCfgDeviceVC.h"
#import "mgVersionVC.h"
#import "mgFaqVC.h"
#import "mgSendOpinionVC.h"
#import "mgNoticeVC.h"
#import "mgCommon.h"

@implementation mgSettionVC
{
    CustomBadge *badge;
}

@synthesize settingNavigationBar;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBadge];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [settingNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    settingNavigationBar.translucent = NO;
    [settingNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    //뱃지 카운트(수강강좌 + 마이톡)
    if (badge == nil) {
        badge = [CustomBadge customBadgeWithString:@"0" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        [badge setFrame:CGRectMake(26, 2, 26, 24)];
        [settingNavigationBar addSubview:badge];
        [self setBadge];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];

    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        canverseView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, screenHeight - 20)];
    }else {
        canverseView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, screenHeight - 20)];
    }
    
    [self.view addSubview:canverseView];
    
    scrollView = [[mgSettingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight - 50)];
    [canverseView addSubview:scrollView];
    
    scrollView._delegateScroll = self;
}

- (void)setBadge
{
    if (badge != nil) {
        if ([UIApplication sharedApplication].applicationIconBadgeNumber <= 0) {
            badge.hidden = YES;
        }else{
            [badge autoBadgeSizeWithString:[[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber]];
            badge.hidden = NO;
        }
    }
}

// 네비게이션 좌측 바버튼 눌렀을때 처리
- (void)touchMenu:(id)sender{
    SlideNavigationController *vc = (SlideNavigationController*)self.parentViewController;
    if ([vc isMenuOpen]) {
        [vc closeSlide];
    }else{
        [vc openSlide];
    }
}

- (IBAction)menuBtn:(id)sender {
    SlideNavigationController *vc = (SlideNavigationController*)self.parentViewController;
    if ([vc isMenuOpen]) {
        [vc closeSlide];
    }else{
        [vc openSlide];
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TalkReceived" object:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark mgSettigScrollViewDelegate

//설정화면 스크롤 버튼
- (void)mgSettingScrollViewtouchButton:(int)tag{
    //NSLog(@"%d", tag);
    UIStoryboard *storyBoard = nil;
    UIViewController *vc ;
    
    switch (tag) {
        case 0:{
            UIStoryboard *_newStoryboard = nil;
            
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_CfgProfile4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_CfgProfile" bundle:nil];
            }
            
            mgCfgProfileVC *cfg = [_newStoryboard instantiateInitialViewController];
            [self.navigationController pushViewController:cfg animated:YES];
            break;
        }
            
        case 1:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgDDay4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgDDay" bundle: nil];
            }
            
            mgCfgDDayVC *dDay = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:dDay animated:YES];
            break;
        }
            
        case 2:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_Setting4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_Setting" bundle: nil];
            }
            
            vc = [storyBoard instantiateViewControllerWithIdentifier: @"mgAlimConfigVC"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgDevice4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgDevice" bundle: nil];
            }
            
            mgCfgDeviceVC *device = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:device animated:YES];
            break;
        }
            
        case 4:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgVersion4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgVersion" bundle: nil];
            }
            
            mgVersionVC *version = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:version animated:YES];
            break;
        }
            
        case 5:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgFAQ4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgFAQ" bundle: nil];
            }
            
            mgFaqVC *faq = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:faq animated:YES];
            break;
        }
            
        case 6:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgOpinion4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgOpinion" bundle: nil];
            }

            mgSendOpinionVC *send = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:send animated:YES];
            break;
        }
            
        case 7:{
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgNotice4" bundle: nil];
            }else{
                storyBoard = [UIStoryboard storyboardWithName:@"SBiPn_CfgNotice" bundle: nil];
            }

            mgNoticeVC *notice = [storyBoard instantiateInitialViewController];
            [self.navigationController pushViewController:notice animated:YES];
            break;
        }
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

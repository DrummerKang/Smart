//
//  mgSettingVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "mgSettingMenuView_iPad.h"
#import "AppDelegate.h"
#import "mgNoticeView_iPad.h"
#import "mgFAQView_iPad.h"
#import "mgDeviceView_iPad.h"
#import "mgAlimView_iPad.h"
#import "mgDDayView_iPad.h"
#import "mgSendOpinionVC_iPad.h"
#import "mgVersionView_iPad.h"
#import "mgSettingProfileVC_iPad.h"
#import "mgLoginVC_iPad.h"

@interface mgSettingVC_iPad : mgUIControllerPadCommon<mgSettingMenuDelegate, mgProfile_iPad_Delegate, mgSendVC_iPad_Delegate>{
    AppDelegate *_app;
    
    mgSettingMenuView_iPad *settingMenuView;
    
    UIView *canverseView;
    
    mgNoticeView_iPad *noticeView;
    mgFAQView_iPad *faqView;
    mgDeviceView_iPad *deviceView;
    mgAlimView_iPad *alimView;
    mgDDayView_iPad *dDayView;
    mgSettingProfileVC_iPad *profileVC;
    mgSendOpinionVC_iPad *sendVC;
    mgVersionView_iPad *versionView;
    mgLoginVC_iPad *loginVC;
    
    NSURLConnection *connLogout;
    NSMutableData *_dataLogout;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

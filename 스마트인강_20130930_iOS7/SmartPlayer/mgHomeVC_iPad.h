//
//  mgHomeVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "AppDelegate.h"
#import "mgMyLecView_iPad.h"
#import "AsyncImageView.h"
#import "mgAlignLabelV.h"
#import "mgTextField.h"
#import "mgPopoverBgV.h"
#import "mgAskLecWriteVC_iPad.h"
#import "mgAskLecWriteOptVC_iPad.h"
#import "mgFirstProfile_iPad.h"
#import "mgSettingProfileVC_iPad.h"
#import "mgAskLecEditVC_iPad.h"
#import "mgLoginVC_iPad.h"
#import "mgRequestPauseLecVC_iPad.h"

@interface mgHomeVC_iPad : mgUIControllerPadCommon<UIActionSheetDelegate, mgFirstProfile_iPad_Delegate, mgAskLecWriteVC_iPad_Delegate, mgProfile_iPad_Delegate, mgAskLecEditVC_iPad_Delegate>{
    AppDelegate *_app;
    mgMyLecView_iPad *myLecView;
    AsyncImageView *ImageViewEx;
    mgFirstProfile_iPad *_profileVC;
    mgAskLecWriteVC_iPad *_askLecVC;
    mgSettingProfileVC_iPad *profileVC;
    mgAskLecEditVC_iPad *_editVC;
    mgLoginVC_iPad *loginVC;
    mgRequestPauseLecVC_iPad *pauseVC;
    
    NSInteger skipNum;
    
    // 멀티코넥션을 사용함으로 따로따로 관리함
    NSURLConnection *urlConnBS;  // BasicSetting
    NSURLConnection *urlConnAL;  // AutoLogin
    NSURLConnection *urlConnLec; // Lec list

    NSMutableData *homeData;
    NSMutableData *loginData;
    NSMutableData *lecData;
    
    NSDictionary *myLecDic;
    NSDictionary *pauseDic;
    
    int lecCount;
    
    NSString *subject;
    NSString *teacher;
    NSString *imgPath;
    
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
    
    NSUserDefaults *defaults;
    
    UIButton *questionBtn;
}

@property (strong, nonatomic) IBOutlet UIView *noItemView;
@property (strong, nonatomic) IBOutlet UITableView *_homeTable;

@property (strong, nonatomic) IBOutlet mgAlignLabelV *_setDdayView;
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet mgTextField *goalText;

- (IBAction)gotoProfile:(id)sender;

@end

//
//  mgHomeVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"
#import "mgTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "mgAlignLabelV.h"

@interface mgHomeVC : mgUIControllerCommon<UITableViewDelegate, UITableViewDataSource>{
    AppDelegate *_app;
    
    NSInteger skipNum;
    
    // 멀티코넥션을 사용함으로 따로따로 관리함
    NSURLConnection *urlConnBS;  // BasicSetting
    NSURLConnection *urlConnAL;  // AutoLogin
    NSURLConnection *urlConnLec; // Lec list
    NSURLConnection *urlConnDo;  // lec Doing
    
    NSMutableData *homeData;
    NSMutableData *loginData;
    NSMutableData *lecData;
    NSMutableData *doingData;
    
    NSDictionary *myLecDic;
    NSDictionary *pauseDic;
    
    int lecCount;
    
    NSString *subject;
    NSString *teacher;
    NSString *imgPath;
    
    NSString *app_no;
    NSString *app_seq;
    
    NSUserDefaults *defaults;
    
    AsyncImageView *ImageViewEx;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *homeNavigationBar;
@property (strong, nonatomic) IBOutlet mgTextField *goalText;
@property (weak, nonatomic)   IBOutlet UITableView *homeTable;

@property (strong, nonatomic) IBOutlet UIView *mainNoImage;
@property (strong, nonatomic) IBOutlet UIView *_setDdayBtn;
@property (strong, nonatomic) IBOutlet mgAlignLabelV *_DdayLabel;

@property (strong, nonatomic) IBOutlet UIImageView *mainBg;
@property (strong, nonatomic) IBOutlet UIButton *goalTextBtn;
@property (strong, nonatomic) IBOutlet UILabel *goalImage;


- (IBAction)myGoalBtn:(id)sender;

- (IBAction)menuBtn:(id)sender;

@end

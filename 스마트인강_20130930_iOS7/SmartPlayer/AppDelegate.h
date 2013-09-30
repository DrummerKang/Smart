//
//  AppDelegate.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgAccount.h"
#import "mgConfig.h"
#import "mgMenuVC.h"
#import "CDNDownloadContext.h"
#import "DownViewController.h"

#define STARTUP_TONOR  0
#define STARTUP_TOLEC  1
#define STARTUP_TOTALK 2

@class Reachability;
@class mgTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, mgAccountProtocol, mgConfigProtocol>{
    NSURLConnection *urlConnection;
    NSMutableData *deviceData;
    
    NSUserDefaults *defaults;
    
    UIBackgroundTaskIdentifier bgTask;
}

@property (nonatomic, retain) UINavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Reachability      *_internetReach;
@property int _ReachStatus;

@property (strong, nonatomic) mgAccount         *_account;
@property (strong, nonatomic) mgConfig          *_config;

@property (retain, nonatomic) CDNDownloadContext *downloadContext;

@property (strong, nonatomic) DownViewController *_downloadVC;

@property(nonatomic,retain) mgTabBarController* mgTabController;

@property (nonatomic,retain) NSString* pushBadge;
@property (nonatomic,retain) NSString *pushMeta;
@property (nonatomic,retain) NSString* pushAlert;
@property (nonatomic,retain) NSMutableArray* pushMethArray;;

@property int _StartWithPushType;

- (void)deviceCheck;
- (NSString*)getCDNdeviceId;

@end

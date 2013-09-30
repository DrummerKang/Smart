//
//  mgAlimConfigVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgAlimConfigVC : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *_swUsageAnsAlarm;
- (IBAction)toggleUsageAnsAlarm:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *_swUsageMsgAlarm;
- (IBAction)toggleUsageMsgAlarm:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *_swUsageProgAlarm;
- (IBAction)toggleUsageProgAlarm:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *_swUsageLecEndAlarm;
- (IBAction)toggleUsageLecEndAlarm:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *_swUsageLecInfoAlarm;
- (IBAction)toggleUsageLecInfoAlarm:(id)sender;

@property (strong, nonatomic) IBOutlet UINavigationBar *alimNavigationBar;
- (IBAction)backBtn:(id)sender;

@end

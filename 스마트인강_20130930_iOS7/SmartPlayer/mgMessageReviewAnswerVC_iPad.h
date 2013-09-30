//
//  mgMessageReviewAnswerVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"

@interface mgMessageReviewAnswerVC_iPad : mgUIControllerPadCommon<UIActionSheetDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIWebViewDelegate>{
    NSString *timeStr;
    NSString *contentStr;
}

@property (strong, nonatomic) NSString *timeStr;
@property (strong, nonatomic) NSString *contentStr;
@property (strong, nonatomic) NSString *r_nm;
@property (strong, nonatomic) NSString *s_nm;

@property (strong, nonatomic) NSString *_Message;
@property (strong, nonatomic) NSString *tidx;

@property (strong, nonatomic) IBOutlet UILabel *timeText;
@property (strong, nonatomic) IBOutlet UIWebView *_web;

- (IBAction)settingBtn:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

//
//  mgMessageAskQuestionVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgMessageAskQuestionLecOpt1VC.h"
#import "mgUIControllerCommon.h"

@interface mgMessageAskQuestionVC : mgUIControllerCommon <UITextViewDelegate, mgMessageAskQuestionLecOpt1VCDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *writeNavigationBar;
@property (strong, nonatomic) IBOutlet UITextField *_tfReceiveID;
@property (strong, nonatomic) NSString *_sReceiverName;
@property (strong, nonatomic) NSString *_sReplyID;
@property (strong, nonatomic) NSString *_sReplyName;
@property (strong, nonatomic) IBOutlet UITextView *_tvMessageContent;

- (IBAction)backBtn:(id)sender;

@end

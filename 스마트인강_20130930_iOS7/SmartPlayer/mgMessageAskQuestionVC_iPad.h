//
//  mgMessageAskQuestionVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgMessageAskQuestionOptTView_iPad.h"

@interface mgMessageAskQuestionVC_iPad : mgUIControllerCommon <UITextViewDelegate, mgMessageOptTViewDelegate_iPad, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    mgMessageAskQuestionOptTView_iPad *tview;
    
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UITextField *_tfReceiveID;
@property (strong, nonatomic) NSString *_sReceiverName;
@property (strong, nonatomic) NSString *_sReplyID;
@property (strong, nonatomic) NSString *_sReplyName;
@property (strong, nonatomic) IBOutlet UITextView *_tvMessageContent;

@end

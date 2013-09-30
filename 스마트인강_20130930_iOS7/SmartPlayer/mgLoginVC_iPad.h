//
//  mgLoginVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "AppDelegate.h"
#import "HTTPNetworkManager.h"

@interface mgLoginVC_iPad : mgUIControllerPadCommon{
    AppDelegate *_app;
    
    NSURLConnection *urlConnection;
    NSMutableData *loginData;
}

@property (strong, nonatomic) IBOutlet UITextField *_tfUserID;
@property (strong, nonatomic) IBOutlet UITextField *_tfUserPwd;
@property (strong, nonatomic) IBOutlet UIButton *_btnAutoLogin;

- (IBAction)autoLogin:(id)sender;
- (IBAction)touchLogin:(id)sender;

@end

//
//  mgLoginVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "HTTPNetworkManager.h"
#import "AppDelegate.h"

@interface mgLoginVC : mgUIControllerCommon<UITextFieldDelegate>{
    AppDelegate *_app;
    
    NSURLConnection *urlConnection;
    NSMutableData *loginData;
    
    int touchTag;
}

@property (strong, nonatomic) IBOutlet UITextField *_tfUserID;
@property (strong, nonatomic) IBOutlet UITextField *_tfUserPwd;
@property (strong, nonatomic) IBOutlet UIButton *_btnAutoLogin;

@property (strong, nonatomic) IBOutlet UINavigationBar *_nbNavigation;

@property (strong, nonatomic) IBOutlet UIImageView *loginBg;

- (IBAction)touchLogin:(id)sender;
- (IBAction)toggleAutoLogin:(id)sender;

@end

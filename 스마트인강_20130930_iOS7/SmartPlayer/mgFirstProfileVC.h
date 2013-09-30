//
//  mgFirstProfileVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "mgUIControllerPadCommon.h"

@interface mgFirstProfileVC : mgUIControllerPadCommon<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>{
    NSURLConnection *urlConnection;
    NSMutableData *fileUploadData;
    UIImage *fileImage;
    
    AppDelegate *_app;
    
    UIImageView *bgImage;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *firstNavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *textBgImage;

@property (strong, nonatomic) IBOutlet UIImageView *bl1;
@property (strong, nonatomic) IBOutlet UIImageView *bl2;
@property (strong, nonatomic) IBOutlet UIImageView *bl3;

@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UITextView *myGoal;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *completeBtn;
- (IBAction)completeBtn:(id)sender;

- (IBAction)skipBtn:(id)sender;

- (IBAction)profileImageBtn:(id)sender;

@end


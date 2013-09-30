//
//  mgSettingProfileVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgTextField.h"
#import "mgTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"

@protocol mgProfile_iPad_Delegate <NSObject>

@optional

- (void)mgProfile_iPad_DismissModalView;

@end

@interface mgSettingProfileVC_iPad : mgUIControllerCommon<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>{
    AsyncImageView *ImageViewEx;
    
    id <mgProfile_iPad_Delegate> profileDelegate;
}

@property (strong, nonatomic) id <mgProfile_iPad_Delegate> profileDelegate;

@property (strong, nonatomic) IBOutlet mgTextField *_tfNickName;
@property (strong, nonatomic) IBOutlet mgTextField *_tfUserId;

@property (strong, nonatomic) IBOutlet mgTextView *_tvMyGoal;
@property (strong, nonatomic) IBOutlet mgTextView *_tvMyDecision;

- (IBAction)imagePhotoBtn:(id)sender;

@end

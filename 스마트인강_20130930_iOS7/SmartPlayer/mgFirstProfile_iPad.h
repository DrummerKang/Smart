//
//  mgFirstProfile_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 26..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "mgTextView.h"
#import "AppDelegate.h"

@protocol mgFirstProfile_iPad_Delegate <NSObject>

@optional
- (void)mgFirstProfile_iPad_DismissModalView;
- (void)mgFirstProfile_iPad_SkipTrue;

@end

@interface mgFirstProfile_iPad : mgUIControllerPadCommon<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>{
    id <mgFirstProfile_iPad_Delegate> ProfileDelegate;
    
    NSURLConnection *urlConnection;
    NSMutableData *fileUploadData;
    UIImage *fileImage;

    AppDelegate *_app;
    
    UIImageView *bgImage;
    
    UIPopoverController *popover;
}

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UILabel *userID;
@property (strong, nonatomic) IBOutlet mgTextView *myGoal;

@property (strong, nonatomic) id <mgFirstProfile_iPad_Delegate> ProfileDelegate;

- (IBAction)profileImageBtn:(id)sender;

- (IBAction)saveBtn:(id)sender;

- (IBAction)skipBtn:(id)sender;


@end

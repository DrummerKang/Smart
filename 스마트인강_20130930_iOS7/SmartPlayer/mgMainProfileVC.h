//
//  mgMainProfileVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 21..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"

#import "mgTextField.h"
#import "mgTextView.h"
//#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"

@interface mgMainProfileVC : mgUIControllerCommon  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>{
    AsyncImageView *ImageViewEx;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *mainProfileNavigationBar;
@property (strong, nonatomic) IBOutlet UILabel *_lblNickname;
@property (strong, nonatomic) IBOutlet UILabel *_lblUserId;
@property (strong, nonatomic) IBOutlet mgTextField *_tfNickname;        // 닉네임
@property (strong, nonatomic) IBOutlet mgTextField *_tfUserId;          // 아이디
@property (strong, nonatomic) IBOutlet mgTextView  *_tvMyGoal;          // 나의 목표
@property (strong, nonatomic) IBOutlet mgTextView  *_tvMyDecision;      // 다짐의 글
@property (strong, nonatomic) IBOutlet UIImageView *textBgImage;

@property (strong, nonatomic) NSString *photoNum;                       //사진클릭시 액션시트 바로 띄움

- (IBAction)profileImageBtn:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

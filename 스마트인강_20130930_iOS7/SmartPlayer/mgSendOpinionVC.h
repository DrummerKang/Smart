//
//  mgSendOpinionVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mgOpinionTypeVC.h"
#import "mgImageV.h"
#import "mgUIControllerCommon.h"

@interface mgSendOpinionVC : mgUIControllerCommon <mgOpinionTypeVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel          *_lblOpinionCD;
@property (strong, nonatomic) IBOutlet UITextField      *_tfOpinionTitle;       // 의견 제목
//@property (strong, nonatomic) IBOutlet UITextView       *_tvOpinionContent;     // 의견 내용
@property (strong, nonatomic) IBOutlet mgImageV         *_imgOpinion;
@property (strong, nonatomic) IBOutlet UIImageView      *_imgTextViewBG;

@property (strong, nonatomic) IBOutlet UINavigationBar *opiNavigationBar;
- (IBAction)backBtn:(id)sender;

@end

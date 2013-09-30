//
//  mgAskLecWriteVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgImageV.h"
#import "mgAskLecWriteOptVC.h"

@interface mgAskLecWriteVC : mgUIControllerCommon<UITextViewDelegate, mgAskLecWriteOptVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    NSString *brd_cd;
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *askNavigationBar;
@property (strong, nonatomic) NSString *_lblLecTitle;

@property (strong, nonatomic) IBOutlet UILabel      *_lblLecture;       // 강좌명
@property (strong, nonatomic) IBOutlet UITextField  *_tfLectureIndex;   // 강의회차
@property (strong, nonatomic) IBOutlet UIImageView  *_imgTextViewBG;

@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;

@property (strong, nonatomic) IBOutlet mgImageV *_imageV;

- (IBAction)backBtn:(id)sender;

@end

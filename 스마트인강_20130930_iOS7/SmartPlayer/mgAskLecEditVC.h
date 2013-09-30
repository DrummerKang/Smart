//
//  mgAskLecEditVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 17..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgImageV.h"

@interface mgAskLecEditVC : mgUIControllerCommon<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
    NSString *brd_cd;
    NSString *bidx;
    NSString *lec_cd;
    NSString *book_cd;
    
    NSURLConnection *urlConnEdit;
    NSMutableData *editData;
    NSDictionary *editDic;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *askEditNavigationBar;
@property (strong, nonatomic) NSString *_lblLecTitle;

@property (strong, nonatomic) IBOutlet UILabel      *_lblLecture;       // 질문제목
@property (strong, nonatomic) IBOutlet UIImageView *_imgTextViewBG;

@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;
@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *bidx;

@property (strong, nonatomic) IBOutlet mgImageV *_imageV;

- (IBAction)backBtn:(id)sender;

@end

//
//  mgAskLecWriteVC_iPad.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUIControllerPadCommon.h"
#import "mgUIControllerCommon.h"
#import "mgImageV.h"
#import "mgAskLecWriteOptVC_iPad.h"

@protocol mgAskLecWriteVC_iPad_Delegate <NSObject>

@optional
-(void)mgAskLecWriteVC_iPad_DismissModalView;

@end

@interface mgAskLecWriteVC_iPad : mgUIControllerPadCommon<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, mgAskLecWriteOptVC_iPadDelegate>{
    id <mgAskLecWriteVC_iPad_Delegate> dlg;
    
    mgAskLecWriteOptVC_iPad *tview;
    
    NSString *brd_cd;
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
}

@property (strong, nonatomic) id <mgAskLecWriteVC_iPad_Delegate> dlg;

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

@end

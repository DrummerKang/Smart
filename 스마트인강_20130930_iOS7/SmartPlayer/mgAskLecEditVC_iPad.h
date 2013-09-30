//
//  mgAskLecEditVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "mgImageV.h"
#import "mgTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "mgAskLecWriteOptVC_iPad.h"

@protocol mgAskLecEditVC_iPad_Delegate <NSObject>

@optional
-(void)mgAskLecEditVC_iPad_DismissModalView;

@end

@interface mgAskLecEditVC_iPad : mgUIControllerPadCommon<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, mgAskLecWriteOptVC_iPadDelegate>{
    id <mgAskLecEditVC_iPad_Delegate> editDelegate;
    
    mgAskLecWriteOptVC_iPad *tview;
    
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
    
    UIPopoverController *popover;
}

@property (strong, nonatomic) id <mgAskLecEditVC_iPad_Delegate> editDelegate;

@property (strong, nonatomic) IBOutlet UILabel *_lblLecture;
@property (strong, nonatomic) IBOutlet mgTextField *_tfLectureIndex;
@property (strong, nonatomic) IBOutlet UIImageView *_imgTextViewBG;
@property (strong, nonatomic) IBOutlet mgImageV *_imageV;

@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;
@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *bidx;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;

@end

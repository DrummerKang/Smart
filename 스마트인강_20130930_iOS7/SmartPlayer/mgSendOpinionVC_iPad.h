//
//  mgSendOpinionVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgImageV.h"
#import "mgUIControllerCommon.h"
#import "mgOpinionView_iPad.h"

@protocol mgSendVC_iPad_Delegate <NSObject>

@optional
-(void)mgSendVC_iPad_DismissModalView;

@end

@interface mgSendOpinionVC_iPad : mgUIControllerCommon <mgOpinionTypeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>{
    mgOpinionView_iPad *opinionView;
    
    id <mgSendVC_iPad_Delegate> dlg;
}

@property (strong, nonatomic) id <mgSendVC_iPad_Delegate> dlg;

@property (strong, nonatomic) IBOutlet UILabel          *_lblOpinionCD;
@property (strong, nonatomic) IBOutlet UITextField      *_tfOpinionTitle;       // 의견 제목
@property (strong, nonatomic) IBOutlet mgImageV         *_imgOpinion;
@property (strong, nonatomic) IBOutlet UIImageView      *_imgTextViewBG;

@end

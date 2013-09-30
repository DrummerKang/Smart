//
//  mgUIControllerCommon.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 16..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgGlobal.h"
#import "mgBackgroundView.h"

@interface mgUIControllerCommon : UIViewController{
    UIActivityIndicatorView *spinner;
    
    mgBackgroundView *backgroundView;
    bool _isLoading;
}

@property bool _isLoading;

- (void)createButtonV:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action;
- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action;

- (void)drawSourceImageV:(NSString *)name frame:(CGRect)frame;
- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame;

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontSize:(CGFloat)fontSize fontColor:(unsigned int)fontColor;
- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontSize:(CGFloat)fontSize fontColor:(unsigned int)fontColor;

- (UITextField *)createTextField:(CGRect)frame;
- (UITextField *)createTextField:(CGRect)frame type:(BOOL)isPW;
- (UITextField *)createTextField:(CGRect)frame type:(BOOL)isPW returnKeyType:(int)returnKeyType;

- (void)showAlert:(NSString *)message tag:(NSInteger)tag;
- (void)showAlertChoose:(NSString *)message tag:(NSInteger)tag;

- (NSString *)getAppPath;
- (NSString *)createDirectory:(NSString *)strDir;
- (NSNumber *)localFreeSizeMemory;

- (NSString *)encodeURL:(NSString *)urlString;

- (void)initLoadBar;
- (void)homeLoadBar;
- (void)setPositionLoadBar:(CGRect)posion;
- (void)destroyLoadBar;
- (void)startLoadBar;
- (void)endLoadBar;

- (UIColor *) getColor: (NSString *) hexColor;

- (NSString*)stringByStrippingHTML:(NSString*)stringHtml;

@end

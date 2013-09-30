//
//  mgUIViewPadCommon.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgBackgroundView.h"

@interface mgUIViewPadCommon : UIView {
	UIActivityIndicatorView *spinner;
	id delegate;
    mgBackgroundView *backgroundView;
    mgBackgroundView *homegroundView;
    mgBackgroundView *searchgroundView;
}

//UI관련
- (UIImage *)imageResizeSquare:(UIImage *)image;
- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (UIImage *)maskImage:(NSString *)imageName  maskNake:(NSString *)maskImgName;
- (void)rotationImage:(UIImageView *)img angle:(CGFloat) angle;

- (void)createButtonV:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame fontName:(NSString *)fontName fontText:(NSString *)fontText fontSize:(CGFloat)fontSize action:(SEL)action;
- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame fontName:(NSString *)fontName fontText:(NSString *)fontText fontSize:(CGFloat)fontSize action:(SEL)action;

- (void)drawTextV:(NSString *)str frame:(CGRect)frame fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor;
- (void)drawTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor;

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor;
- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor;

- (UITextView *)drawScrollTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;
- (void)drawScrollTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;

- (UITextField *)createTextField:(CGRect)frame;
- (UITextField *)createTextField:(CGRect)frame type:(BOOL)isPW;

- (void)drawSourceImageV:(NSString *)name frame:(CGRect)frame;
- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame;

- (void)showAlert:(NSString *)message tag:(NSInteger)tag;
- (void)showAlertChoose:(NSString *)message tag:(NSInteger)tag;

- (void)initLoadBar;
- (void)setPositionLoadBar:(CGRect)posion;
- (void)startLoadBar;
- (void)homeLoadBar;
- (void)searchLoadBar;
- (void)endLoadBar;

//기타
- (BOOL)saveImageFile:(NSData *)data path:(NSString*)dPath fileName:(NSString *)fileName;

- (NSString *)getAppPath;
- (NSString *)createDirectory:(NSString *)strDir;

- (NSNumber *)localFreeSizeMemory;

- (BOOL)isPad;

- (UIColor *)getColor: (NSString *) hexColor;

- (NSString *)encodeURL:(NSString *)urlString;

- (NSString*)stringByStrippingHTML:(NSString*)stringHtml;

@end

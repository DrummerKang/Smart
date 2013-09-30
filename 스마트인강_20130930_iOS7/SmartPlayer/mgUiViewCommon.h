//
//  mgUiViewCommon.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 15..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgUiViewCommon : UITableViewCell{

}

- (NSString *)getAppPath;

- (NSString *)createDirectory:(NSString *)strDir;

- (NSNumber *)localFreeSizeMemory;

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontSize:(CGFloat)fontSize;
- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align
			  fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;

- (UITextView *)drawScrollTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align
					   fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;
- (void)drawScrollTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontSize:(CGFloat)fontSize
					  r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;

- (void)drawSourceImageV:(NSString *)name frame:(CGRect)frame;
- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame;
- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action;

- (UIColor *) getColor: (NSString *) hexColor;

@end

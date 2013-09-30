//
//  mgUiViewCommon.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 15..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUiViewCommon.h"
#import "AppDelegate.h"

@implementation mgUiViewCommon

#pragma mark -
#pragma mark 기타 필요 Util

//어플리케이션의 doc path얻기
- (NSString *)getAppPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

///Documents 및에 디렉토리 만들기
- (NSString *)createDirectory:(NSString *)strDir{
	NSString *appPath = [self getAppPath];
	
	appPath = [appPath stringByAppendingPathComponent:strDir];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL isDir=YES;
	
	if(![fileManager  fileExistsAtPath:appPath isDirectory:&isDir]) {
		if(![fileManager createDirectoryAtPath:appPath withIntermediateDirectories:NO attributes:nil error:nil]) {
			return nil;
		}
	}
	return appPath;
}

//남은 용량 확인
- (NSNumber *)localFreeSizeMemory{
	NSDictionary* FileAttrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSTemporaryDirectory() error:nil];
	
	NSNumber* freeSize = [FileAttrs objectForKey:NSFileSystemFreeSize];
	
	return freeSize;
}

- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action {
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	button.exclusiveTouch = YES;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	if(imgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal]; //백그라운드 이미지 설정
	}
	if(selImgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:selImgName] forState:UIControlStateHighlighted]; //백그라운드 이미지 설정
	}
	
	[self addSubview:button];
	
	return button;
}

#pragma mark 텍스트 그리기
/**
 * @brief 텍스트 그리기
 * @param str 텍스트
 * @param frame 텍스트가 그려질 위치 및 넓이
 * @param align 텍스트 정렬
 * @param fontSize 폰트사이즈
 * @param fontColor 폰트컬러
 */

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontSize:(CGFloat)fontSize
{
	return [self drawTextR:str frame:frame align:UITextAlignmentLeft fontSize:fontSize r:0 g:0 b:0];
}

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align
			  fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue
{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = str;									//스트링
	[label setBackgroundColor:[UIColor clearColor]];	//백그라운드 컬러
	label.textColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:255 / 255];
	label.textAlignment = align;						//정렬
	label.numberOfLines = 0;							//줄넘기기
	//label.adjustsFontSizeToFitWidth = YES;			//크기에 맞춰 폰트크기 자동조절
	label.font = [UIFont systemFontOfSize:fontSize];
	[self addSubview:label];
	return label;
}

#pragma mark 스크롤 텍스트 그리기

/**
 * @brief 스크롤 텍스트 그리기
 * @param str 텍스트
 * @param frame 텍스트가 그려질 위치 및 넓이
 * @param align 텍스트 정렬
 * @param fontSize 폰트사이즈
 * @param fontColor 폰트컬러
 */
- (UITextView *)drawScrollTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align
fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue
{
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	textView.text = str;									//스트링
	[textView setBackgroundColor:[UIColor clearColor]];	//백그라운드 컬러
	textView.textColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:255 / 255];
	textView.textAlignment = align;						//정렬
	textView.editable = NO;
	textView.userInteractionEnabled = YES;
	textView.font = [UIFont systemFontOfSize:fontSize];
	[self addSubview:textView];
	return textView;
}

- (void)drawScrollTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue
{
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	textView.text = str;									//스트링
	[textView setBackgroundColor:[UIColor clearColor]];	//백그라운드 컬러
	textView.textColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:255 / 255];
	textView.textAlignment = align;						//정렬
	textView.editable = NO;
	textView.userInteractionEnabled = YES;
	textView.font = [UIFont systemFontOfSize:fontSize];
	[self addSubview:textView];
	[textView release];
}

#pragma mark 이미지 그리기
/**
 * @brief 소스에 포함되어있는 이미지 그리기
 * @param name 소스파일명
 * @frame frame 그려질 위치및 높이
 */
- (void)drawSourceImageV:(NSString *)name frame:(CGRect)frame{
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	img.frame = frame;
	
	[self addSubview:img];
	[img release];
}

- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame{
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	img.frame = frame;
	
	[self addSubview:img];
	
	return img;
}

- (UIColor *) getColor: (NSString *) hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@end

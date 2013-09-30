//
//  mgUIControllerPadCommon.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUIControllerPadCommon.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation mgUIControllerPadCommon

@synthesize delegate;

#pragma mark 텍스트 그리기

/**
 * @brief 텍스트 그리기
 * @param str 텍스트
 * @param frame 텍스트가 그려질 위치 및 넓이
 * @param align 텍스트 정렬
 * @param fontSize 폰트사이즈
 * @param getColor 폰트컬러
 */
- (void)drawTextV:(NSString *)str frame:(CGRect)frame fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor{
	[self drawTextV:str frame:frame align:UITextAlignmentLeft fontName:fontName fontSize:fontSize getColor:getColor];
}

- (void)drawTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = str;
	[label setBackgroundColor:[UIColor clearColor]];
	label.textColor = [self getColor:getColor];
	label.textAlignment = align;
	label.numberOfLines = 0;
	label.font = [UIFont fontWithName:fontName size:fontSize];
	[self.view addSubview:label];
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

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor{
	return [self drawTextR:str frame:frame align:UITextAlignmentLeft fontName:fontName fontSize:fontSize getColor:getColor];
}

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize getColor:(NSString *)getColor{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = str;
	[label setBackgroundColor:[UIColor clearColor]];
	label.textColor = [self getColor:getColor];
	label.textAlignment = align;
	label.numberOfLines = 0;
	//label.adjustsFontSizeToFitWidth = YES;
	label.font = [UIFont fontWithName:fontName size:fontSize];
	[self.view addSubview:label];
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
- (UITextView *)drawScrollTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue{
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	textView.text = str;
	[textView setBackgroundColor:[UIColor clearColor]];
	textView.textColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:255 / 255];
	textView.textAlignment = align;
	textView.editable = NO;
	textView.userInteractionEnabled = YES;
	textView.font = [UIFont fontWithName:fontName size:fontSize];
	[self.view addSubview:textView];
	return textView;
}

- (void)drawScrollTextV:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontName:(NSString *)fontName fontSize:(CGFloat)fontSize r:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue
{
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	textView.text = str;
	[textView setBackgroundColor:[UIColor clearColor]];
	textView.textColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:255 / 255];
	textView.textAlignment = align;
	textView.editable = NO;
	textView.userInteractionEnabled = YES;
	textView.font = [UIFont fontWithName:fontName size:fontSize];
	[self.view addSubview:textView];
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
	
	[self.view addSubview:img];
}

- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame{
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	img.frame = frame;
	
	[self.view addSubview:img];
	
	return img;
}

#pragma mark 이미지 프로세싱 관련

/**
 * @brief 이미지 마스크 씌우기
 * @param imageName 원본이미지
 * @param maskImgName 마스크이미지 (마스크영역은 검정, 바탕은 투명이 아닌 흰색이어야함)
 * @return UIImage* 완료이미지
 */
- (UIImage *)maskImage:(NSString *)imageName  maskNake:(NSString *)maskImgName{
	CGImageRef imageRef = [[UIImage imageNamed:imageName] CGImage];
	CGImageRef maskRef = [[UIImage imageNamed:maskImgName] CGImage];
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef),
										NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
	CGImageRelease(mask);
    
	UIImage *maskedImage = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
	
	return maskedImage;
}

/**
 * @brief 이미지 자르기
 * @param imageToCrop 원본이미지
 * @param rect 원본이미지에서 자를 위치 및 크기
 * @return UIImage* 자른이미지
 */
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropped;
}

/**
 * @brief 이미지 사각형에 맞게 리사이즈하여 자르기
 * @param imageToCrop 원본이미지
 * @param rect 원본이미지에서 자를 위치 및 크기
 * @return UIImage* 자른이미지
 */
- (UIImage *)imageResizeSquare:(UIImage *)image{
	CGFloat w = image.size.width;
	CGFloat h = image.size.height;
	UIImage *resultImg;
	
	if(w > h)
	{
		resultImg = [self imageByCropping:image toRect:CGRectMake((w - h) /2, 0, h, h)];
	}else{
		resultImg = [self imageByCropping:image toRect:CGRectMake(0, (h - w) / 2, w, w)];
	}
	
	return resultImg;
}

/**
 * @brief 이미지 회전시키기
 * @param img 회전시킬 이미지
 * @return UIImage* 자른이미지
 */
- (void)rotationImage:(UIImageView *)img angle:(CGFloat) angle{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState:NO];
	CGAffineTransform transform =CGAffineTransformMakeRotation(angle);
	img.transform = transform;
	[UIView setAnimationsEnabled:NO];
}

#pragma mark UI버튼관련

/**
 * @brief 버튼붙이기
 * @param title 텍스트
 * @param url 백그라운드 이미지 url
 * @param type 버튼타입
 * @param frame 버튼 위치 및 크기
 * @param target action이 작동될 타겟
 * @param action 버튼을 클릭하였을때 불려질 함수
 * @param fontName 폰트
 * @param fontSize 폰트 사이즈
 * @return UIButton 생성된 버튼
 */

- (void)createButtonV:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame fontName:(NSString *)fontName fontText:(NSString *)fontText fontSize:(CGFloat)fontSize action:(SEL)action {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
    button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    button.titleLabel.text = fontText;
	button.exclusiveTouch = YES;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	if(imgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	}
	if(selImgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:selImgName] forState:UIControlStateHighlighted];
	}
	
	[self.view addSubview:button];
}

- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame fontName:(NSString *)fontName fontText:(NSString *)fontText fontSize:(CGFloat)fontSize action:(SEL)action {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
    button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    button.titleLabel.text = fontText;
	button.exclusiveTouch = YES;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	if(imgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	}
	if(selImgName != nil){
		[button setBackgroundImage:[UIImage imageNamed:selImgName] forState:UIControlStateHighlighted];
	}
	
	[self.view addSubview:button];
	
	return button;
}

#pragma mark UI 텍스트필드

/**
 * @brief 텍스트 입력창 만들기
 * @param CGRect 입력위치
 * @param UITextAutocapitalizationType 텍스트 타입
 * @return UITextField 생성된 텍스트 필드
 */
- (UITextField *)createTextField:(CGRect)frame{
	return [self createTextField:frame type:NO];
}

- (UITextField *)createTextField:(CGRect)frame type:(BOOL)isPW{
	UITextField *field = [[UITextField alloc] initWithFrame:frame];
	field.borderStyle = UITextBorderStyleNone;
	field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //수직정렬
	field.returnKeyType = UIReturnKeyDone;
	field.autocapitalizationType = UITextAutocapitalizationTypeNone;
	field.secureTextEntry = isPW;
	
	[self.view addSubview:field];
	
	return field;
}

#pragma mark 알림창 관련

- (void)showAlert:(NSString *)message tag:(NSInteger)tag{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:self
										  cancelButtonTitle:@"확인" otherButtonTitles:nil ,nil];
	[alert show];
	alert.tag = tag;
	
}

- (void)showAlertChoose:(NSString *)message tag:(NSInteger)tag{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인" ,nil];
	[alert show];
	
	alert.tag = tag;
}

#pragma mark 네트워크 로드바 관련

//로드바 초기화
- (void)initLoadBar{
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(1024 / 2.0, 748 / 2.0)];
	
    backgroundView = [[mgBackgroundView alloc] initWithFrame:CGRectMake(0, 64, 1024, 654)];
	
	[self.view addSubview:spinner];
}

- (void)setPositionLoadBar:(CGRect)posion{
	if (spinner != nil) {
		[spinner setCenter:CGPointMake(posion.origin.x + (posion.size.width / 2.0),
									   posion.origin.y + (posion.size.height / 2.0))];
	}
}

//로드바 에니메이션 시작
- (void)startLoadBar{
	if(spinner != nil)
        [self.view addSubview:backgroundView];
        [self.view bringSubviewToFront:spinner];
    
		[spinner startAnimating];
}

//로드바 에니메이션 끝내기
- (void)endLoadBar{
	if(spinner != nil)
		[spinner stopAnimating];
    
    [backgroundView removeFromSuperview];
}

#pragma mark 기타 필요 Util

//어플리케이션의 doc path얻기
- (NSString *)getAppPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

//Documents 및에 디렉토리 만들기
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

- (UIColor *)getColor: (NSString *) hexColor{
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

- (NSString*)stringByStrippingHTML:(NSString*)stringHtml{
    NSRange r;
    while ((r = [stringHtml rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringHtml = [stringHtml stringByReplacingCharactersInRange:r withString:@" "];
    return stringHtml;
}

//문자 치환
- (NSString *)encodeURL:(NSString *)urlString {
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(newString);
}

@end

//
//  mgUIControllerCommon.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 16..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@implementation mgUIControllerCommon

@synthesize _isLoading;

#pragma mark -
#pragma mark UI버튼관련

- (void)createButtonV:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
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

- (UIButton *)createButtonR:(NSString *)imgName selImg:(NSString *)selImgName frame:(CGRect)frame action:(SEL)action {
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
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

#pragma mark -
#pragma mark 이미지 그리기
/**
 * @brief 소스에 포함되어있는 이미지 그리기
 * @author 강요셉
 * @param name 소스파일명
 * @frame frame 그려질 위치및 높이
 */
- (void)drawSourceImageV:(NSString *)name frame:(CGRect)frame{
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	img.frame = frame;
	
	[self.view addSubview:img];
	[img release];
}

- (UIImageView *)drawSourceImageR:(NSString *)name frame:(CGRect)frame{
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	img.frame = frame;
	
	[self.view addSubview:img];
	
	return img;
}

#pragma mark 텍스트 그리기
- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame fontSize:(CGFloat)fontSize fontColor:(unsigned int)fontColor {
	return [self drawTextR:str frame:frame align:UITextAlignmentLeft fontSize:fontSize fontColor:fontColor];
}

- (UILabel *)drawTextR:(NSString *)str frame:(CGRect)frame align:(UITextAlignment)align fontSize:(CGFloat)fontSize fontColor:(unsigned int)fontColor{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = str;									
	[label setBackgroundColor:[UIColor clearColor]];	
	if (fontColor == 0x000000FF) {
		label.textColor = [UIColor colorWithRed:153 / 255 green:141 / 255 blue:136 / 255 alpha:255 / 255];
	}else {
		label.textColor = HEXCOLOR(fontColor);				
	}
	label.textAlignment = align;						
	label.numberOfLines = 0;									
	label.font = [UIFont systemFontOfSize:fontSize];
	[self.view addSubview:label];
	return label;
}

#pragma mark -
#pragma mark UI 텍스트필드

/**
 * @brief 텍스트 입력창 만들기
 * @author 강요셉
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

- (UITextField *)createTextField:(CGRect)frame type:(BOOL)isPW returnKeyType:(int)returnKeyType{
	UITextField *field = [[UITextField alloc] initWithFrame:frame];
	field.borderStyle = UITextBorderStyleNone;
	field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //수직정렬
	field.returnKeyType = returnKeyType;
	field.autocapitalizationType = UITextAutocapitalizationTypeNone;
	field.secureTextEntry = isPW;
	
	[self.view addSubview:field];
	
	return field;
}

#pragma mark -
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

//문자 치환
- (NSString *)encodeURL:(NSString *)urlString {
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(newString);
}

#pragma mark -
#pragma mark 네트워크 로드바 관련

//로드바 초기화
- (void)initLoadBar{
    // 이전에 돌고 있는게 있으면 정지
    if (self._isLoading == true) {
        [self endLoadBar];
    }
    
    self._isLoading = false;
    
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(320 / 2.0, (screenHeight - 80) / 2.0)];

    backgroundView = [[mgBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    
	[self.view addSubview:spinner];
}

- (void)homeLoadBar{
    // 이전에 돌고 있는게 있으면 정지
    if (self._isLoading == true) {
        [self endLoadBar];
    }
    
    self._isLoading = false;
    
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(320 / 2.0, screenHeight/ 2.0)];
    
    backgroundView = [[mgBackgroundView alloc] initWithFrame:CGRectMake(0, 199, 320, screenHeight - 200)];
    
	[self.view addSubview:spinner];
}

- (void)setPositionLoadBar:(CGRect)posion{
	if (spinner != nil) {
		[spinner setCenter:CGPointMake(posion.origin.x + (posion.size.width / 2.0),
									   posion.origin.y + (posion.size.height / 2.0))];
	}
}

//로드바 에니메이션 끝내기
- (void)destroyLoadBar{
	[spinner release];
}

//로드바 에니메이션 시작
- (void)startLoadBar{
    if (self._isLoading == false) {

        [self.view addSubview:backgroundView];
        [self.view bringSubviewToFront:spinner];
   
        if(spinner != nil)
            [spinner startAnimating];
        
        self._isLoading = true;
    }
}

- (void)endLoadBar{
    if (self._isLoading == true) {
        if(spinner != nil)
            [spinner stopAnimating];
        
        //backgroundView.hidden = YES;
        [backgroundView removeFromSuperview];
        
        self._isLoading = false;
    }
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

- (NSString*)stringByStrippingHTML:(NSString*)stringHtml{
    NSRange r;
    while ((r = [stringHtml rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringHtml = [stringHtml stringByReplacingCharactersInRange:r withString:@" "];
    return stringHtml;
}

@end


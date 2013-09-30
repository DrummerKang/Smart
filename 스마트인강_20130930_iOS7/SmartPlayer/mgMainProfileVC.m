//
//  mgMainProfileVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 21..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMainProfileVC.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "mgAccount.h"
#import "mgConfig.h"
#import "JSON.h"
#import "mgCommon.h"

@implementation UIImagePickerController (NonRotating)
 
- (BOOL)shouldAutorotate{
    return NO;
}
 
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
 
@end

@interface mgMainProfileVC ()
{
    CGRect _rtGoal;
    CGRect _rtDecision;
    
    UIButton *completeBtn;
    UIButton *saveBtn;
}

@end

@implementation mgMainProfileVC

@synthesize _tfNickname, _tfUserId, _tvMyDecision, _tvMyGoal, _lblNickname, _lblUserId;
@synthesize textBgImage;
@synthesize photoNum;
@synthesize mainProfileNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [mainProfileNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    mainProfileNavigationBar.translucent = NO;
    [mainProfileNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                           [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                           [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    [self initLoadBar];
    
    [self saveMethod];
    
    _tvMyDecision.tag = 0;
    _tvMyGoal.tag = 1;
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:_app._config._sMyImage];
 
    //썸네일 이미지
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileImageBtn:)];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 76, 64, 64)];
    }else {
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 57, 64, 64)];
    }
    
    ImageViewEx.backgroundColor = [UIColor clearColor];
    ImageViewEx.layer.cornerRadius = 5.0f;
    ImageViewEx.layer.masksToBounds = YES;
    ImageViewEx.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ImageViewEx.layer.borderWidth = 1.0f;
    [ImageViewEx addGestureRecognizer:tgr];
    [ImageViewEx loadImageFromURL:url];
    [self.view addSubview:ImageViewEx];
    
    [self DataToView];
    
    if([photoNum isEqualToString:@"1"] == YES){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PHOTO", @"CAMERA",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_tfNickname:nil];
    [self set_tfUserId:nil];
    [self set_tvMyGoal:nil];
    [self set_tvMyDecision:nil];
    [self set_lblNickname:nil];
    [self set_lblUserId:nil];
    [self setTextBgImage:nil];
    [super viewDidUnload];
}

// 화면에 출력
- (void)DataToView{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //NSLog(@"%@", _app._account);
    
    _tfNickname.text = _app._config._sNickName;
    _tfUserId.text = [_app._account getUserID];
    _tvMyGoal.text = _app._config._sMyGoal;
    _tvMyDecision.text = _app._config._sMyDecision;
}

// 화면 내용 저장
- (void)ViewToData{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [_app._config setNickName:_tfNickname.text];
    [_app._config setMyGoal:_tvMyGoal.text];
    [_app._config setMyDecision:_tvMyDecision.text];
}

- (void)saveMethod{
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        saveBtn.frame = CGRectMake(255, 27, 60, 30);
    }else {
        saveBtn.frame = CGRectMake(255, 7, 60, 30);
    }
    
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"저장" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:saveBtn];
}

- (void)completeMethod{
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.titleLabel.text = @"완료";
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        completeBtn.frame = CGRectMake(255, 27, 60, 30);
    }else {
        completeBtn.frame = CGRectMake(255, 7, 60, 30);
    }
    
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:completeBtn];
}

#pragma mark -
#pragma mark Button Action

- (void)completeAction{    
    [self saveMethod];
    
    _tvMyDecision.hidden = NO;
    
    [_tvMyDecision resignFirstResponder];
    [_tvMyGoal resignFirstResponder];
}

- (void)saveAction{
    [self startLoadBar];
    
    [self ViewToData];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // 사진 & 동영상 업로드
    NSString *imgURL = [self uploadMedia];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:imgURL error:NULL];
    
    NSString *result = [dic objectForKey:@"result"];
    NSString *msg = [dic objectForKey:@"msg"];
    
    //NSLog(@"이미지업로드_result : %@", result);
    //NSLog(@"이미지업로드_msg : %@", msg);
    
    if([result isEqualToString:@"0000"] == YES){
        [self showAlert:msg tag:TAG_MSG_NONE];
        
        [_app._account setSkip:TRUE];
        
        [_app._config set_sNickName:_tfNickname.text];
        [_app._config set_sMyGoal:_tvMyGoal.text];
        [_app._config set_sMyDecision:_tvMyDecision.text];
        [_app._config set_sMyImage:[[[dic objectForKey:@"aData"]objectAtIndex:0]objectForKey:@"path"]];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"RELOADPROFILE" forKey:@"reloadProfile"];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"reloadProfile" object:self userInfo:dic];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self showAlert:msg tag:TAG_MSG_NONE];
    }
    
    [self endLoadBar];
}

- (IBAction)profileImageBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PHOTO", @"CAMERA",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	//PHOTO
	if(buttonIndex == 0){
        // 이미지피커 띄우기
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:nil];
	}
	
	//CAMERA
	if (buttonIndex == 1){
        [self startCameraControllerFromViewController:self usingDelegate:self];
	}
}

#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect keyboardRect = textView.bounds;
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;

    _lblNickname.hidden = YES;
    _lblUserId.hidden = YES;
    ImageViewEx.hidden = YES;
    _tfNickname.hidden = YES;
    _tfUserId.hidden = YES;
    textBgImage.hidden = NO;
    
    [self completeMethod];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];

    _rtGoal = textView.frame;
    
    if(textView.tag == 0){
        self.navigationItem.title = @"다짐의 글";
    }else if(textView.tag == 1){
        _tvMyDecision.hidden = YES;
        self.navigationItem.title = @"나의 목표";
    }
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        if ([mgCommon hasFourInchDisplay]) {
            [textView setFrame:CGRectMake(0.0f, 60.0f, 320.0f, 300.0f)];
            
        }else{
            [textView setFrame:CGRectMake(0.0f, 60.0f, 320.0f, 210.0f)];
        }
        
    }else{
        if ([mgCommon hasFourInchDisplay]) {
            [textView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 292.0f)];
            
        }else{
            [textView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 204.0f)];
        }
    }
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];

    textView.frame = _rtGoal;

    self.navigationItem.title = @"내 프로필";
    
    [UIView commitAnimations];
    
    _lblNickname.hidden = NO;
    _lblUserId.hidden = NO;
    ImageViewEx.hidden = NO;
    _tfNickname.hidden = NO;
    _tfUserId.hidden = NO;
    textBgImage.hidden = YES;
    
    return YES;
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSLog(@"%@", info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqual:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* rotat = [self rotateUIImage:image orientation:image.imageOrientation];
        
        //[_imgPhoto setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        UIImage *thumb = [self makeThumbnailImage:rotat onlyCrop:YES Size:50];
        [ImageViewEx SetImage:thumb];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma CropImage

#define DEGREES_TO_RADIANS(x) ( M_PI * (x) / 180.0 )

- (UIImage*) rotateUIImage:(UIImage*) src orientation:(UIImageOrientation)ori{
	if( ori == UIImageOrientationUp )
		return src;
	
	int nDegree = 0;
	CGFloat width, height;
	
	width = src.size.width;
	height = src.size.height;
	
	//90도로 회전할 경우, 높이와 넓이를 바꿔준다. 필요없는 경우에는 생략해도 된다.(카메라로 찍은 이미지를 화면에 보이는 것 처럼 저장하려면, 회전이 필요하다.)
	//UIImage의 UIImageOrientation은 현재 이미지의 방향을 나타낸다.
	switch( ori )
	{
		case UIImageOrientationDown :	//케이블 꽂는 곳이 왼쪽. 뒤집힘.(레티나의 경우 960 x 720)
			nDegree = 180;
			break;
		case UIImageOrientationLeft :	//케이블 꽂는 곳이 위쪽. 왼쪽으로 회전됨.(레티나의 경우 720 x 960)
			width = src.size.height;
			height = src.size.width;
			nDegree = -90;
			break;
		case UIImageOrientationRight :	//케이블 꽂는 곳이 아래쪽. 오른쪽으로 회전됨.(레티나의 경우 720 x 960)
			width = src.size.height;
			height = src.size.width;
			nDegree = 90;
			break;
		case UIImageOrientationUp:		//케이블 꽂는 곳이 오른쪽. 정방향(레티나의 경우 960 x 720)
		default :
			nDegree = 0;
			break;
	}
	
	//UIView를 통해서 이미지를 회전했을 때의 크기를 구함.
	//90도와 -90도의 경우, 960 x 720으로 들어온다. 위에서 값을 변경했으므로.
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, width, height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(nDegree));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
	//90도와 -90도의 경우 위 코드를 지나면, 결국 다시 720 x 960이 된다.
	
	//위에서 변경한 크기로 컨텍스트 이미지를 만든다.
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	//기준점을 이미지의 중간으로 변경한다. 센터 기준 회전을 하기 위해서.
	//CTM은 Current Translate Matrix의 약자같음.
	//원래 이미지는 720 x 960이 되고, 가져온 컨텍스를 이리저리 회전시켜, 원래의 720 x 960이미지를 만드는 것 같다.
	//즉, UIGraphicsBeginImageContext로 만든 이미지가 회전되는 것이 아닌 것 같다. 원본 이미지에 그리는데, 회전을 시켜서 원본에 그려라~이 의미 인듯.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//기준점을 기준으로 각도만큼 회전한다.
    CGContextRotateCTM(bitmap, DEGREES_TO_RADIANS(nDegree));
	
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-width / 2, -height / 2, width, height), [src CGImage]);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

- (UIImage*) makeThumbnailImage:(UIImage*)image onlyCrop:(BOOL)bOnlyCrop Size:(float)size{
    CGRect rcCrop;
    if (image.size.width == image.size.height){
        rcCrop = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        
    }else if (image.size.width > image.size.height){
        int xGap = (image.size.width - image.size.height)/2;
        rcCrop = CGRectMake(xGap, 0.0, image.size.height, image.size.height);
        
    }else{
        int yGap = (image.size.height - image.size.width)/2;
        rcCrop = CGRectMake(0.0, yGap, image.size.width, image.size.width);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rcCrop);
    UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    if (bOnlyCrop) return cropImage;
    
    NSData* dataCrop = UIImagePNGRepresentation(cropImage);
    UIImage* imgResize = [[UIImage alloc] initWithData:dataCrop];
    
    UIGraphicsBeginImageContext(CGSizeMake(size,size));
    [imgResize drawInRect:CGRectMake(0.0f, 0.0f, size, size)];
    UIImage* imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgThumb;
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

-(NSString*)uploadImage:(UIImage *)image filename:(NSString*)filename{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *nickname = _tfNickname.text;
    NSString *mygoal = _tvMyGoal.text;
    NSString *mydesc = _tvMyDecision.text;
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@", URL_FILE_DOMAIN, URL_FILEUPLOAD];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    
    int encodeType = NSUTF8StringEncoding;
	NSString *boundary = @"-----------------------------7dd9371500ce6";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
	NSMutableData *body = [[NSMutableData data] init];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:encodeType]];
    
    //acc_key
	[body appendData:[[NSString stringWithFormat:@"Content-disposition: form-data; name=\"acc_key\"\r\n\r\n%@", [_app._account getAcc_key]] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //nick_name
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"nick_nm\"\r\n\r\n%@", nickname] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //goal
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"goal\"\r\n\r\n%@", mygoal] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //promise
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"promise\"\r\n\r\n%@", mydesc] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    NSString *fileYN = @"N";
    
    //파일삭제 여부
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file_del_yn\"\r\n\r\n%@", fileYN] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
	// file data
	// RFC문서를 보면 이미지 파일에 대해서 별도의 boundary를 다시 설정해 주는데요. 일단 리눅스서버에 PHP로 작업한 경우에는
	// 지금처럼 작성해도 문제가 없었습니다만 다른 서버에는 문제가 될지도 모르겠습니다.
    [body appendData:[[[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:encodeType]];
    [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:encodeType]];
    [body appendData:[[NSString stringWithFormat:@"Content-Length: %i\r\n\r\n", imageData.length] dataUsingEncoding:encodeType]];
    [body appendData:[[NSData alloc]initWithData:imageData]]; // 실제 이미지 Data를 append 해줌
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:encodeType] ];
    
    //NSLog(@"%@", [[NSString alloc] initWithData:body encoding:encodeType]);
	[request setHTTPBody:body];
    
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Return String = %@",returnString);
    
    return returnString;
}

- (NSString*)uploadMedia{
    /*
    if([_arrUploadFileUrl count] == 0){
        return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
    }*/
    
    //NSDictionary *info = (NSDictionary*)[_arrUploadFileUrl objectAtIndex:0];
    
    UIImage *image = (UIImage*)ImageViewEx._tempImage;

    //NSLog(@"%@", image);
    
    if (image == nil) {
        return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
    }
    
    return [self uploadImage:image filename:[[NSString alloc]initWithFormat:@"%@%02d.jpg", [self getnerateFileName], 0]];
    
    /*
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqual:@"public.image"]) {
        //UIImage *img = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
        UIImage *img = (UIImage*)_imgPhoto.image;
        //NSLog(@"%@", img);
        
        return [self uploadImage:img filename:[[NSString alloc]initWithFormat:@"%@%02d.jpg", [self getnerateFileName], 0]];
    }
    
    return @"";
     */
}

- (NSString*)getnerateFileName{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strNow = [fmt stringFromDate:now];
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return [[NSString alloc]initWithFormat:@"qst_%@_%@", [_app._account getUserID], strNow];
}

#pragma mark -
#pragma 회전 관련

- (BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end

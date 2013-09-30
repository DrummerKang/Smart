//
//  mgSettingProfileVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSettingProfileVC_iPad.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"

@interface mgSettingProfileVC_iPad ()
{
    CGRect _rtGoal;
    CGRect _rtDecision;
    
    UITapGestureRecognizer *_photoTGR;
    
    UIPopoverController *popover;
    
    UIButton *cancelBtn;
    UIButton *completeBtn;
}

@end

@implementation mgSettingProfileVC_iPad

@synthesize profileDelegate;
@synthesize _tfNickName;
@synthesize _tfUserId;
@synthesize _tvMyDecision;
@synthesize _tvMyGoal;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _tvMyDecision.tag = 0;
    _tvMyGoal.tag = 1;
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:_app._config._sMyImage];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePhotoBtn:)];
    //썸네일 이미지
    ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(20, 64, 64, 64)];
    ImageViewEx.backgroundColor = [UIColor clearColor];
    ImageViewEx.layer.cornerRadius = 5.0f;
    ImageViewEx.layer.masksToBounds = YES;
    ImageViewEx.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ImageViewEx.layer.borderWidth = 1.0f;
    ImageViewEx.IsThumbNainSave = YES;
    [ImageViewEx SetImageViewParentRect:YES];
    [ImageViewEx SetImage:[UIImage imageNamed:@"thumb_img"]];
    ImageViewEx.notImagePath = @"thumb_img";
    [ImageViewEx loadImageFromURL:url];
    [ImageViewEx addGestureRecognizer:tgr];
    [self.view addSubview:ImageViewEx];
    
    [self DataToView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(6, 7, 60, 30);
    cancelBtn.exclusiveTouch = YES;
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"취소" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:cancelBtn];
    
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(284, 7, 60, 30);
    completeBtn.exclusiveTouch = YES;
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:completeBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(350, 480); // size of view in popover
    self.contentSizeForViewInPopover = size;
    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [self set_tfNickName:nil];
    [self set_tfUserId:nil];
    [self set_tvMyGoal:nil];
    [self set_tvMyDecision:nil];
    [self set_tvMyGoal:nil];
    [self set_tvMyDecision:nil];
    [super viewDidUnload];
}

// 화면에 출력
- (void)DataToView{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //NSLog(@"%@", _app._account);
    
    _tfNickName.text = _app._config._sNickName;
    _tfUserId.text = [_app._account getUserID];
    _tvMyGoal.text = _app._config._sMyGoal;
    _tvMyDecision.text = _app._config._sMyDecision;
}

// 화면 내용 저장
- (void)ViewToData{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [_app._config setNickName:_tfNickName.text];
    [_app._config setMyGoal:_tvMyGoal.text];
    [_app._config setMyDecision:_tvMyDecision.text];
}

#pragma mark -
#pragma mark Button Action

- (void)saveAction{
    [self initLoadBar];
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
        
        [_app._config set_sNickName:_tfNickName.text];
        [_app._config set_sMyGoal:_tvMyGoal.text];
        [_app._config set_sMyDecision:_tvMyDecision.text];
        [_app._config set_sMyImage:[[[dic objectForKey:@"aData"]objectAtIndex:0]objectForKey:@"path"]];
        
        [self dismissModalViewControllerAnimated:YES];
        
        // 프로필 재로드
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadProfile" object:nil];
        
    }else{
        [self showAlert:msg tag:TAG_MSG_NONE];
    }
    
    [self endLoadBar];
}

- (void)completeAction{
    [self saveAction];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [profileDelegate mgProfile_iPad_DismissModalView];
    
    [_tvMyGoal resignFirstResponder];
    [_tvMyDecision resignFirstResponder];}

- (void)cancelAction{
    [self showAlertChoose:@"프로필 설정을 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
}

- (IBAction)imagePhotoBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PHOTO", @"CAMERA",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	//PHOTO
	if(buttonIndex == 0){
        // 이미지피커 띄우기
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if (popover == nil) {
            popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        }
        
        [popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0)
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
	}
	
	//CAMERA
	if (buttonIndex == 1){
        [self startCameraControllerFromViewController:self usingDelegate:self];
	}
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSLog(@"%@", info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqual:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* rotat = [self rotateUIImage:image orientation:image.imageOrientation];
        
        //[_imgPhoto setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        UIImage *thumb = [self makeThumbnailImage:rotat onlyCrop:YES Size:100];
        [ImageViewEx SetImage:thumb];
    }
    
    if (popover != nil) {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [profileDelegate mgProfile_iPad_DismissModalView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [profileDelegate mgProfile_iPad_DismissModalView];
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
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *nickname = _tfNickName.text;
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
    UIImage *image = (UIImage*)ImageViewEx._tempImage;
    
    if (image == nil) {
        return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
    }
    
    return [self uploadImage:image filename:[[NSString alloc]initWithFormat:@"%@%02d.jpg", [self getnerateFileName], 0]];
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
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_WRITE_CANCEL){
        if(buttonIndex == 1){
            [self dismissModalViewControllerAnimated:YES];
            
            [profileDelegate mgProfile_iPad_DismissModalView];
        }
    }
}

@end

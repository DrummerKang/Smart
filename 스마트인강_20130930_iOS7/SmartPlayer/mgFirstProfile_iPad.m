//
//  mgFirstProfile_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 26..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgFirstProfile_iPad.h"
#import "mgGlobal.h"
#import "JSON.h"
#import "mgCommon.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation mgFirstProfile_iPad

@synthesize nickName;
@synthesize userID;
@synthesize myGoal;
@synthesize imagePhoto;
@synthesize ProfileDelegate;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
     _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    userID.text = [_app._account getUserID];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	//PHOTO
	if(buttonIndex == 0){
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
        
        imagePhoto.layer.cornerRadius = 5.0f;
        imagePhoto.layer.masksToBounds = YES;
        imagePhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imagePhoto.layer.borderWidth = 1.0f;
        
        UIImage *thumb = [self makeThumbnailImage:rotat onlyCrop:YES Size:50];
        [imagePhoto setImage:thumb];
    }
    
    if (popover != nil) {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [ProfileDelegate mgFirstProfile_iPad_DismissModalView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    
    [ProfileDelegate mgFirstProfile_iPad_DismissModalView];
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

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
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
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
}

#pragma mark -
#pragma mark Button Action

- (IBAction)profileImageBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PHOTO", @"CAMERA",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}

- (IBAction)saveBtn:(id)sender {
    [self initLoadBar];
    [self startLoadBar];
    
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
        [self dismissModalViewControllerAnimated:YES];
        [ProfileDelegate mgFirstProfile_iPad_SkipTrue];
        
        [self endLoadBar];
        
    }else{
        [self showAlert:msg tag:TAG_MSG_NONE];
        [self endLoadBar];
    }
}

- (IBAction)skipBtn:(id)sender {
    [_app._account setSkip:TRUE];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [ProfileDelegate mgFirstProfile_iPad_SkipTrue];
}

- (void)viewDidUnload {
    [self setNickName:nil];
    [self setUserID:nil];
    [self setImagePhoto:nil];
    [self setMyGoal:nil];
    [super viewDidUnload];
}

- (NSString*)uploadImage:(UIImage *)image filename:(NSString*)filename{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
    
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
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"nick_nm\"\r\n\r\n%@", nickName.text] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //goal
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"goal\"\r\n\r\n%@", myGoal.text] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    NSString *fileYN = nil;
    
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
    UIImage *image = (UIImage*)imagePhoto.image;
    
    if (image == nil) {
        return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
    }
    
    return [self uploadImage:image filename:[[NSString alloc]initWithFormat:@"%@%02d.jpg", [self getnerateFileName], 0]];
}

- (NSString*)getnerateFileName{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMdd"];
    NSString *strNow = [fmt stringFromDate:now];
    return [[NSString alloc]initWithFormat:@"%@_%@", [_app._account getUserID], strNow];
}

@end

//
//  mgAskLecWriteVC_iPad.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecWriteVC_iPad.h"
#import "mgAskLecWriteOptVC_iPad.h"
#import "SBJsonParser.h"
#import "mgCommon.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface mgAskLecWriteVC_iPad ()
{
    CGRect rtTextView;
    UITextView *_tvQuestion;
    
    UIPopoverController *popover;
}
@end

@implementation mgAskLecWriteVC_iPad
{
    CGRect _tvQuestionFrame; // 텍스트뷰 이전 위치
    
    UIToolbar *_tbKeyboard;
    
    NSString *type_cd;
    NSString *qChrType;
    
    UIButton *cancelBtn;
    UIButton *completeBtn;
}

@synthesize dlg;

@synthesize _lblLecTitle;
@synthesize _lblLecture, _tfLectureIndex;
@synthesize _imageV, _imgTextViewBG;

@synthesize brd_cd;
@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;
@synthesize chr_nm;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (_tvQuestion == nil) {
        rtTextView = CGRectMake(11, 139, 334, 331);
        
        _tvQuestion = [[UITextView alloc]initWithFrame:rtTextView];
        _tvQuestion.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        _tvQuestion.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tvQuestion];
        
        UIImage *bgImage = [[UIImage imageNamed:@"_bg_textfield2"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [_imgTextViewBG setImage:bgImage];
    }
    
    _lblLecture.text = chr_nm;
    
    [_tvQuestion becomeFirstResponder];
    
    [self initKeyboard];
    [self initImageView];
    
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
    [self set_lblLecture:nil];
    [self set_tfLectureIndex:nil];
    [self set_imageV:nil];
    [super viewDidUnload];
}

- (void)resizeTextView
{
    if (_imageV.hidden == true) {
        [_tvQuestion setFrame:rtTextView];
    }else{
        [_tvQuestion setFrame:CGRectMake(rtTextView.origin.x, rtTextView.origin.y, rtTextView.size.width-76, rtTextView.size.height)];
    }
}

- (void)initImageView
{
    _imageV.userInteractionEnabled = YES;
    _imageV.alpha = 0.8f;
    
    _imageV.layer.cornerRadius = 5.0f;
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageV.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
    [_imageV addGestureRecognizer:tgr];
    
    UITapGestureRecognizer *_tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLectureIndex)];
    [_tfLectureIndex addGestureRecognizer:_tgr];
}

- (void)touchImage:(id)sender{
    [self showAlertChoose:@"선택한 이미지를 삭제하시겠습니까?" tag:TAG_MSG_IMAGEDEL];
}

// _tfLectureIndex 이벤트 처리
- (void) touchLectureIndex{
    _tbKeyboard.hidden = YES;
    
    [_tvQuestion resignFirstResponder];
    
    tview = [[[NSBundle mainBundle] loadNibNamed:@"mgAskLecWriteOptVC_iPad" owner:self options:nil] objectAtIndex:0];
    tview.frame = CGRectMake(0, 0, 350, 480);
    tview.app_no = self.app_no;
    tview.app_seq = self.app_seq;
    tview.chr_cd = self.chr_cd;
    tview.dlg = self;
    
    [tview initMethod];
    [self.view addSubview:tview];
}

- (void)initKeyboard{
    // 키보드 액세서리 만들어 붙이자
    UIImage *keyboardBg = [UIImage imageNamed:@"clean_nor"];
    _tbKeyboard = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 36.0f)];
    [_tbKeyboard setBackgroundImage:keyboardBg forToolbarPosition:0 barMetrics:0];
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCamera setFrame:CGRectMake(_tbKeyboard.frame.size.width - 687.0f, 0.0f, 175.0f, 36.0f)];
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"P_btn_camera_normal"] forState:UIControlStateNormal];
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"P_btn_camera_pressed"] forState:UIControlStateHighlighted];
    [_tbKeyboard addSubview:btnCamera];
    
    UIButton *btnAlubm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAlubm setFrame:CGRectMake(_tbKeyboard.frame.size.width - 512.0f, 0.0f, 175.0f, 36.0f)];
    [btnAlubm setBackgroundImage:[UIImage imageNamed:@"P_btn_album_normal"] forState:UIControlStateNormal];
    [btnAlubm setBackgroundImage:[UIImage imageNamed:@"P_btn_album_pressed"] forState:UIControlStateHighlighted];
    [_tbKeyboard addSubview:btnAlubm];
    
    _tvQuestion.inputAccessoryView = _tbKeyboard;
    
    UITapGestureRecognizer *_cameragr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCamera:)];
    [btnCamera addGestureRecognizer:_cameragr];
    
    UITapGestureRecognizer *_albumgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAlbum:)];
    [btnAlubm addGestureRecognizer:_albumgr];
}

#pragma mark -
#pragma mark Button Action

- (void)complete{
    if([qChrType isEqualToString:@""] == YES){
        [self showAlert:@"질문대상을 선택해주세요." tag:TAG_MSG_NONE];
        return;
        
    }else if([_tvQuestion.text isEqualToString:@""] == YES){
        [self showAlert:@"내용을 입력해주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    [self SendQuestionToServer];
    
    [self initLoadBar];
    [self startLoadBar];
}

- (void)touchCamera:(id)sender{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)touchAlbum:(id)sender{
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

- (void)completeAction{
    [self complete];
}

- (void)cancelAction{
    [self showAlertChoose:@"질문하기를 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
}

#pragma mark -
#pragma mark mgAskLecOptVCDelegate

- (void)mgAskLecOptVC_iPad_Hidden{
    _tbKeyboard.hidden = NO;
}

- (void)mgAskLecOptVC_iPad_touchClose:(NSString *)title code:(NSString *)code qChrType:(NSString *)type{
    //NSLog(@"mgAskLecOptVCDelegate - %@, %@, %@", title, code, type);
    _tbKeyboard.hidden = NO;
    _tfLectureIndex.text = title;
    type_cd = code;
    qChrType = type;
}

#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    return YES;
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

#pragma mark -
#pragma mark UIImagePickerView Deleagate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSLog(@"%@", info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqual:@"public.image"]) {
        _imageV.hidden = NO;
        [_imageV setImage:(UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage]];
        [self resizeTextView];
    }
    
    if (popover != nil) {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }else{

        [self dismissViewControllerAnimated:YES completion:nil];

        [dlg mgAskLecWriteVC_iPad_DismissModalView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [dlg mgAskLecWriteVC_iPad_DismissModalView];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_IMAGEDEL){
        if(buttonIndex == 1){
            _imageV.hidden = YES;
            [self resizeTextView];
        }
    }
    
    if(alertView.tag == TAG_MSG_WRITE_CANCEL){
        if(buttonIndex == 1){
 
            [self dismissModalViewControllerAnimated:YES];
            
            [dlg mgAskLecWriteVC_iPad_DismissModalView];
        }
    }
    
    if(alertView.tag == TAG_MSG_WRITE_SUCCESS){

        [self dismissModalViewControllerAnimated:YES];
        
        [dlg mgAskLecWriteVC_iPad_DismissModalView];
    }
}

#pragma mark -
#pragma mark mgImageV Delegate

// 이미지뷰 닫기
- (void)mgImageV_touchClose:(id)mgImageV{
    [mgImageV removeFromSuperview];
}

#pragma mark
#pragma mark NSURLConnection

- (NSString*)uploadImage:(UIImage *)image filename:(NSString*)filename{
    NSString *returnString;
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *_app_no = self.app_no;
    NSString *_app_seq = self.app_seq;
    NSString *_qst_chr_cd = self.chr_cd;
    NSString *_brd_cd = self.brd_cd;
    NSString *_method = @"ins";
    NSString *_qflg = @"1"; // 1로 고정
    NSString *_qChrType = qChrType; // 1 : 강의, 3:교재
    NSString *_lec_cd = @"";
    NSString *_book_cd = @"";
    NSString *title = _tfLectureIndex.text;
    NSString *_content = _tvQuestion.text;
    
    if ([_qChrType isEqualToString:@"1"]) {
        _lec_cd = type_cd;
    }else{
        _book_cd = type_cd;
    }
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@", URL_FILE_DOMAIN, URL_QNASEND];
    
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
    
    //app_no
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"app_no\"\r\n\r\n%@", _app_no] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //app_seq
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"app_seq\"\r\n\r\n%@", _app_seq] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_qst_chr_cd
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qst_chr_cd\"\r\n\r\n%@", _qst_chr_cd] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_brd_cd
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"brd_cd\"\r\n\r\n%@", _brd_cd] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_method
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"method\"\r\n\r\n%@", _method] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_qflg
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qflg\"\r\n\r\n%@", _qflg] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_qChrType
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qChrType\"\r\n\r\n%@", _qChrType] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //_lec_cd
    if (![_lec_cd isEqualToString:@""]) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lec_cd\"\r\n\r\n%@", _lec_cd] dataUsingEncoding:encodeType] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    }
    
    if (![_book_cd isEqualToString:@""]) {
        //book_cd
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"book_cd\"\r\n\r\n%@", _book_cd] dataUsingEncoding:encodeType] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    }
    
    //title
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n%@", title] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    if ([filename isEqualToString:@""]) {
        //content
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content\"\r\n\r\n%@", _content] dataUsingEncoding:encodeType] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:encodeType] ];
    }else{
        //content
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content\"\r\n\r\n%@", _content] dataUsingEncoding:encodeType] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
        
        // file data
        // RFC문서를 보면 이미지 파일에 대해서 별도의 boundary를 다시 설정해 주는데요. 일단 리눅스서버에 PHP로 작업한 경우에는
        // 지금처럼 작성해도 문제가 없었습니다만 다른 서버에는 문제가 될지도 모르겠습니다.
        [body appendData:[[[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"att_file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:encodeType]];
        [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:encodeType]];
        [body appendData:[[NSString stringWithFormat:@"Content-Length: %i\r\n\r\n", imageData.length] dataUsingEncoding:encodeType]];
        [body appendData:[[NSData alloc]initWithData:imageData]]; // 실제 이미지 Data를 append 해줌
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:encodeType] ];
    }
    
    //NSLog(@"%@", [[NSString alloc] initWithData:body encoding:encodeType]);
	[request setHTTPBody:body];
    
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Return String = %@",returnString);
    
    return returnString;
}

// 서버로 의견 보내기
- (void)SendQuestionToServer{
    NSString *ret = [self uploadMedia];
    
    if ([ret isEqualToString:@""]) {
        [self showAlert:@"통신 중 오류가 발생하였습니다. 다시 시도해 주시기 바랍니다." tag:TAG_MSG_NONE];
    }
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:ret error:NULL];
    
    if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
        [self endLoadBar];
        [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_WRITE_SUCCESS];
        
    }else{
        [self endLoadBar];
        [self showAlert:@"글쓰기가 실패하였습니다. 잠시 후 다시 이용해주세요." tag:TAG_MSG_NONE];
    }
}

- (NSString*)uploadMedia{
    if (! _imageV.hidden) {
        UIImage *image = (UIImage*)_imageV.image;
        return [self uploadImage:image filename:[[NSString alloc]initWithFormat:@"%@.jpg", [self getnerateFileName]]];
    }
    
    return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
}

- (NSString*)getnerateFileName{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strNow = [fmt stringFromDate:now];
    return [[NSString alloc]initWithFormat:@"qst_%@", strNow];
}


#pragma mark -
#pragma 회전 관련

- (BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

@end


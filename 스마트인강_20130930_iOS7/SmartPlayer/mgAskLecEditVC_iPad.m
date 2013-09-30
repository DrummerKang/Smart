//
//  mgAskLecEditVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecEditVC_iPad.h"
#import "AppDelegate.h"
#import "mgCommon.h"
#import "SBJsonParser.h"

@implementation mgAskLecEditVC_iPad
{
    CGRect _tvQuestionFrame; // 텍스트뷰 이전 위치
    
    UIToolbar *_tbKeyboard;
    
    NSString *type_cd;
    NSString *qChrType;
    
    CGRect rtTextView;
    UITextView   *_tvQuestion;
}

@synthesize editDelegate;
@synthesize _lblLecture;
@synthesize _imgTextViewBG;
@synthesize _tfLectureIndex;
@synthesize _imageV;

@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;
@synthesize chr_nm;
@synthesize brd_cd;
@synthesize bidx;

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
    
    [self initKeyboard];
    [self initImageView];
    
    [_tvQuestion becomeFirstResponder];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_QNAEDIT];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]                                                                       forKey:@"acc_key"];
    [dic setObject:app_no                                                                                           forKey:@"app_no"];
    [dic setObject:app_seq                                                                                          forKey:@"app_seq"];
    [dic setObject:chr_cd                                                                                           forKey:@"chr_cd"];
    [dic setObject:brd_cd                                                                                           forKey:@"brd_cd"];
    [dic setObject:bidx                                                                                             forKey:@"bidx"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnEdit = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnEdit){
        editData = [[NSMutableData alloc] init];
    }
}

- (void)resizeTextView
{
    if (_imageV.hidden == true) {
        [_tvQuestion setFrame:rtTextView];
    }else{
        [_tvQuestion setFrame:CGRectMake(rtTextView.origin.x, rtTextView.origin.y, rtTextView.size.width-76, rtTextView.size.height)];
    }
}

- (void)initImageView{
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
    _tvQuestion.inputAccessoryView = _tbKeyboard;
    
    UITapGestureRecognizer *_cameragr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCamera:)];
    [btnCamera addGestureRecognizer:_cameragr];
    
    UITapGestureRecognizer *_albumgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAlbum:)];
    [btnAlubm addGestureRecognizer:_albumgr];
}

#pragma mark -
#pragma mark Button Action

- (void) touchLectureIndex{
    _tbKeyboard.hidden = YES;
    [_tfLectureIndex resignFirstResponder];
    
    tview = [[[NSBundle mainBundle] loadNibNamed:@"mgAskLecWriteOptVC_iPad" owner:self options:nil] objectAtIndex:0];
    tview.frame = CGRectMake(0, 0, 350, 480);
    tview.app_no = self.app_no;
    tview.app_seq = self.app_seq;
    tview.chr_cd = self.chr_cd;
    tview.dlg = self;
    
    [tview initMethod];
    [self.view addSubview:tview];
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

- (IBAction)cancelBtn:(id)sender {
     [self showAlertChoose:@"질문수정을 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
}

- (IBAction)saveBtn:(id)sender {
    [self SendQuestionToServer];
    [self initLoadBar];
    [self startLoadBar];
}

- (void)viewDidUnload {
    [self set_imgTextViewBG:nil];
    [self set_imageV:nil];
    [self set_lblLecture:nil];
    [self set_tfLectureIndex:nil];
    [self set_imgTextViewBG:nil];
    [super viewDidUnload];
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
        
        [editDelegate mgAskLecEditVC_iPad_DismissModalView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [editDelegate mgAskLecEditVC_iPad_DismissModalView];
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
            
            [editDelegate mgAskLecEditVC_iPad_DismissModalView];
        }
    }
    
    if(alertView.tag == TAG_MSG_WRITE_SUCCESS){
        
        [self dismissModalViewControllerAnimated:YES];
        
        [editDelegate mgAskLecEditVC_iPad_DismissModalView];
    }
}

#pragma mark -
#pragma mark NSURLConnection

- (NSArray *)generatorParameters:(NSDictionary *)param{
    // 임시 배열을 생성한 후
    // 모든 key 값을 받와 해당 키값으로 값을 반환하고
    // 해당 키와 값을 임시 배열에 저장 후 반환하는 함수
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:[param count]];
    
    NSArray * allKeys = [param allKeys];
    
    for (NSString * key in allKeys){
        NSString * value = [param objectForKey:key];
        [result addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    return result;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection == urlConnEdit) {
        [editData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnEdit) {
        NSString *encodeData = [[NSString alloc] initWithData:editData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSString *result = [dic objectForKey:@"result"];
        //NSString *msg = [dic objectForKey:@"msg"];
        
        //NSLog(@"질문수정_result : %@", result);
        //NSLog(@"질문수정_msg : %@", msg);
        //NSLog(@"질문수정_dic : %@", dic);
        
        NSArray *aDataArr = [dic objectForKey:@"aData"];
        NSDictionary *aData = [aDataArr objectAtIndex:0];
        
        qChrType = [aData valueForKey:@"qChrType"];
        lec_cd = [aData valueForKey:@"lec_cd"];
        book_cd = [aData valueForKey:@"book_cd"];
        
        _lblLecture.text = [aData valueForKey:@"title"];
        _tvQuestion.text = [aData valueForKey:@"content"];
        
        bidx = [aData valueForKey:@"bidx"];
        
        NSString *file_path = [aData valueForKey:@"file_path"];
        //NSLog(@"%@", file_path);
        
        if (![file_path isEqualToString:@""]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:file_path]]];
            if (image != nil) {
                [_imageV setImage:image];
                _imageV.hidden = NO;
                [self resizeTextView];
            }
        }
    }
}

#pragma mark -
#pragma mark Connection

- (NSString*)uploadImage:(UIImage *)image filename:(NSString*)filename{
    NSString *returnString;
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *_app_no = self.app_no;
    NSString *_app_seq = self.app_seq;
    NSString *_qst_chr_cd = self.chr_cd;
    NSString *_brd_cd = brd_cd;
    NSString *_method = @"upd";
    NSString *_qflg = @"1"; // 1로 고정
    NSString *_qChrType = qChrType; // 1 : 강의, 3:교재
    NSString *_lec_cd = @"";
    NSString *_book_cd = @"";
    NSString *title = _lblLecture.text;
    NSString *_content = _tvQuestion.text;
    NSString *_bidx = bidx;
    
    if ([_qChrType isEqualToString:@"1"]) {
        _lec_cd = lec_cd;
        //NSLog(@"%@", _lec_cd);
    }else{
        _book_cd = lec_cd;
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
    
    //NSLog(@"%@", _lec_cd);
    //NSLog(@"%@", _book_cd);
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
    
    //bidx
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bidx\"\r\n\r\n%@", _bidx] dataUsingEncoding:encodeType] ];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"통신 중 오류가 발생하였습니다. 다시 시도해 주시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:ret error:NULL];
    
    if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
        [self endLoadBar];
        [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_WRITE_SUCCESS];
        
    }else{
        [self endLoadBar];
        [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
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

@end

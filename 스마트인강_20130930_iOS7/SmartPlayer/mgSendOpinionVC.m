//
//  mgSendOpinionVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSendOpinionVC.h"
#import "AppDelegate.h"
#import "mgCommon.h"
#import "SBJsonParser.h"
#import "mgGlobal.h"

@interface mgSendOpinionVC ()

@end

@implementation mgSendOpinionVC
{
    UIToolbar *_tbKeyboard;
    UIButton *completeBtn;
    
    CGRect rtTextView;
    
    UITextView       *_tvOpinionContent;
}

@synthesize _tfOpinionTitle, /*_tvOpinionContent, */_lblOpinionCD, _imgOpinion, _imgTextViewBG;
@synthesize opiNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (_tvOpinionContent == nil) {
        // 7.0이상
        if([mgCommon osVersion_7]){
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                rtTextView = CGRectMake(20, 106, 280, 204);
                
            }else{
                rtTextView = CGRectMake(20, 106, 280, 106);
            }
            
        }else {
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                rtTextView = CGRectMake(15, 76, 290, 204);
                
            }else{
                rtTextView = CGRectMake(15, 80, 290, 106);
            }
        }
        _tvOpinionContent = [[UITextView alloc]initWithFrame:rtTextView];
        _tvOpinionContent.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        _tvOpinionContent.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tvOpinionContent];
    }
    
    UIImage *bgImage = [[UIImage imageNamed:@"_bg_textfield2"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_imgTextViewBG setImage:bgImage];

    UITapGestureRecognizer * _tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLectureIndex)];
    [_tfOpinionTitle addGestureRecognizer:_tgr];
    
    [_tvOpinionContent becomeFirstResponder];
    
    [opiNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    opiNavigationBar.translucent = NO;
    [opiNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                               [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                               [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    [self initImageView];
    [self completeMethod];
    [self initKeyboard];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_tvOpinionContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_tfOpinionTitle:nil];
//    [self set_tvOpinionContent:nil];
    [self set_imgOpinion:nil];
    [self set_lblOpinionCD:nil];
    [self set_imgTextViewBG:nil];
    [super viewDidUnload];
}

- (void)touchLectureIndex{
    [self performSegueWithIdentifier:@"sgPopType" sender:self];
}

- (void)resizeTextView
{
    if (_imgOpinion.hidden == true) {
        [_tvOpinionContent setFrame:rtTextView];
    }else{
        [_tvOpinionContent setFrame:CGRectMake(rtTextView.origin.x, rtTextView.origin.y, rtTextView.size.width-90, rtTextView.size.height)];
    }
}

- (void)initKeyboard{
    // 키보드 액세서리 만들어 붙이자
    UIImage *keyboardBg = [UIImage imageNamed:@"keypad_bar"];
    _tbKeyboard = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 36.0f)];
    [_tbKeyboard setBackgroundImage:keyboardBg forToolbarPosition:0 barMetrics:0];
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCamera setFrame:CGRectMake(_tbKeyboard.frame.size.width - 320.0f, 0.0f, 160.0f, 36.0f)];
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"btn_camera_normal"] forState:UIControlStateNormal];
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"btn_camera_pressed"] forState:UIControlStateHighlighted];
    [_tbKeyboard addSubview:btnCamera];
    
    UIButton *btnAlubm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAlubm setFrame:CGRectMake(_tbKeyboard.frame.size.width - 160.0f, 0.0f, 158.0f, 36.0f)];
    [btnAlubm setBackgroundImage:[UIImage imageNamed:@"btn_album_normal"] forState:UIControlStateNormal];
    [btnAlubm setBackgroundImage:[UIImage imageNamed:@"btn_album_pressed"] forState:UIControlStateHighlighted];
    [_tbKeyboard addSubview:btnAlubm];
    
    _tvOpinionContent.inputAccessoryView = _tbKeyboard;

    UITapGestureRecognizer *_cameragr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCamera:)];
    [btnCamera addGestureRecognizer:_cameragr];
    
    UITapGestureRecognizer *_albumgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAlbum:)];
    [btnAlubm addGestureRecognizer:_albumgr];
}

- (void)initImageView
{
    _imgOpinion.userInteractionEnabled = YES;
    
    _imgOpinion.alpha = 0.8f;
    
    _imgOpinion.layer.cornerRadius = 5.0f;
    _imgOpinion.layer.masksToBounds = YES;
    _imgOpinion.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgOpinion.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
    [_imgOpinion addGestureRecognizer:tgr];
    /*
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panImage:)];
    [_imgOpinion addGestureRecognizer:pgr];
     */
}

#pragma mark -
#pragma mark Button Action

- (IBAction)backBtn:(id)sender {
    [self showAlertChoose:@"문의/의견 보내기를 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
}

- (void)completeMethod{
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        completeBtn.frame = CGRectMake(255, 27, 60, 30);
    }else{
        completeBtn.frame = CGRectMake(255, 7, 60, 30);
    }

    [completeBtn addTarget:self action:@selector(touchSend:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:completeBtn];
}

- (void)touchImage:(id)sender{
    [self showAlertChoose:@"선택한 이미지를 삭제하시겠습니까?" tag:TAG_MSG_IMAGEDEL];
}

- (void)panImage:(id)sender
{
    UIPanGestureRecognizer *panRecognizer =
    (UIPanGestureRecognizer *)sender;
    if (panRecognizer.state == UIGestureRecognizerStateBegan ||
        panRecognizer.state == UIGestureRecognizerStateChanged ||
        panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint currentPoint = _imgOpinion.center;
        CGPoint translation = [panRecognizer translationInView:_imgOpinion.superview];
        _imgOpinion.center = CGPointMake(currentPoint.x + translation.x, currentPoint.y + translation.y);
        [panRecognizer setTranslation: CGPointZero inView: _imgOpinion.superview];
    }
}

- (void)touchCamera:(id)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)touchAlbum:(id)sender
{
    [self startAlbumControllerFromViewController];
}

- (void)backView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// 질문답변 보내기
- (void)touchSend:(id)sender
{
    if ([_tfOpinionTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"보내실 의견 항목을 선택하여주시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_tvOpinionContent.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"보내실 의견 항목을 기재하여 보내주시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self initLoadBar];
    [self startLoadBar];
    [self SendOpinionToServer];
}

// 서버로 의견 보내기
- (void)SendOpinionToServer
{
    NSString *ret = [self uploadMedia];
    
    if ([ret isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"통신 중 오류가 발생하였습니다. 다시 시도해 주시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:ret error:NULL];

    if ([[dic objectForKey:@"result"]isEqualToString:@"0000"] == YES) {
        [self endLoadBar];
        [self showAlert:@"발송되었습니다." tag:TAG_MSG_WRITE_SUCCESS];
        
    }else{
        [self endLoadBar];
        [self showAlert:@"의견보내기가 실패하였습니다. 잠시 후 이용해주세요." tag:TAG_MSG_NONE];
    }
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"sgPopType"])
    {
        mgOpinionTypeVC *nextVC = (mgOpinionTypeVC*)segue.destinationViewController;
        // mgOpinionTypeVC 의 객체에 데이터 넘기기
        nextVC.dlgt_OpinionTypeVC = self;
    }
}

#pragma mark -
#pragma mark mgOpinionTypeVC Delegate

- (void)mgOpinionTypeVC_SelectedOpinionType:(NSString *)type typeCode:(int)code{
    _tfOpinionTitle.text = type;
    _lblOpinionCD.text = [[NSString alloc]initWithFormat:@"%d", code];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)startAlbumControllerFromViewController
{
    //이미지피커 띄우기
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSLog(@"%@", info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqual:@"public.image"]) {
        //[_arrUploadFileUrl addObject:info];
        [_imgOpinion setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        _imgOpinion.hidden = NO;
        
        [self resizeTextView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //[controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(NSString*)uploadImage:(UIImage *)image filename:(NSString*)filename{
    NSString *returnString;
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *t_cd = _lblOpinionCD.text;
    NSString *content = _tvOpinionContent.text;
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@", URL_FILE_DOMAIN, URL_OPI_SEND];
    
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
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"t_cd\"\r\n\r\n%@", t_cd] dataUsingEncoding:encodeType] ];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:encodeType] ];
    
    //goal
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content\"\r\n\r\n%@", content] dataUsingEncoding:encodeType] ];
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
	returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Return String = %@",returnString);
    
    return returnString;
}

- (NSString*)uploadMedia{
    if (! _imgOpinion.hidden) {
        UIImage *image = (UIImage*)_imgOpinion.image;
        return [self uploadImage:image filename:[[NSString alloc]initWithFormat:@"%@%02d.jpg", [self getnerateFileName], 0]];
    }
    
    return [self uploadImage:nil filename:[[NSString alloc]initWithFormat:@""]];
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
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_IMAGEDEL){
        if(buttonIndex == 1){
            _imgOpinion.hidden = YES;
            [self resizeTextView];
        }
    }
    
    if(alertView.tag == TAG_MSG_WRITE_CANCEL){
        if(buttonIndex == 1){
            [self backView:nil];
        }
    }
    
    if(alertView.tag == TAG_MSG_WRITE_SUCCESS){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark 회전 관련

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

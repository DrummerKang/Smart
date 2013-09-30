//
//  mgMessageAskQuestionVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageAskQuestionVC.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "mgCommon.h"

@interface mgMessageAskQuestionVC ()
{
    NSURLConnection *conn;
    NSMutableData *mData;
}
@end

@implementation mgMessageAskQuestionVC
{
    UIToolbar *_tbKeyboard;
    UIButton *completeBtn;
    NSMutableArray *marrRecentIDs;
}

@synthesize _tfReceiveID, _tvMessageContent, _sReceiverName, _sReplyID, _sReplyName;
@synthesize writeNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UITapGestureRecognizer *_tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLectureIndex)];
    [_tfReceiveID addGestureRecognizer:_tgr];
    
    [self completeMethod];
    
    [writeNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    writeNavigationBar.translucent = NO;
    [writeNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];

    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    marrRecentIDs = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:MYTALK_ID]];
    if(marrRecentIDs != nil){
        if (marrRecentIDs.count>0) {
            NSDictionary *_dic = [marrRecentIDs objectAtIndex:marrRecentIDs.count - 1];
            _tfReceiveID.text = [_dic objectForKey:@"id"];
            _sReceiverName = [_dic objectForKey:@"name"];
        }
    }else{
        marrRecentIDs = [[NSMutableArray alloc]init];
    }
    
    // 회신 아이디
    if (![_sReplyID isEqualToString:@""] && _sReplyID != nil ) {
        _tfReceiveID.text = _sReplyID;
        _sReceiverName = _sReplyName;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
    [self set_tfReceiveID:nil];
    [self set_tvMessageContent:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_tvMessageContent becomeFirstResponder];
}

- (void)touchLectureIndex{
    [self performSegueWithIdentifier:@"selectLecture" sender:self];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)backBtn:(id)sender {
    [self showAlertChoose:@"쪽지쓰기를 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
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

- (void)completeAction{
    if(_tfReceiveID.text.length == 0){
        [self showAlert:@"받는사람을 선택해주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    if(_tvMessageContent.text.length == 0){
        [self showAlert:@"내용을 입력해주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    [self SendMessage];
}

- (void)SendMessage
{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_ACTION];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    NSString *title = @"";
    if (_tvMessageContent.text.length < 10) {
        title = _tvMessageContent.text;
    }else{
        title = [[NSString alloc]initWithFormat:@"%@…", [_tvMessageContent.text substringToIndex:10]];
    }
    
    NSString *encodingStr = @"";
    encodingStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)_tvMessageContent.text, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8));
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:@"INS"                               forKey:@"method"];
    [dic setObject:@""                                  forKey:@"tidx"];
    [dic setObject:title                                forKey:@"title"];
    [dic setObject:encodingStr                          forKey:@"content"];
    [dic setObject:_tfReceiveID.text                    forKey:@"r_id"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (mData == nil){
        mData = [[NSMutableData alloc] init];
    }else{
        [mData setLength:0];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

- (void)backView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectLecture"]) {
        mgMessageAskQuestionLecOpt1VC *nextView = (mgMessageAskQuestionLecOpt1VC*)segue.destinationViewController;
        nextView.delegate = self;
    }
}

#pragma mark -
#pragma mark mgMessageAskQuestionLecOpt1VCDelegate

- (void)mgMessageAskQuestionLecOpt1VC_touchClose:(NSString*)sid name:(NSString *)name{
    _tfReceiveID.text = sid;
    _sReceiverName = name;
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
    [mData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *encodeData = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    
    if ([[dic objectForKey:@"result"] isEqualToString:@"0000"] == YES) {
        if (marrRecentIDs.count >= 5) {
	    // 인덱스 레이블은 무시
            [marrRecentIDs removeObjectAtIndex:0];
        }
        
        if (![self IsSameID:_tfReceiveID.text]) {
            [marrRecentIDs addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:_tfReceiveID.text, @"id", _sReceiverName, @"name", nil]];
            [defaults setObject:marrRecentIDs forKey:MYTALK_ID];
            [defaults synchronize];
        }
        
        [self showAlert:@"발송되었습니다." tag:TAG_MSG_TALK_SUCCESS];

    }else{
        [self showAlert:@"쪽지 보내기가 실패하였습니다. 잠시 후 이용해주세요." tag:TAG_MSG_NONE];
    }
    
    [self endLoadBar];
}

- (bool)IsSameID:(NSString*)sid
{
    //NSLog(@"%@", marrRecentIDs);
    
    int cnt = marrRecentIDs.count;
    int idx = 0;
    for (idx = 0; idx < cnt; idx++)
    {
        NSDictionary *dic = [marrRecentIDs objectAtIndex:idx];
        NSString *compId = [dic objectForKey:@"id"];
        
        if ([compId isEqualToString:sid]) {
            return true;
        }
    }
    
    return false;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_WRITE_CANCEL){
        if(buttonIndex == 1){
            [self backView:nil];
        }
    }
    
    if(alertView.tag == TAG_MSG_TALK_SUCCESS){
        [self.navigationController popViewControllerAnimated:YES];
    }
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

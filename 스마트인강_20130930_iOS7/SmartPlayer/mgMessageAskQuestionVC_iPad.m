//
//  mgMessageAskQuestionVC_iPad.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageAskQuestionVC_iPad.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "mgSettingMenuView_iPad.h"

@interface mgMessageAskQuestionVC_iPad ()
{
    NSURLConnection *conn;
    NSMutableData *mData;
}
@end

@implementation mgMessageAskQuestionVC_iPad
{
    UIToolbar *_tbKeyboard;
    NSMutableArray *marrRecentIDs;
    
    UIButton *cancelBtn;
    UIButton *completeBtn;
}

@synthesize _tfReceiveID, _tvMessageContent, _sReceiverName, _sReplyID, _sReplyName;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [_tvMessageContent becomeFirstResponder];
    
    UITapGestureRecognizer *_tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLectureIndex)];
    [_tfReceiveID addGestureRecognizer:_tgr]; 

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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
    [self set_tfReceiveID:nil];
    [self set_tvMessageContent:nil];
    [super viewDidUnload];
}

- (void)touchLectureIndex{
    [_tvMessageContent resignFirstResponder];

    tview = [[[NSBundle mainBundle] loadNibNamed:@"mgMessageAskQuestionOptTView_iPad" owner:self options:nil] objectAtIndex:0];
    tview.frame = CGRectMake(0, 0, 350, 480);
    tview.dlg = self;
    
    [tview initMethod];
    [self.view addSubview:tview];
}

#pragma mark -
#pragma mark Button Action

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

//완료버튼
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

- (void)cancelAction{
    [self showAlertChoose:@"쪽지쓰기를 취소하시겠습니까?" tag:TAG_MSG_WRITE_CANCEL];
}

- (void)backView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark mgMessageAskQuestionOptTView_iPad

- (void)mgMessageAskQuestionOptTView_iPad_touchClose:(NSString*)sid name:(NSString *)name{
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
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
    if(alertView.tag == TAG_MSG_TALK_SUCCESS){
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end

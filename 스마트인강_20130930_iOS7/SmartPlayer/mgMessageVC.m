//
//  mgMessageVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 13..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageVC.h"
#import "mgMessageCellView.h"
#import "mgMessageReviewAnswerVC.h"
#import "mgMessageAskQuestionVC.h"

#import "AppDelegate.h"
#import "mgLoginVC.h"
#import "mgFirstProfileVC.h"
#import "SBJsonParser.h"
#import "JSONKit.h"
#import "mgCommon.h"

@interface mgMessageVC (){
    UIButton *messageWriteBtn;
    
    int startindex;
    int totalindex;
}

@end

@implementation mgMessageVC

@synthesize talkNavigationBar;
@synthesize _messageSV;
@synthesize noBgImage;
@synthesize naviItem;

static int itemPerPage = 10;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
 
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [talkNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    talkNavigationBar.translucent = NO;
    [talkNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    messageWriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageWriteBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [messageWriteBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        messageWriteBtn.frame = CGRectMake(255, 27, 60, 30);
    }else {
        messageWriteBtn.frame = CGRectMake(255, 7, 60, 30);
    }

    [messageWriteBtn addTarget:self action:@selector(msgWriteAction) forControlEvents:UIControlEventTouchUpInside];
    [messageWriteBtn setTitle:@"쪽지쓰기" forState:UIControlStateNormal];
    messageWriteBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:messageWriteBtn];
    
    startindex = 0;
    totalindex = 0;
    
    _messageSV = [_messageSV initWithFrame:CGRectMake(0, 0, 0, 0)];
    _messageSV.delegate = self;
    _messageSV._dlgtMessageScrollView = self;
    
    [_messageSV setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"_bg_tile_myTalk"]]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_messageSV:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageArrived) name:@"TalkReceived" object:nil];

    
    [self badgeToZero];   
    [self initMethod];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TalkReceived" object:nil];
}

- (void)newMessageArrived
{
    [self badgeToZero]; 
    
    [self initMethod];
}

- (void)badgeToZero{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)initMethod{
    startindex = 0;
    totalindex = 0;
    
    [_messageSV clearMessage];
    
    [self getTalkListAtIndex:startindex withItemCount:itemPerPage];
}

- (void)getTalkListAtIndex:(int)index withItemCount:(int)count{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_LIST];
    //NSLog(@"%@", url);
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:[_app._account getAcc_key]                               forKey:@"acc_key"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", index]            forKey:@"startRowNum"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", count]            forKey:@"itemPerPage"];
    
    //NSLog(@"params=%@,%d,%d", [_app._account getAcc_key], index, count);
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnTalkList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self initLoadBar];
    [self startLoadBar];
    
    if (talkListData  == nil){
        talkListData= [[NSMutableData alloc] init];
    }else{
        [talkListData setLength:0];
    }
}

// 네비게이션 좌측 바버튼 눌렀을때 처리
- (void)touchMenu:(id)sender{
    SlideNavigationController *vc = (SlideNavigationController*)self.parentViewController;
    if ([vc isMenuOpen]) {
        [vc closeSlide];
    }else{
        [vc openSlide];
    }
}

// 로그인 화면 팝업
- (void)PopupLogin{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //자동 로그인 처리
    if([_app._account getUsageAutoLogin] == TRUE){
        [self autoLogin];
        skipNum = 1;
        return;
    }
    
    UIStoryboard *_newStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Login4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Login" bundle:nil];
    }
    
    mgLoginVC *_loginVC = [_newStoryboard instantiateInitialViewController];
    [self presentModalViewController:_loginVC animated:YES];
}

// 최초프로필 화면 팝업
- (void)PopupFirstProfile{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //최초 한번만 프로필 설정을 띄운다.
    if([_app._account getIsSkip] == TRUE){
        
    }else{
        UIStoryboard *_newStoryboard = nil;
        
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_FirstProfile4" bundle:nil];
        }else{
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_FirstProfile" bundle:nil];
        }
        
        mgFirstProfileVC *_profileVC = [_newStoryboard instantiateInitialViewController];
        [self presentViewController:_profileVC animated:YES completion:nil];
        return;
    }
    
    //로그인하고 난뒤 기본설정값 읽어오기
    if([_app._account getIsLogin] == TRUE){
        [self basicSetting];
        
        //시작할때 자동로그인 or 로그인할때 자동로그인 체크인지 확인
    }else if([_app._account getUsageAutoLogin] == TRUE){
        if(skipNum == 1){
            
        }else{
            [self autoLogin];
        }
    }
}

// 기본셋팅
- (void)basicSetting{
    
}

//자동 로그인
- (void)autoLogin{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    parserAuto = @"autoLogin";
    parserBasic = @"";
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN_LOGIN, URL_AUTO_LOGIN];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]                                                                       forKey:@"acc_key"];
    [dic setObject:[_app._account getEnc_info]                                                                      forKey:@"enc_info"];
    [dic setObject:[UIDevice currentDevice].systemVersion                                                           forKey:@"os_ver"];
    [dic setObject:[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"]        forKey:@"app_ver"];
    [dic setObject:[_app._account getToken]                                                                         forKey:@"push_id"];
    [dic setObject:@"2"                                                                                             forKey:@"push_svr"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnection){
        messageData= [[NSData alloc] init];
    }
}

- (IBAction)menuBtn:(id)sender {
    SlideNavigationController *vc = (SlideNavigationController*)self.parentViewController;
    if ([vc isMenuOpen]) {
        [vc closeSlide];
    }else{
        [vc openSlide];
    }
}

#pragma mark -
#pragma mark mgMessageScrollView Delegate

- (void) mgMessageScrollViewTouchCell:(id)mgMessageViewCell{
    switch ([mgMessageViewCell getFlag])
    {
        case _flg_SEND:
        {
            UIStoryboard *_newStoryboard = nil;
            
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgA4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgA" bundle:nil];
            }
            
            mgMessageReviewAnswerVC *nextVC = (mgMessageReviewAnswerVC*)[_newStoryboard instantiateInitialViewController];
            nextVC._Message = [mgMessageViewCell getMessage];
            nextVC.tidx = [mgMessageViewCell getTIdx];
            nextVC.timeStr = [mgMessageViewCell getDateStamp];
            nextVC.s_nm = [mgMessageViewCell getSenderName];
            nextVC.r_nm = [mgMessageViewCell getReceiverName];
            
            [self.navigationController pushViewController:nextVC animated:YES];
        }break;
            
        case _flg_RECV:
        {
            UIStoryboard *_newStoryboard = nil;
            
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgA4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgA" bundle:nil];
            }
            
            mgMessageReviewAnswerVC *nextVC = (mgMessageReviewAnswerVC*)[_newStoryboard instantiateInitialViewController];
            nextVC._Message = [mgMessageViewCell getMessage];
            nextVC.tidx = [mgMessageViewCell getTIdx];
            nextVC.timeStr = [mgMessageViewCell getDateStamp];
            nextVC.s_nm = [mgMessageViewCell getSenderName];
            nextVC.r_nm = [mgMessageViewCell getReceiverName];
            
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

- (void) mgMessageScrollViewTouchCellForReply:(id)mgMessageViewCell
{// 답장하기
    mgMessageCellView *cell = (mgMessageCellView*)mgMessageViewCell;
    
    // 질문하기
    UIStoryboard *_newStoryboard = nil;
    
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgQ4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgQ" bundle:nil];
    }
    
    mgMessageAskQuestionVC *nextVC = [_newStoryboard instantiateInitialViewController];
    nextVC._sReplyID = [cell getSendID];
    nextVC._sReplyName = [cell getSenderName];    
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    // 맨 아래가면 다음 페이지 추가
    if(distanceFromBottom < height){
        if ((startindex+itemPerPage+1) < totalindex) {
            startindex += (itemPerPage+1);
            [self getTalkListAtIndex:startindex withItemCount:itemPerPage];
            return;
        }
    }
    
    // 맨 위로가면 재조횐
    if(scrollView.contentOffset.y < -100){
        [self newMessageArrived];
        return;
    }
}

#pragma mark -
#pragma mark Button Action

- (void)msgWriteAction{
    UIStoryboard *_newStoryboard = nil;
    
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgQ4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyMsgQ" bundle:nil];
    }
    
    mgMessageReviewAnswerVC *nextVC = [_newStoryboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:nextVC animated:YES];
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
    if(connection == urlConnTalkList){
        [talkListData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    [self endLoadBar];
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        //NSLog(@"인터넷 연결 NO : 0");
        [self showAlertChoose:@"네트워크가 작동되지 않습니다. \n 재시도 하시겠습니까?" tag:TAG_MSG_NETWORK];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self endLoadBar];
    
    if (connection == urlConnTalkList) {
        NSString *encodeData = [[NSString alloc] initWithData:talkListData encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [encodeData objectFromJSONString];
        //NSLog(@"마이톡_dic : %@", dic);
        
        if (startindex == 0) {
            totalindex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"tot_cnt"]intValue];
            NSLog(@"%d", totalindex);
        }
        
        NSArray *countArr = [[dic valueForKey:@"aData"] valueForKey:@"pos_ar"];
        
        for(int i = 0; i < [countArr count]; i++){
            NSArray *msgArr = [dic valueForKey:@"aData"];
            NSDictionary *msgDic = [msgArr objectAtIndex:i];
            NSString *msg = [msgDic valueForKey:@"content"];
            
            msg = [[msg stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            msg = [self stringByStrippingHTML:msg];
            
            NSString *time = [msgDic valueForKey:@"reg_dt"];
            NSString *pos_ar = [msgDic valueForKey:@"pos_ar"];
            NSString *tidx = [msgDic valueForKey:@"tidx"];
            NSString *r_nm = [msgDic valueForKey:@"r_nm"];
            NSString *s_nm = [msgDic valueForKey:@"s_nm"];
            NSString *r_id = [msgDic valueForKey:@"r_id"];
            NSString *s_id = [msgDic valueForKey:@"s_id"];
            //관리자모드 글 판단
            NSString *v_flg = [msgDic valueForKey:@"view_flg"];
            NSString *title = [msgDic valueForKey:@"title"];
            title = [[title stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            title = [self stringByStrippingHTML:title];
            
            if (msg.length > 80) {
                msg = [[NSString alloc]initWithFormat:@"%@…", [msg substringToIndex:80]];
            }
            
            if([pos_ar isEqualToString:@"1"] == YES){
                if([v_flg isEqualToString:@"1"] == YES){
                    msg = [NSString stringWithFormat:@"%@ \n %@", title, msg];
                }
                // 받은거
                [_messageSV addMessage:msg timestamp:time tidx:tidx senderName:s_nm senderID:s_id receiverName:r_nm receiverID:r_id viewFlg:v_flg flag:_flg_SEND];
                
            }else if([pos_ar isEqual:@"0"] == YES){
                s_nm = [NSString stringWithFormat:@"%@", r_nm];
                // 보낸거
                [_messageSV addMessage:msg timestamp:time tidx:tidx senderName:s_nm senderID:s_id receiverName:r_nm receiverID:r_id viewFlg:nil flag:_flg_RECV];
            }
        }
        
        if(totalindex == 0){
            noBgImage.hidden = NO;
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshBadge" object:nil];
    }
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//NSLog(@"alertView tag = %d", alertView.tag);
	
	if(alertView.tag == TAG_MSG_NETWORK){
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self initMethod];
        }
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

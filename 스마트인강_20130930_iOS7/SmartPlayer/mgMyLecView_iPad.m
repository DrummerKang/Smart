//
//  mgMyLecView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 31..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMyLecView_iPad.h"
#import "mgMyLecCell_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "AquaDBManager.h"
#import "AquaContentHandler.h"
#import "mgPopoverBgV.h"
#import "NSString+URL.h"

#define MUTE 6000

@implementation mgMyLecView_iPad
{
    UIPopoverController *popover;
}

@synthesize noItemView;
@synthesize lecTable;
@synthesize lecTitle;
@synthesize cls_nm;
@synthesize chr_ogz;
@synthesize make_nm;
@synthesize progress;
@synthesize std_sdt;
@synthesize std_edt;

@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;
@synthesize chr_nm;
@synthesize brd_cd;
@synthesize free_yn;
@synthesize subject;
@synthesize teacher;
@synthesize imgPath;

@synthesize moveBtn;
@synthesize move2Btn;
@synthesize lecQuestionBtn;
@synthesize downloadBtn;

@synthesize brd_cdArr;
@synthesize brd_tec_nmArr;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [lecQuestionBtn setFrame:CGRectMake(554, 583, 114, 44)];
        [downloadBtn setFrame:CGRectMake(492, 583, 44, 44)];
    }
    return self;
}

- (void)ReloadLecList{
    [self downloadCheck];
    [self initLoad];
}

- (void)initMethod:(NSString *)no seq:(NSString *)seq cd:(NSString *)cd photo:(NSString *)photo nm:(NSString *)nm yn:(NSString *)yn subject:(NSString *)sub teacher:(NSString *)tec paht:(NSString *)path footer:(NSDictionary *)fDic{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadLecList) name:@"ReloadLecList" object:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    app_no = no;
    app_seq = seq;
    chr_cd = cd;
    
    teacher = tec;
    subject = sub;
    imgPath = photo;
    chr_nm = nm;

   _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [moveBtn setFrame:CGRectMake(666, 603, 28, 44)];
    [moveBtn setFrame:CGRectMake(666, 603, 28, 44)];
    [lecQuestionBtn setFrame:CGRectMake(544, 603, 114, 44)];
    [downloadBtn setFrame:CGRectMake(492, 603, 44, 44)];
    
    bookmarkFinish = @"0";
    
    [self downloadCheck];
    [self initLoad];
    
    footerDic = fDic;
}

- (void)noItem{
    noItemView.hidden = NO;
}

- (void)initLoad{
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_MYLEC_LIST];       
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:app_no                               forKey:@"app_no"];
    [dic setObject:app_seq                              forKey:@"app_seq"];
    [dic setObject:chr_cd                               forKey:@"chr_cd"];
    [dic setObject:@"0"                                 forKey:@"lst_type"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnLec = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnLec){
        lecData  = [[NSMutableData alloc] init];
        
        [self initLoadBar];
        [self homeLoadBar];
    }
}

//다운로드 받은 강좌체크
- (bool)checkDownloadComplete:(int)row
{
    NSMutableArray *bDataArr = [myLecDic objectForKey:@"bData"];
    
    //다운받은 강의
    NSMutableArray *downCompleteArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] selectAllLecCD:downCompleteArr];
    //NSLog(@"%d", [downCompleteArr count]);
    for(int i = 0; i < [downCompleteArr count]; i++){
        NSDictionary *arrDic = [downCompleteArr objectAtIndex:i];
        
        NSString *lecCDNum = [arrDic valueForKey:@"lecCD"];
        //NSLog(@"%@", lecCDNum);
        NSString *quality = [arrDic valueForKey:@"moveQuality"];
        
        
        for(int j = 0; j < [bDataArr count]; j++){
            NSDictionary *lecCDDic = [bDataArr objectAtIndex:row];
            
            NSString *lec_CdNum = [lecCDDic valueForKey:@"lec_cd"];
            
            if([lecCDNum isEqualToString:lec_CdNum] == YES){
                if([quality isEqualToString:@"high"] == YES){
                    return true;
                    
                }else if([quality isEqualToString:@"low"] == YES){
                    return true;
                }
            }
        }
    }
    
    return false;
}

//다운중인 강좌 체크
- (bool)checkDownloading:(int)row
{
    NSMutableArray *bDataArr = [myLecDic objectForKey:@"bData"];
    
    //다운받고 있는 강의
    NSMutableArray *downLecCDArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downLecCDArr];
    //NSLog(@"%d", [downLecCDArr count]);
    
    for(int i = 0; i < [downLecCDArr count]; i++){
        NSDictionary *arrDic = [downLecCDArr objectAtIndex:i];
        
        NSString *lecCDNum = [arrDic valueForKey:@"lecCD"];
        //NSLog(@"%@", lecCDNum);
        NSString *quality = [arrDic valueForKey:@"moveQuality"];
        
        
        for(int j = 0; j < [bDataArr count]; j++){
            NSDictionary *lecCDDic = [bDataArr objectAtIndex:row];
            
            NSString *lec_CdNum = [lecCDDic valueForKey:@"lec_cd"];
            
            if([lecCDNum isEqualToString:lec_CdNum] == YES){
                if([quality isEqualToString:@"high"] == YES){
                    return true;
                    
                }else if([quality isEqualToString:@"low"] == YES){
                    return true;
                }
            }
        }
    }
    
    return false;
}

#pragma mark -
#pragma mark FooterView

- (void)makeFooterView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 694, 62)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_con_btn.png"]];
    bgImage.frame = CGRectMake(15, 10, 327, 42);
    [bgView addSubview:bgImage];
    
    NSArray *aDataArr = [footerDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:0];
    
    stopText = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 650, 42)];
    stopText.backgroundColor = [UIColor clearColor];
    stopText.textColor = [self getColor:@"8fa4c9"];
    stopText.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
    
    //일시정지
    stopON = [UIButton buttonWithType:UIButtonTypeCustom];
    stopON.frame = CGRectMake(212, 16, 124, 29);
    stopON.exclusiveTouch = YES;
    [stopON addTarget:self action:@selector(stopONAction) forControlEvents:UIControlEventTouchUpInside];
    [stopON setBackgroundImage:[UIImage imageNamed:@"btn_stop@2x"] forState:UIControlStateNormal];
    [stopON setBackgroundImage:[UIImage imageNamed:@"btn_stop@2x"] forState:UIControlStateHighlighted];
    
    //해지하기
    stopOFF = [UIButton buttonWithType:UIButtonTypeCustom];
    stopOFF.frame = CGRectMake(253, 16, 83, 29);
    stopOFF.exclusiveTouch = YES;
    [stopOFF addTarget:self action:@selector(stopOFFAction) forControlEvents:UIControlEventTouchUpInside];
    [stopOFF setBackgroundImage:[UIImage imageNamed:@"btn_clear@2x"] forState:UIControlStateNormal];
    [stopOFF setBackgroundImage:[UIImage imageNamed:@"btn_clear@2x"] forState:UIControlStateHighlighted];
    
    if([[aData valueForKey:@"stop_flg"] isEqualToString:@"0"] == YES){
        stopON.hidden = YES;
        stopOFF.hidden = YES;
        stopText.text = @"일시정지 불가입니다.";
        
    }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"1"]){
        stopON.hidden = NO;
        stopOFF.hidden = YES;
        stopText.text = @"일시정지 신청이 가능합니다.";
        
    }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"2"] == YES){
        stopON.hidden = YES;
        stopOFF.hidden = NO;
        stopText.text = @"일시정지 예정입니다.";
        
    }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"3"] == YES){
        stopON.hidden = YES;
        stopOFF.hidden = NO;
        stopText.text = @"일시정지 사용중입니다.";
        
    }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"4"] == YES){
        stopON.hidden = YES;
        stopOFF.hidden = YES;
        stopText.text = @"일시정지 사용완료입니다.";
    }
    
    [bgView addSubview:stopText];
    [bgView addSubview:stopON];
    [bgView addSubview:stopOFF];
     
    lecTable.tableFooterView = bgView;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return lecCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgMyLecCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgMyLecCell_iPad identifier]];
    if (cell == nil) {
        cell = [mgMyLecCell_iPad create];
    }
    
    NSMutableArray *bDataArr = [myLecDic objectForKey:@"bData"];
    NSMutableDictionary *bData = [bDataArr objectAtIndex:indexPath.row];
    
    cell.subject.text = [bData valueForKey:@"lec_title"];
    cell.endDay.text = [bData valueForKey:@"lst_dt"];
    NSString *timeText = [NSString stringWithFormat:@"%@분",[bData valueForKey:@"lec_tm"]];
    cell.lecTime.text = timeText;
    
    if([[bData valueForKey:@"vod_norm_yn"] isEqualToString:@"false"] == YES){
        cell.sdPlay.enabled = NO;
    }else{
        if ([bData valueForKey:@"sdPlayDisable"] != nil) {
            cell.sdPlay.enabled = NO;
        }else{
            cell.sdPlay.enabled = YES;
        }
    }
    
    if([[bData valueForKey:@"vod_high_yn"] isEqualToString:@"false"] == YES){
        cell.hdPlay.enabled = NO;
    }else{
        if ([bData valueForKey:@"hdPlayDisable"] != nil) {
            cell.hdPlay.enabled = NO;
        }else{
            cell.hdPlay.enabled = YES;
        }
    }
    
    if([[bData valueForKey:@"file_norm_yn"] isEqualToString:@"false"] == YES){
        cell.sdDown.enabled = NO;
    }else{
        if ([bData valueForKey:@"sdDownDisable"] != nil) {
            cell.sdDown.enabled = NO;
        }else{
            cell.sdDown.enabled = YES;
        }
    }
    
    if([[bData valueForKey:@"file_high_yn"] isEqualToString:@"false"] == YES){
        cell.hdDown.enabled = NO;
    }else{
        if ([bData valueForKey:@"hdDownDisable"] != nil) {
            cell.hdDown.enabled = NO;
        }else{
            cell.hdDown.enabled = YES;
        }
    }
    
    cell.sdPlay.tag = indexPath.row;
    [cell.sdPlay addTarget:self action:@selector(sdPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.sdDown.tag = indexPath.row;
    [cell.sdDown addTarget:self action:@selector(sdDownAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.hdPlay.tag = indexPath.row;
    [cell.hdPlay addTarget:self action:@selector(hdPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.hdDown.tag = indexPath.row;
    [cell.hdDown addTarget:self action:@selector(hdDownAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[bData valueForKey:@"vod_msg"] isEqualToString:nil] == YES){
        UIImageView *newImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P_box_cnt2"]];
        [newImage setFrame:CGRectMake(15, 60, 665, 44)];
        [cell addSubview:newImage];
        
        UILabel *pcText = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 650, 42)];
        pcText.text = @"PC 전용강좌입니다.";
        pcText.backgroundColor = [UIColor clearColor];
        pcText.textColor = [self getColor:@"8fa4c9"];
        pcText.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        [cell addSubview:pcText];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark -
#pragma mark Button Action

//일시정지 신청
- (void)stopONAction{
    NSArray *aDataArr = [footerDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:0];
    
    NSDictionary *stopDic = [NSDictionary dictionaryWithObjectsAndKeys:[aData valueForKey:@"app_no"], @"app_no", [aData valueForKey:@"app_seq"], @"app_seq", nil];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"stopFooter" object:self userInfo:stopDic];
}

//해지하기
- (void)stopOFFAction{
    [self showAlertChoose:@"수강 일시정지 기간 중입니다. \n일시정지를 해제하시겠습니까?" tag:TAG_MSG_LECDOING];
}

- (void)sdPlayAction:(UIButton *)btn{
    timeNum = btn.tag;
    
    //다운로드 중일때는 플레이 못하게...
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    if([downloadArr count] > 0){
        [self showAlert:@"다운로드 중에는 강의Play가 되지 않습니다. 다운로드 완료 후 다시 시도해 주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    NSMutableArray *sdArr = [myLecDic objectForKey:@"bData"];
    NSMutableDictionary *bData = [sdArr objectAtIndex:btn.tag];
    
    if([[bData valueForKey:@"vod_norm_yn"] isEqual:@"true"] == YES){
        NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_SD_PLAY];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
        
        [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
        [dic setObject:app_no                               forKey:@"app_no"];
        [dic setObject:app_seq                              forKey:@"app_seq"];
        [dic setObject:chr_cd                               forKey:@"chr_cd"];
        [dic setObject:[bData valueForKey:@"lec_cd"]        forKey:@"lec_cd"];
        [dic setObject:[bData valueForKey:@"player_kbn"]    forKey:@"player_kbn"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnPlay = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (nil != urlConnPlay){
            playData = [[NSMutableData alloc] init];
        }
        
        [bData setValue:@"1" forKey:@"sdPlayDisable"];
        [sdArr replaceObjectAtIndex:btn.tag withObject:bData];
        
    }else{
        [self showAlert:@"동영상 파일이 없습니다." tag:TAG_MSG_NONE];
    }
}

- (void)sdDownAction:(UIButton *)btn{
    moveQuality = @"low";
    
    mgMyLecCell_iPad *_cell = (mgMyLecCell_iPad*)[[btn superview]superview];
    UIButton *_btn = (UIButton*)[_cell viewWithTag:1];
    _btn.enabled = NO;

    NSInteger nIndex = btn.tag;

    //다운로드 받은
    if ([self checkDownloadComplete:nIndex]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"다운로드 받은 강좌입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //다운로드 중인
    if ([self checkDownloading:nIndex]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"다운로드 작업 중인 강좌입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *bDataArr = [myLecDic objectForKey:@"bData"];
    NSMutableDictionary *bData = [bDataArr objectAtIndex:nIndex];
    lec_cd = [bData valueForKey:@"lec_cd"];
    finishDay = [bData valueForKey:@"lst_dt"];
    
    if([[bData valueForKey:@"file_high_yn"] isEqual:@"true"] == YES){
        NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_DEVICE_CHECK];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
        [dic setObject:[_app._account getEnc_info]          forKey:@"enc_info"];
        [dic setObject:[defaults stringForKey:DEVICE_ID]    forKey:@"deviceid"];
        [dic setObject:[UIDevice currentDevice].model       forKey:@"devicemodel"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnDeviceCheck = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (nil != urlConnDeviceCheck){
            deviceCheckData = [[NSMutableData alloc] init];
        }
        
        [bData setValue:@"1" forKey:@"sdDownDisable"];
        [bDataArr replaceObjectAtIndex:nIndex withObject:bData];
        
    }else{
        [self showAlert:@"동영상 파일이 없습니다." tag:TAG_MSG_NONE];
    }
}

- (void)hdPlayAction:(UIButton *)btn{
    timeNum = btn.tag;
    
    //다운로드 중일때는 플레이 못하게...
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    if([downloadArr count] > 0){
        [self showAlert:@"다운로드 중에는 강의Play가 되지 않습니다. 다운로드 완료 후 다시 시도해 주세요." tag:TAG_MSG_NONE];
        return;
    }
    
    NSMutableArray *hdArr = [myLecDic objectForKey:@"bData"];
    NSMutableDictionary *bData = [hdArr objectAtIndex:btn.tag];
    
    if([[bData valueForKey:@"vod_high_yn"] isEqual:@"true"] == YES){
        NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_HIGH_PLAY];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
        
        [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
        [dic setObject:app_no                               forKey:@"app_no"];
        [dic setObject:app_seq                              forKey:@"app_seq"];
        [dic setObject:chr_cd                               forKey:@"chr_cd"];
        [dic setObject:[bData valueForKey:@"lec_cd"]        forKey:@"lec_cd"];
        [dic setObject:[bData valueForKey:@"player_kbn"]    forKey:@"player_kbn"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnPlay = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (nil != urlConnPlay){
            playData = [[NSMutableData alloc] init];
        }
        
        [bData setValue:@"1" forKey:@"hdPlayDisable"];
        [hdArr replaceObjectAtIndex:btn.tag withObject:bData];
        
    }else{
        [self showAlert:@"동영상 파일이 없습니다." tag:TAG_MSG_NONE];
    }
}

- (void)hdDownAction:(UIButton *)btn{
    moveQuality = @"high";
    
    mgMyLecCell_iPad *_cell = (mgMyLecCell_iPad*)[[btn superview]superview];
    UIButton *_btn = (UIButton*)[_cell viewWithTag:2];
    _btn.enabled = NO;

    NSInteger nIndex = btn.tag;
    NSLog(@"nIndex : %d", nIndex);
    
    //다운로드 받은
    if ([self checkDownloadComplete:nIndex]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"다운로드 받은 강좌입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //다운로드 중인
    if ([self checkDownloading:nIndex]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"다운로드 작업 중인 강좌입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *bDataArr = [myLecDic objectForKey:@"bData"];
    NSMutableDictionary *bData = [bDataArr objectAtIndex:nIndex];
    lec_cd = [bData valueForKey:@"lec_cd"];
    finishDay = [bData valueForKey:@"lst_dt"];
    
    if([[bData valueForKey:@"file_high_yn"] isEqual:@"true"] == YES){
        NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_DEVICE_CHECK];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
        [dic setObject:[_app._account getEnc_info]          forKey:@"enc_info"];
        [dic setObject:[defaults stringForKey:DEVICE_ID]    forKey:@"deviceid"];
        [dic setObject:[UIDevice currentDevice].model       forKey:@"devicemodel"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnDeviceCheck = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (nil != urlConnDeviceCheck){
            deviceCheckData = [[NSMutableData alloc] init];
        }
        
        [bData setValue:@"1" forKey:@"hdDownDisable"];
        [bDataArr replaceObjectAtIndex:nIndex withObject:bData];
        
    }else{
        [self showAlert:@"동영상 파일이 없습니다." tag:TAG_MSG_NONE];
    }
}

//다운로드
- (void)downloadLec{
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_DOWNLOADURL];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [dic setObject:app_no                               forKey:@"app_no"];
    [dic setObject:app_seq                              forKey:@"app_seq"];
    [dic setObject:[_app._account getUserID]            forKey:@"uid"];
    [dic setObject:chr_cd                               forKey:@"chr_cd"];
    [dic setObject:lec_cd                               forKey:@"lec_cd"];
    [dic setObject:moveQuality                          forKey:@"MoveQuality"];
    [dic setObject:[defaults stringForKey:DEVICE_ID]    forKey:@"deviceid"];
    [dic setObject:[UIDevice currentDevice].model       forKey:@"devicemodel"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnDown = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (nil != urlConnDown){
        downData = [[NSMutableData alloc] init];
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
    if (connection == urlConnLec) {
        [lecData appendData:data];
    }else if(connection == urlConnPlay){
        [playData appendData:data];
    }else if(connection == urlConnDown){
        [downData appendData:data];
    }else if(connection == urlConnDeviceCheck){
        [deviceCheckData appendData:data];
    }else if(connection == urlConnBookMarkDel){
        [bookMarkDelData appendData:data];
    }else if(connection == urlConnDo){
        [doingData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        //NSLog(@"인터넷 연결 NO : 0");
        [self showAlertChoose:@"네트워크가 작동되지 않습니다. \n 재시도 하시겠습니까?" tag:TAG_MSG_NETWORK];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnLec) {
        NSString *encodeData = [[NSString alloc] initWithData:lecData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dic = (NSMutableDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"수강중인 강좌 : %@", dic);
        
        NSArray *aDataArr = [dic objectForKey:@"aData"];
        if([aDataArr count] == 0){
            noItemView.hidden = NO;
            return;
        }
        
        NSArray *bDataArr = [dic objectForKey:@"bData"];
        NSDictionary *aData = [aDataArr objectAtIndex:0];
        lecCount = [bDataArr count];
        
        brd_cdArr = [aData objectForKey:@"brd_cd"];
        brd_tec_nmArr = [aData objectForKey:@"brd_tec_nm"];
        
        [lecTitle  setText:[aData objectForKey:@"chr_nm"]];
        [cls_nm  setText:[aData objectForKey:@"cls_nm"]];
        [chr_ogz  setText:[aData objectForKey:@"chr_ogz"]];
        [make_nm  setText:[aData objectForKey:@"make_nm"]];
        [std_sdt  setText:[aData objectForKey:@"std_sdt"]];
        [std_edt  setText:[aData objectForKey:@"std_edt"]];
        [progress setText:[NSString stringWithFormat:@"%@ / %@ (%@%%)", [aData valueForKey:@"view_cnt"], [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"progress"]]];
        
        // 미수강 위치를 구하여 자동스크롤 하기위해 옵셋값을 구함
        AutoOffsetY = 0;
        for (NSDictionary *dic in bDataArr) {
            NSString *lst_dt = [dic valueForKey:@"lst_dt"];
            if (![lst_dt isEqualToString:@"미수강"]) {
                AutoOffsetY += 1;
                //NSLog(@"%d", AutoOffsetY);
            }
        }
        
        if([bDataArr count] == AutoOffsetY){
            AutoOffsetY = [bDataArr count] -1;
        }
        
        [self endLoadBar];
        [lecTable reloadData];
        
        myLecDic = dic;
        [self makeFooterView];
        
    }else if (connection == urlConnPlay) {
        NSString *encodeData = [[NSString alloc] initWithData:playData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", encodeData);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if([[dic objectForKey:@"result"] isEqualToString:@"0000"] == YES){
            NSArray *aDataArr = [dic objectForKey:@"aData"];
            NSDictionary *aData = [aDataArr objectAtIndex:0];
            //NSLog(@"플레이영상ALL : %@", [aData valueForKey:@"i_path"]);
            
            //url 앞부분 삭제
            NSString *pathURL = [aData valueForKey:@"i_path"];
            NSArray *pathArray = [pathURL componentsSeparatedByString:@"cnmpx://"];
            NSString *pathDel = [pathArray objectAtIndex:1];
            //NSLog(@"플레이영상 : %@", pathDel);
            
            playerURL = pathDel;
            
            //BookMark URL 뽑아내기 위해서...
            NSArray *param1 = [pathDel componentsSeparatedByString:@"?"];
            NSString *paramS1 = [param1 objectAtIndex:1];
            NSArray *param2 = [paramS1 componentsSeparatedByString:@"&"];
            NSString *paramS2 = [param2 objectAtIndex:0];
            //NSLog(@"%@", paramS2);
            
            NSString *decryptParam = [CDNMoviePlayer decryptString:paramS2];
            //NSLog(@"다운로드 파라미터 : %@", decryptParam);
            
            NSArray *paramArr3 = [decryptParam componentsSeparatedByString:@"userid="];
            NSString *paramStr3 = [paramArr3 objectAtIndex:1];
            NSArray *paramArr4 = [paramStr3 componentsSeparatedByString:@"&"];
            bookmarkUserID = [paramArr4 objectAtIndex:0];
            //NSLog(@"%@", bookmarkUserID);
            
            NSArray *paramArr9 = [decryptParam componentsSeparatedByString:@"bookmark_url="];
            NSString *paramStr9 = [paramArr9 objectAtIndex:1];
            NSArray *paramArr10 = [paramStr9 componentsSeparatedByString:@"&"];
            bookmarkString = [paramArr10 objectAtIndex:0];
            //NSLog(@"%@", bookmarkString);
            
            NSArray *paramArr11 = [decryptParam componentsSeparatedByString:@"bookmark_data="];
            NSString *paramStr11 = [paramArr11 objectAtIndex:1];
            NSArray *paramArr12 = [paramStr11 componentsSeparatedByString:@"&"];
            bookmarkData = [paramArr12 objectAtIndex:0];
            
            NSArray *paramArr13 = [decryptParam componentsSeparatedByString:@"pos="];
            NSString *paramStr13 = [paramArr13 objectAtIndex:1];
            NSArray *paramArr14 = [paramStr13 componentsSeparatedByString:@"&"];
            bookmarkPos = [paramArr14 objectAtIndex:0];
            
            bookmarkData = [bookmarkData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bookmarkString = [bookmarkString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", bookmarkData);
            //NSLog(@"%@", bookmarkString);
            //NSLog(@"다운로드 파라미터 주소 : %@", paramStr2);
            
            if(_app._ReachStatus == 1){
                NSLog(@"%d", [bookmarkPos intValue]);
                if([bookmarkPos intValue] != 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"Play를 중간에 중단하셨습니다." delegate:self cancelButtonTitle:@"이어보기" otherButtonTitles:@"처음부터 보기" ,nil];
                    [alert show];
                    alert.tag = TAG_MSG_STREMCONTINUE;
                    
                    return;
                }
                
                isAirPlay = NO;
                NSString *content = [NSString stringWithFormat:@"%@%d/%@", STREAMING_URL, [CDNMoviePlayer getPort], playerURL];
                
                [self executePlayer:[NSURL URLWithString:content] pos:[bookmarkPos intValue]];
                
            }else if(_app._ReachStatus == 2){
                [self showAlert:@"3G & LTE로 동영상 이용시 과다 요금이 발생할 수 있습니다." tag:TAG_MSG_STREAMPLAY];
            }
            
        }else{
            
        }
        
    }else if(connection == urlConnDeviceCheck){
        NSString *encodeData = [[NSString alloc] initWithData:deviceCheckData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"등록된 디바이스 체크  : %@", dic);
        
        if([[dic objectForKey:@"result"] isEqualToString:@"301"] == YES){
            [self downloadLec];
            
        }else if([[dic objectForKey:@"result"] isEqualToString:@"000"] == YES){
            [self showAlertChoose:[dic valueForKey:@"msg"] tag:TAG_MSG_DEVICE_SUBMIT];
            
        }else{
            [self showAlert:[dic valueForKey:@"msg"] tag:TAG_MSG_NONE];
        }

    }else if(connection == urlConnDown){
        NSString *encodeData = [[NSString alloc] initWithData:downData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"다운로드 영상 주소 : %@", dic);
        
        NSString *result = [dic valueForKey:@"result"];
        
        if ([result isEqualToString:@"000"]) {
            NSArray *aDataArr = [dic objectForKey:@"aData"];
            
            NSDictionary *aData = [aDataArr objectAtIndex:0];
            
            NSString *decryptParam = [CDNMoviePlayer decryptString:[aData valueForKey:@"param"]];
            //NSLog(@"다운로드 파라미터 : %@", decryptParam);
            paramString = [aData valueForKey:@"param"];
            
            NSArray *paramArr1 = [decryptParam componentsSeparatedByString:@"download_list_url="];
            NSString *paramStr1 = [paramArr1 objectAtIndex:1];
            NSArray *paramArr2 = [paramStr1 componentsSeparatedByString:@"&"];
            NSString *paramStr2 = [paramArr2 objectAtIndex:0];
            
            NSArray *paramArr3 = [decryptParam componentsSeparatedByString:@"offline_period="];
            NSString *paramStr3 = [paramArr3 objectAtIndex:1];
            NSArray *paramArr4 = [paramStr3 componentsSeparatedByString:@"&"];
            offline_period = [paramArr4 objectAtIndex:0];
            
            //NSLog(@"다운로드 파라미터 주소 : %@", paramStr2);
            //NSLog(@"다운로드 오프라인 날짜 : %@", offline_period);
            
            paramStr2 = [paramStr2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            requestDown = [HTTPNetworkManager requestWithURL:paramStr2 setDelegate:self finishSel:@selector(requestDone:) failSel:@selector(requestFailed:)];
        }else{
            NSString *ErrorMsg = [dic valueForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:ErrorMsg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    }else if(connection == urlConnBookMarkDel){
        NSString *encodeData = [[NSString alloc] initWithData:bookMarkDelData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];

        if ([[dic valueForKey:@"result"] isEqualToString:@"0000"]) {
            [self initLoad];
            
            [self showAlert:@"북마크가 삭제되었습니다." tag:TAG_MSG_BOOKMARK_DEL];
        }
    
    }else if(connection == urlConnDo){
        NSString *encodeData = [[NSString alloc] initWithData:doingData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if([[dic objectForKey:@"result"] isEqualToString:@"0000"] == YES){
            [self downloadCheck];
            [self initLoad];
            
            [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
            
        }else{
            [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
        }
    }
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //스트리밍 플레이
	if ( alertView.tag == TAG_MSG_STREAMPLAY ) {
        
        if([bookmarkPos intValue] != 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"Play를 중간에 중단하셨습니다." delegate:self cancelButtonTitle:@"이어보기" otherButtonTitles:@"처음부터 보기" ,nil];
            [alert show];
            alert.tag = TAG_MSG_STREMCONTINUE;
            
            return;
        }
        
        isAirPlay = NO;
        NSString *content = [NSString stringWithFormat:@"%@%d/%@", STREAMING_URL, [CDNMoviePlayer getPort], playerURL];

        [self executePlayer:[NSURL URLWithString:content] pos:[bookmarkPos intValue]];
        
    //디바이스 체크
    }else if(alertView.tag == TAG_MSG_DEVICE_SUBMIT){
        if(buttonIndex == 1){
            [CDNMoviePlayer registerDevice:_app._config._sPlayer_reg];
            BOOL registerDevice = [CDNMoviePlayer registerDevice:_app._config._sPlayer_reg];
            NSLog(@"errorCode : %d", [CDNMoviePlayer errCode]);
            
            if(registerDevice == 0){
                [self downloadLec];
                
            }else{
                [self showAlert:@"오류입니다." tag:TAG_MSG_NONE];
            }
        }
        
    //네트워크 체크
    }else if(alertView.tag == TAG_MSG_NETWORK){
        /*
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self initMethod];
        }
        */
        
    //이어보기 체크
    }else if(alertView.tag == TAG_MSG_STREMCONTINUE){
        //이어보기
        if(buttonIndex == 0){
            posCheck = 0;
            //처음부터 보기
        }else if(buttonIndex == 1){
            posCheck = 1;
        }
        
        isAirPlay = NO;
        NSString *content = [NSString stringWithFormat:@"%@%d/%@", STREAMING_URL, [CDNMoviePlayer getPort], playerURL];
        //NSLog(@"%@", content);
        
        [self executePlayer:[NSURL URLWithString:content] pos:[bookmarkPos intValue]];
    
    }else if(alertView.tag == TAG_MSG_BOOKMARK){
        [self timerMethod];
    
    }else if(alertView.tag == TAG_MSG_BOOKMARK_DEL){
        [self timerMethod];
    
    }else if(alertView.tag == TAG_MSG_LECDOING){
        if(buttonIndex == 1){
            NSArray *aDataArr = [footerDic objectForKey:@"aData"];
            NSDictionary *aData = [aDataArr objectAtIndex:0];
            
            NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_LECTURE_ENDDATE];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            // @param POST와 GET 방식을 나타냄.
            [request setHTTPMethod:@"POST"];
            
            // 파라메터를 NSDictionary에 저장
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
            
            [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
            [dic setObject:[aData valueForKey:@"app_no"]        forKey:@"app_no"];
            [dic setObject:[aData valueForKey:@"app_seq"]       forKey:@"app_seq"];
            
            // NSDictionary에 저장된 파라메터를 NSArray로 제작
            NSArray * params = [self generatorParameters:dic];
            
            // POST로 파라메터 넘기기
            [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
            urlConnDo = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (nil != urlConnDo){
                doingData = [[NSMutableData alloc] init];
            }
        }
    }
}

#pragma mark -
#pragma mark Request Param

- (void)requestDone:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSString *encodeStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"encodeStr : %@", encodeStr);
    
    NSArray *encodeArr = [CDNMoviePlayer decryptDownloadContext:encodeStr];
    //NSLog(@"%@", [CDNMoviePlayer decryptDownloadContext:encodeStr]);
    //NSLog(@"%@", encodeArr);
    
    NSDictionary *encodeDic = [encodeArr objectAtIndex:0];
    //NSLog(@"dic : %@", encodeDic);
    cid = [encodeDic objectForKey:@"cid"];
    downName= [encodeDic objectForKey:@"path"];
    downSmi = [encodeDic objectForKey:@"smi"];
    downURL = [encodeDic objectForKey:@"url"];
    
    //NSLog(@"cid : %@", cid);
    //NSLog(@"downName : %@", downName);
    //NSLog(@"downSmi : %@", downSmi);
    //NSLog(@"downURL : %@", downURL);
    //NSLog(@"lec_cd : %@", lec_cd);
    //NSLog(@"moveQuality : %@", moveQuality);
    //NSLog(@"teacher : %@", teacher);
    //NSLog(@"imgPath : %@", imgPath);
    //NSLog(@"finishDay : %@", finishDay);
    //NSLog(@"offline_period : %@", offline_period);
    
    NSDictionary *downDic = [NSDictionary dictionaryWithObjectsAndKeys:cid, @"VODID", downName, @"VODNAME", downURL, @"VODURL", lec_cd, @"LEC_CD", moveQuality, @"MOVEQUALITY", chr_nm, @"CHR_NM", subject, @"SUBJECT", teacher, @"TEACHER", imgPath, @"IMGPATH", finishDay, @"FINISHDAY", offline_period, @"OFFLINEPERIOD", nil];
    //NSLog(@"downDic : %@", downDic);
    
    if (_app._downloadVC != nil) {
        [_app._downloadVC addItem:downDic param:paramString];
    }
    
    [self downloadCheck];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [self showAlert:@"다운로드 에러입니다." tag:TAG_MSG_NONE];
}

#pragma mark -
#pragma mark CDNPlayer Method

//북마크
- (BOOL) doBookmark{
    NSURL* url = [[NSURL alloc] initWithString:bookmarkString];
    
    NSString *timeString = [NSString stringWithFormat:@"%f", [player getCurrentTime]];
    int posTime = [timeString intValue];
    int TM = [player getTMTime];
    int PT = [player getPTTime];
    NSString *bookmark_PosType = nil;
    
    if([bookmarkFinish isEqualToString:@"0"] == YES){
        bookmark_PosType = @"bookmark";
        
    }else if([bookmarkFinish isEqualToString:@"1"] == YES){
        bookmark_PosType = @"done";
    }
    
    //NSLog(@"%d", posTime);
    NSString* data = [[NSString alloc] initWithFormat:@"%@&pos=%d&pos_type=%@&TM=%d&PT=%d", bookmarkData, posTime * 1000, bookmark_PosType, TM, PT];
    //NSLog(@"%@", data);
    
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse* res = nil;
    NSError* err = nil;
    NSData* receivedData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    NSLog(@"%@", receivedData);
    
    if(nil != err) {
        //NSLog(@"Failed for bookmark! error=%@", [err localizedDescription]); return NO;
    }
    
    //NSLog(@"Success for bookmark!");
    
    if([bookmarkFinish isEqualToString:@"0"] == YES){
        [self showAlert:@"북마크가 추가되었습니다." tag:TAG_MSG_BOOKMARK];
        
        [self initLoad];
    }
    
    bookmarkFinish = @"0";
    
    return YES;
}

- (void) executePlayer:(NSURL *)url pos:(int)pos{
    contentURL = url;
    
    startPos = pos;
    //NSLog(@"%d", startPos);
    
    [self playMovieWithOptions:contentURL from:!isAirPlay];
}

- (void) clearOptionValue{
	if(contentURL)
	{
		contentURL = nil;
	}
}

- (void)playMovieWithOptions:(NSURL*)url from:(BOOL)_from;{
    from = _from;
    
	[self clearOptionValue];
    
    if ([url query] != nil) {
        NSString *urlquery = [url query];
        NSString* decrypted = nil;
        if ([urlquery hasPrefix:@"param="]) {
            urlquery = [urlquery substringFromIndex:6];
            decrypted = [CDNMoviePlayer decryptString:urlquery];
            if (decrypted == nil) {
                //[AquaAlertView showWithId:CDDR_DL_PROTOCOL_INVALID_PARAMETER title:ALERT_NOTICE_TITLE message:[AppErrorHandler messageFromCode:CDDR_DL_PROTOCOL_INVALID_PARAMETER] data:nil delegate:self type:AquaAlertViewTypeOK];
                return;
            }
        }
        
        decrypted = [CDNMoviePlayer decryptString:urlquery];
        if ([decrypted length] == 0)
        {
            decrypted = [url query];
        }
        else {
            NSString *auth = decrypted;
            NSRange start = [decrypted rangeOfString:@"d_id="];
            if (start.location != NSNotFound) {
                NSRange end = [decrypted rangeOfString:@"&" options:1 range:NSMakeRange(start.location, decrypted.length - start.location)];
                if (end.location != NSNotFound) {
                    start.length = end.location - start.location +1;
                    auth = [decrypted stringByReplacingCharactersInRange:start withString:@""];
                }
                else
                {
                    auth = [decrypted substringToIndex:start.location];
                }
                [CDNMoviePlayer setAuth:auth];
            }
            else
            {
                [CDNMoviePlayer setAuth:decrypted];
            }
        }
        
        NSString *contentUrl = nil;
        NSMutableDictionary *watermarkContext = [NSMutableDictionary dictionary];
        NSMutableDictionary *wmText = [NSMutableDictionary dictionary];
        [watermarkContext setValue:wmText forKey:@"wm_text"];
        BOOL hasWatermark = NO;
        NSArray* query = [decrypted componentsSeparatedByString:@"&"];
        NSMutableArray *qArr = [NSMutableArray arrayWithArray:query];
        
        for(NSString* queryStr in qArr)
        {
            NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            NSString* value = [keyValue objectAtIndex:1];
            
            if([key isEqualToString:@"from"])
            {
                from = YES;
            }
            else if([key isEqualToString:@"url"])
            {
                contentUrl = [value urlDecodedString];
                contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            }
            else if([key isEqualToString:@"wm_text"])
            {
                [wmText setValue:value forKey:@"text"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_color"])
            {
                [wmText setValue:value forKey:@"color"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_size"])
            {
                [wmText setValue:value forKey:@"size"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_shade_color"])
            {
                [wmText setValue:value forKey:@"shade_color"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_padding"])
            {
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_pos"])
            {
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_image"])
            {
            }
        }
        
        NSString *port = [[url port] intValue]>0?[NSString stringWithFormat:@":%d",[[url port] intValue]]:@"";
        NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@://%@%@",[url scheme], [url host], port];
        if ([[url path] hasPrefix:@"/cddr_dnp/webstream"]) {
            [urlString appendFormat:@"/%@?%@", contentUrl, decrypted];
        }
        else {
            [urlString appendFormat:@"%@?%@",[url path], decrypted];
            [urlString appendFormat:@"&host=%@", [[urlString pathComponents] objectAtIndex:2]];
        }
        
        NSString *conUrl = [urlString stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        //NSLog(@"%@", conUrl);
        
        [self playMovie:conUrl];
        
    } else {
        NSMutableString* urlString = [[NSMutableString alloc] initWithString:[url absoluteString]];
        //NSLog(@"playMovie=%@", urlString);
        [self playMovie:urlString];
    }
}

//무비 플레이
- (void) playMovie:(NSString*)urlString{
    if (!playerController) {
        [CDNMoviePlayer terminate];
        if (![CDNMoviePlayer initialize:[AquaContentHandler basePath]]) {
        }
    }
    
//    [CDNMoviePlayer getDeviceID];
    
    callConnected = NO;
    pressedHomeButton = NO;
    
    contentURL = [[NSURL alloc] initWithString:urlString];
    //NSLog(@" contentURL url :: %@", contentURL);
    player = [[CDNMoviePlayer alloc] initWithContentURL:contentURL parentView:_app.navigationController bookmarkParam:bookmarkPos];
	[player setDelegate:self];
    
	[player allowsAirPlay:NO];
    
    NSString *nibName = @"PlayerControlViewController_iPad";
    
	controlViewController = [[PlayerControlViewController_iPad alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
	[player setControlView:[controlViewController view]];
	
    UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
    [button addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    
	[player setControlImage:[NSArray arrayWithObjects:@"player_play_normal", @"player_pause_normal", nil] forControl:CONTROL_PLAY];
	[player setControlImage:[NSArray arrayWithObjects:@"player_full_normal", @"player_downsize_normal", nil] forControl:CONTROL_SCREEN_SCALING];
	
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"ko"])
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    else
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    [self addNotification];
    
	[player play];
}

//이어보기 기능
- (void) seekToStartPos{
    if(posCheck == 0){
        [player setCurrentTime:startPos/1000];
        [player play];
        
    }else if(posCheck == 1){
        [player setCurrentTime:0];
        [player play];
    }
}

//노티 추카
- (void)addNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinished:)
												 name:CDNMoviePlayerFinishedPlaybackNotification
											   object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(myMovieStateChanged:)
     name:CDNMoviePlayerStateChangedNotification
     object:nil];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieLoaded:)
												 name:CDNMoviePlayerLoadedNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(changeVolume:)
												 name:@"AVSystemController_SystemVolumeDidChangeNotification"
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatStart:)
                                                 name: CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatEnd:)
                                                 name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseSectionRepeat:) name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn1:) name:@"timeBtn1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn2:) name:@"timeBtn2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn3:) name:@"timeBtn3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn4:) name:@"timeBtn4" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn5:) name:@"timeBtn5" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn6:) name:@"timeBtn6" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn7:) name:@"timeBtn7" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn8:) name:@"timeBtn8" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn9:) name:@"timeBtn9" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeBtn10:) name:@"timeBtn10" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel1:) name:@"timeDel1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel2:) name:@"timeDel2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel3:) name:@"timeDel3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel4:) name:@"timeDel4" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel5:) name:@"timeDel5" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel6:) name:@"timeDel6" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel7:) name:@"timeDel7" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel8:) name:@"timeDel8" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel9:) name:@"timeDel9" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDel10:) name:@"timeDel10" object:nil];
    
    [self timerMethod];
}

- (void)timerMethod{
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    [self initLoad];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    if([bookMarkArr count] == 0){
        controlViewController.timeBtn1.hidden = YES;
        controlViewController.timeBtn2.hidden = YES;
        controlViewController.timeBtn3.hidden = YES;
        controlViewController.timeBtn4.hidden = YES;
        controlViewController.timeBtn5.hidden = YES;
        controlViewController.timeBtn6.hidden = YES;
        controlViewController.timeBtn7.hidden = YES;
        controlViewController.timeBtn8.hidden = YES;
        controlViewController.timeBtn9.hidden = YES;
        controlViewController.timeBtn10.hidden = YES;
        
        controlViewController.timeDel1.hidden = YES;
        controlViewController.timeDel2.hidden = YES;
        controlViewController.timeDel3.hidden = YES;
        controlViewController.timeDel4.hidden = YES;
        controlViewController.timeDel5.hidden = YES;
        controlViewController.timeDel6.hidden = YES;
        controlViewController.timeDel7.hidden = YES;
        controlViewController.timeDel8.hidden = YES;
        controlViewController.timeDel9.hidden = YES;
        controlViewController.timeDel10.hidden = YES;
        
    }else{
        for(int j = 0; [bookMarkArr count]; j++){
            NSDictionary *bookMarkDic1 = [bookMarkArr objectAtIndex:0];
            if([[bookMarkDic1 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn1.hidden = YES;
                controlViewController.timeDel1.hidden = YES;
                
            }else{
                time1 = [bookMarkDic1 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn1 setTitle:[bookMarkDic1 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn1.hidden = NO;
                controlViewController.timeDel1.hidden = NO;
            }
            
            if([bookMarkArr count] == 1){
                controlViewController.timeBtn2.hidden = YES;
                controlViewController.timeBtn3.hidden = YES;
                controlViewController.timeBtn4.hidden = YES;
                controlViewController.timeBtn5.hidden = YES;
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel2.hidden = YES;
                controlViewController.timeDel3.hidden = YES;
                controlViewController.timeDel4.hidden = YES;
                controlViewController.timeDel5.hidden = YES;
                controlViewController.timeDel6.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic2 = [bookMarkArr objectAtIndex:1];
            if([[bookMarkDic2 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn2.hidden = YES;
                controlViewController.timeDel2.hidden = YES;
                
            }else{
                time2 = [bookMarkDic2 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn2 setTitle:[bookMarkDic2 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn2.hidden = NO;
                controlViewController.timeDel2.hidden = NO;
            }
            
            if([bookMarkArr count] == 2){
                controlViewController.timeBtn3.hidden = YES;
                controlViewController.timeBtn4.hidden = YES;
                controlViewController.timeBtn5.hidden = YES;
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel3.hidden = YES;
                controlViewController.timeDel4.hidden = YES;
                controlViewController.timeDel5.hidden = YES;
                controlViewController.timeDel6.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic3 = [bookMarkArr objectAtIndex:2];
            if([[bookMarkDic3 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn3.hidden = YES;
                controlViewController.timeDel3.hidden = YES;
                
            }else{
                time3 = [bookMarkDic3 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn3 setTitle:[bookMarkDic3 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn3.hidden = NO;
                controlViewController.timeDel3.hidden = NO;
            }
            
            if([bookMarkArr count] == 3){
                controlViewController.timeBtn4.hidden = YES;
                controlViewController.timeBtn5.hidden = YES;
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel4.hidden = YES;
                controlViewController.timeDel5.hidden = YES;
                controlViewController.timeDel6.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic4 = [bookMarkArr objectAtIndex:3];
            if([[bookMarkDic4 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn4.hidden = YES;
                controlViewController.timeDel4.hidden = YES;
                
            }else{
                time4 = [bookMarkDic4 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn4 setTitle:[bookMarkDic4 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn4.hidden = NO;
                controlViewController.timeDel4.hidden = NO;
            }
            
            if([bookMarkArr count] == 4){
                controlViewController.timeBtn5.hidden = YES;
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel5.hidden = YES;
                controlViewController.timeDel6.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic5 = [bookMarkArr objectAtIndex:4];
            if([[bookMarkDic5 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn5.hidden = YES;
                controlViewController.timeDel5.hidden = YES;
                
            }else{
                time5 = [bookMarkDic5 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn5 setTitle:[bookMarkDic5 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn5.hidden = NO;
                controlViewController.timeDel5.hidden = NO;
            }
            
            if([bookMarkArr count] == 5){
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel6.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic6 = [bookMarkArr objectAtIndex:5];
            if([[bookMarkDic6 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn6.hidden = YES;
                controlViewController.timeDel6.hidden = YES;
                
            }else{
                time6 = [bookMarkDic6 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn6 setTitle:[bookMarkDic6 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn6.hidden = NO;
                controlViewController.timeDel6.hidden = NO;
            }
            
            if([bookMarkArr count] == 6){
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel7.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic7 = [bookMarkArr objectAtIndex:6];
            if([[bookMarkDic7 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn7.hidden = YES;
                controlViewController.timeDel7.hidden = YES;
                
            }else{
                time7 = [bookMarkDic7 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn7 setTitle:[bookMarkDic7 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn7.hidden = NO;
                controlViewController.timeDel7.hidden = NO;
            }
            
            if([bookMarkArr count] == 7){
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel8.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic8 = [bookMarkArr objectAtIndex:7];
            if([[bookMarkDic8 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn8.hidden = YES;
                controlViewController.timeDel8.hidden = YES;
                
            }else{
                time8 = [bookMarkDic8 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn8 setTitle:[bookMarkDic8 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn8.hidden = NO;
                controlViewController.timeDel8.hidden = NO;
            }
            
            if([bookMarkArr count] == 8){
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel9.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic9 = [bookMarkArr objectAtIndex:8];
            if([[bookMarkDic9 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn9.hidden = YES;
                controlViewController.timeDel9.hidden = YES;
                
            }else{
                time9 = [bookMarkDic9 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn9 setTitle:[bookMarkDic9 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn9.hidden = NO;
                controlViewController.timeDel9.hidden = NO;
            }
            
            if([bookMarkArr count] == 9){
                controlViewController.timeBtn10.hidden = YES;
                
                controlViewController.timeDel10.hidden = YES;
                return;
            }
            
            NSDictionary *bookMarkDic10 = [bookMarkArr objectAtIndex:9];
            if([[bookMarkDic10 valueForKey:@"bm_ss"] isEqualToString:nil] == YES){
                controlViewController.timeBtn10.hidden = YES;
                controlViewController.timeDel10.hidden = YES;
                
            }else{
                time10 = [bookMarkDic10 valueForKey:@"bm_ss"];
                [controlViewController.timeBtn10 setTitle:[bookMarkDic10 valueForKey:@"bm_tm"] forState:UIControlStateNormal];
                controlViewController.timeBtn10.hidden = NO;
                controlViewController.timeDel10.hidden = NO;
                return;
            }
            
            if([bookMarkArr count] == 10){
                return;
            }
        }
    }
}

- (void)myMovieFinished:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerFinishedPlaybackNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
    
    NSDictionary *notiUserInfo = [noti userInfo];
    
    if(nil != notiUserInfo){
        NSNumber *reason = [notiUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        NSError *errorInfo = [notiUserInfo objectForKey:@"error"];
        NSLog(@"Movie is finished. reason=%d. errorInfo=%@", [reason intValue], [errorInfo description]);
        
        if([reason intValue] == MPMovieFinishReasonPlaybackError) {
            NSString *msgStr = [NSString stringWithFormat:@"일시적인 오류입니다. \n 잠시 후 이용해주세요.(%@)", [errorInfo description]];
            UIAlertView *notice = [ [UIAlertView alloc] initWithTitle:@"Error" message:msgStr delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [notice show];
            
            [self endLoadBar];
        }
    }
    
    bookmarkFinish = @"1";
    [self doBookmark];
}

- (void) myMovieStateChanged:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *state = [userInfo objectForKey:@"playbackState"];
    
    MPMoviePlaybackState playbackState = (MPMoviePlaybackState)[state intValue];
    
    if (startPos > 0 && playbackState == MPMoviePlaybackStatePlaying) {
        if ([player getCurrentTime] > 2) {
            startPos = 0;
            
        }else {
            if (_sourceLoaded) {
                [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
            }
        }
    }
}

- (void) myMovieLoaded:(NSNotification*)aNotification{
    _sourceLoaded = YES;
    if (startPos > 0) {
        if ([player getCurrentTime] > 2) {
            startPos = 0;
            
        }else {
            [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
        }
    }
}

- (void) changeVolume:(NSNotification*)aNotification{
    if (isMute == YES){
        //mute에 의해 볼륨이 바뀐경우는 무시.
        if(isVolumeChanged== NO){
            isVolumeChanged = YES;
            return;
        }
        
        isMute = NO;
        
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        
    }
}

- (IBAction) mute{
    if (isMute == NO){
        prevVolume =  [[MPMusicPlayerController applicationMusicPlayer] volume];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_mute_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_mute_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        isMute = YES;
        isVolumeChanged= NO;
        
    }else{
        isMute = NO;
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
    }
}

- (void) releaseSectionRepeat:(NSNotification*)aNotification {
    [controlViewController.description setText:@"구간반복을 해제합니다."];
}

- (void) setSectionRepeatStart:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *startTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatStartTimeUserInfoKey];
    
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate initWithTimeIntervalSinceReferenceDate:[startTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [timeF setDateFormat:@"HH:mm:ss"];
    
    NSString *timerStr = [timeF stringFromDate:currentDate];
    [controlViewController.description setText:[NSString stringWithFormat:@"구간반복 %@ ~", timerStr]];
}

- (void) setSectionRepeatEnd:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *endTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatEndTimeUserInfoKey];
    // display a message to label
    NSDate *playbackTime = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[endTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; [timeF setDateFormat:@"HH:mm:ss"];
    NSString *playbackTimeStr = [timeF stringFromDate:playbackTime];
    NSString *text = controlViewController.description.text;
    [controlViewController.description setText:[NSString stringWithFormat:@"%@ %@", text, playbackTimeStr]];
}

#pragma mark -
#pragma mark NOTI

- (void)timeBtn1:(NSNotification *)noti {
    [player setCurrentTime:[time1 intValue]];
    [player play];
}

- (void)timeBtn2:(NSNotification *)noti {
    [player setCurrentTime:[time2 intValue]];
    [player play];
}

- (void)timeBtn3:(NSNotification *)noti {
    [player setCurrentTime:[time3 intValue]];
    [player play];
}

- (void)timeBtn4:(NSNotification *)noti {
    [player setCurrentTime:[time4 intValue]];
    [player play];
}

- (void)timeBtn5:(NSNotification *)noti {
    [player setCurrentTime:[time5 intValue]];
    [player play];
}

- (void)timeBtn6:(NSNotification *)noti {
    [player setCurrentTime:[time6 intValue]];
    [player play];
}
- (void)timeBtn7:(NSNotification *)noti {
    [player setCurrentTime:[time7 intValue]];
    [player play];
}
- (void)timeBtn8:(NSNotification *)noti {
    [player setCurrentTime:[time8 intValue]];
    [player play];
}

- (void)timeBtn9:(NSNotification *)noti {
    [player setCurrentTime:[time9 intValue]];
    [player play];
}

- (void)timeBtn10:(NSNotification *)noti {
    [player setCurrentTime:[time10 intValue]];
    [player play];
}

- (void)initDelMethod:(NSString *)bm_no cd:(NSString *)cd{
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_BOOKMARK_DEL];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:@"DEL"                               forKey:@"mode"];
    [dic setObject:app_no                               forKey:@"app_no"];
    [dic setObject:cd                                   forKey:@"lec_cd"];
    [dic setObject:bm_no                                forKey:@"bm_no"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnBookMarkDel = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnBookMarkDel){
        bookMarkDelData  = [[NSMutableData alloc] init];
    }
}

- (void)timeDel1:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:0];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel2:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:1];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel3:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:2];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel4:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:3];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel5:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:4];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel6:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:5];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel7:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:6];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel8:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:7];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel9:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:8];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

- (void)timeDel10:(NSNotification *)noti {
    NSDictionary *dicArr = [[NSDictionary alloc] init];
    
    dicArr = myLecDic;
    
    NSArray *bDataArr = [dicArr objectForKey:@"bData"];
    NSDictionary *bData = [bDataArr objectAtIndex:timeNum];
    NSArray *bookMarkArr = [bData valueForKey:@"book_mark"];
    
    NSDictionary *bookMarkDic = [bookMarkArr objectAtIndex:9];
    
    [self initDelMethod:[bookMarkDic valueForKey:@"bm_no"] cd:[bData valueForKey:@"lec_cd"]];
}

#pragma mark -
#pragma mark Button Action

- (void)downloadCheck{
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    
    if([downloadArr count] == 0){
        downloadBtn.hidden = YES;
        
    }else{
        downloadBtn.hidden = NO;
    }
}

- (IBAction)moveBtn:(id)sender {
    [self downloadCheck];
    
    moveBtn.hidden = YES;
    move2Btn.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationRepeatCount:1];
    
    [lecQuestionBtn setFrame:CGRectMake(544+160, 603, 114, 44)];
    [downloadBtn setFrame:CGRectMake(614, 603, 44, 44)];
    
    NSLog(@"%@", [NSValue valueWithCGRect:moveBtn.frame]);
    
    [UIView commitAnimations];
}

- (IBAction)lecQuestionBtn:(id)sender {
    long nBrdCd = (long)[[brd_cdArr objectAtIndex:0]longValue];
    brd_cd = [[NSString alloc]initWithFormat:@"%ld",  nBrdCd];
    
    askLecView = [[[NSBundle mainBundle] loadNibNamed:@"mgAskLecView_iPad" owner:self options:nil] objectAtIndex:0];
    askLecView.frame = CGRectMake(0, 0, 694, 655);
    [askLecView initMethod:brd_cd no:app_no seq:app_seq cd:chr_cd nm:chr_nm];
    [self addSubview:askLecView];
}

- (IBAction)downloadBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PopupDownloadList" object:nil];
}

- (IBAction)move2Btn:(id)sender {
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    
    if([downloadArr count] == 0){
        downloadBtn.hidden = YES;
    }
    
    [self closeMove];
}

- (void)closeMove{
    move2Btn.hidden = YES;
    moveBtn.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationRepeatCount:1];

    [lecQuestionBtn setFrame:CGRectMake(544, 603, 114, 44)];
    [downloadBtn setFrame:CGRectMake(492, 603, 44, 44)];
    
    NSLog(@"%@", [NSValue valueWithCGRect:moveBtn.frame]);

    [UIView commitAnimations];
}

@end

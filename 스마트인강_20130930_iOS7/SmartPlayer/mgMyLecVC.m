//
//  mgMyLecVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMyLecVC.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "mgMyLecListTVC.h"
#import "mgFirstProfileVC.h"
#import "JSON.h"
#import "mgProgressBar.h"
#import "mgCommon.h"

@interface mgMyLecVC (){
     CustomBadge *badge;
}
@end

@implementation mgMyLecVC

@synthesize myLecTable;
@synthesize noBgImage;
@synthesize myLecNavigationBar;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];
    
    [myLecNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    myLecNavigationBar.translucent = NO;
    [myLecNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    //뱃지 카운트(수강강좌 + 마이톡)
    if (badge == nil) {
        badge = [CustomBadge customBadgeWithString:@"0" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        [badge setFrame:CGRectMake(26, 2, 26, 24)];
        [myLecNavigationBar addSubview:badge];
        [self setBadge];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBadge];
    NSIndexPath *selectIndex = [myLecTable indexPathForSelectedRow];
    [myLecTable deselectRowAtIndexPath:selectIndex animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if ([_app._account getIsLogin] == true) {
        [self PopupFirstProfile];
    }else{
        [self PopupLogin];
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TalkReceived" object:nil];
    [self setMyLecTable:nil];
    [self setNoBgImage:nil];
    [super viewDidUnload];
}

- (void)setBadge{
    if (badge != nil) {
        if ([UIApplication sharedApplication].applicationIconBadgeNumber <= 0) {
            badge.hidden = YES;
        }else{
            [badge autoBadgeSizeWithString:[[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber]];
            badge.hidden = NO;
        }
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
        [self myLec];
        
        //시작할때 자동로그인 or 로그인할때 자동로그인 체크인지 확인
    }else if([_app._account getUsageAutoLogin] == TRUE){
        if(skipNum == 1){
            
        }else{
            [self autoLogin];
        }
    }
}

//수강 강좌
- (void)myLec{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_MYLEC];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnLec = [[NSURLConnection alloc] initWithRequest:request delegate:self];
   
    if (nil != urlConnLec){
        lecData = [[NSMutableData alloc] init];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

//자동 로그인
- (void)autoLogin{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
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
    urlConnAL = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnAL){
        loginData = [[NSMutableData alloc] init];
    }
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
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:indexPath.row];
    
    if([[aData valueForKey:@"std_rest_day"] intValue] <= 30){
        CellIdentifier = @"cell_PauseLec";
    }else{
        CellIdentifier = @"cell_UnpauseLec";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([CellIdentifier isEqualToString:@"cell_UnpauseLec"]){
        // 이미지를 읽어올 주소
        NSURL *url = [NSURL URLWithString:[aData valueForKey:@"tec_img_path"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 무료강좌여부
        NSString *sFreeFlg = [aData valueForKey:@"free_yn"];
        if ([sFreeFlg isEqualToString:@"Y"]) {
            UIImageView *imgFreeV = (UIImageView*)[cell viewWithTag:4];
            imgFreeV.hidden = NO;
        }else{
            UIImageView *imgFreeV = (UIImageView*)[cell viewWithTag:4];
            imgFreeV.hidden = YES;
        }
        
        // 강좌선생님 사진
        UIImageView *photoImage = (UIImageView *)[cell viewWithTag:1];
        if(data) {
            [photoImage setImage:[[UIImage alloc] initWithData:data]];
            photoImage.layer.cornerRadius = 5.0f;
            photoImage.layer.masksToBounds = YES;
            photoImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            photoImage.layer.borderWidth = 1.0f;
        }
        
        // 강좌종류 이미지
        NSString *dom_nm = [aData valueForKey:@"dom_nm"];
        UIImageView *imgvLecClass = (UIImageView*)[cell viewWithTag:11];
        if([dom_nm isEqualToString:@"국어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_korean"]];
        else if([dom_nm isEqualToString:@"수학"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_math"]];
        else if([dom_nm isEqualToString:@"영어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_english"]];
        else if([dom_nm isEqualToString:@"사회"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_society"]];
        else if([dom_nm isEqualToString:@"과학"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_science"]];
        else if([dom_nm isEqualToString:@"제2외국어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_language"]];
        else if([dom_nm isEqualToString:@"전공"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_major"]];
        else if([dom_nm isEqualToString:@"논술"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_essay"]];
        else if([dom_nm isEqualToString:@"구술"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_talk"]];
        
        // 강좌선생님 이름
        UILabel *teacherName = (UILabel*)[cell viewWithTag:2];
        teacherName.text = [NSString stringWithFormat:@"%@ 선생님", [aData valueForKey:@"tec_nm"]];
        
        UILabel *lecName = (UILabel*)[cell viewWithTag:3];
        lecName.text = [aData valueForKey:@"chr_nm"];
        
        UILabel *lbl = (UILabel*)[cell viewWithTag:5];
        UIButton *doingBtn = (UIButton*)[cell viewWithTag:6];
        UIImageView *bellImage = (UIImageView*)[cell viewWithTag:10];
        UIImageView *lockImage = (UIImageView*)[cell viewWithTag:13];
        UIButton *selectedBtn = (UIButton*)[cell viewWithTag:14];
        
        if([[aData valueForKey:@"stop_flg"] isEqualToString:@"3"] == YES){
            lbl.text = @"일시정지 중입니다.";
            doingBtn.hidden = NO;
            bellImage.hidden = YES;
            lockImage.hidden = NO;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"2"] == YES){
            lbl.text = @"일시정지 예정입니다.";
            doingBtn.hidden = NO;
            bellImage.hidden = YES;
            lockImage.hidden = NO;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"1"] == YES){
		NSString *time = @"";
            if ([[aData valueForKey:@"view_cnt"]isEqualToString:@"0"]) {
                time = @"아직 강의를 수강하지 않고 있습니다.";
            }
            else{
                time =[NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
            }
            lbl.text = time;
            doingBtn.hidden = YES;
            bellImage.hidden = NO;
            lockImage.hidden = YES;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"0"] == YES){
            lbl.text =[NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
            doingBtn.hidden = YES;
            bellImage.hidden = NO;
            lockImage.hidden = YES;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"4"] == YES){
            lbl.text = @"일시정지 기능 사용 완료입니다.";
            doingBtn.hidden = YES;
            bellImage.hidden = YES;
            lockImage.hidden = YES;
        }
        
        int sliderProgress = [[aData valueForKey:@"progress"] intValue];
        mgProgressBar *progressView = (mgProgressBar *)[cell viewWithTag:9];
        [progressView setProgress:sliderProgress];
    
        [doingBtn addTarget:self action:@selector(doingBtn:) forControlEvents:UIControlEventTouchUpInside];
        selectedBtn.tag = indexPath.row;
        [selectedBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if([CellIdentifier isEqualToString:@"cell_PauseLec"]){
        // 이미지를 읽어올 주소
        NSURL *url = [NSURL URLWithString:[aData valueForKey:@"tec_img_path"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 무료강좌여부
        NSString *sFreeFlg = [aData valueForKey:@"free_yn"];
        if ([sFreeFlg isEqualToString:@"Y"]) {
            UIImageView *imgFreeV = (UIImageView*)[cell viewWithTag:4];
            imgFreeV.hidden = NO;
        }else{
            UIImageView *imgFreeV = (UIImageView*)[cell viewWithTag:4];
            imgFreeV.hidden = YES;
        }
        
        // 강좌선생님 사진
        UIImageView *photoImage = (UIImageView *)[cell viewWithTag:1];
        if(data) {
            [photoImage setImage:[[UIImage alloc] initWithData:data]];
            photoImage.layer.cornerRadius = 5.0f;
            photoImage.layer.masksToBounds = YES;
            photoImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            photoImage.layer.borderWidth = 1.0f;
        }
        
        // 강좌종류 이미지
        NSString *dom_nm = [aData valueForKey:@"dom_nm"];
        UIImageView *imgvLecClass = (UIImageView*)[cell viewWithTag:11];
        if([dom_nm isEqualToString:@"국어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_korean"]];
        else if([dom_nm isEqualToString:@"수학"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_math"]];
        else if([dom_nm isEqualToString:@"영어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_english"]];
        else if([dom_nm isEqualToString:@"사회"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_society"]];
        else if([dom_nm isEqualToString:@"과학"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_science"]];
        else if([dom_nm isEqualToString:@"제2외국어"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_language"]];
        else if([dom_nm isEqualToString:@"전공"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_major"]];
        else if([dom_nm isEqualToString:@"논술"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_essay"]];
        else if([dom_nm isEqualToString:@"구술"])
            [imgvLecClass setImage:[UIImage imageNamed:@"ico_talk"]];
        
        // 강좌선생님 이름
        UILabel *teacherName = (UILabel*)[cell viewWithTag:2];
        teacherName.text = [NSString stringWithFormat:@"%@ 선생님", [aData valueForKey:@"tec_nm"]];
        
        UILabel *lecName = (UILabel*)[cell viewWithTag:3];
        lecName.text = [aData valueForKey:@"chr_nm"];
        
        UILabel *lbl = (UILabel*)[cell viewWithTag:5];
        UIButton *doingBtn = (UIButton*)[cell viewWithTag:6];
        UILabel *dayStr = (UILabel*)[cell viewWithTag:8];
        UIImageView *bellImage = (UIImageView*)[cell viewWithTag:10];
        UILabel *endDay = (UILabel*)[cell viewWithTag:12];
        UIImageView *lockImage = (UIImageView*)[cell viewWithTag:13];
        UIButton *selectedBtn = (UIButton*)[cell viewWithTag:14];
        
        NSString *restDayStr = [NSString stringWithFormat:@"종료일로부터 %@일 남았습니다.", [aData valueForKey:@"std_rest_day"]];
        dayStr.text = restDayStr;
        endDay.text = [aData valueForKey:@"std_edt"];
        
        if([[aData valueForKey:@"stop_flg"] isEqualToString:@"3"] == YES){
            lbl.text = @"일시정지 중입니다.";
            doingBtn.hidden = NO;
            bellImage.hidden = YES;
            lockImage.hidden = NO;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"2"] == YES){
            lbl.text = @"일시정지 예정입니다.";
            doingBtn.hidden = NO;
            bellImage.hidden = YES;
            lockImage.hidden = NO;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"1"] == YES){
            NSString *time = @"";
            if ([[aData valueForKey:@"view_cnt"]isEqualToString:@"0"]) {
                time = @"아직 강의를 수강하지 않고 있습니다.";
            }else{
                time = [NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
                lbl.text = time;
                doingBtn.hidden = YES;
                bellImage.hidden = NO;
                lockImage.hidden = YES;
            }
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"0"] == YES){
            lbl.text = [NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
            doingBtn.hidden = YES;
            bellImage.hidden = NO;
            lockImage.hidden = YES;
            
        }else if([[aData valueForKey:@"stop_flg"] isEqualToString:@"4"] == YES){
            lbl.text = @"일시정지 기능 사용 완료입니다.";
            doingBtn.hidden = YES;
            bellImage.hidden = YES;
            lockImage.hidden = YES;
        }
        
        int sliderProgress = [[aData valueForKey:@"progress"] intValue];
        mgProgressBar *progressView = (mgProgressBar *)[cell viewWithTag:9];
        [progressView setProgress:sliderProgress];
        
        [doingBtn addTarget:self action:@selector(doingBtn:) forControlEvents:UIControlEventTouchUpInside];
        selectedBtn.tag = indexPath.row;
        [selectedBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:indexPath.row];
    
    if([[aData valueForKey:@"std_rest_day"] intValue] <= 30){
        return 210.0f;
    }else{
        return 180.0f;
    }
    
    return 0.0f;
}

#pragma mark -
#pragma mark Button Action

//해지 신청
- (void)doingBtn:(id)sender {
    NSIndexPath *indexPath = [myLecTable indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSInteger nIndex = indexPath.row;

    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:nIndex];
    
    //일시정지 해제를 위한
    app_no = [aData valueForKey:@"app_no"];
    app_seq = [aData valueForKey:@"app_seq"];
    
    [self showAlertChoose:@"수강 일시정지 기간 중입니다. \n일시정지를 해제하시겠습니까?" tag:TAG_MSG_LECDOING];
}

- (void)selectBtn:(UIButton *)sender {
    NSInteger nIndex = sender.tag;
    
    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *dic = [aDataArr objectAtIndex:nIndex];
    
    UIStoryboard *_newStoryboard = nil;
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLecList4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLecList" bundle:nil];
    }
    
    mgMyLecListTVC *nextVC = [_newStoryboard instantiateViewControllerWithIdentifier: @"mgMyLecListTVC"];
    
    nextVC.url_tec_photo =  [dic valueForKey:@"tec_img_path"];
    nextVC.app_no = [dic valueForKey:@"app_no"];
    nextVC.app_seq = [dic valueForKey:@"app_seq"];
    nextVC.chr_cd = [dic valueForKey:@"chr_cd"];
    nextVC.chr_nm  = [dic valueForKey:@"chr_nm"];
    nextVC.free_yn = [dic valueForKey:@"free_yn"];
    nextVC.subject = [dic valueForKey:@"dom_nm"];
    nextVC.teacher = [dic valueForKey:@"tec_nm"];
    nextVC.imgPath = [dic valueForKey:@"tec_img_path"];
    nextVC.footerDic = dic;
    
    [self.navigationController pushViewController:nextVC animated:YES];
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
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//NSLog(@"alertView tag = %d", alertView.tag);
	
	if(alertView.tag == TAG_MSG_LECDOING){
        if(buttonIndex == 1){
            AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_LECTURE_ENDDATE];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            // @param POST와 GET 방식을 나타냄.
            [request setHTTPMethod:@"POST"];
            
            // 파라메터를 NSDictionary에 저장
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
            
            [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
            [dic setObject:app_no                               forKey:@"app_no"];
            [dic setObject:app_seq                              forKey:@"app_seq"];

            // NSDictionary에 저장된 파라메터를 NSArray로 제작
            NSArray * params = [self generatorParameters:dic];
            
            // POST로 파라메터 넘기기
            [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
            urlConnDo = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (nil != urlConnDo){
                doingData = [[NSMutableData alloc] init];
            }
        }
    
    }else if(alertView.tag == TAG_MSG_NETWORK){
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self autoLogin];
        }
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
    if (connection == urlConnAL) {
        [loginData appendData:data];
    }else if(connection == urlConnLec){
        [lecData appendData:data];
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
    if (connection == urlConnAL) {
        NSString *encodeData = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSString *result = [dic objectForKey:@"result"];
        NSString *msg = [dic objectForKey:@"msg"];
        NSArray *aDataArr = [dic objectForKey:@"aData"];
        NSDictionary *aData = [aDataArr objectAtIndex:0];
        NSString *accKey = [aData valueForKey:@"acc_key"];
        //NSLog(@"%@", accKey);
        NSString *encInfo = [aData valueForKey:@"enc_info"];
        accKey = [self encodeURL:accKey];
        encInfo = [self encodeURL:encInfo];
        
        //NSLog(@"My자동로그인_result : %@", result);
        //NSLog(@"My자동로그인_msg : %@", msg);
        
        if([result isEqualToString:@"0000"] == YES){            
            [_app._account setAccKey:accKey];
            [_app._account setEncInfo:encInfo];
            
            [self myLec];
            
        }else if([result isEqualToString:@"1001"] == YES){
            [self showAlert:msg tag:TAG_MSG_NONE];
        }
        
    }else if(connection == urlConnLec){
        NSString *encodeData = [[NSString alloc] initWithData:lecData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        myLecDic = dic;

        //NSLog(@"My강좌리스트_result : %@", [myLecDic objectForKey:@"result"]);
        //NSLog(@"My강좌리스트_msg : %@", [myLecDic objectForKey:@"msg"]);
        
        NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
        
        if([aDataArr count] == 0){
            noBgImage.hidden = NO;
        }
        
        if([[myLecDic objectForKey:@"result"] isEqualToString:@"0000"] == YES){
            lecCount = [aDataArr count];
            
            [self endLoadBar];
            [myLecTable reloadData];
            
        }else{
            [self endLoadBar];
        }
        
    }else if(connection == urlConnDo){
        NSString *encodeData = [[NSString alloc] initWithData:doingData encoding:NSUTF8StringEncoding];        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];

        if([[dic objectForKey:@"result"] isEqualToString:@"0000"] == YES){
            [self myLec];
            [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
            
        }else{
            [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
        }
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

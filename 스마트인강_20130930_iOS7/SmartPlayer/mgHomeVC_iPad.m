//
//  mgHomeVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgHomeVC_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "AquaDBManager.h"
#import "mgProgressBar.h"
#import "CustomBadge.h"
#import "Reachability.h"

#import "AquaAlertView.h"
#import "AppErrorHandler.h"
#import "AquaContentHandler.h"
#import "NSString+URL.h"
#import "mgCommon.h"

#define MUTE 6000

@implementation mgHomeVC_iPad
{
    //UITapGestureRecognizer *_photoTGR;
    UIPopoverController *popover;
}

@synthesize noItemView;
@synthesize _homeTable;
@synthesize _setDdayView;
@synthesize goalText;
@synthesize nickname;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setObject:@"0" forKey:SETTING_NUM];
    [defaults setObject:@"0" forKey:DDAY_NUM];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadProfile) name:@"ReloadProfile" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popupDownloadlist) name:@"PopupDownloadList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissDownloadList) name:@"DismissDownloadList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTabBarAfterDismiss) name:@"ChangeTabBarAfterDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lecEdit:) name:@"lecEdit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopFooter:) name:@"stopFooter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstLogin:) name:@"firstLogin" object:nil];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myImageBtn:)];
    [nickname addGestureRecognizer:tgr];
    
    skipNum = 0;
    
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        [self drawSourceImageR:@"bg_top" frame:CGRectMake(0, 20, 1024, 44)];
        [self drawSourceImageR:@"P_logo" frame:CGRectMake(495, 26, 34, 33)];
        questionBtn.frame = CGRectMake(957, 27, 60, 30);
        
    }else{
        [self drawSourceImageR:@"bg_top" frame:CGRectMake(0, 0, 1024, 44)];
        [self drawSourceImageR:@"P_logo" frame:CGRectMake(495, 6, 34, 33)];
        questionBtn.frame = CGRectMake(957, 7, 60, 30);
    }
    
    questionBtn.exclusiveTouch = YES;
    [questionBtn addTarget:self action:@selector(questionAction) forControlEvents:UIControlEventTouchUpInside];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [questionBtn setTitle:@"질문하기" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:questionBtn];
    
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoConfig)];
    [_setDdayView addGestureRecognizer:tgr2];
    
    _setDdayView.frame = CGRectMake(0, 230, 330, 40);
    _setDdayView.hidden = YES;
    [self.view addSubview:_setDdayView];
}

- (void)initMethod{
    goalText.userInteractionEnabled = NO;
    _setDdayView.hidden = NO;
    
    // 자동 로그인 처리
    if([_app._account getUsageAutoLogin] == TRUE){\
        if([_app._account getIsSkip] == TRUE){
            [self autoLogin];
            skipNum = 1;
            return;
            
        }else{
            UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_FirstProfile" bundle:nil];
            _profileVC = (mgFirstProfile_iPad*)[_newStoryboard instantiateInitialViewController];
            _profileVC.modalPresentationStyle = UIModalPresentationFormSheet;
            _profileVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:_profileVC animated:YES];
            _profileVC.ProfileDelegate = self;
            _profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
            return;
        }
    }
    
    // 로그인 처리
    if([_app._account getIsLogin] == false){
        UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_Login" bundle:nil];
        loginVC = (mgLoginVC_iPad*)[_newStoryboard instantiateInitialViewController];
        loginVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:loginVC animated:NO];
        loginVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
        return;
        
    }else{
        if([_app._account getIsSkip] == TRUE){
            
        }else{
            UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_FirstProfile" bundle:nil];
            //_profileVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgFirstProfile_iPad"];
            _profileVC = (mgFirstProfile_iPad*)[_newStoryboard instantiateInitialViewController];
            _profileVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentModalViewController:_profileVC animated:YES];
            _profileVC.ProfileDelegate = self;
            _profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
            return;
        }
    }
}

- (void)firstLogin:(NSNotification *)note{
    [self initMethod];
    [self reloadProfile];
    [self reloadDday];
    
    if([_app._account getUsageAutoLogin] == TRUE){
        if(skipNum == 1){
            
        }else{
            [self autoLogin];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectIndex = [_homeTable indexPathForSelectedRow];
    [_homeTable deselectRowAtIndexPath:selectIndex animated:YES];
    
    [self initMethod];
    [self reloadProfile];
    [self reloadDday];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (loginVC != nil) {
        loginVC.view.superview.frame = CGRectMake(1024/2-480/2, 337, 480, 350);
    }

    if([_app._account getUsageAutoLogin] == TRUE){
        if(skipNum == 1){
            
        }else{
            [self autoLogin];
        }
    }
}

- (void)viewDidUnload {    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReloadProfile" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PopupDownloadList" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DismissDownloadList" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ChangeTabBarAfterDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"lecEdit" object:nil];

    [self set_homeTable:nil];
    [self set_setDdayView:nil];
    [self setGoalText:nil];
    [self setNoItemView:nil];
    [self setNickname:nil];
    
    [super viewDidUnload];
}

//프로필 갱신
- (void)reloadProfile{
    NSLog(@"mgHomeVC::reloadProfile");
    
    UITapGestureRecognizer *tgrImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myImageBtn:)];
    NSURL *url = [NSURL URLWithString:_app._config._sMyImage];
    //썸네일 이미지
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(15, 84, 64, 64)];
    }else{
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(15, 64, 64, 64)];
    }
    
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
    [ImageViewEx addGestureRecognizer:tgrImage];
    [self.view addSubview:ImageViewEx];
    
    if ([_app._config._sNickName isEqualToString:@""]) {
        nickname.text = @"나의 목표";
    }else
        nickname.text = [[NSString alloc]initWithFormat:@"%@의 목표", _app._config._sNickName];
    goalText.text = _app._config._sMyGoal;
}

//D-Day 갱신
- (void)reloadDday{
    NSString *_DdayNo = @"";
    NSDate *dtDday = _app._config._dtMyDDay;
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd 00:00:00";
    
    NSString *startStr = [dateFormatter stringFromDate:now];
    NSDate *startDay = [dateFormatter dateFromString:startStr];
    
    NSString *endStr = [dateFormatter stringFromDate:dtDday];
    NSDate *endDay = [dateFormatter dateFromString:endStr];
    
    NSDateComponents *diff = [[NSCalendar currentCalendar] components: NSDayCalendarUnit fromDate:startDay toDate:endDay options:0];
    
    if (dtDday != nil) {
        if([diff day] < 0){
            _DdayNo = [[NSString alloc]initWithFormat:@"D+%d", [diff day] - [diff day]*2];
        }else{
            _DdayNo = [[NSString alloc]initWithFormat:@"D-%d", [diff day]];
        }
        
    }else{
        
    }
    
    [_setDdayView setDday:_app._config._sMyDDayMsg DDayNo:_DdayNo];
}

#pragma mark -
#pragma mark 기본셋팅

//기본설정 값
- (void)basicSetting{
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_BASIC_SETTING];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:[_app._account getEnc_info]          forKey:@"enc_info"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnBS = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (nil != urlConnBS){
        homeData = [[NSMutableData alloc] init];
    }
}

//자동 로그인
- (void)autoLogin{
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

//수강 강좌
- (void)myLecList{
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_MYLEC];
    
    //NSLog(@"%@", url);
    
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
    
    //NSLog(@"%@", myLecDic);
    
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
        
        // 강좌종류 이미지
        NSString *dom_nm = [aData valueForKey:@"dom_nm"];
        UIImageView *imgvLecClass = (UIImageView*)[cell viewWithTag:1];
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
        
        // 강좌선생님 사진
        UIImageView *photoImage = (UIImageView *)[cell viewWithTag:2];
        if(data) {
            [photoImage setImage:[[UIImage alloc] initWithData:data]];
            photoImage.layer.cornerRadius = 5.0f;
            photoImage.layer.masksToBounds = YES;
            photoImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            photoImage.layer.borderWidth = 1.0f;
        }

        // 강좌선생님 이름
        UILabel *teacherName = (UILabel*)[cell viewWithTag:3];
        teacherName.text = [NSString stringWithFormat:@"%@ 선생님", [aData valueForKey:@"tec_nm"]];
        
        UILabel *lecName = (UILabel*)[cell viewWithTag:5];
        lecName.text = [aData valueForKey:@"chr_nm"];
        
        UIImageView *bellImage = (UIImageView*)[cell viewWithTag:7];
        UIImageView *lockImage = (UIImageView*)[cell viewWithTag:8];
        UILabel *lbl = (UILabel*)[cell viewWithTag:9];
        UIButton *doingBtn = (UIButton*)[cell viewWithTag:10];
        
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
                time = [NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
            }
            lbl.text = time;
            doingBtn.hidden = YES;
            bellImage.hidden = NO;
            lockImage.hidden = YES;
            
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
        mgProgressBar *progressView = (mgProgressBar *)[cell viewWithTag:6];
        [progressView setProgress:sliderProgress];
        
        [doingBtn addTarget:self action:@selector(doingBtn:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        // 강좌종류 이미지
        NSString *dom_nm = [aData valueForKey:@"dom_nm"];
        UIImageView *imgvLecClass = (UIImageView*)[cell viewWithTag:1];
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
        
        // 강좌선생님 사진
        UIImageView *photoImage = (UIImageView *)[cell viewWithTag:2];
        if(data) {
            [photoImage setImage:[[UIImage alloc] initWithData:data]];
            photoImage.layer.cornerRadius = 5.0f;
            photoImage.layer.masksToBounds = YES;
            photoImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            photoImage.layer.borderWidth = 1.0f;
        }
        
        // 강좌선생님 이름
        UILabel *teacherName = (UILabel*)[cell viewWithTag:3];
        teacherName.text = [NSString stringWithFormat:@"%@ 선생님", [aData valueForKey:@"tec_nm"]];
        
        UILabel *lecName = (UILabel*)[cell viewWithTag:5];
        lecName.text = [aData valueForKey:@"chr_nm"];
        
        UILabel *dayStr = (UILabel*)[cell viewWithTag:6];
        UILabel *endDay = (UILabel*)[cell viewWithTag:7];
        UIImageView *bellImage = (UIImageView*)[cell viewWithTag:9];
        UIImageView *lockImage = (UIImageView*)[cell viewWithTag:10];
        UILabel *lbl = (UILabel*)[cell viewWithTag:11];
        UIButton *doingBtn = (UIButton*)[cell viewWithTag:12];
        
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
            }
            else{
                time = [NSString stringWithFormat:@"총 %@강 중 %@강을 수강하셨습니다.", [aData valueForKey:@"lec_cnt"], [aData valueForKey:@"view_cnt"]];
            }
            lbl.text = time;
            doingBtn.hidden = YES;
            bellImage.hidden = NO;
            lockImage.hidden = YES;
            
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
        mgProgressBar *progressView = (mgProgressBar *)[cell viewWithTag:8];
        [progressView setProgress:sliderProgress];
        
        [doingBtn addTarget:self action:@selector(doingBtn:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *dic = [aDataArr objectAtIndex:indexPath.row];
    
    [myLecView initMethod:[dic valueForKey:@"app_no"] seq:[dic valueForKey:@"app_seq"] cd:[dic valueForKey:@"chr_cd"] photo:[dic valueForKey:@"tec_img_path"] nm:[dic valueForKey:@"chr_nm"] yn:[dic valueForKey:@"free_yn"] subject:[dic valueForKey:@"dom_nm"] teacher:[dic valueForKey:@"tec_nm"] paht:[dic valueForKey:@"tec_img_path"] footer:myLecDic];
}

#pragma mark -
#pragma mark Button Action

- (void)myImageBtn:(id)sender {
    UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_settingProfile" bundle:nil];
    profileVC = (mgSettingProfileVC_iPad*)[_newStoryboard instantiateInitialViewController];
    profileVC.modalPresentationStyle = UIModalPresentationFormSheet;
    profileVC.profileDelegate = self;
    [self presentModalViewController:profileVC animated:YES];
    profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
}

//해지 신청
- (void)doingBtn:(id)sender {
    NSIndexPath *indexPath = [_homeTable indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSInteger nIndex = indexPath.row;
    NSLog(@"%d", nIndex);
    
    NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:nIndex];
    
    //일시정지 해제를 위한
    app_no = [aData valueForKey:@"app_no"];
    app_seq = [aData valueForKey:@"app_seq"];
    
    [self showAlertChoose:@"수강 일시정지 기간 중입니다. \n일시정지를 해제하시겠습니까?" tag:TAG_MSG_LECDOING];
}

- (void)questionAction {
    if([myLecView.brd_cdArr count] > 1){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for(int i = 0; i < [myLecView.brd_tec_nmArr count]; i++){
            [sheet addButtonWithTitle:[myLecView.brd_tec_nmArr objectAtIndex:i]];
        }
        
        [sheet addButtonWithTitle:@"취소"];
        sheet.cancelButtonIndex = sheet.numberOfButtons;
        
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
        
        return;
        
    }else{
        UIStoryboard *_newStoryboard = nil;
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_AskLecWriteVC_iPad" bundle:nil];
        _askLecVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecWriteVC_iPad"];
        _askLecVC.modalPresentationStyle = UIModalPresentationFormSheet;
        _askLecVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _askLecVC.dlg = self;
        
        long nBrdCd = (long)[[myLecView.brd_cdArr objectAtIndex:0]longValue];
        _askLecVC.brd_cd = [[NSString alloc]initWithFormat:@"%ld",  nBrdCd];
        _askLecVC.app_no = myLecView.app_no;
        _askLecVC.app_seq = myLecView.app_seq;
        _askLecVC.chr_cd = myLecView.chr_cd;
        _askLecVC.chr_nm = myLecView.chr_nm;

        [self presentModalViewController:_askLecVC animated:YES];
        _askLecVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    for(int i = 0; i < [myLecView.brd_tec_nmArr count]; i++){
        if(buttonIndex == i){
            long nBrdCd = (long)[[myLecView.brd_cdArr objectAtIndex:i]longValue];
            myLecView.brd_cd = [[NSString alloc]initWithFormat:@"%ld",  nBrdCd];
            //NSLog(@"%@", brd_cd);
        }
    }
    
    UIStoryboard *_newStoryboard = nil;
    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_AskLecWriteVC_iPad" bundle:nil];
    _askLecVC = (mgAskLecWriteVC_iPad*)[_newStoryboard instantiateInitialViewController];
    _askLecVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _askLecVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _askLecVC.dlg = self;
    
    long nBrdCd = (long)[[myLecView.brd_cdArr objectAtIndex:0]longValue];
    _askLecVC.brd_cd = [[NSString alloc]initWithFormat:@"%ld",  nBrdCd];
    _askLecVC.app_no = myLecView.app_no;
    _askLecVC.app_seq = myLecView.app_seq;
    _askLecVC.chr_cd = myLecView.chr_cd;
    _askLecVC.chr_nm = myLecView.chr_nm;
    
    [self presentModalViewController:_askLecVC animated:YES];
    _askLecVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView.tag == TAG_MSG_NETWORK){
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self autoLogin];
        }
        
    }else if(alertView.tag == TAG_MSG_DOWNLOADING){
        if(buttonIndex == 1){
            [self popupDownloadlist];
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
    }else if(connection == urlConnBS){
        [homeData appendData:data];
    }else if(connection == urlConnLec){
        [lecData appendData:data];
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
    if([_app._account getIsSkip] == TRUE){
        
    }else{
        UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_FirstProfile" bundle:nil];
        _profileVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgFirstProfile_iPad"];
        _profileVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:_profileVC animated:YES];
        _profileVC.ProfileDelegate = self;
        _profileVC.view.superview.backgroundColor = [UIColor clearColor];
        _profileVC.view.backgroundColor = [UIColor clearColor];
        _profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
    
    if (connection == urlConnAL) {
        NSString *encodeData = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        NSString *result = [dic objectForKey:@"result"];
        NSString *msg = [dic objectForKey:@"msg"];
        NSArray *aDataArr = [dic objectForKey:@"aData"];
        NSDictionary *aData = [aDataArr objectAtIndex:0];
        NSString *accKey = [aData valueForKey:@"acc_key"];
        NSString *encInfo = [aData valueForKey:@"enc_info"];
        accKey = [self encodeURL:accKey];
        encInfo = [self encodeURL:encInfo];
        
        //NSLog(@"Home자동로그인_result : %@", result);
        //NSLog(@"Home자동로그인_msg : %@", msg);
        //NSLog(@"Home자동로그인_aData : %@", [aData valueForKey:@"acc_key"]);
        
        if([result isEqualToString:@"0000"] == YES){
            [_app._account setAccKey:accKey];
            [_app._account setEncInfo:encInfo];
            
            [self basicSetting];
            
        }else if([result isEqualToString:@"1001"] == YES){
            [self showAlert:msg tag:TAG_MSG_NONE];
        }
        
    }else if(connection == urlConnBS){
        NSString *encodeData = [[NSString alloc] initWithData:homeData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        NSString *result = [dic objectForKey:@"result"];
        NSArray *aDataArr = [dic objectForKey:@"aData"];
        if([aDataArr count] == 0){
            return;
        }
        
        NSDictionary *aData = [aDataArr objectAtIndex:0];
        NSString *goal = [aData valueForKey:@"goal"];
        
        // 설정
        NSString *noti_ans = [aData valueForKey:@"noti_ans"];
        NSString *noti_chr_end = [aData valueForKey:@"noti_chr_end"];
        NSString *noti_class_info = [aData valueForKey:@"noti_class_info"];
        NSString *noti_paper = [aData valueForKey:@"noti_paper"];
        NSString *noti_progress = [aData valueForKey:@"noti_progress"];
        
        // 버전
        NSString *newVersion = [aData valueForKey:@"lst_ver"];
        
        //NSLog(@"기본설정_result : %@", result);
        //NSLog(@"기본설정_msg : %@", msg);
        //NSLog(@"기본설정_aData : %@", [aDataArr objectAtIndex:0]);
        
        if([result isEqualToString:@"0000"] == YES){
            
            [_app._config setNickName:[aData valueForKey:@"nick_nm"]];
            [_app._account setUserID:[aData valueForKey:@"mem_id"]];
            [_app._config setMyGoal:[aData valueForKey:@"goal"]];
            [_app._config setMyDecision:[aData valueForKey:@"promise"]];
            [_app._config setMyDDayMsg:[aData valueForKey:@"content"]];
            
            // 설정
            [_app._config set_bUsageAnsAlarm:[noti_ans isEqualToString:@"Y"] ? TRUE:FALSE];
            [_app._config set_bUsageLecEndAlarm:[noti_chr_end isEqualToString:@"Y"] ? TRUE:FALSE];
            [_app._config set_bUsageLecInfoAlarm:[noti_class_info isEqualToString:@"Y"] ? TRUE:FALSE];
            [_app._config set_bUsageMsgAlarm:[noti_paper isEqualToString:@"Y"] ? TRUE:FALSE];
            [_app._config set_bUsageProgAlarm:[noti_progress isEqualToString:@"Y"] ? TRUE:FALSE];
            
            // 버전
            [_app._config set_strNewVersion:newVersion];
            
            NSString *sDday = [aData valueForKey:@"dday"];
            if (![sDday isEqualToString:@""]) {
                NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                [fmt setDateFormat:@"yyyy-MM-dd"];
                NSDate *dtDday = [fmt dateFromString:sDday];
                
                [_app._config setMyDDay:dtDday];
                
            }else{
                [_app._config setMyDDay:nil];
            }
            
            [_app._config setPlayer_reg:[aData valueForKey:@"player_reg"]];
            
            [self reloadDday];
            _setDdayView.hidden = NO;
            
            NSString *imgName = [aData valueForKey:@"img_path"];
            if([_app._config._sMyImage isEqualToString:imgName] == YES){
                
            }else{
                [_app._config setMyImage:[aData valueForKey:@"img_path"]];
                [self reloadProfile];
            }
            
            [self myLecList];

        }else if([result isEqualToString:@"1001"] == YES){
            return;
        }
        
        goalText.text = goal;
        
        // 이미지를 읽어올 주소
        NSURL *url = [NSURL URLWithString:[aData valueForKey:@"img_path"]];
        [ImageViewEx loadImageFromURL:url];
        
        [self myLecList];
        
    }else if(connection == urlConnLec){
        NSString *encodeData = [[NSString alloc] initWithData:lecData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        myLecDic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"Home강좌리스트_result : %@", [myLecDic objectForKey:@"result"]);
        //NSLog(@"Home강좌리스트_msg : %@", [myLecDic objectForKey:@"msg"]);
        //NSLog(@"Home강좌리스트_dic : %@", myLecDic);
        
        NSArray *aDataArr = [myLecDic objectForKey:@"aData"];
        if([aDataArr count] == 0){
            noItemView.hidden = NO;
            questionBtn.hidden = YES;
            
            myLecView = [[[NSBundle mainBundle] loadNibNamed:@"mgMyLecView_iPad" owner:self options:nil] objectAtIndex:0];

            // 7.0이상
            if([mgCommon osVersion_7]){
                myLecView.frame = CGRectMake(330, 64, 694, 655);
            }else{
                myLecView.frame = CGRectMake(330, 44, 694, 655);
            }
            
            [myLecView noItem];
            [self.view addSubview:myLecView];
        }
        
        if([[myLecDic objectForKey:@"result"] isEqualToString:@"0000"] == YES){
            lecCount = [aDataArr count];
            
            [self endLoadBar];
            
            [_homeTable reloadData];
            
            NSDictionary *firstDic = [aDataArr objectAtIndex:0];
            myLecView = [[[NSBundle mainBundle] loadNibNamed:@"mgMyLecView_iPad" owner:self options:nil] objectAtIndex:0];
            
            // 7.0이상
            if([mgCommon osVersion_7]){
                myLecView.frame = CGRectMake(330, 64, 694, 655);
            }else{
                myLecView.frame = CGRectMake(330, 44, 694, 655);
            }
            
            [myLecView initMethod:[firstDic valueForKey:@"app_no"] seq:[firstDic valueForKey:@"app_seq"] cd:[firstDic valueForKey:@"chr_cd"] photo:[firstDic valueForKey:@"tec_img_path"] nm:[firstDic valueForKey:@"chr_nm"] yn:[firstDic valueForKey:@"free_yn"] subject:[firstDic valueForKey:@"dom_nm"] teacher:[firstDic valueForKey:@"tec_nm"] paht:[firstDic valueForKey:@"tec_img_path"] footer:myLecDic];
            [self.view addSubview:myLecView];

        }else{
            [self endLoadBar];
        }
        
        NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
        [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
        if([downloadArr count] > 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"완료되지 않은 다운로드 리스트가 \n존재합니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"다운로드 화면으로 이동" ,nil];
            [alert show];
            alert.tag = TAG_MSG_DOWNLOADING;
        }
        
        return;
    }
}

#pragma mark -
#pragma mark UIPopover Delegate

- (void)popupDownloadlist
{
    if (popover == nil) {
        popover = [[UIPopoverController alloc] initWithContentViewController:_app._downloadVC];
        popover.popoverBackgroundViewClass = [mgPopoverBgV class];
    }
    [popover setContentViewController:_app._downloadVC];
    
    [popover presentPopoverFromRect:CGRectMake(689, 156, 320.0, 480.0)
                             inView:self.view
           permittedArrowDirections:NULL
                           animated:YES];
    [popover setPopoverContentSize:CGSizeMake(320, 480)];
}

- (void)dismissDownloadList
{
    [myLecView downloadCheck];
    [popover dismissPopoverAnimated:YES];
}

- (void)changeTabBarAfterDismiss
{
    [myLecView downloadCheck];
    [popover dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:@"1"]; // 강좌보관함으로
}

#pragma mark -
#pragma mark FirstProfileDelegate

- (void)mgFirstProfile_iPad_DismissModalView{
    [self closeFirstProfile:nil];
}

- (void)closeFirstProfile:(id)sender{
    if(_profileVC != nil)
    {
        // 가로모드라 수치를 바꿔서 넣음
        _profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

- (void)mgFirstProfile_iPad_SkipTrue{
    if(_profileVC != nil)
    {
        // 가로모드라 수치를 바꿔서 넣음
        _profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
    
    //[self basicSetting];
}

#pragma mark -
#pragma mark mgProfile Delegate

- (void)mgProfile_iPad_DismissModalView{
    [self closeProfile:nil];
}

- (void)closeProfile:(id)sender{
    if(profileVC != nil)
    {
        // 가로모드라 수치를 바꿔서 넣음
        profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

#pragma mark -
#pragma mark mgAskWriteVC Delegate

- (void)mgAskLecWriteVC_iPad_DismissModalView
{
    [self closeAskLec:nil];
}

- (void)closeAskLec:(id)sender{
    if(_askLecVC != nil)
    {
        _askLecVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

#pragma mark -
#pragma mark mgAskLecEdit Delegate

- (void)mgAskLecEditVC_iPad_DismissModalView
{
    [self closeAskEdit:nil];
}

- (void)closeAskEdit:(id)sender{
    if(_editVC != nil)
    {
        _editVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

#pragma mark -
#pragma mark mgAskLecView Delegate

- (void)mgAskLecView_iPad_Edit:(NSString *)no seq:(NSString *)seq chr:(NSString *)chr brd:(NSString *)brd bidx:(NSString *)bidx{
    NSLog(@"%@", no);
    NSLog(@"%@", seq);
    NSLog(@"%@", chr);
    NSLog(@"%@", brd);
    NSLog(@"%@", bidx);
}

- (void)lecEdit:(NSNotification *)note{
    NSString *no = [[note userInfo] objectForKey:@"app_no"];
    NSString *seq = [[note userInfo] objectForKey:@"app_seq"];
    NSString *chr = [[note userInfo] objectForKey:@"chr_cd"];
    NSString *brd = [[note userInfo] objectForKey:@"brd_cd"];
    NSString *bidx = [[note userInfo] objectForKey:@"bidx"];
    
    NSLog(@"no : %@", no);
    NSLog(@"seq : %@", seq);
    NSLog(@"chr : %@", chr);
    NSLog(@"brd : %@", brd);
    NSLog(@"bidx : %@", bidx);
    
    UIStoryboard *_newStoryboard = nil;
    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_AskLecEditVC_iPad" bundle:nil];
    _editVC = (mgAskLecEditVC_iPad*)[_newStoryboard instantiateInitialViewController];
    _editVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _editVC.editDelegate = self;
    _editVC.app_no = no;
    _editVC.app_seq = seq;
    _editVC.chr_cd = chr;
    _editVC.brd_cd = brd;
    _editVC.bidx = bidx;
    
    [self presentModalViewController:_editVC animated:YES];
    _editVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
}

#pragma mark -
#pragma mark mgMyLecView Delegate

- (void)stopFooter:(NSNotification *)note{
    NSString *no = [[note userInfo] objectForKey:@"app_no"];
    NSString *seq = [[note userInfo] objectForKey:@"app_seq"];
    
    NSLog(@"no : %@", no);
    NSLog(@"seq : %@", seq);
    
    NSDictionary *footerDic = [NSDictionary dictionaryWithObjectsAndKeys:no, @"app_no", seq, @"app_seq", nil];
    
    UIStoryboard *_newStoryboard = nil;
    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_RequestPauseLecVC_iPad" bundle:nil];
    pauseVC = (mgRequestPauseLecVC_iPad*)[_newStoryboard instantiateInitialViewController];
    pauseVC.modalPresentationStyle = UIModalPresentationFormSheet;
    pauseVC._LecInfo = footerDic;
    [self presentModalViewController:pauseVC animated:YES];
    pauseVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
}

- (void)gotoConfig {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:@"4"];
    [defaults setObject:@"1" forKey:SETTING_NUM];
    [defaults setObject:@"1" forKey:DDAY_NUM];
}

- (IBAction)gotoProfile:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:@"4"];
    [defaults setObject:@"0" forKey:SETTING_NUM];
}

@end

// UIimagePickerController 부분 재정의
@implementation UIImagePickerController (LandscapeOrientation)

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return UIInterfaceOrientationLandscapeLeft;
    } else {
        return UIInterfaceOrientationLandscapeRight;
    }
}

@end

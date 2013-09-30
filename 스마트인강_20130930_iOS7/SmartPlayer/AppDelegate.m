//
//  AppDelegate.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "AppDelegate.h"

#import <sys/utsname.h>
#import "Reachability.h"
#import "mgGlobal.h"
#import "mgCommon.h"
#import "JSON.h"
#import "CDNMoviePlayer.h"
#import "SlideNavigationController.h"
#import "AquaContentHandler.h"
#import "AquaDBManager.h"
#import "KeychainItemWrapper.h"
#import "mgHomeVC.h"
#import "mgTabBarController.h"

#define HEADER_SIZE 512

@implementation AppDelegate

@synthesize navigationController;

@synthesize window;

@synthesize _internetReach;
@synthesize _account, _config;

@synthesize _downloadVC;

@synthesize _StartWithPushType;
@synthesize _ReachStatus;

@synthesize pushAlert;
@synthesize pushBadge;
@synthesize pushMeta;
@synthesize pushMethArray;
@synthesize mgTabController;

static NSString *_accountFileName       = @"mgSmartPlayer_Account.archive";
static NSString *_configFileName        = @"mgSmartPlayer_Config.archive";

- (NSString *)encodeURL:(NSString *)urlString {
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(newString);
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
    [deviceData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *encodeData = [[NSString alloc] initWithData:deviceData encoding:NSUTF8StringEncoding];
	//NSLog(@"delegate : %@", encodeData);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    
    //NSString *result = [dic objectForKey:@"result"];
    //NSString *msg = [dic objectForKey:@"msg"];
    NSArray *aDataArr = [dic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:0];
    NSString *req_key = [aData valueForKey:@"req_key"];
    
    req_key = [self encodeURL:req_key];
    
    //NSLog(@"디바이스 체크_result : %@", result);
    //NSLog(@"디바이스 체크_msg : %@", msg);
    //NSLog(@"req_key : %@", [aData valueForKey:@"req_key"]);
    
    [_account setReqKey:req_key];
    [_account setDeviceCheck:TRUE];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if([[mgCommon getDeviceModel] isEqualToString:@"iPad"]){
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
        _ReachStatus = COMM_NOTACCESS;
        
        int cacheSizeMemory = 4*1024*1024; // 4MB
        int cacheSizeDisk = 32*1024*1024;  // 32MB
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
        [NSURLCache setSharedURLCache:sharedCache];
        
        // 통지 처리기 추가
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTabBar:) name:@"changeTabBar" object:nil];
        
        // 통신망 확인
        [self initReachability];
        
        // 아카이빙
        [self initArchivingData];
        
        // 짝퉁로긴
        _account.delegate = self;
        
        // 푸시 등록
        [self regPushNotification];
        
        // ETC /////////////////////////////////////////////////////////////////////////////////////////
        // 통지로 시작한지 여부 판단~
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if(remoteNotification != nil){
            [self application:application didReceiveRemoteNotification:remoteNotification];
            NSString *meta = [[remoteNotification objectForKey:@"aps"]objectForKey:@"meta"] ;
            
            // 통지 받고 실행한거면 메인 실행시 이벤트 처리
            if ([meta isEqualToString:@"toLec"]) {
                // 강좌홈으로
                _StartWithPushType = STARTUP_TOLEC;
                
            }else if([meta isEqualToString:@"toTalk"]) {
                // 마이톡으로
                _StartWithPushType = STARTUP_TOTALK;
                
            }else
                _StartWithPushType = STARTUP_TONOR;
        }
        
        // CDN 디바이스 아이디 확인
        NSString* newDeviceID = [self getCDNdeviceId];
        [defaults setObject:newDeviceID forKey:DEVICE_ID];
        NSLog(@"%@", [defaults stringForKey:DEVICE_ID]);
        
        //CDN 파일 업데이트 판별
        if (_config._bNeedUpdate) {
            
            //SDK UPDATE(기존에 다운받았던 파일 갱신)
            if(![CDNMoviePlayer initialize_key_exchange:[AquaContentHandler basePath] newDeviceID:[defaults stringForKey:DEVICE_ID]]){
                
            }
            
            // CDN 파일업데이트
            [self CDNdeviceIDUpdate];
            
            // 업데이트할 파일이 없음으로 파일 변환 필요 없음
            [_config setNeedUpdate:false];
            
            // 파일 변환후 프로그램 종료
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"버전 변경에 따른 파일 변환 작업후 앱이 종료됩니다.\r\n종료 후 다시 실행해 주시기바랍니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
            
            return YES;
        }
        
        if(![CDNMoviePlayer initialize_key_exchange:[AquaContentHandler basePath] newDeviceID:[defaults stringForKey:DEVICE_ID]]){
            
        }
        
        [self deviceCheck];
        
        self.mgTabController = [[mgTabBarController alloc] init] ;
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:self.mgTabController];
        self.mgTabController.navigationController.navigationBarHidden = YES;
        self.window.rootViewController = navigationController;
        [self.window addSubview:navigationController.view];
        [self.mgTabController InitViewController];
        
        [self.window makeKeyAndVisible];
        
        // 다운로드 뷰 생성
        if (self._downloadVC == nil) {
            self._downloadVC = [[DownViewController alloc] initWithNibName:@"DownViewController" bundle:nil];
        }
        
        return YES;
    }
    
    _ReachStatus = COMM_NOTACCESS;
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024;  // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setObject:@"0" forKey:HOME_LOAD_COUNT];
    
    [NSThread sleepForTimeInterval:0.5];
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        // 홈메뉴
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Menu4" bundle: nil];
        mgMenuVC *leftMenu = (mgMenuVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mgMenuVC"];
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;

    }else{
        // 홈메뉴
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Menu" bundle: nil];
        mgMenuVC *leftMenu = (mgMenuVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mgMenuVC"];
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    }
    
    // 통신망 확인
    [self initReachability];
    
    // 아카이빙
    [self initArchivingData];
    
    // 짝퉁로긴
    _account.delegate = self;
    
    // 푸시등록 (테스트용)
    // 푸시 등록
    [self regPushNotification];
    
    // ETC /////////////////////////////////////////////////////////////////////////////////////////
    // 통지로 시작한지 여부 판단~
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotification != nil){
        [self application:application didReceiveRemoteNotification:remoteNotification];
        NSString *meta = [[remoteNotification objectForKey:@"aps"]objectForKey:@"meta"] ;
        
        // 통지 받고 실행한거면 메인 실행시 이벤트 처리
        if ([meta isEqualToString:@"toLec"]) {
            // 강좌홈으로
            _StartWithPushType = STARTUP_TOLEC;
            
        }else if([meta isEqualToString:@"toTalk"]) {
            // 마이톡으로
            _StartWithPushType = STARTUP_TOTALK;
            
        }else
            _StartWithPushType = STARTUP_TONOR;
    }
    
    // CDN 디바이스 아이디 확인
    NSString* newDeviceID = [self getCDNdeviceId];
    [defaults setObject:newDeviceID forKey:DEVICE_ID];
    NSLog(@"%@", [defaults stringForKey:DEVICE_ID]);
    
    //CDN 파일 업데이트 판별
    if (_config._bNeedUpdate) {
        
        //SDK UPDATE(기존에 다운받았던 파일 갱신)
        if(![CDNMoviePlayer initialize_key_exchange:[AquaContentHandler basePath] newDeviceID:[defaults stringForKey:DEVICE_ID]]){
            
        }
        
        // CDN 파일업데이트
        [self CDNdeviceIDUpdate];
        
        // 업데이트할 파일이 없음으로 파일 변환 필요 없음
        [_config setNeedUpdate:false];
        
        // 파일 변환후 프로그램 종료
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"버전 변경에 따른 파일 변환 작업후 앱이 종료됩니다.\r\n종료 후 다시 실행해 주시기바랍니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        alert.tag = 2;
        [alert show];
        
        return YES;
    }
    
    if(![CDNMoviePlayer initialize_key_exchange:[AquaContentHandler basePath] newDeviceID:[defaults stringForKey:DEVICE_ID]]){
        
    }
    
    [self deviceCheck];
    
    // 다운로드 뷰 생성
    if ([mgCommon hasFourInchDisplay]) {
        if (self._downloadVC == nil) {
            self._downloadVC = [[DownViewController alloc] initWithNibName:@"DownViewController_5" bundle:nil];
        }
        
    }else{
        if (self._downloadVC == nil) {
            self._downloadVC = [[DownViewController alloc] initWithNibName:@"DownViewController" bundle:nil];
        }
    }

    return YES;
}

- (NSString*)getCDNdeviceId
{
    // 키체인에서 cdn devicd id를 가져옴
    NSString * sCDNdevicdId;
    KeychainItemWrapper *uuidKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"CDNdevicdId" accessGroup:nil];
    sCDNdevicdId = [uuidKeyChain objectForKey:(__bridge id)kSecAttrAccount];
    
    if([sCDNdevicdId isEqualToString:@""] == YES)
    {// cdn device id 가 없는 경우 생성해서 리턴
        sCDNdevicdId = [CDNMoviePlayer getDeviceID];
        
        KeychainItemWrapper *uuidKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"CDNdevicdId" accessGroup:nil];
        [uuidKeyChain setObject:sCDNdevicdId forKey:(__bridge id)kSecAttrAccount];
        
        NSLog(@"CDN device id : %@", sCDNdevicdId);
        return sCDNdevicdId;
    }
    
    // 있을 경우 그냥 리턴
    NSLog(@"CDN device id : %@", sCDNdevicdId);
    return sCDNdevicdId;
}

- (void)CDNdeviceIDUpdate
{
    //SDK UPDATE(기존에 다운받았던 파일 갱신)
    NSMutableArray *arr = (NSMutableArray *)[[AquaDBManager sharedManager] selectAllIDContent:[_account getUserID]];
    
    if([arr count] > 0)
    {
        for(int i = 0; i < [arr count]; i++){
            NSDictionary *dic = [arr objectAtIndex:i];
            
            NSString *cIdName = [dic valueForKey:@"cId"];
            NSLog(@"%@", cIdName);
            
            NSString *addressName = [NSString stringWithFormat:@"/meg/%@.cnm", cIdName];
            NSString *filepath = [[AquaContentHandler basePath] stringByAppendingPathComponent:addressName];
            NSLog(@"%@", filepath);
            
            NSLog(@"file transfer to new key : %@", [defaults stringForKey:DEVICE_ID]);
            if(![CDNMoviePlayer file_header_change:filepath newDeviceID:[defaults stringForKey:DEVICE_ID]]){
                
            }
        }
    }//SDK UPDATE(기존에 다운받았던 파일 갱신) 끝
}

- (void)deviceCheck{
    if([_account getUsageAutoLogin] == FALSE){
        [_account setAccKey:@""];
        [_account setEncInfo:@""];
    }
    
    if([_account getIsDeviceCheck] == FALSE){
        NSString * url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN, URL_DEVICE_INFO];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
        
        [dic setObject:@"7a713d8a"                                                                                      forKey:@"app_key"];
        [dic setObject:[defaults stringForKey:DEVICE_ID]                                                                forKey:@"device_id"];
        [dic setObject:[UIDevice currentDevice].model                                                                   forKey:@"model_nm"];
        [dic setObject:[UIDevice currentDevice].systemName                                                              forKey:@"os_nm"];
        [dic setObject:[UIDevice currentDevice].systemVersion                                                           forKey:@"os_ver"];
        [dic setObject:[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"]        forKey:@"app_ver"];
        [dic setObject:@""                                                                                              forKey:@"hp"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (nil != urlConnection){
            deviceData = [[NSMutableData alloc] init];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{

}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    UIApplication *app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^
              {
                  [app endBackgroundTask:bgTask];
                  bgTask = UIBackgroundTaskInvalid;
              }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    if (![CDNMoviePlayer initialize:[AquaContentHandler basePath]]) {
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

}

- (void)applicationWillTerminate:(UIApplication *)application{

}

#pragma mark -
#pragma mark Archiving

- (void)initArchivingData{
    // 아카이빙을 위한 초기 데이터 생성
    // 멤버초기화
    _account = [self loadAccountData];
    _account.delegate = self;
    
    // 설정초기화
    _config = [self loadConfigData];
    _config.delegate = self;
}

- (NSString*)applicationDocumentDirectory{
    // 앱의 설치 경로를 구해온다.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basepath = ([paths count]>0) ? [paths objectAtIndex:0] : nil;
    return basepath;
}

- (void)saveAccountData:(mgAccount*)account{
    if(account == nil)
        account = [[mgAccount alloc]init];
    
    NSMutableArray *marrAccount = [[NSMutableArray alloc]init];
    [marrAccount addObject:[account getUserID]];
    [marrAccount addObject:[account getUserPwd]];
//    [marrAccount addObject:[account getIsLogin] ? @"1":@"0"];
    [marrAccount addObject:[account getUsageAutoLogin] ? @"1":@"0"];
    [marrAccount addObject:[account getIsSkip] ? @"1":@"0"];
    [marrAccount addObject:[account getIsDeviceCheck] ? @"1":@"0"];
    [marrAccount addObject:[account getReq_key]];
    [marrAccount addObject:[account getAcc_key]];
    [marrAccount addObject:[account getEnc_info]];
    [marrAccount addObject:[account getToken]];
    
    NSString *appFile = [[self applicationDocumentDirectory]stringByAppendingPathComponent:_accountFileName];
    [NSKeyedArchiver archiveRootObject:(NSArray*)marrAccount toFile:appFile];
    
    ////NSLog(@"Account data saved : %@", marrAccount);
}

- (mgAccount*)loadAccountData{
    mgAccount *retAccount = [[mgAccount alloc]init];
    
    NSString *appFile = [[self applicationDocumentDirectory] stringByAppendingPathComponent:_accountFileName];
    
    NSMutableArray *marrAccount = [[NSMutableArray alloc]init];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:appFile]) {
        // 성공적으로 파일에 불러들이면 객체에 담아서 반환
        NSArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        marrAccount = [[NSMutableArray alloc]initWithArray:unarchivedArray];
        
        [retAccount setUserID:(NSString*)[marrAccount objectAtIndex:0]];
        [retAccount setUserPwd:(NSString*)[marrAccount objectAtIndex:1]];
//        [retAccount setIsLogin:([[marrAccount objectAtIndex:2]isEqualToString:@"1"]?true:false)];
        [retAccount setUsageAutoLogin:([[marrAccount objectAtIndex:2]isEqualToString:@"1"]?true:false)];
        [retAccount setSkip:([[marrAccount objectAtIndex:3]isEqualToString:@"1"]?true:false)];
        [retAccount setDeviceCheck:([[marrAccount objectAtIndex:4]isEqualToString:@"1"]?true:false)];
        [retAccount setReqKey:(NSString*)[marrAccount objectAtIndex:5]];
        [retAccount setAccKey:(NSString*)[marrAccount objectAtIndex:6]];
        [retAccount setEncInfo:(NSString*)[marrAccount objectAtIndex:7]];
        [retAccount setToken:(NSString*)[marrAccount objectAtIndex:8]];
    }
    
    ////NSLog(@"Account data loaded : %@", [retAccount toString]);
    
    return retAccount;
}

- (void)saveConfigData:(mgConfig*)config{
    // 설정정보를 파일에 저장
    if(config == nil)
        config = [[mgConfig alloc]init];
    
    NSMutableArray *marrConfig = [[NSMutableArray alloc]init];
    
    // 설정
    [marrConfig addObject:config._bUsageAnsAlarm ? @"1":@"0"];
    [marrConfig addObject:config._bUsageMsgAlarm ? @"1":@"0"];
    [marrConfig addObject:config._bUsageProgAlarm ? @"1":@"0"];
    [marrConfig addObject:config._bUsageLecEndAlarm ? @"1":@"0"];
    [marrConfig addObject:config._bUsageLecInfoAlarm ? @"1":@"0"];
    [marrConfig addObject:config._bUsageTimer ? @"1":@"0"];
    [marrConfig addObject:[[NSString alloc]initWithFormat:@"%d", config._nTimerInterval]];
    
    // 프로필
    [marrConfig addObject:config._sNickName];
    [marrConfig addObject:config._sMyGoal];
    [marrConfig addObject:config._sMyDecision];
    [marrConfig addObject:config._sMyImage];
    [marrConfig addObject:config._sPlayer_reg];
    
    // Dday
    [marrConfig addObject:config._sMyDDayMsg];
    
    if(config._dtMyDDay != nil){
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
        [_fmt setDateFormat:@"yyyy/mm/dd"];
        [marrConfig addObject:[_fmt stringFromDate:config._dtMyDDay]];
        
    }else{
        [marrConfig addObject:@""];
    }
    
    // need update
    [marrConfig addObject:config._bNeedUpdate ? @"1":@"0"];
    
    NSString *appFile = [[self applicationDocumentDirectory]stringByAppendingPathComponent:_configFileName];
    [NSKeyedArchiver archiveRootObject:(NSArray*)marrConfig toFile:appFile];
    
    ////NSLog(@"Config data saved : %@", marrConfig);
}

- (mgConfig*)loadConfigData{
    mgConfig *retConfig = [[mgConfig alloc]init];
    
    NSString *appFile = [[self applicationDocumentDirectory] stringByAppendingPathComponent:_configFileName];
    
    NSMutableArray *marrConfig = [[NSMutableArray alloc]init];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:appFile]) {
        // 성공적으로 파일에 불러들이면 객체에 담아서 반환
        NSArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        marrConfig = [[NSMutableArray alloc]initWithArray:unarchivedArray];
        
        // 설정
        [retConfig setUsageAnsAlarm:[[marrConfig objectAtIndex:0]isEqualToString:@"1"] ? true:false];
        [retConfig setUsageMsgAlarm:[[marrConfig objectAtIndex:1]isEqualToString:@"1"] ? true:false];
        [retConfig setUsageProgAlarm:[[marrConfig objectAtIndex:2]isEqualToString:@"1"] ? true:false];
        [retConfig setUsageLecEndAlarm:[[marrConfig objectAtIndex:3]isEqualToString:@"1"] ? true:false];
        [retConfig setUsageLecInfoAlarm:[[marrConfig objectAtIndex:4]isEqualToString:@"1"] ? true:false];
        [retConfig setUsageTimer:[[marrConfig objectAtIndex:5]isEqualToString:@"1"] ? true:false];
        [retConfig setTimerInterval:[[marrConfig objectAtIndex:6]intValue]];
        
        // 프로필
        [retConfig setNickName:[marrConfig objectAtIndex:7]];
        [retConfig setMyGoal:[marrConfig objectAtIndex:8]];
        [retConfig setMyDecision:[marrConfig objectAtIndex:9]];
        [retConfig setMyImage:[marrConfig objectAtIndex:10]];
        [retConfig setPlayer_reg:[marrConfig objectAtIndex:11]];
        
        // Dday
        [retConfig setMyDDayMsg:[marrConfig objectAtIndex:12]];
        NSString *sDday = [marrConfig objectAtIndex:13];
        if ([sDday isEqualToString:@""]) {
            [retConfig setMyDDay:nil];
        }else{
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
            [_fmt setDateFormat:@"yyyy/mm/dd"];
            [retConfig setMyDDay:[_fmt dateFromString:sDday]];
        }
        
        // NeedUpdate (최소 실행시는 무조건 예)
        if (marrConfig.count > 14) {
            [retConfig setNeedUpdate:[[marrConfig objectAtIndex:14]isEqualToString:@"1"] ? true:false];
        }else{
            [retConfig setNeedUpdate:true];
        }
    }
    
    //NSLog(@"Config data loaded : %@", [retConfig toString]);
    
    return retConfig;
}

- (void)changeAccount{
    // 계정정보 변경시 이벤트 핸들러
    [self saveAccountData:self._account];
}

- (void)changeConfig{
    // 설정 변경시 이벤트 핸들러
    [self saveConfigData:self._config];
}

- (void)changeAccount:(id)account{
    self._account = (mgAccount*)account;
    [self saveAccountData:account];
}

- (void)userLogin{
    //NSLog(@"user login");
}

- (void)userLogOff{
    //NSLog(@"user logoff");
}

- (void)changeConfig:(id)config{
    self._config = (mgConfig*)config;
    [self saveConfigData:config];
}

#pragma mark -
#pragma mark Reachability

- (void) initReachability{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];    // 현재 통신이 데이터 통신인지 wifi인지 확인하기 위해 reachability 객체를 초기화 시킴
    _internetReach = [Reachability reachabilityForInternetConnection];
	[_internetReach startNotifier];
	[self updateInterfaceWithReachability:_internetReach];
}

- (void) checkReachability: (Reachability*) curReach{
    // 현재 통신이 데이터 통신인지 wifi인지 확인
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {// 통신 안됄때
            //NSLog(@"Access Not Available");
            
            _ReachStatus = COMM_NOTACCESS;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_REACHABILTY_CHANGE object:@"0"];
        }break;
            
        case ReachableViaWWAN:
        {// 데이터 통신
            //NSLog(@"Reachable WWAN");

            _ReachStatus = COMM_WAAN;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_REACHABILTY_CHANGE object:@"1"];
        }break;
            
        case ReachableViaWiFi:
        {// WIFI
            //NSLog(@"Reachable WiFi");
            
            _ReachStatus = COMM_WIFI;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_REACHABILTY_CHANGE object:@"1"];
	
        }break;
    }
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach{
    if(curReach == _internetReach)
        [self checkReachability:curReach];
}

- (void) reachabilityChanged: (NSNotification* )note{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

#pragma mark -
#pragma mark Push Notification

// 애플리케이션이 푸시서버에 성공적으로 등록되었을때 호출됨
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *devToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"device token : %@", devToken);
    
    [_account setToken:devToken];
}

// registerForRemoteNotificationTyles 결과 실패했을 때 호출됨
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error);
}

// 어플리케이션이 실행줄일 때 노티피케이션을 받았을떄 호출됨
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo %@", userInfo);
    
    pushBadge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    pushMeta = [[userInfo objectForKey:@"aps"] objectForKey:@"meta"];
    pushAlert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //NSLog(@"pushBadge : %@", pushBadge);
    
    pushAlert = [self stringByStrippingHTML:pushAlert];
    NSLog(@"%@", pushAlert);
    
    if([pushBadge intValue] > 99){
        pushBadge = @"99";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:pushAlert delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    alertView.tag = 0;
    [alertView show];
    
    if([pushMeta isEqualToString:@"toTalk"] == YES){
        [UIApplication sharedApplication].applicationIconBadgeNumber = [pushBadge intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TalkReceived" object:nil];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *localDic = (NSDictionary*)notification.userInfo;
    NSLog(@"localDic %@", localDic);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:[localDic valueForKey:@"message"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
    
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:3];
}

- (void)dismissAlert:(UIAlertView*)alertView{
    if (alertView.tag == 1) {
        [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

// APNS 등록
- (void)regPushNotification{
    // NOTIFICATION ////////////////////////////////////////////////////////////////////////////////
    // 뱃지 값을 0으로 초기화 시킨다. 어플리케이션이 실행될 때 뱃지 값을 초기화 하는 것이 좋다.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    // 푸시 통보 서비스에 자신을 등록시킴
    // 성공이면 didRegisterForRemotedNotificationsWithDevicToken가 호출됨
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
}

// APNS 등록해제
- (void)unregPushNotification{
    [[UIApplication sharedApplication]unregisterForRemoteNotifications];
}

- (NSString*)stringByStrippingHTML:(NSString*)stringHtml{
    NSRange r;
    while ((r = [stringHtml rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringHtml = [stringHtml stringByReplacingCharactersInRange:r withString:@" "];
    return stringHtml;
}

#pragma mark -
#pragma mark AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        if(buttonIndex == 1){
            
            //마이톡
            if([pushMeta isEqualToString:@"toTalk"] == YES){
                if([[mgCommon getDeviceModel] isEqualToString:@"iPad"]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"moveTab" object:nil];
                    
                }else{
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"TALK" forKey:@"talk"];
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"talk" object:self userInfo:dic];
                }

            //강좌홈
            }else if([pushMeta isEqualToString:@"toLec"] == YES){
                if([[mgCommon getDeviceModel] isEqualToString:@"iPad"]){
                    [self.mgTabController moveView:0];
                    
                }else{
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"LEC" forKey:@"lec"];
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"lec" object:self userInfo:dic];

                }
                                
            //nil
            }else{
                
            }
        }
    }
    
    if (alertView.tag == 2) {
        if(buttonIndex == 0)
        {
            exit(0);
        }
    }
}

@end

#pragma mark -
#pragma mark 회전관련

@implementation UINavigationController(Rotate_iOS6)

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end


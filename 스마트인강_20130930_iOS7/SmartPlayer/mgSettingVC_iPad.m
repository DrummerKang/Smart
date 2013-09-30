//
//  mgSettingVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSettingVC_iPad.h"
#import "mgSendOpinionVC_iPad.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@interface mgSettingVC_iPad ()

@end

@implementation mgSettingVC_iPad

@synthesize navigationBar;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    canverseView = [[UIView alloc] init];
    canverseView.backgroundColor = [UIColor whiteColor];
    
    settingMenuView = [[mgSettingMenuView_iPad alloc] init];
    settingMenuView._delegateMenu = self;
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        canverseView.frame = CGRectMake(330, 64, 694, 655);
        settingMenuView.frame = CGRectMake(0, 64, 330, 655);
    }else{
        canverseView.frame = CGRectMake(330, 44, 694, 655);
        settingMenuView.frame = CGRectMake(0, 44, 330, 655);
    }

    
    [self.view addSubview:canverseView];
    [self.view addSubview:settingMenuView];
    
    [self initNavigationBar];
}

// 네비게이션바 초기화
- (void)initNavigationBar{
    [navigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Apple SD Gothic Neo-Bold" size:0.0],
      UITextAttributeFont,
      nil]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    if([[defaults stringForKey:SETTING_NUM] isEqualToString:@"1"] == YES){
        [settingMenuView selectMenu:1];
    }else{
        // 초기화면
        [settingMenuView selectMenu:0];
        [defaults setObject:@"0" forKey:SETTING_NUM];
    }
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"closeProfile" object:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark mgSettingMenuDelegate

//설정화면 스크롤 버튼
- (void)mgSettingMenutouchButton:(int)tag{
    NSLog(@"setting : %d", tag);
    
    switch (tag) {
        case 0:
        {
            NSLog(@"%@", [NSValue valueWithCGRect:self.view.frame]);
            
            UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_settingProfile" bundle:nil];
            profileVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"SBiPd_settingProfile"];
            profileVC.modalPresentationStyle = UIModalPresentationFormSheet;
            profileVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:profileVC animated:YES];
            profileVC.profileDelegate = self;
            profileVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
            
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            dDayView = [[mgDDayView_iPad alloc] init];
            dDayView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:dDayView];
             
            break;
        }
            
        case 1:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            dDayView = [[mgDDayView_iPad alloc] init];
            dDayView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:dDayView];
            
            break;
        }
            
        case 2:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            alimView = [[mgAlimView_iPad alloc] init];
            alimView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:alimView];
            
            break;
        }
            
        case 3:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            deviceView = [[mgDeviceView_iPad alloc] init];
            deviceView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:deviceView];
            
            break;
        }
        
        case 4:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            versionView = [[mgVersionView_iPad alloc] init];
            versionView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:versionView];
            
            break;
        }
            
        case 5:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            faqView = [[mgFAQView_iPad alloc] init];
            faqView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:faqView];

            break;
        }

        case 6:
        {
            [canverseView removeFromSuperview];
            
            UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_CfgOpinion" bundle:nil];
            sendVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgSendOpinionVC_iPad"];
            sendVC.modalPresentationStyle = UIModalPresentationFormSheet;
            sendVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:sendVC animated:YES];
            sendVC.dlg = self;
            sendVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
        
            break;
        }

        case 7:
        {
            [canverseView removeFromSuperview];
            
            canverseView = [[UIView alloc] initWithFrame:CGRectMake(330, 44, 694, 675)];
            [self.view addSubview:canverseView];
            
            noticeView = [[mgNoticeView_iPad alloc] init];
            noticeView.frame = CGRectMake(0, 0, 694, 675);
            [canverseView addSubview:noticeView];
            break;
        }
            
        case 8:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"정말 로그아웃 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            alert.tag = 1;
            [alert show];
        }
    }
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
#pragma mark mgSend Delegate

- (void)mgSendVC_iPad_DismissModalView{
    [self closeSend:nil];
}

- (void)closeSend:(id)sender{
    if(sendVC != nil){
        sendVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self LogoutFromServer];
        }
    }
}

- (void)LogoutFromServer
{
    // 서버에 dday 설정을 보낸다.
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_LOGOUT];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:[_app._account getAcc_key]                           forKey:@"acc_key"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    connLogout = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_dataLogout == nil){
        _dataLogout = [[NSMutableData alloc] init];
    }else{
        [_dataLogout setLength:0];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate

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
    if(connection == connLogout){
        [_dataLogout appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(connection == connLogout){
        NSString *encodeData = [[NSString alloc] initWithData:_dataLogout encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"로그아웃 되었습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [_app._account setUsageAutoLogin:false];
            [_app._account setUserID:@""];
            [_app._account setUserPwd:@""];
            [_app._account setIsLogin:false];
            [_app._account setAccKey:@""];
            [_app._account setEncInfo:@""];
            [_app._account setReqKey:@""];
            [_app._account setDeviceCheck:false];
            
            [_app._config setNickName:@""];
            [_app._config setMyGoal:@""];
            [_app._config setMyDecision:@""];
            [_app._config setMyImage:@""];
            [_app._config setMyDDayMsg:@""];
            
            [_app deviceCheck];
            
            UIStoryboard *_newStoryboard = [UIStoryboard storyboardWithName:@"SBiPd_Login" bundle:nil];
            loginVC = (mgLoginVC_iPad*)[_newStoryboard instantiateInitialViewController];
            loginVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentModalViewController:loginVC animated:YES];
            loginVC.view.superview.frame = CGRectMake(337, 115, 350, 480);
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
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

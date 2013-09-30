//
//  mgSettingScrollView.m
//
//  Created by S&T_iMac on 12. 10. 11..
//  Copyright (c) 2012년 S&T_iMac. All rights reserved.
//

#import "mgSettingScrollView.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@implementation mgSettingScrollView

@synthesize _delegateScroll;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        UIImage *tmpImage = [UIImage imageNamed:@"bg_setting"];
        imageView = [[UIImageView alloc] initWithImage:tmpImage];
        [self addSubview:imageView];
        
        CGSize imageSize = imageView.image.size;
        
        //배경 이미지
        UIImageView *bgImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 38, 308, 93)];
        bgImage1.image = [UIImage imageNamed:@"table2"];
        [self addSubview:bgImage1];
        
        UIImageView *bgImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 168, 308, 93)];
        bgImage2.image = [UIImage imageNamed:@"table2"];
        [self addSubview:bgImage2];
        
        UIImageView *bgImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 298, 308, 93)];
        bgImage3.image = [UIImage imageNamed:@"table2"];
        [self addSubview:bgImage3];
        
        UIImageView *bgImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 428, 308, 185)];
        bgImage4.image = [UIImage imageNamed:@"table4"];
        [self addSubview:bgImage4];
        
        newImage = [[UIImageView alloc] initWithFrame:CGRectMake(170, 487, 23, 22)];
        newImage.image = [UIImage imageNamed:@"ico_new"];
        [self addSubview:newImage];
        
        UIImageView *icoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 58, 8, 9)];
        icoImage1.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage1];
        
        UIImageView *icoImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 103, 8, 9)];
        icoImage2.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage2];
        
        UIImageView *icoImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 233, 8, 9)];
        icoImage3.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage3];
        
        UIImageView *icoImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 317, 8, 9)];
        icoImage4.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage4];
        
        UIImageView *icoImage5 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 362, 8, 9)];
        icoImage5.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage5];
        
        UIImageView *icoImage6 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 447, 8, 9)];
        icoImage6.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage6];
        
        UIImageView *icoImage7 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 492, 8, 9)];
        icoImage7.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage7];
        
        UIImageView *icoImage8 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 537, 8, 9)];
        icoImage8.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage8];
        
        UIImageView *icoImage9 = [[UIImageView alloc] initWithFrame:CGRectMake(291, 582, 8, 9)];
        icoImage9.image = [UIImage imageNamed:@"ico_click"];
        [self addSubview:icoImage9];
        
        //텍스트
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 54, 252, 17)];
        label1.text = @"내 프로필";
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label1.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 99, 252, 17)];
        label2.text = @"나만의 D-day";
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label2.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(22, 184, 252, 17)];
        label3.text = @"자동 로그인 설정";
        label3.backgroundColor = [UIColor clearColor];
        label3.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label3.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(22, 229, 252, 17)];
        label4.text = @"알림 설정";
        label4.backgroundColor = [UIColor clearColor];
        label4.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label4.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(22, 314, 252, 17)];
        label5.text = @"등록기기 리스트";
        label5.backgroundColor = [UIColor clearColor];
        label5.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label5.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label5];
        
        _lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(22, 359, 252, 17)];
        _lblVersion.backgroundColor = [UIColor clearColor];
        _lblVersion.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        _lblVersion.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:_lblVersion];
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(22, 444, 252, 17)];
        label7.text = @"FAQ";
        label7.backgroundColor = [UIColor clearColor];
        label7.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label7.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label7];
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(22, 490, 252, 17)];
        label8.text = @"문의/오류/의견 보내기";
        label8.backgroundColor = [UIColor clearColor];
        label8.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label8.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label8];
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(22, 536, 252, 17)];
        label9.text = @"공지사항";
        label9.backgroundColor = [UIColor clearColor];
        label9.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label9.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label9];
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(22, 582, 252, 17)];
        label10.text = @"고객센터 1599-1010";
        label10.backgroundColor = [UIColor clearColor];
        label10.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label10.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label10];
        
        //버튼
        UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        profileBtn.frame = CGRectMake(6, 38, 308, 46);
        profileBtn.exclusiveTouch = YES;
        profileBtn.tag = 0;
        [profileBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [profileBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [profileBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:profileBtn];
        
        UIButton *dDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dDayBtn.frame = CGRectMake(6, 84, 308, 46);
        dDayBtn.exclusiveTouch = YES;
        dDayBtn.tag = 1;
        [dDayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [dDayBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [dDayBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:dDayBtn];
        
        UIButton *alimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        alimBtn.frame = CGRectMake(6, 214, 308, 46);
        alimBtn.exclusiveTouch = YES;
        alimBtn.tag = 2;
        [alimBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [alimBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [alimBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:alimBtn];
        
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deviceBtn.frame = CGRectMake(6, 298, 308, 46);
        deviceBtn.exclusiveTouch = YES;
        deviceBtn.tag = 3;
        [deviceBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [deviceBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:deviceBtn];
        
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        infoBtn.frame = CGRectMake(6, 344, 308, 46);
        infoBtn.exclusiveTouch = YES;
        infoBtn.tag = 4;
        [infoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [infoBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:infoBtn];
        
        UIButton *faqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        faqBtn.frame = CGRectMake(6, 428, 308, 46);
        faqBtn.exclusiveTouch = YES;
        faqBtn.tag = 5;
        [faqBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [faqBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [faqBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:faqBtn];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(6, 474, 308, 46);
        sendBtn.exclusiveTouch = YES;
        sendBtn.tag = 6;
        [sendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:sendBtn];
        
        UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noticeBtn.frame = CGRectMake(6, 520, 308, 46);
        noticeBtn.exclusiveTouch = YES;
        noticeBtn.tag = 7;
        [noticeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [noticeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [noticeBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:noticeBtn];
        
        UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        customerBtn.frame = CGRectMake(6, 566, 308, 46);
        customerBtn.exclusiveTouch = YES;
        customerBtn.tag = 8;
        [customerBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [customerBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [customerBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:customerBtn];
        
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
        logout.frame = CGRectMake(107, 668, 106, 28);
        logout.exclusiveTouch = YES;
        [logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [logout setBackgroundImage:[UIImage imageNamed:@"btn_black02_normal"] forState:UIControlStateNormal];
        [logout setBackgroundImage:[UIImage imageNamed:@"btn_black02_pressed"] forState:UIControlStateHighlighted];
        [logout setTitle:@"로그아웃" forState:UIControlStateNormal];
        logout.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        [self addSubview:logout];
        
        [self DataToView];
        
        //스위치 버튼
        // 7.0이상
        if([mgCommon osVersion_7]){
            _swUsageAutoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(250, 175, 79, 27)];
        }else {
            _swUsageAutoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(226, 178, 79, 27)];
        }
        
		[_swUsageAutoLogin addTarget:self action:@selector(autoLoginON) forControlEvents:UIControlEventValueChanged];
        _swUsageAutoLogin.on = [_app._account getUsageAutoLogin];
		[self addSubview:_swUsageAutoLogin];
        
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 1.0f;
        self.contentSize = imageSize;
    }
    return self;
}

- (void)DataToView{
    _lblVersion.text = [[NSString alloc]initWithFormat:@"정보 (현재버전 %@ / %@)", _app._config._strAppVersion, _app._config._strNewVersion];
}

#pragma mark -
#pragma mark Button Action

- (void)btnAction:(UIButton *)sender{
    if(sender.tag == 8){
        UIAlertView *alert = (UIAlertView*)[[UIAlertView alloc]initWithTitle:@"알림" message:@"콜센터로 연결하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = 2;
        [alert show];
    }
    
    [_delegateScroll mgSettingScrollViewtouchButton:sender.tag];
}

- (void)callCenter{
    NSString *phoneNo = [[NSString alloc]initWithFormat:@"tel://%@", _app._config._strCallCenterPhoneNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNo]];
}
- (void)logoutAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"정말 로그아웃 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    alert.tag = 1;
    [alert show];
}

- (void)autoLoginON{
    [_app._account setUsageAutoLogin:_swUsageAutoLogin.on];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width)/2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self LogoutFromServer];
        }
    }    

    if (alertView.tag == 2) {
        if(buttonIndex == 1){
            [self callCenter];
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
    if (connection == conn) {
        [_receiveData appendData:data];
    }else if(connection == connLogout){
        [_dataLogout appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == conn) {
        NSString *encodeData = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            //NSLog(@"저장");
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if(connection == connLogout){
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
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults synchronize];
            [defaults setObject:@"0" forKey:HOME_LOAD_COUNT];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Main" bundle: nil];
            
            UIViewController *vc ;
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgHomeVC"];
            
            [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end


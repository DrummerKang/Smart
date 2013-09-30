//
//  mgSettingMenuView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSettingMenuView_iPad.h"

@implementation mgSettingMenuView_iPad

@synthesize _delegateMenu;

- (id)init {
    self = [super init];
    if (self) {
        _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [self drawSourceImageR:@"P_bg_setting" frame:CGRectMake(0, 0, 330, 655)];
        [self drawSourceImageR:@"cnt_gra" frame:CGRectMake(320, 0, 10, 655)];
        [self drawSourceImageR:@"ico_new" frame:CGRectMake(190, 478, 23, 22)];
        [self drawSourceImageR:@"table2" frame:CGRectMake(11, 31, 308, 93)];
        [self drawSourceImageR:@"table2" frame:CGRectMake(11, 161, 308, 93)];
        [self drawSourceImageR:@"table2" frame:CGRectMake(11, 291, 308, 93)];
        [self drawSourceImageR:@"P_table3" frame:CGRectMake(11, 421, 308, 139)];
        
        //버튼
        UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        profileBtn.frame = CGRectMake(11, 31, 308, 46);
        profileBtn.exclusiveTouch = YES;
        profileBtn.tag = 0;
        [profileBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [profileBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [profileBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:profileBtn];
        
        UIButton *dDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dDayBtn.frame = CGRectMake(11, 77, 308, 46);
        dDayBtn.exclusiveTouch = YES;
        dDayBtn.tag = 1;
        [dDayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [dDayBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [dDayBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:dDayBtn];
        
        UIButton *alimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        alimBtn.frame = CGRectMake(11, 207, 308, 46);
        alimBtn.exclusiveTouch = YES;
        alimBtn.tag = 2;
        [alimBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [alimBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [alimBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:alimBtn];
        
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deviceBtn.frame = CGRectMake(11, 291, 308, 46);
        deviceBtn.exclusiveTouch = YES;
        deviceBtn.tag = 3;
        [deviceBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [deviceBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:deviceBtn];
        
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        infoBtn.frame = CGRectMake(11, 337, 308, 46);
        infoBtn.exclusiveTouch = YES;
        infoBtn.tag = 4;
        [infoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [infoBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:infoBtn];
        
        UIButton *faqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        faqBtn.frame = CGRectMake(11, 421, 308, 46);
        faqBtn.exclusiveTouch = YES;
        faqBtn.tag = 5;
        [faqBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [faqBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [faqBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:faqBtn];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(11, 467, 308, 46);
        sendBtn.exclusiveTouch = YES;
        sendBtn.tag = 6;
        [sendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:sendBtn];
        
        UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noticeBtn.frame = CGRectMake(11, 513, 308, 46);
        noticeBtn.exclusiveTouch = YES;
        noticeBtn.tag = 7;
        [noticeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [noticeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [noticeBtn setBackgroundImage:[UIImage imageNamed:@"cellClick"] forState:UIControlStateHighlighted];
        [self addSubview:noticeBtn];
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(112, 618, 106, 28);
        logoutBtn.exclusiveTouch = YES;
        logoutBtn.tag = 8;
        [logoutBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_black02_normal"] forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_black02_pressed"] forState:UIControlStateHighlighted];
        [logoutBtn setTitle:@"로그아웃" forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        [self addSubview:logoutBtn];
        
        //텍스트
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(27, 47, 252, 17)];
        label1.text = @"내 프로필";
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label1.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(27, 93, 252, 17)];
        label2.text = @"나만의 D-day";
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label2.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(27, 177, 252, 17)];
        label3.text = @"자동 로그인 설정";
        label3.backgroundColor = [UIColor clearColor];
        label3.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label3.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(27, 223, 252, 17)];
        label4.text = @"알림 설정";
        label4.backgroundColor = [UIColor clearColor];
        label4.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label4.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(27, 307, 252, 17)];
        label5.text = @"등록기기 리스트";
        label5.backgroundColor = [UIColor clearColor];
        label5.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label5.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label5];
        
        _lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(27, 353, 252, 17)];
        _lblVersion.backgroundColor = [UIColor clearColor];
        _lblVersion.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        _lblVersion.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:_lblVersion];
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(27, 437, 252, 17)];
        label7.text = @"FAQ";
        label7.backgroundColor = [UIColor clearColor];
        label7.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label7.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label7];
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(27, 483, 252, 17)];
        label8.text = @"문의/오류/의견 보내기";
        label8.backgroundColor = [UIColor clearColor];
        label8.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label8.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label8];
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(27, 529, 252, 17)];
        label9.text = @"공지사항";
        label9.backgroundColor = [UIColor clearColor];
        label9.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label9.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label9];
        
        //스위치 버튼
        _swUsageAutoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(226, 171, 79, 27)];
		[_swUsageAutoLogin addTarget:self action:@selector(autoLoginON) forControlEvents:UIControlEventValueChanged];
        _swUsageAutoLogin.on = [_app._account getUsageAutoLogin];
		[self addSubview:_swUsageAutoLogin];
        
        [self DataToView];
    }
    
    return self;
}

- (void)DataToView{
    _lblVersion.text = [[NSString alloc]initWithFormat:@"정보 (현재버전 %@ / %@)", _app._config._strAppVersion, _app._config._strNewVersion];
}


- (void)autoLoginON{
    [_app._account setUsageAutoLogin:_swUsageAutoLogin.on];
}

#pragma mark -
#pragma mark Button Action

- (void)btnAction:(UIButton *)sender{
    [_delegateMenu mgSettingMenutouchButton:sender.tag];
}

- (void)selectMenu:(int)menu
{
    [_delegateMenu mgSettingMenutouchButton:menu];
}

@end

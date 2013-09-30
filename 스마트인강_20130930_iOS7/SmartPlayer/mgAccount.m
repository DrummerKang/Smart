//
//  mgAccount.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgAccount.h"

@implementation mgAccount
{
    NSString *_userID;      // 사용자 아이디
    NSString *_userPwd;     // 사용자 패스워드
    bool _bUsageAutoLogin;  // 자동로그인 여부
    bool _bIsLogin;         // 로그인 여부
    bool _bIsSkip;          // 스킵 여부
    bool _bIsDeviceCheck;   // 기기정보 등록 여부
    NSString *_req_key;     // 기기정보 요청키
    NSString *_acc_key;     // 로그인 접근권한키
    NSString *_enc_info;    // 로그인키
    NSString *_deviceModel; // 디바이스 모델
    NSString *_deviceToken; // 디바이스 토큰키
}

@synthesize delegate;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        _userID = @"";
        _userPwd = @"";
        _bUsageAutoLogin = false;
        _bIsLogin = false;
        _bIsSkip = false;
        _bIsDeviceCheck = false;
        _req_key = @"";
        _acc_key = @"";
        _enc_info = @"";
        _deviceModel = @"";
        _deviceToken = @"";
    }
    return self;
}

//ID
- (NSString*)getUserID{
    return _userID;
}
- (void)setUserID:(NSString*)userID{
    _userID = userID;
    [self.delegate changeAccount:self];
}

//PASSWORD
- (NSString*)getUserPwd{
    return _userPwd;
}
- (void)setUserPwd:(NSString*)userPwd{
    _userPwd = userPwd;
    [self.delegate changeAccount:self];
}

//LOGIN
- (bool)getIsLogin{
    return _bIsLogin;
}
- (void)setIsLogin:(bool)bIsLogin{
    _bIsLogin = bIsLogin;
    
    if(_bIsLogin)
        [self.delegate userLogin];
    else
        [self.delegate userLogOff];
    
     [self.delegate changeAccount:self];
}

//AUTO_LOGIN
- (bool)getUsageAutoLogin{
    return _bUsageAutoLogin;
}
- (void)setUsageAutoLogin:(bool)bUsageAutoLogin{
    _bUsageAutoLogin = bUsageAutoLogin;
    [self.delegate changeAccount:self];
}

//PROFILE_SKIP
- (bool)getIsSkip{
    return _bIsSkip;
}
- (void)setSkip:(bool)bIsSkip{
    _bIsSkip = bIsSkip;
    [self.delegate changeAccount:self];
}

//DEVICE_CHECK
- (bool)getIsDeviceCheck{
    return _bIsDeviceCheck;
}
- (void)setDeviceCheck:(bool)bIsDeviceCheck{
    _bIsDeviceCheck = bIsDeviceCheck;
    [self.delegate changeAccount:self];
}

//REQ_KEY
- (NSString*)getReq_key{
    return _req_key;
}
- (void)setReqKey:(NSString *)req_key{
    _req_key = req_key;
    [self.delegate changeAccount:self];
}

//ACC_KEY
- (NSString*)getAcc_key{
    return _acc_key;
}
- (void)setAccKey:(NSString *)acc_key{
    _acc_key = acc_key;
    [self.delegate changeAccount:self];
}

//ENC_INFO
- (NSString*)getEnc_info{
    return _enc_info;
}
- (void)setEncInfo:(NSString *)enc_info{
    _enc_info = enc_info;
    [self.delegate changeAccount:self];
}

//TOKEN
- (NSString*)getToken{
    return _deviceToken;
}
- (void)setToken:(NSString *)token{
    _deviceToken = token;
    [self.delegate changeAccount:self];
}

- (NSString*)toString{
    return [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"pwd\":\"%@\",\"ln\":\"%@\",\"lgn\":\"%@\",\"skip\":\"%@\",\"deviceCheck\":\"%@\",\"req_key\":\"%@\",\"acc_key\":\"%@\",\"enc_info\":\"%@\", \"token\":\"%@\"}", _userID, _userPwd, _bIsLogin ? @"1" : @"0", _bUsageAutoLogin ? @"1" : @"0", _bIsSkip ? @"1" : @"0", _bIsDeviceCheck ? @"1" : @"0", _req_key, _acc_key, _enc_info, _deviceToken];
}

@end

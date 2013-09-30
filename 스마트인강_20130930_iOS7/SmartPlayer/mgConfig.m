//
//  mgConfig.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgConfig.h"

#import "mgGlobal.h"

@implementation mgConfig

@synthesize _sMyDDayMsg, _sMyGoal, _sMyDecision, _sNickName, _dtMyDDay;
@synthesize _bNeedUpdate, _bUsageAnsAlarm, _bUsageLecEndAlarm, _bUsageLecInfoAlarm, _bUsageMsgAlarm, _bUsageProgAlarm, _bUsageTimer;
@synthesize _nTimerInterval, _strCallCenterPhoneNo, _strAppVersion, _strNewVersion;
@synthesize delegate;
@synthesize _sMyImage;
@synthesize _sPlayer_reg;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _sNickName = @"";
        _sMyGoal = @"";
        _sMyDecision = @"";
        _sMyDDayMsg = @"";
        _dtMyDDay = nil;
        _sMyImage = @"";
        _sPlayer_reg = @"";
        
        _bNeedUpdate = false;
        
        _bUsageAnsAlarm = false;
        _bUsageMsgAlarm = false;
        _bUsageProgAlarm = false;
        _bUsageLecEndAlarm = false;
        _bUsageLecInfoAlarm = false;
        
        _bUsageTimer = false;
        _nTimerInterval = 60; // 단위 : 분
        
        NSString *bundleVersionInfo = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
        _strCallCenterPhoneNo = CENTER_PHONE_NUMBER;
        _strAppVersion = bundleVersionInfo;
        //_strNewVersion = APP_VERSION;
    }
    return self;
}

-(void)setNeedUpdate:(bool)bNeedUpdate
{
    self._bNeedUpdate = bNeedUpdate;
    [self.delegate changeConfig:self];
}

-(void)setUsageAnsAlarm:(bool)bUsageAnsAlarm{
    self._bUsageAnsAlarm = bUsageAnsAlarm;
    [self.delegate changeConfig:self];
}
-(void)setUsageMsgAlarm:(bool)bUsageMsgAlarm{
    self._bUsageMsgAlarm = bUsageMsgAlarm;
    [self.delegate changeConfig:self];
}
-(void)setUsageProgAlarm:(bool)bUsageProgAlarm{
    self._bUsageProgAlarm = bUsageProgAlarm;
    [self.delegate changeConfig:self];
}
-(void)setUsageLecEndAlarm:(bool)bUsageLecEndAlarm{
    self._bUsageLecEndAlarm = bUsageLecEndAlarm;
    [self.delegate changeConfig:self];
}
-(void)setUsageLecInfoAlarm:(bool)bUsageLecInfoAlarm{
    self._bUsageLecInfoAlarm = bUsageLecInfoAlarm;
    [self.delegate changeConfig:self];
}
-(void)setUsageTimer:(bool)bUsageTimer{
    self._bUsageTimer = bUsageTimer;
    [self.delegate changeConfig:self];
}
-(void)setTimerInterval:(int)nTimeInterval{
    self._nTimerInterval = nTimeInterval;
    [self.delegate changeConfig:self];
}
// 프로필
-(void)setNickName:(NSString*)nickname{
    self._sNickName = nickname;
    [self.delegate changeConfig:self];
}
-(void)setMyGoal:(NSString*)goal{
    self._sMyGoal = goal;
    [self.delegate changeConfig:self];
}
-(void)setMyDecision:(NSString*)decision{
    self._sMyDecision = decision;
    [self.delegate changeConfig:self];
}
// DDay
-(void)setMyDDayMsg:(NSString*)ddaymsg{
    self._sMyDDayMsg = ddaymsg;
    [self.delegate changeConfig:self];
}
-(void)setMyDDay:(NSDate*)dday{
    self._dtMyDDay = dday;
    [self.delegate changeConfig:self];
}
//이미지
-(void)setMyImage:(NSString *)myImage{
    self._sMyImage = myImage;
    [self.delegate changeConfig:self];
}
//디바이스체크
-(void)setPlayer_reg:(NSString *)player_reg{
    self._sPlayer_reg = player_reg;
    [self.delegate changeConfig:self];
}
-(NSString*)toString
{
    NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
    [_fmt setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *_sDtDDay = @"";
    
    if(self._dtMyDDay != nil)
        [_fmt stringFromDate:self._dtMyDDay];
    
    return [[NSString alloc]initWithFormat:@"{\"ans\":\"%@\",\"msg\":\"%@\",\"prg\":\"%@\",\"lece\":\"%@\",\"leci\":\"%@\",\"usgtimer\":\"%@\",\"timerinfo\":\"%d\",\"nick\":\"%@\",\"goal\":\"%@\",\"decision\":\"%@\",\"ddaymsg\":\"%@\",\"dday\":\"%@\",\"myImage\":\"%@\",\"player_reg\":\"%@\",\"needupdate\":\"%@\"}", self._bUsageAnsAlarm ? @"1":@"0", self._bUsageMsgAlarm ? @"1":@"0", self._bUsageProgAlarm ? @"1":@"0", self._bUsageLecEndAlarm ? @"1":@"0", self._bUsageLecInfoAlarm ? @"1":@"0", self._bUsageTimer ? @"1":@"0", self._nTimerInterval, self._sNickName, self._sMyGoal, self._sMyDecision, self._sMyDDayMsg, _sDtDDay, self._sMyImage, self._sPlayer_reg,self._bNeedUpdate ? @"1":@"0"];
}
@end

//
//  mgConfig.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol mgConfigProtocol <NSObject>
- (void)changeConfig:(id)config;
@end

@interface mgConfig : NSObject
{
    // 프로필
    NSString *_sNickName;       // 닉네임
    NSString *_sMyGoal;         // 나의목표
    NSString *_sMyDecision;     // 나의다짐
    // DDay
    NSString *_sMyDDayMsg;      // 다짐의글
    NSDate   *_dtMyDDay;        // DDay
    // 이미지 경로
    NSString *_sMyImage;
    //디바이스 체크
    NSString *_sPlayer_reg;
    
    // 설정정보
    bool _bNeedUpdate;
    
    bool _bUsageAnsAlarm;
    bool _bUsageMsgAlarm;
    bool _bUsageProgAlarm;
    bool _bUsageLecEndAlarm;
    bool _bUsageLecInfoAlarm;
    
    bool _bUsageTimer;
    int _nTimerInterval;
    
    id <mgConfigProtocol> delegate;
}

// 프로필
@property (strong, nonatomic) NSString *_sNickName;
@property (strong, nonatomic) NSString *_sMyGoal;
@property (strong, nonatomic) NSString *_sMyDecision;

// DDay
@property (strong, nonatomic) NSString *_sMyDDayMsg;
@property (strong, nonatomic) NSDate *_dtMyDDay;

@property (strong, nonatomic) NSString *_sMyImage;

@property (strong, nonatomic) NSString *_sPlayer_reg;

// 설정
@property bool _bNeedUpdate;
@property bool _bUsageAnsAlarm;
@property bool _bUsageMsgAlarm;
@property bool _bUsageProgAlarm;
@property bool _bUsageLecEndAlarm;
@property bool _bUsageLecInfoAlarm;

@property bool _bUsageTimer;
@property int _nTimerInterval;

@property (strong, nonatomic) id <mgConfigProtocol> delegate;

// 프로필
-(void)setNickName:(NSString*)nickname;
-(void)setMyGoal:(NSString*)goal;
-(void)setMyDecision:(NSString*)decision;
// DDay
-(void)setMyDDayMsg:(NSString*)ddaymsg;
-(void)setMyDDay:(NSDate*)dday;

-(void)setMyImage:(NSString*)myImage;

-(void)setPlayer_reg:(NSString*)player_reg;

// 설정
-(void)setNeedUpdate:(bool)bNeedUpdate;
-(void)setUsageAnsAlarm:(bool)bUsageAnsAlarm;
-(void)setUsageMsgAlarm:(bool)bUsageMsgAlarm;
-(void)setUsageProgAlarm:(bool)bUsageProgAlarm;
-(void)setUsageLecEndAlarm:(bool)bUsageLecEndAlarm;
-(void)setUsageLecInfoAlarm:(bool)bUsageLecInfoAlarm;

-(void)setUsageTimer:(bool)bUsageTimer;
-(void)setTimerInterval:(int)nTimeInterval;

@property (strong, nonatomic) NSString *_strCallCenterPhoneNo;
@property (strong, nonatomic) NSString *_strAppVersion;
@property (strong, nonatomic) NSString *_strNewVersion;

-(NSString*)toString;

@end

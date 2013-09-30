//
//  mgCommon.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 4. 1..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "mgGlobal.h"

@interface mgCommon : NSObject
+ (int)getMarkHour;
+ (NSDate*)DateToMarkDate:(NSDate*)date;
+(void)setPushToken:(NSString*)PushToken;
+ (NSString*)getToken;
+ (NSString*)getiOSVersion;
+ (NSString*)getDeviceUUID;
+ (NSString*)getDeviceModel;
+ (BOOL)hasFourInchDisplay;
+ (BOOL)osVersion_7;
+ (BOOL)hasRetinaDisplay;
+ (CGRect)getScreenFrame;

// 시간관련 공용함수
+ (int)getSecondFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate;
+ (int)getMinutesFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate;
+ (int)getHourFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate;

+ (NSDate*)addMinute:(int)minuite ToDate:(NSDate*)date;
+ (NSDate*)addHour:(int)hour ToDate:(NSDate*)date;
+ (NSDate*)addDay:(int)day ToDate:(NSDate*)date;
+ (NSDate*)dateWithoutMilisecond:(NSDate*)date;

+ (uint64_t)freeDiskspace;

@end


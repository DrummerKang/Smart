//
//  mgCommon.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 4. 1..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

// 앱에 쓰일 정적함수들의 집합체
#import "mgCommon.h"

@implementation mgCommon

static NSString *_sPushToken = @"";

+ (int)getMarkHour
{
    return TIMER_MARK_HOUR;
}
+ (NSDate*)DateToMarkDate:(NSDate*)date
{
    NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
    NSString *_fmtString = [[NSString alloc]initWithFormat:@"yyyy/MM/dd %02d:00:00", [mgCommon getMarkHour]];
    [_fmt setDateFormat:_fmtString];
    NSString *_retString = [_fmt stringFromDate:date];
    [_fmt setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    return [_fmt dateFromString:_retString];
}

+(void)setPushToken:(NSString*)PushToken
{
    _sPushToken = PushToken;
}

+ (NSString*)getToken
{
    return _sPushToken;
}

+(NSString*)getiOSVersion
{
    return [[NSString alloc]initWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
}

+(NSString*)getDeviceModel
{
    return [[UIDevice currentDevice]model];
}

+(NSString*)getDeviceUUID
{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

+(BOOL)hasFourInchDisplay
{
    return ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone & [UIScreen mainScreen].bounds.size.height == 568.0);
}

+(BOOL)osVersion_7
{
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f);
}

+(BOOL)hasRetinaDisplay
{
    if([[UIScreen mainScreen]respondsToSelector:@selector(displayLinkWithTarget:selector:)]&&([UIScreen mainScreen].scale == 2.0))
    {
        return true;
    }else{
        return false;
    }
}

+ (CGRect)getScreenFrame
{
    return [[UIScreen mainScreen]applicationFrame];
}

#pragma mark - Common Functions for Time & Date Calculation
// 시간관련 공용함수
+ (int)getSecondFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate
{// 두 시간사이의 분차이를 정수로 반환
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:frDate
                                                  toDate:toDate options:0];
    NSInteger diff = [components second];
    
    return (int)diff;
}

+ (int)getMinutesFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate
{// 두 시간사이의 분차이를 정수로 반환
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMinuteCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:frDate
                                                  toDate:toDate options:0];
    NSInteger diff = [components minute];
    
    return (int)diff;
}

+ (int)getHourFromDate:(NSDate*)frDate ToDate:(NSDate*)toDate
{// 두 시간사이의 분차이를 정수로 반환
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSHourCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:frDate
                                                  toDate:toDate options:0];
    NSInteger diff = [components hour];
    
    return (int)diff;
}

+ (NSDate*)addMinute:(int)minuite ToDate:(NSDate*)date
{
    NSDateComponents *dtCompt = [[NSDateComponents alloc]init];
    [dtCompt setMinute:minuite];
    return [[NSCalendar currentCalendar]dateByAddingComponents:dtCompt toDate:date options:0];
}

+ (NSDate*)addHour:(int)hour ToDate:(NSDate*)date
{
    NSDateComponents *dtCompt = [[NSDateComponents alloc]init];
    [dtCompt setHour:hour];
    return [[NSCalendar currentCalendar]dateByAddingComponents:dtCompt toDate:date options:0];
}

+ (NSDate*)addDay:(int)day ToDate:(NSDate*)date
{
    NSDateComponents *dtCompt = [[NSDateComponents alloc]init];
    [dtCompt setDay:day];
    return [[NSCalendar currentCalendar]dateByAddingComponents:dtCompt toDate:date options:0];
}

+ (NSDate*)dateWithoutMilisecond:(NSDate*)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy/MM/dd HH:mm:ss 000"];
    NSString *strDate = [fmt stringFromDate:date];
    [fmt setDateFormat:@"yyyy/MM/dd HH:mm:ss SSS"];
    NSDate *dtRet = [fmt dateFromString:strDate];
    
    return dtRet;
}

+ (uint64_t)freeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        ////NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        ////NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    return totalFreeSpace;
}

@end

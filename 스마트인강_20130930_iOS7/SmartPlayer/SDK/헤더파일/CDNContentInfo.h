//
//  ContentInfo.h
//  CDNPlayerSDK
//
//  Created by CDNetworks on 12. 9. 15..
//

#import <UIKit/UIKit.h>

@interface CDNContentInfo : NSObject
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, assign) int playCount;
@property (nonatomic, retain) NSString *playEndDate;
@property (nonatomic, retain) NSString *playStartDate;
@property (nonatomic, assign) int restPlayCount;
@property (nonatomic, assign) int restTime;
@end

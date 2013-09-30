//
//  CoreErrorHandler.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 27..
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CoreSysErrCode.h"
#import "CoreProtocolErrCode.h"

@interface CoreErrorHandler : NSObject

+ (NSString *)messageFromCode:(int)errCode;
+ (NSString *)messageCode:(int)errCode;

@end

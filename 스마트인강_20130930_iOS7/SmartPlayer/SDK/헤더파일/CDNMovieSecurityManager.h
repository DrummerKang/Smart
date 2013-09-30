//
//  CDNMovieSecurityManager.h
//  CDNPlayerSDK
//
//  Created by Lee Michael on 11. 9. 13..
//  Copyright 2011년 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CDNMovieSecurityManager : NSObject
{
    BOOL isJailbreakBlocked;
    BOOL isMirroringBlocked;
    UIWindow *secondWindow;
}
@property BOOL isJailbreakBlocked;
@property BOOL isMirroringBlocked;
@property (nonatomic,assign) UIWindow *secondWindow;

+(CDNMovieSecurityManager *) sharedManager;

-(BOOL) isJailbroken;
-(void) checkCurrencScreen;

@end

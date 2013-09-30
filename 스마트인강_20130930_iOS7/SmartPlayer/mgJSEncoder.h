//
//  mbJSEncoder.h
//  mbestMom1
//
//  Created by 메가스터디 on 13. 1. 23..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mgJSEncoder : NSObject
+ (NSString*) unescapeUnicodeString:(NSString*)string;
+ (NSString*) escapeUnicodeString:(NSString*)string;

@end

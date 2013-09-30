//
//  mgDeviceNoItemView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgDeviceNoItemView_iPad.h"

@implementation mgDeviceNoItemView_iPad

- (id)init{
    if ((self = [super init])) {
        self.backgroundColor = [self getColor:@"E5E9F1"];
        
        [self drawSourceImageR:@"bg_nophone@2x" frame:CGRectMake(187, 130, 320, 416)];
    }
    return self;
}

- (UIColor *)getColor: (NSString *) hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@end

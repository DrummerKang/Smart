//
//  mgMyLecCell_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 5..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMyLecCell_iPad.h"

static NSString *identifier = @"mgMyLecCell_iPad";

@implementation mgMyLecCell_iPad

@synthesize subject;
@synthesize endDay;
@synthesize lecTime;

@synthesize sdPlay;
@synthesize sdDown;
@synthesize hdPlay;
@synthesize hdDown;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgMyLecCell_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgMyLecCell_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end

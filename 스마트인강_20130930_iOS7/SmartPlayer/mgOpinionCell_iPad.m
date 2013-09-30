//
//  mgOpinionCell_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 30..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgOpinionCell_iPad.h"

static NSString *identifier = @"mgOpinionCell_iPad";

@implementation mgOpinionCell_iPad

@synthesize titleText;
@synthesize checkBtn;
@synthesize titleCode;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgOpinionCell_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgOpinionCell_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end


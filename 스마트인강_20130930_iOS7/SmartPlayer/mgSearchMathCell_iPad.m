//
//  mgSearchMathCell_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchMathCell_iPad.h"

static NSString *identifier = @"mgSearchMathCell_iPad";

@implementation mgSearchMathCell_iPad

@synthesize titleText;
@synthesize cellSelectedBtn;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgSearchMathCell_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgSearchMathCell_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end

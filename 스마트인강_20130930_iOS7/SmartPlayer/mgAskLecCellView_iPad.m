//
//  mgAskLecCellView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecCellView_iPad.h"

static NSString *identifier = @"mgAskLecCellView_iPad";

@implementation mgAskLecCellView_iPad

@synthesize titleName;
@synthesize userName;
@synthesize dayName;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgAskLecCellView_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgAskLecCellView_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end

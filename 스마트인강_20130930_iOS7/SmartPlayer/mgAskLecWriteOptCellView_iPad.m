//
//  mgAskLecWriteOptCellView_iPad.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecWriteOptCellView_iPad.h"

static NSString *identifier = @"mgAskLecWriteOptCellView_iPad";

@implementation mgAskLecWriteOptCellView_iPad

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgAskLecWriteOptCellView_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgAskLecWriteOptCellView_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end

//
//  mgMessageAskQuestionOptCellView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageAskQuestionOptCellView_iPad.h"

static NSString *identifier = @"mgMessageAskQuestionOptCellView_iPad";

@implementation mgMessageAskQuestionOptCellView_iPad

@synthesize name;
@synthesize userId;
@synthesize hiddenName;
@synthesize hiddenId;
@synthesize checkBtn;

+ (id)create{
    UINib *nib = [UINib nibWithNibName:@"mgMessageAskQuestionOptCellView_iPad" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    mgMessageAskQuestionOptCellView_iPad *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (NSString *)reuseIdentifier{
    return identifier;
}

+ (NSString *)identifier{
    return identifier;
}

@end

//
//  mgBackgroundView.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 31..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgBackgroundView.h"

@implementation mgBackgroundView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

@end


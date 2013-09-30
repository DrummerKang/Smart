//
//  mgPopoverBgV.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 2..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgPopoverBgV.h"
#import <QuartzCore/QuartzCore.h>

@implementation mgPopoverBgV


@synthesize arrowOffset, arrowDirection;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)layoutSubviews{
    
//    self.layer.cornerRadius = 10;
//    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.layer.shadowRadius = 10;
	self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
	self.layer.shadowOpacity = 1;
}

+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

+(CGFloat)arrowHeight{
    return 0;
}

+(CGFloat)arrowBase{
    return 0;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return YES;
}

@end

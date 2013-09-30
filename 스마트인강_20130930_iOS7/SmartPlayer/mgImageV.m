//
//  mgImageV.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgImageV.h"

@implementation mgImageV
{
    UIImageView *imgClose;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 닫기버튼 추가
    }
    return self;
}

- (void)awakeFromNib
{
    UIImage *image = [UIImage imageNamed:@"ico_x"];
    if (imgClose == nil) {
        imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(80-43, 0, 23, 23)];
        [imgClose setImage:image];
        [self addSubview:imgClose];
    }
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    [imgClose removeFromSuperview];
    [self addSubview:imgClose];
}

@end

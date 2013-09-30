//
//  mgInputTextField.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgInputTextField.h"

@implementation mgInputTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect{
    UIImage *bgImage = [[UIImage imageNamed:@"search_input.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [bgImage drawInRect:rect];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    ret.origin.x = ret.origin.x + 10;
    ret.size.width = ret.size.width - 20;
    return ret;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

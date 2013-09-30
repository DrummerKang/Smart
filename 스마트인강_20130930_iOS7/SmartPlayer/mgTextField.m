//
//  mgTextField.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 17..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgTextField.h"

@implementation mgTextField

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
    if (self.userInteractionEnabled == NO){
        UIImage *bgImage = [[UIImage imageNamed:@"_bg_textfield1"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [bgImage drawInRect:rect];
        
    }else{
        UIImage *bgImage = [[UIImage imageNamed:@"_bg_textfield2"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [bgImage drawInRect:rect];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    [self setNeedsDisplay];
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

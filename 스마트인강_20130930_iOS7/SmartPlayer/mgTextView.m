//
//  mgTextView.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 17..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgTextView.h"

@implementation mgTextView

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

@end

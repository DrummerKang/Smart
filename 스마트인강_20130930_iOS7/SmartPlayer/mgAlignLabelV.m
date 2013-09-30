//
//  mgAlignLabelV.m
//  DemoAlignLabel
//
//  Created by 메가스터디 on 13. 7. 16..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgAlignLabelV.h"

@implementation mgAlignLabelV
{
    UIImage *_imgICON;
    NSString *_Dday;
    NSString *_DdayNumber;
}

- (void)awakeFromNib
{
    _imgICON = [UIImage imageNamed:@"ico_time"];
    _Dday = @"Dday";
    _DdayNumber = @"D - 100";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float centerY = rect.size.height/2.0f;
    float centerX = rect.size.width/2.0f;
    
    int totalWidth = 0.0f;
    
    UIFont *font1 = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
    UIFont *font2 = [UIFont fontWithName:@"Apple SD Gothic Neo" size:25];

    [[UIColor colorWithRed:53 green:66 blue:93 alpha:1]setStroke];
    
    
    CGSize expectedLabelSize1 = [_Dday sizeWithFont:font1 constrainedToSize:CGSizeMake(rect.size.width, rect.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize expectedLabelSize2 = [_DdayNumber sizeWithFont:font2 constrainedToSize:CGSizeMake(rect.size.width, rect.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    // Drawing code
    if (_imgICON != nil) {
        _imgICON = [UIImage imageNamed:@"ico_time"];
    }

    totalWidth = _imgICON.size.width + 8.0f + expectedLabelSize1.width + 8.0f + expectedLabelSize2.width;
    float XOffset = centerX - totalWidth/2;
    
    NSLog(@"%f", XOffset);
    
    [_imgICON drawAtPoint:CGPointMake(XOffset, centerY - _imgICON.size.height/2 + 6)];

    XOffset += _imgICON.size.width + 8.0f;
    [_Dday drawInRect:CGRectMake(XOffset, centerY-expectedLabelSize1.height/2 + 6, expectedLabelSize1.width, expectedLabelSize1.height) withFont:font1 lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
    
    NSLog(@"%f", XOffset);
    XOffset += expectedLabelSize1.width + 8.0f;
    [_DdayNumber drawInRect:CGRectMake(XOffset, centerY-expectedLabelSize2.height/2 + 6, expectedLabelSize2.width, expectedLabelSize1.height) withFont:font2 lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)setDday:(NSString*)message DDayNo:(NSString*)DdayNo
{
    _Dday = message;
    _DdayNumber = DdayNo;
    
    [self setNeedsDisplay];
}

@end

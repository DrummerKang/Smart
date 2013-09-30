//
//  mgButtonSlideV.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgButtonSlideV.h"
#import "mgCommon.h"

@implementation mgButtonSlideV
{
    int _buttonCnt;
}

@synthesize _dlgtSlideV;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonCnt = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

}

- (UIColor *) getColor: (NSString *) hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

- (void)addButton:(NSString*)title{
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btn setTitle:title forState:UIControlStateNormal];
    [_btn.titleLabel setTextColor:[UIColor whiteColor]];
    
    [_btn setBackgroundImage:[UIImage imageNamed:@"_btn_slidebutton_default"] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[UIImage imageNamed:@"_btn_slidebutton_selected"] forState:UIControlStateSelected];
    
    _btn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
    
    [_btn setTitleColor:[[UIColor alloc]initWithRed:202.0f/225.0f green:211.0f/225.0f blue:229.0f/225.0f alpha:1.0f] forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    //_btn.titleLabel.textColor = [self getColor:@"#cad3e5"];
    [_btn setFrame:CGRectMake(0.0f + SLIDE_BUTTON_WIDTH * _buttonCnt, 0.0f, SLIDE_BUTTON_WIDTH, SLIDE_BUTTON_HEIGHT)];
    [_btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btn];
    
    _buttonCnt ++;
    
    [self setContentSize:CGSizeMake(SLIDE_BUTTON_WIDTH * _buttonCnt, SLIDE_BUTTON_HEIGHT)];
}

- (void)touchButton:(id)sender{
    [self clearSelect];
    
    UIButton *btn = (UIButton*)sender;
    btn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:19];
    //btn.titleLabel.textColor = [self getColor:@"#ffffff"];
    //[btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn setSelected:YES];
    [_dlgtSlideV mgButtonSlideV_touchButton:btn.titleLabel.text tag:btn.tag];
}

- (void)clearSelect{
    int cntSubViews = self.subviews.count;
    int idxSubView = 0;
    for (idxSubView=0; idxSubView < cntSubViews; idxSubView++)
    {
        id subview = [self.subviews objectAtIndex:idxSubView];
        NSString *className = [[NSString alloc]initWithFormat:@"%@", [subview class]];

        // 7.0이상
        if([mgCommon osVersion_7]){
            if ([className isEqualToString:@"UIButton"] ) {
                UIButton *_btn = (UIButton*)subview;
                _btn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
                //_btn.titleLabel.textColor = [self getColor:@"#cad3e5"];
                [_btn setSelected:NO];
            }
        }else{
            if ([className isEqualToString:@"UIRoundedRectButton"] ) {
                UIButton *_btn = (UIButton*)subview;
                _btn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
                //_btn.titleLabel.textColor = [self getColor:@"#cad3e5"];
                [_btn setSelected:NO];
            }
        }
    }
}

- (void)scrollToRight{
    if(self.contentOffset.x + self.bounds.size.width >= self.contentSize.width)
        return;
    
    CGPoint offset = self.contentOffset;
    int index = offset.x / self.bounds.size.width;
    [self setContentOffset:CGPointMake((index+1)*self.bounds.size.width, 0.0f) animated:YES];
}

- (void)scrollToLeft{
    CGPoint offset = self.contentOffset;
    int index = offset.x / self.bounds.size.width;
    int xOffset = (index-1)*self.bounds.size.width;
    
    [self setContentOffset:CGPointMake(index < 1 ? 0 : xOffset, 0.0f) animated:YES];
}

- (void)setButton:(NSString*)title setSelected:(bool)value
{
    int cntSubViews = self.subviews.count;
    int idxSubView = 0;
    for (idxSubView=0; idxSubView < cntSubViews; idxSubView++)
    {
        id subview = [self.subviews objectAtIndex:idxSubView];
        NSString *className = [[NSString alloc]initWithFormat:@"%@", [subview class]];
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            if ([className isEqualToString:@"UIButton"] ) {
                UIButton *_btn = (UIButton*)subview;
                
                if ([_btn.titleLabel.text isEqualToString:title]) {
                    [self touchButton:_btn];
                }
            }
            
        }else{
            if ([className isEqualToString:@"UIRoundedRectButton"] ) {
                UIButton *_btn = (UIButton*)subview;
                
                if ([_btn.titleLabel.text isEqualToString:title]) {
                    [self touchButton:_btn];
                }
            }
        }
    }
}

@end

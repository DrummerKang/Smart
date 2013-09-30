//
//  mgProgressBar.m
//  DemoCustomSlider
//
//  Created by 메가스터디 on 13. 6. 24..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgProgressBar.h"

static int progressbar_offset_x = 1;
static int progressbar_offset_y = 3;
static float progressbar_alpha = 0.7f;

@implementation mgProgressBar
{
    UIImage *_backgroundImage;
    UIImage *_progressbarImage_25;
    UIImage *_progressbarImage_50;
    UIImage *_progressbarImage_75;
    UIImage *_progressbarImage_100;
    
    UIImage *_progressmarkerImage_25;
    UIImage *_progressmarkerImage_50;
    UIImage *_progressmarkerImage_75;
    UIImage *_progressmarkerImage_100;
    
    UIImageView *_marker;
    
    float _nMaxValue;
    float _nMinValue;
    float _nValue;
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
    // Drawing code
    if (_backgroundImage != nil) {
        [_backgroundImage drawInRect:CGRectMake(0, 0, _backgroundImage.size.width, _backgroundImage.size.height)];
    }
    
    UIImage *progressmarkerImage = nil;
    UIImage *progressbarImage = nil;
    
    float percent = (_nValue-_nMinValue)/(_nMaxValue-_nMinValue);
    
    if (percent > 0.75f) {
        progressbarImage = _progressbarImage_100;
        progressmarkerImage = _progressmarkerImage_100;
    }else if (percent > 0.50f) {
        progressbarImage = _progressbarImage_75;
        progressmarkerImage = _progressmarkerImage_75;
    }else if (percent > 0.25f) {
        progressbarImage = _progressbarImage_50;
        progressmarkerImage = _progressmarkerImage_50;
    }else{
        progressbarImage = _progressbarImage_25;
        progressmarkerImage = _progressmarkerImage_25;
    }
    
    [_marker setImage:progressmarkerImage];
    
    if (progressbarImage != nil) {
        [progressbarImage drawInRect:CGRectMake(progressbar_offset_x, progressbar_offset_y, progressbarImage.size.width * percent, progressbarImage.size.height) blendMode:kCGBlendModeNormal alpha:progressbar_alpha];
        [_marker setFrame:CGRectMake(progressbarImage.size.width * percent - progressmarkerImage.size.width/2, -5, progressmarkerImage.size.width, progressmarkerImage.size.height)];
    }
}

- (void)awakeFromNib
{
    _nMaxValue = 100;
    _nMinValue = 0;
    _nValue = _nMinValue;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (_backgroundImage == nil) {
        _backgroundImage = [UIImage imageNamed:@"slider_bg"];
    }
    
    // progressbar
    if (_progressbarImage_25 == nil) {
        _progressbarImage_25 = [[UIImage imageNamed:@"slider_step01"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    }
    
    if (_progressbarImage_50 == nil) {
        _progressbarImage_50 = [[UIImage imageNamed:@"slider_step02"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    }
    
    if (_progressbarImage_75 == nil) {
        _progressbarImage_75 = [[UIImage imageNamed:@"slider_step03"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    }
    
    if (_progressbarImage_100 == nil) {
        _progressbarImage_100 = [[UIImage imageNamed:@"slider_step04"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    }
    
    // progressbar marker
    if (_progressmarkerImage_25 == nil) {
        _progressmarkerImage_25 = [UIImage imageNamed:@"ico_step01"];
    }
    
    if (_progressmarkerImage_50 == nil) {
        _progressmarkerImage_50 = [UIImage imageNamed:@"ico_step02"];
    }
    
    if (_progressmarkerImage_75 == nil) {
        _progressmarkerImage_75 = [UIImage imageNamed:@"ico_step03"];
    }
    
    if (_progressmarkerImage_100 == nil) {
        _progressmarkerImage_100 = [UIImage imageNamed:@"ico_step04"];
    }
    
    if (_marker == nil) {
        _marker = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_marker setImage:_progressmarkerImage_25];
        [self addSubview:_marker];
    }
}

- (void)setMaxValue:(float)max
{
    _nMaxValue = max;
}
- (void)setMinValue:(float)min
{
    _nMinValue = min;
}
- (void)setProgress:(float)value
{
    if (value < _nMinValue) {
        value = _nMinValue;
    }else if(value > _nMaxValue)
    {
        value = _nMaxValue;
    }
    _nValue = value;
    
    [self setNeedsDisplay];
}

@end


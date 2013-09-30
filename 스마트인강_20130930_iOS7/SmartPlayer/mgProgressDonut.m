//
//  mgProgressCircle.m
//  DemoProgressCircle
//
//  Created by 메가스터디 on 13. 5. 9..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgProgressDonut.h"

//macro
#define RADIANS(degree)(3*M_PI/2 + M_PI/2*degree/90.0f)

@implementation mgProgressDonut
{
    float _fProgress;
    CGPoint _ptCenter;
    UILabel *_lblPercent;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setProgress:(float)fValue
{
    _fProgress = fValue;
    [self setNeedsDisplay];
}

- (float)getProgress
{
    return (_fProgress > 1.0f) ? 1.0f : _fProgress;
}

- (void)InitLabel
{
    if (_lblPercent == nil) {
        _lblPercent = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, self.frame.size.height/2-10.0f, self.frame.size.width, 20.0f)];
        _lblPercent.font = [UIFont systemFontOfSize:9.0f];
        _lblPercent.textAlignment = NSTextAlignmentCenter;
        [_lblPercent setTextColor:[[UIColor alloc]initWithRed:63.0f/255.0f green:175.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        _lblPercent.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblPercent];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // init label
    [self InitLabel];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    // get size
    _ptCenter.x = self.frame.size.width/2;
    _ptCenter.y = self.frame.size.height/2;
    
    // draw donut
    [self drawDonut:context degree:360.0f color:[[UIColor alloc]initWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]];

    [self drawDonut:context degree:(360.0f * [self getProgress]) color:[[UIColor alloc]initWithRed:63.0f/255.0f green:175.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
 
    //set Label
    if(_lblPercent) _lblPercent.text = [[NSString alloc]initWithFormat:@"%d%%",(int)([self getProgress]*100)];
}

- (void)drawLines:(CGContextRef)context color:(UIColor*)color lineWidth:(int)width
{
    CGRect rect = self.frame;
    
    CGContextMoveToPoint(context, _ptCenter.x, _ptCenter.y);
    CGContextAddLineToPoint(context, _ptCenter.x, 0);
    
    CGContextMoveToPoint(context, _ptCenter.x, _ptCenter.y);
    CGContextAddLineToPoint(context, rect.size.width, _ptCenter.y);
    
    CGContextMoveToPoint(context, _ptCenter.x, _ptCenter.y);
    CGContextAddLineToPoint(context, _ptCenter.x, rect.size.height);
    
    CGContextMoveToPoint(context, _ptCenter.x, _ptCenter.y);
    CGContextAddLineToPoint(context, 0, _ptCenter.y);
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGContextStrokePath(context);
}

- (void)drawInnerDonut:(CGContextRef)context degree:(float)degree color:(UIColor*)color
{
    // draw donut
    CGMutablePathRef arc = CGPathCreateMutable();
    CGPathMoveToPoint(arc, NULL,
                      _ptCenter.x, _ptCenter.y-[self getInnerRadius]);
    CGPathAddArc(arc, NULL,
                 _ptCenter.x, _ptCenter.y,
                 [self getInnerRadius],
                 RADIANS(0.0f),
                 RADIANS(degree),
                 NO);
    
    CGFloat lineWidth = 4.0;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   10); // 10 is default miter limit
    
    CGContextAddPath(context, strokedArc);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawDonut:(CGContextRef)context degree:(float)degree color:(UIColor*)color
{
    // draw donut
    CGMutablePathRef arc = CGPathCreateMutable();
    CGPathMoveToPoint(arc, NULL,
                      _ptCenter.x, _ptCenter.y-[self getInnerRadius]);
    CGPathAddArc(arc, NULL,
                 _ptCenter.x, _ptCenter.y,
                 [self getInnerRadius],
                 RADIANS(0.0f),
                 RADIANS(degree),
                 NO);
    
    CGFloat lineWidth = 8.0;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   10); // 10 is default miter limit

    CGContextAddPath(context, strokedArc);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}
- (float)getOuterRadius
{
    return (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / 2 * 0.8 : self.frame.size.height / 2 * 0.8;
}

- (float)getInnerRadius
{
    return (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / 2 * 0.7 : self.frame.size.height / 2 * 0.6;
}

@end

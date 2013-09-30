//
//  mgMessageView.m
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgMessageView.h"

#import <QuartzCore/QuartzCore.h>

// TODO make some of these instance variables to add more customization.
static const CGFloat kArrowOffset = 0.0f;
static const CGFloat kStrokeWidth = 1.0f;
static const CGFloat kArrowSize = 8.0f;
static const CGFloat kFontSize = 12.0f;
static const CGFloat kMaxWidth = 196.0f;
static const CGFloat kMaxHeight = CGFLOAT_MAX;
static const CGFloat kPaddingWidth = 12.0f;
static const CGFloat kPaddingHeight = 10.0f;

@implementation mgMessageView
{
    UITextView *_tvMessage;
    UIImageView *_imgBGV;
    int _nFlag;
}

- (id)initWithFrame:(CGRect)frame flag:(int)nFlag{
    self = [super initWithFrame:frame];
    if (self) {
        _nFlag = nFlag;
        
        if (_imgBGV == nil) {
            _imgBGV = [[UIImageView alloc]initWithFrame:frame];
            [self addSubview:_imgBGV];
            
            if (_nFlag == _flg_SEND) {
                [_imgBGV setImage:[[UIImage imageNamed:@"bg_talk01"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            }else{
                [_imgBGV setImage:[[UIImage imageNamed:@"bg_talk02"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            }
        }
        
//        self.layer.shadowOffset = CGSizeMake(2, 2);
//        self.layer.shadowRadius = 1.0;
//        self.layer.shadowOpacity = 0.3;
//        self.layer.shadowColor = [UIColor grayColor].CGColor;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    if (_nFlag == _flg_SEND) {
//        [self drawSendBaloon:context];
//    }else{
//        [self drawReceiveBaloon:context];
//    }
//}
//
//- (void)drawGradientRectangle:(CGContextRef)context rect:(CGRect)rect{
//    // 그라디언트
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//        29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
//        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
//    };
//    CGGradientRef _gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
//    
//    CGPoint start = rect.origin;
//    CGPoint end = CGPointMake(rect.size.width, rect.size.height);
//    CGContextDrawLinearGradient(context, _gradient, start, end, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
//}
//
//- (void)drawReceiveBaloon:(CGContextRef)context{
//    // 말풍선
//    CGRect rect = self.bounds;
//    rect.origin.x += (kStrokeWidth/2.0f);
//    rect.origin.y += kStrokeWidth + kArrowSize;
//    rect.size.width -= kStrokeWidth;
//    rect.size.height -= kStrokeWidth*1.5f + kArrowSize;
//    
//    CGFloat radius = 6.0f;
//    CGFloat x_left = rect.origin.x;
//    CGFloat x_right = x_left + rect.size.width;
//    CGFloat y_top = rect.origin.y;
//    CGFloat y_bottom = y_top + rect.size.height;
//    
//    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, kStrokeWidth);
//    CGContextSetRGBStrokeColor(context, 110.0f/255.0f, 171.0f/255.0f, 204.0f/255.0f, 1.0f); // green
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    
//    CGContextMoveToPoint(context, x_right-kArrowSize-kArrowOffset, y_top+radius);
//    CGContextAddLineToPoint(context, x_right-kArrowOffset, y_top+kArrowSize+radius);
//    CGContextAddLineToPoint(context, x_right-kArrowSize-kArrowOffset, y_top+kArrowSize+radius);
//    
//    static const CGFloat F_PI = (CGFloat)M_PI;
//    CGContextAddArc(context, x_right-radius-kArrowSize, y_bottom-radius-kArrowSize, radius, 0.0f, F_PI/2.0f, 0);
//    CGContextAddArc(context, x_left+radius, y_bottom-radius-kArrowSize, radius, F_PI/2.0f, F_PI, 0);
//    CGContextAddArc(context, x_left+radius, y_top+kStrokeWidth, radius, F_PI, 3.0f*F_PI/2.0f, 0);
//    CGContextAddArc(context, x_right-radius-kArrowSize, y_top+kStrokeWidth, radius, 3.0f*F_PI/2.0f, 0.0f, 0);
//
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);
//}
//
//- (void)drawSendBaloon:(CGContextRef)context{
//    CGRect rect = self.bounds;
//    rect.origin.x += (kStrokeWidth/2.0f);
//    rect.origin.y += kStrokeWidth + kArrowSize;
//    rect.size.width -= kStrokeWidth;
//    rect.size.height -= kStrokeWidth*1.5f + kArrowSize;
//    
//    CGFloat radius = 6.0f;
//    CGFloat x_left = rect.origin.x;
//    CGFloat x_right = x_left + rect.size.width;
//    CGFloat y_top = rect.origin.y;
//    CGFloat y_bottom = y_top + rect.size.height;
//    
//    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, kStrokeWidth);
//    CGContextSetRGBStrokeColor(context, 232.0f/255.0f, 204.0f/255.0f, 111.0f/255.0f, 1.0f); // green
//    CGContextSetFillColorWithColor(context, [[UIColor alloc]initWithRed:255.0f/255.0f green:248.0f/255.0f blue:186.0f/255.0f alpha:1.0f].CGColor );
//    
//    // Draw triangle.
//    CGContextMoveToPoint(context, x_left+kArrowSize, y_top+kArrowOffset+kArrowSize+kArrowSize);
//    CGContextAddLineToPoint(context, x_left, y_top+kArrowOffset+kArrowSize+kArrowSize);
//    CGContextAddLineToPoint(context, x_left+kArrowSize, y_top+kArrowOffset+kArrowSize);
//    
//    static const CGFloat F_PI = (CGFloat)M_PI;
//    CGContextAddArc(context, x_left+radius+kArrowSize, y_top+kStrokeWidth, radius, F_PI, 3.0f*F_PI/2.0f, 0);
//    CGContextAddArc(context, x_right-radius, y_top+kStrokeWidth, radius, 3.0f*F_PI/2.0f, 0.0f, 0);
//    CGContextAddArc(context, x_right-radius, y_bottom-radius-kArrowSize, radius, 0.0f, F_PI/2.0f, 0);
//    CGContextAddArc(context, x_left+radius+kArrowSize, y_bottom-radius-kArrowSize, radius, F_PI/2.0f, F_PI, 0);
//
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);
//
//}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if(_tvMessage != nil){
        CGRect rect = self.bounds;
        
        if (_nFlag == _flg_SEND) {
            rect.origin.x += (kStrokeWidth/2.0f)+kArrowSize;
            rect.origin.y += kStrokeWidth + kArrowSize;
            rect.size.width -= kStrokeWidth + kArrowSize + kArrowSize;
            rect.size.height -= kStrokeWidth*1.5f + kArrowSize;
        }else{
            rect.origin.x += (kStrokeWidth/2.0f);
            rect.origin.y += kStrokeWidth + kArrowSize;
            rect.size.width -= kStrokeWidth+kArrowSize;
            rect.size.height -= kStrokeWidth*1.5f + kArrowSize;
        }
        
        CGFloat x_left = rect.origin.x;
        CGFloat x_right = x_left + rect.size.width;
        CGFloat y_top = rect.origin.y;
        CGFloat y_bottom = y_top + rect.size.height;
        
        [_tvMessage setFrame:CGRectMake(x_left, y_top-kArrowSize+5, x_right, y_bottom-kArrowSize-10)];
        
        if (_imgBGV != nil) {
            if (_nFlag == _flg_SEND)
                [_imgBGV setFrame:CGRectMake(x_left-7, y_top, x_right+5, y_bottom-10)];
            else
                [_imgBGV setFrame:CGRectMake(x_left, y_top, x_right+5, y_bottom-10)];
        }
    }
}

- (void)setMessage:(NSString*)msg{
    if(_tvMessage == nil){
        CGRect rect = self.bounds;
        rect.origin.x += (kStrokeWidth/2.0f);
        rect.origin.y += kStrokeWidth + kArrowSize;
        rect.size.width -= kStrokeWidth;
        rect.size.height -= kStrokeWidth*1.5f + kArrowSize;
        
        CGFloat x_left = rect.origin.x;
        CGFloat x_right = x_left + rect.size.width;
        CGFloat y_top = rect.origin.y;
        CGFloat y_bottom = y_top + rect.size.height;
        
        _tvMessage = [[UITextView alloc]initWithFrame:CGRectMake(x_left, y_top-kArrowSize+5, x_right, y_bottom-kArrowSize-10)];
        _tvMessage.scrollEnabled = NO;
        _tvMessage.userInteractionEnabled = NO;
        _tvMessage.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        _tvMessage.backgroundColor   = [UIColor clearColor];
        
        [self addSubview:_tvMessage];
    }
    
    _tvMessage.text = msg;
}

- (CGFloat)getMessageHeight{
    return [_tvMessage contentSize].height + 10.0f;
}

- (NSString*)getMessage{
    if (_tvMessage != nil) {
        return _tvMessage.text;
    }

    return @"";
}

@end

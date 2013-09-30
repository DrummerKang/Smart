//
//  CDNPlayerWatermarkInfo.h
//  CDNPlayerSDK
//
//  Created by CDNetworks on 12. 9. 14..
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TOP_LEFT = 0,
    TOP_CENTER,
    TOP_RIGHT,
    MEDIUM_LEFT,
    MEDIUM_CENTER,
    MEDIUM_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_CENTER,
    BOTTOM_RIGHT,
    RANDOM
} WatermarkPosition;

typedef enum {
    SMALL = 0,
    MEDIUM,
    LARGE
} WatermarkTextSize;

@interface CDNPlayerWatermarkInfo : NSObject
@property (nonatomic, assign) int showTimeSec;
@property (nonatomic, assign) int hideTimeSec;

@property (nonatomic,assign) int paddingWidth;
@property (nonatomic,assign) int paddingHeight;

@property (nonatomic,assign) WatermarkPosition position;

@property (nonatomic, retain) UIImage *watermarkImage;
@property (nonatomic, retain) NSString *watermarkText;

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *textShadowColor;

@property (nonatomic,assign) WatermarkTextSize textSize;
@end

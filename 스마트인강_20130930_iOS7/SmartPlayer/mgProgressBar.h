//
//  mgProgressBar.h
//  DemoCustomSlider
//
//  Created by 메가스터디 on 13. 6. 24..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgProgressBar : UIView

- (void)setMaxValue:(float)max;
- (void)setMinValue:(float)min;
- (void)setProgress:(float)value;

@end

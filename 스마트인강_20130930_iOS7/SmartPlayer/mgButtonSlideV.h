//
//  mgButtonSlideV.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLIDE_BUTTON_WIDTH  60.0f
#define SLIDE_BUTTON_HEIGHT 42.0f

@protocol mgButtonSlideVDelegate <NSObject>

- (void)mgButtonSlideV_touchButton:(id)button tag:(int)tag;

@end

@interface mgButtonSlideV : UIScrollView{
    id <mgButtonSlideVDelegate> _dlgtSlideV;
}

@property (strong, nonatomic) id <mgButtonSlideVDelegate> _dlgtSlideV;

- (void)setButton:(NSString*)title setSelected:(bool)value;
- (void)addButton:(NSString*)title;

- (void)scrollToRight;
- (void)scrollToLeft;

@end

//
//  mgMessageView.h
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <UIKit/UIKit.h>

#define _flg_SEND 0
#define _flg_RECV 1

@interface mgMessageView : UIView

- (id)initWithFrame:(CGRect)frame flag:(int)nFlag;
- (void)setMessage:(NSString*)msg;
- (CGFloat)getMessageHeight;

- (NSString*)getMessage;

@end

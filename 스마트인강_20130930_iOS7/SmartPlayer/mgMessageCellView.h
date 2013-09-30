//
//  mgMessageCellView.h
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgMessageView.h"

@protocol mgMessageCellViewDelegate <NSObject>

- (void)mgMessageCellViewTouch:(id)mgMessageCellView;
- (void)mgMessageCellViewTouchReply:(id)mgMessageCellView;

@end

@interface mgMessageCellView : UIView{
    id <mgMessageCellViewDelegate> _dlgtMessageCellView;
}

@property (nonatomic,strong) id <mgMessageCellViewDelegate> _dlgtMessageCellView;

- (id)initWithFrame:(CGRect)frame view_flg:(NSString *)vFlg flag:(int)nFlag;

- (void)setMessageHeight:(CGFloat)height;
- (void)setMessage:(NSString*)msg;
- (void)setDateStamp:(NSString*)date;
- (void)setTIdx:(NSString*)tidx;
- (void)setSenderName:(NSString*)name;
- (void)setReceiverName:(NSString*)name;
- (void)setSendID:(NSString*)sid;
- (void)setReceiverID:(NSString*)sid;

- (void)setAvatar:(UIImage*)image;

- (NSString*)getMessage;
- (NSString*)getDateStamp;
- (int)getFlag;
- (NSString*)getTIdx;
- (NSString*)getSenderName;
- (NSString*)getReceiverName;
- (NSString*)getSendID;
- (NSString*)getReceiverID;

@end

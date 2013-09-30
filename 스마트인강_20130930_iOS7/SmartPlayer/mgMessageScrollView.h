//
//  mgMessageView.h
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgMessageCellView.h"

#define _flg_SEND 0
#define _flg_RECV 1

@protocol mgMessageScrollViewDeleagate <NSObject>

- (void)mgMessageScrollViewTouchCell:(id)mgMessageViewCell;
- (void)mgMessageScrollViewTouchCellForReply:(id)mgMessageViewCell;

@end

@interface mgMessageScrollView : UIScrollView <mgMessageCellViewDelegate>{
    id <mgMessageScrollViewDeleagate> delegate;
}

@property (strong, nonatomic) id <mgMessageScrollViewDeleagate> _dlgtMessageScrollView;

- (void)addMessage:(NSString*)message timestamp:(NSString*)timestamp tidx:(NSString*)tidx senderName:(NSString*)s_nm senderID:(NSString*)s_id receiverName:(NSString*)r_nm receiverID:(NSString*)r_id viewFlg:(NSString *)vFlg flag:(int)nFlag;
- (void)clearMessage;

@end


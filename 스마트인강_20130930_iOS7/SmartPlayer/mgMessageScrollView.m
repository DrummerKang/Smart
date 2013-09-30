//
//  mgMessageView.m
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgMessageScrollView.h"
#import "mgCommon.h"

static float _XCellPadding = 14.0f;
static float _YCellPadding = 14.0f;
static float _2CellPaddinng = 24.0f;

@implementation mgMessageScrollView
{
    NSMutableArray *_arrData;
}

@synthesize _dlgtMessageScrollView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentSize:self.frame.size];
        
        if (_arrData == nil) {
            _arrData = [[NSMutableArray alloc]init];
        }
        
        srand(time(NULL));
        
        if ([[mgCommon getDeviceModel] isEqualToString:@"iPad"]) {
            // 아이패드일때 세로모드임으로 높이가 폭으로 바뀜
            _XCellPadding = 30.0f;
            _YCellPadding = 30.0f;
        }else{
            _XCellPadding = 14.0f;
            _YCellPadding = 14.0f;
        }
  }
    return self;
}

- (void)drawRect:(CGRect)rect{
}

- (void)addMessage:(NSString*)message timestamp:(NSString*)timestamp tidx:(NSString*)tidx senderName:(NSString*)s_nm senderID:(NSString*)s_id receiverName:(NSString*)r_nm receiverID:(NSString*)r_id viewFlg:(NSString *)vFlg flag:(int)nFlag
{
    CGFloat nYOffset = [self getTotalHeight];
    
    NSString *deviceType = [mgCommon getDeviceModel];
    CGRect screenRect = [mgCommon getScreenFrame];
    
    mgMessageCellView *_cell = nil;
    
    if ([deviceType isEqualToString:@"iPad"]) {
        // 아이패드일때 세로모드임으로 높이가 폭으로 바뀜
        if (nFlag == _flg_SEND) {
            _cell = [[mgMessageCellView alloc]initWithFrame:CGRectMake(_XCellPadding, nYOffset, screenRect.size.height-110-_XCellPadding, 80) view_flg:vFlg flag:nFlag];
        }else{
            _cell = [[mgMessageCellView alloc]initWithFrame:CGRectMake(_XCellPadding + 100, nYOffset, screenRect.size.height-110-_XCellPadding, 80) view_flg:vFlg flag:nFlag];
        }
        
    }else{
        _cell = [[mgMessageCellView alloc]initWithFrame:CGRectMake(_XCellPadding, nYOffset, screenRect.size.width-10-_XCellPadding, 80) view_flg:vFlg flag:nFlag];
    }

    _cell._dlgtMessageCellView = self;
    _cell.backgroundColor = [UIColor clearColor];
    [self addSubview:_cell];
    
    // 메시지
    [_cell setMessage:message];
    
    // 타임스탬프
    NSString *newTimeStamp = nil;
    if (nFlag == _flg_RECV) {
        newTimeStamp = [[NSString alloc]initWithFormat:@"To %@, %@", s_nm, timestamp];
    }else{
        newTimeStamp = [[NSString alloc]initWithFormat:@"By %@, %@", s_nm, timestamp];
    }

    [_cell setDateStamp:newTimeStamp];
    
    // tidx
    [_cell setTIdx:tidx];
    
    [_cell setSenderName:s_nm];
    [_cell setReceiverName:r_nm];
    [_cell setSendID:s_id];
    [_cell setReceiverID:r_id];
    
    // 아바타
    int randNumber = rand() % 4;
    //NSLog(@"%d", randNumber);
    
    UIImage *image = nil;
    switch (randNumber) {
        case 0:
            image = [UIImage imageNamed:@"mytoc_thumb_tc.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"mytoc_thumb01.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"mytoc_thumb02.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"mytoc_thumb03.png"];
            break;
            
        default:
            break;
    }
    
    if([vFlg isEqualToString:@"1"] == YES){
        image = [UIImage imageNamed:@"mytoc_thumb_mega.png"];
    }
    
    [_cell setAvatar:image];
    
    // 배열체 추가
    [_arrData addObject:_cell];
    
    // 컨텐츠 영역 재계산
    [self setContentSize:CGSizeMake(self.frame.size.width, nYOffset + _cell.frame.size.height)];
}

- (CGFloat)getTotalHeight{
    CGFloat nTot = _YCellPadding;
    int nCnt = _arrData.count;
    int nIdx = 0;
    for (nIdx = 0; nCnt > nIdx; nIdx++)
    {
        mgMessageCellView *_cell = (mgMessageCellView*)[_arrData objectAtIndex:nIdx];
        
        nTot += _cell.frame.size.height + _2CellPaddinng;
    }
    
    return nTot;
}

- (void)clearMessage{
    [_arrData removeAllObjects];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark mgMessageCellView Delegate

- (void)mgMessageCellViewTouch:(id)mgMessageCellView{
    [_dlgtMessageScrollView mgMessageScrollViewTouchCell:mgMessageCellView];
}

- (void)mgMessageCellViewTouchReply:(id)mgMessageCellView{
    [_dlgtMessageScrollView mgMessageScrollViewTouchCellForReply:mgMessageCellView];
}

@end

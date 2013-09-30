//
//  mgMessageCellView.m
//  DemoMessageView
//
//  Created by 메가스터디 on 13. 5. 10..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import "mgMessageCellView.h"

static const CGFloat fAvatarWidth = 40.0f;
static const CGFloat fAvatarHeight = 42.0f;
static const CGFloat fTimeStampHeight = 10.0f;

@implementation mgMessageCellView
{
    int _nFlag;
    mgMessageView *_msgv;
    UILabel *_label;
    UIImageView *_avatar;
    NSString *_tidx;
    NSString *r_nm;
    NSString *r_id;
    NSString *s_nm;
    NSString *s_id;
    UIButton *replyBtn;
}

@synthesize _dlgtMessageCellView;

- (id)initWithFrame:(CGRect)frame view_flg:(NSString *)vFlg flag:(int)nFlag{
    self = [super initWithFrame:frame];
    if (self) {
        _nFlag = nFlag;
        
        // 말풍선
        if (_msgv == nil) {
            _msgv = [[mgMessageView alloc]initWithFrame:CGRectMake(fAvatarWidth+5.0f, fTimeStampHeight, frame.size.width-fAvatarWidth-5.0f, frame.size.height-fTimeStampHeight) flag:nFlag];
            _msgv.backgroundColor = [UIColor clearColor];
            
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMessageCell)];
            [_msgv addGestureRecognizer:tgr];
            
            [self addSubview:_msgv];
        }
        
        // 하단 메시지 받은 시각
        if (_label == nil) {
            
            if (_nFlag == _flg_SEND) {
                _label = [[UILabel alloc]initWithFrame:CGRectMake(fAvatarWidth+15.0f, 0.0f, frame.size.width-fAvatarWidth-5.0f-15.0f, fTimeStampHeight)];
                _label.textAlignment = NSTextAlignmentLeft;
            }else{
                _label = [[UILabel alloc]initWithFrame:CGRectMake(fAvatarWidth, 0.0f, frame.size.width-fAvatarWidth-5.0f-15.0f, fTimeStampHeight)];
                _label.textAlignment = NSTextAlignmentRight;
            }
            
            _label.font = [UIFont systemFontOfSize:10.0f];
            _label.textColor = [[UIColor alloc]initWithRed:16.0f/255.0f green:70.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
            _label.backgroundColor = [UIColor clearColor];
            
            [self addSubview:_label];
        }
        
        // 보낸경우
        if (_nFlag == _flg_SEND) {
            if (_avatar == nil) {
                _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, fAvatarWidth, fAvatarHeight)];
                _avatar.backgroundColor = [UIColor clearColor];
                [self addSubview:_avatar];
            }
            
            if (replyBtn == nil) {
                if([vFlg isEqualToString:@"1"] == YES){
                    
                }else{
                    replyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [replyBtn setFrame:CGRectMake(frame.size.width - 56, frame.size.height - 30, 46.0f, 16.0f)];
                    [replyBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_normal"] forState:UIControlStateNormal];
                    [replyBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_pressed"] forState:UIControlStateHighlighted];
                    //[replyBtn setTitle:@"more" forState:UIControlStateNormal];
                    [replyBtn addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
                    //replyBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
                    [self addSubview:replyBtn];
                }
            }
            
        }else{// 받는경우
            
        }
        
        // tidx
        if (_tidx == nil) {
            _tidx = [[NSString alloc]initWithFormat:@""];
        }
        
        if (r_nm == nil) {
            r_nm = [[NSString alloc]initWithFormat:@""];
        }
        
        if (r_id == nil) {
            r_id = [[NSString alloc]initWithFormat:@""];
        }
        
        if (s_nm == nil) {
            s_nm = [[NSString alloc]initWithFormat:@""];
        }
        
        if (s_id == nil) {
            s_id = [[NSString alloc]initWithFormat:@""];
        }
        
    }
    return self;
}

- (void)sendReply:(id)sender
{
    [_dlgtMessageCellView mgMessageCellViewTouchReply:self];
}

- (void)drawRect:(CGRect)rect{
}

- (void)setMessage:(NSString*)msg{
    if(_msgv != nil){
        [_msgv setMessage:msg];
        CGFloat textHeight = [_msgv getMessageHeight];
        
        [self setMessageHeight:textHeight];
    }
}

- (void)setDateStamp:(NSString*)date{
    if(_label != nil){
        _label.text = date;
    }
}

- (void)setTIdx:(NSString*)tidx{
    _tidx = tidx;
}

- (void)setMessageHeight:(CGFloat)height{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, fAvatarHeight + height)];
    
    // 레이아웃 재배치
    [_msgv setFrame:CGRectMake(fAvatarWidth+5.0f, fTimeStampHeight, self.frame.size.width-fAvatarWidth-5.0f, self.frame.size.height-fTimeStampHeight)];
    [_avatar setFrame:CGRectMake(0.0f, 0.0f, fAvatarWidth, fAvatarHeight)];
    
    if (_nFlag == _flg_SEND){
        [_label setFrame:CGRectMake(fAvatarWidth+15.0f, 0.0f, self.frame.size.width-fAvatarWidth-5.0f-15.0f, fTimeStampHeight)];
        [replyBtn setFrame:CGRectMake(self.frame.size.width - 56, self.frame.size.height - 30, 46.0f, 16.0f)];
    }else{
        
        [_label setFrame:CGRectMake(fAvatarWidth, 0.0f, self.frame.size.width-fAvatarWidth-5.0f-15.0f, fTimeStampHeight)];
    }
}

- (NSString*)getTIdx{
    return _tidx;
}

- (NSString*)getMessage{
    if (_msgv != nil) {
        return [_msgv getMessage];
    }
    
    return @"";
}

- (NSString*)getDateStamp{
    if (_label != nil) {
        return _label.text;
    }
    
    return @"";
}

- (int)getFlag{
    return _nFlag;
}

- (void)touchMessageCell{
    [_dlgtMessageCellView mgMessageCellViewTouch:self];
}

- (void)setSenderName:(NSString*)name{
    s_nm = name;
}

- (void)setReceiverName:(NSString*)name{
    r_nm = name;
}

- (void)setSendID:(NSString*)sid
{
    s_id = sid;
}

- (void)setReceiverID:(NSString*)sid
{
    r_id = sid;
}

- (NSString*)getSenderName{
    return s_nm;
}

- (NSString*)getReceiverName{
    return r_nm;
}

- (NSString*)getSendID
{
    return s_id;
}
- (NSString*)getReceiverID
{
    return r_id;
}

- (void)setAvatar:(UIImage*)image
{
    if (_avatar != nil) {
        [_avatar setImage:image];
    }
}

@end

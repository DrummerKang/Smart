//
//  mgTableView.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgTableView.h"

@implementation mgTableView

@synthesize _dlgt_mgTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)reloadData
{
    [_dlgt_mgTableView mgTableViewBeginReloadData];
    
    [super reloadData];
    
    [_dlgt_mgTableView mgTableViewEndReloadData];
}

@end

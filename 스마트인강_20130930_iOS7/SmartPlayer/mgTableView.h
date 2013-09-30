//
//  mgTableView.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mgTableViewDelegate <NSObject>

- (void)mgTableViewBeginReloadData;
- (void)mgTableViewEndReloadData;

@end

@interface mgTableView : UITableView
{
    id <mgTableViewDelegate> _dlgt_mgTableView;
}

@property (strong, nonatomic) id <mgTableViewDelegate> _dlgt_mgTableView;

@end

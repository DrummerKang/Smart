//
//  mgCategorySection.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "mgCategoryCell.h"

@interface mgCategorySection : NSObject

@property (strong, nonatomic) NSString *_name;
@property (strong, nonatomic) UIView *_view;

- (void)addCell:(mgCategoryCell*)cell;
- (mgCategoryCell*)getCellAtIndex:(int)index;
- (void)removeCell:(int)index;
- (int)getCount;

@end

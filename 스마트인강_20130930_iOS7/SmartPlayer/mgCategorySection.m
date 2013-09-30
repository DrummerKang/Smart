//
//  mgCategorySection.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgCategorySection.h"

@implementation mgCategorySection
{
    NSMutableArray *_arrCellList;
}

- (id)init{
    self = [super init];
    if (self) {
        if (_arrCellList == nil) {
            _arrCellList = [[NSMutableArray alloc]init];
        }
    }
    return self;
}

- (void)addCell:(mgCategoryCell*)cell{
    if (_arrCellList == nil)
        _arrCellList = [[NSMutableArray alloc]init];
    
    [_arrCellList addObject:cell];
}

- (mgCategoryCell*)getCellAtIndex:(int)index{
    return [_arrCellList objectAtIndex:index];
}

- (void)removeCell:(int)index{
    mgCategoryCell *cell = (mgCategoryCell*)[_arrCellList objectAtIndex:index];
    
    if (cell._view != nil)
        [cell._view removeFromSuperview];
    
    [_arrCellList removeObjectAtIndex:index];
}

- (int)getCount{
   return _arrCellList.count;
}

@end

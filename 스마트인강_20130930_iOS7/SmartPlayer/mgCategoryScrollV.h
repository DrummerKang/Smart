//
//  mgCategoryScrollV.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mgCategorySection.h"
#import "mgCategoryCell.h"

#define SECTION_CELL_WIDTH  100.0f
#define SECTION_CELL_HEIGHT 44.0f

#define CATEGORY_CELL_WIDTH  220.0f
#define CATEGORY_CELL_HEIGHT 44.0f

@protocol mgCategoryScrollVDelegate <NSObject>

- (void)mgCategoryScrollV_touchCell:(NSString*)category inSection:(NSString*)section;

@end

@interface mgCategoryScrollV : UIScrollView{
    id <mgCategoryScrollVDelegate> _dlgtCategoryScrollV;
}

@property (strong, nonatomic) id <mgCategoryScrollVDelegate> _dlgtCategoryScrollV;

- (void)addCategoryItem:(NSString*)name inSection:(NSString*)section;

@end

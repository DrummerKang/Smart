//
//  mgCategoryScrollV.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgCategoryScrollV.h"

@implementation mgCategoryScrollV
{
    NSMutableArray      *_marrCategory;
}

@synthesize _dlgtCategoryScrollV;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (_marrCategory == nil) {
            _marrCategory = [[NSMutableArray alloc]init];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
}

- (void)addCategoryItem:(NSString*)name inSection:(NSString*)section{
    if (_marrCategory == nil) {
        _marrCategory = [[NSMutableArray alloc]init];
    }
    
    if ([self IndexForSection:section] < 0) {
        CGFloat contentHeight = [self getContentHeight];
        
        // 섹션추가
        mgCategorySection *sec = [[mgCategorySection alloc]init];
        sec._name = section;
        UIView *_sectionView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, contentHeight, 320.0f, SECTION_CELL_HEIGHT)];
        _sectionView.backgroundColor = [UIColor grayColor];
        [self addSubview:_sectionView];
        sec._view = _sectionView;
        
        // 섹션레이블 추가
        UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f - CATEGORY_CELL_WIDTH, CATEGORY_CELL_HEIGHT)];
        sectionLabel.textAlignment = NSTextAlignmentCenter;
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.tag = 1;
        sectionLabel.text = section;
        [sec._view addSubview:sectionLabel];

        // 셀추가
        mgCategoryCell *cell = [[mgCategoryCell alloc]init];
        // 셀뷰추가
        UIView *cellview = [[UIView alloc]initWithFrame:CGRectMake(320.0f - CATEGORY_CELL_WIDTH, 0.0f, CATEGORY_CELL_WIDTH, CATEGORY_CELL_HEIGHT-1)];
        cellview.backgroundColor = [UIColor whiteColor];
        cell._view = cellview;
        [sec._view addSubview:cellview];
        
        // 셀이벤트 추가
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        [cellview addGestureRecognizer:tgr];
        
        // 임시 레이블 붙이기
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, CATEGORY_CELL_HEIGHT-1)];
        label.text = name;
        label.tag = 1;
        [cellview addSubview:label];
        
        // 셀 추가
        [sec addCell:cell];
        
        [_marrCategory addObject:sec];
        
    }else{
        int idx = [self IndexForSection:section];
        mgCategorySection *sec = [_marrCategory objectAtIndex:idx];
        
        int contentOffsetY = [self getContentHeighAtIndex:[self IndexForSection:section]];
        
        [sec._view setFrame:CGRectMake(0.0f, contentOffsetY, 320.0f , CATEGORY_CELL_HEIGHT * ([sec getCount]+1))];
        
        // 셀추가
        mgCategoryCell *cell = [[mgCategoryCell alloc]init];
        // 셀뷰추가
        UIView *cellview = [[UIView alloc]initWithFrame:CGRectMake(320.0f - CATEGORY_CELL_WIDTH, CATEGORY_CELL_HEIGHT * [sec getCount], CATEGORY_CELL_WIDTH, CATEGORY_CELL_HEIGHT-1)];
        cellview.backgroundColor = [UIColor whiteColor];
        [sec._view addSubview:cellview];
        cell._view = cellview;
        
        // 셀이벤트 추가
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        [cellview addGestureRecognizer:tgr];
        
        // 섹션레이블 위치조정
        UILabel *sectionLabel = (UILabel*)[sec._view viewWithTag:1];
        [sectionLabel setFrame:CGRectMake(0, 0, 320.0f - CATEGORY_CELL_WIDTH, CATEGORY_CELL_HEIGHT * ([sec getCount]+1))];
        
        // 임시 레이블 붙이기
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, CATEGORY_CELL_HEIGHT-1)];
        label.text = name;
        label.tag = 1;
        [cellview addSubview:label];
        
        // 셀 추가
        [sec addCell:cell];
    }
    
    // 재정렬
    [self orderHeightByIndex];
    
    // 컨텐츠사이즈 조절
    [self setContentSize:CGSizeMake(320.0f, [self getContentHeight])];
}

- (void)touchCell:(id)sender{
     UITapGestureRecognizer *tgr = (UITapGestureRecognizer*)sender;
     UILabel *lblCategory = (UILabel*)[tgr.view viewWithTag:1];
     UILabel *lblSection = (UILabel*)[[tgr.view superview]viewWithTag:1];
    
    [_dlgtCategoryScrollV mgCategoryScrollV_touchCell:lblCategory.text inSection:lblSection.text];
}

- (void)orderHeightByIndex{
    int nCnt = _marrCategory.count;
    int nIdx = 0;
    CGFloat fOffset = 0.0f;
    
    for (nIdx=0; nIdx<nCnt; nIdx++) {
        mgCategorySection *section = (mgCategorySection*)[_marrCategory objectAtIndex:nIdx];
    
        [section._view setFrame:CGRectMake(0.0f, fOffset, 320.0f, section._view.frame.size.height)];
        
        fOffset += section._view.frame.size.height;
    }
}

- (int)IndexForSection:(NSString*)section{
    int cntSection = _marrCategory.count;
    int idxSection = 0;
    
    for (idxSection=0; idxSection<cntSection; idxSection++) {
        mgCategorySection *sec = (mgCategorySection*)[_marrCategory objectAtIndex:idxSection];
        if ([sec._name isEqualToString:section] == true) {
            return idxSection;
        }
    }
    
    return -1;
}

- (CGFloat)getContentHeight{
    int nCnt = _marrCategory.count;
    int nIdx = 0;
    int nHeight = 0.0f;

    for(nIdx = 0;nIdx<nCnt;nIdx++)
    {
        mgCategorySection *section = (mgCategorySection*)[_marrCategory objectAtIndex:nIdx];
        nHeight += section._view.bounds.size.height;
    }
    
    return nHeight;
}

- (CGFloat)getContentHeighAtIndex:(int)Index{
    int nCnt = Index;
    int nIdx = 0;
    int nHeight = 0.0f;
    
    for(nIdx = 0;nIdx<nCnt;nIdx++)
    {
        mgCategorySection *section = (mgCategorySection*)[_marrCategory objectAtIndex:nIdx];
        nHeight += section._view.bounds.size.height;
    }
    
    return nHeight;
}

@end

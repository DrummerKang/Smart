//
//  mgSearchFirstView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"
#import "mgSearchSecondView_iPad.h"

@interface mgSearchFirstView_iPad : mgUIViewPadCommon{
    mgSearchSecondView_iPad *secondView;
    
    NSString *_pageType;
    NSString *_domCd;
    NSString *_qCd;
    NSString *_qOrd;
    
    NSInteger sectionCount;
    
    AppDelegate *_app;
    
    NSURLConnection *urlConnSearch;
    NSMutableData *searchData;
    
    NSDictionary *searchDic;
    NSMutableArray *searchArr;
    
    NSString *_sLecClass;       // 과목
    NSString *_sLecSection;     // 과목 섹션
    NSString *_sLecCategory;    // 과목 섹션의 카테고리
    NSString *naviTitle;
    
    NSMutableDictionary *_dicData;
    NSMutableArray *_arrHeaderOrder;
}

@property (strong, nonatomic) IBOutlet UITableView *firstTable;

@property (strong, nonatomic) IBOutlet UIButton *_btnStepCate;
@property (strong, nonatomic) IBOutlet UIButton *_btnTecCate;

- (IBAction)lecBtn:(id)sender;
- (IBAction)teacherBtn:(id)sender;

- (void)initMethod:(NSString *)type cd:(NSString *)cd;

@end

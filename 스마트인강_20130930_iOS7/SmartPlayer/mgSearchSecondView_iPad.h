//
//  mgSearchSecondView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "AppDelegate.h"
#import "mgSearchThirdView_iPad.h"
#import "mgSearchMathView_iPad.h"

@interface mgSearchSecondView_iPad : mgUIViewPadCommon{
    NSMutableArray *_marrData;
    NSURLConnection *urlConnSearchList;
    NSMutableData *searchListData;
    
    AppDelegate *_app;
    
    NSString *_sLecClass;             // 강좌 과목
    NSString *_sLecSection;           // 강좌 과목의 섹션
    NSString *_sLecCategory;          // 강좌 섹션의 카테고리
    NSString *_sLecqCd;
    NSString *_sLecqOrd;
    NSString *_sLecPageType;
    NSString *_sLecdomCd;
    NSString *_sLecqTecCd;
    NSString *_naviTitle;
    
    mgSearchThirdView_iPad *thirdView;
    mgSearchMathView_iPad *mathView;
}

@property (strong, nonatomic) IBOutlet UITableView *secondTable;
@property (strong, nonatomic) IBOutlet UILabel *titleText;

- (void)initMethod:(NSString *)class section:(NSString *)section category:(NSString *)category qCd:(NSString *)qCd qOrd:(NSString *)qOrd type:(NSString *)type domCd:(NSString *)domCd title:(NSString *)title;

- (IBAction)backBtn:(id)sender;

@end

//
//  mgSearchCategory1VC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@interface mgSearchCategory1VC : mgUIControllerCommon <UITableViewDelegate, UITableViewDataSource>{
    NSURLConnection *urlConnSearchList;
    
    NSMutableData *searchListData;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *cate1NavigationBar;

@property (strong, nonatomic) NSString *_sLecClass;             // 강좌 과목
@property (strong, nonatomic) NSString *_sLecSection;           // 강좌 과목의 섹션
@property (strong, nonatomic) NSString *_sLecCategory;          // 강좌 섹션의 카테고리
@property (strong, nonatomic) NSString *_sLecqCd;
@property (strong, nonatomic) NSString *_sLecqOrd;
@property (strong, nonatomic) NSString *_sLecPageType;
@property (strong, nonatomic) NSString *_sLecdomCd;
@property (strong, nonatomic) NSString *_sLecqTecCd;
@property (strong, nonatomic) NSString *_naviTitle;

@property (strong, nonatomic) IBOutlet UITableView *_table;
@property (strong, nonatomic) IBOutlet UILabel *titleText;

- (IBAction)cellSelectedBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@end

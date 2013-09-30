//
//  mgSearchVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mgButtonSlideV.h"
#import "mgCategoryScrollV.h"
#import "AppDelegate.h"
#import "mgUIControllerCommon.h"
#import "ASIHTTPRequest.h"

@interface mgSearchVC : mgUIControllerCommon <mgButtonSlideVDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSURLConnection *urlConnSearch;
    
    NSMutableData *searchData;
    
    NSDictionary *searchDic;
    NSMutableArray *searchArr;
    
    AppDelegate *_app;
    
    NSString *_pageType;
    NSString *_domCd;
    NSString *_qCd;
    NSString *_qOrd;
    
    NSInteger sectionCount;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *searchNavigationBar;
@property (strong, nonatomic) IBOutlet mgButtonSlideV       *_slideV;
@property (strong, nonatomic) IBOutlet UITableView          *_table;
@property (strong, nonatomic) IBOutlet UIButton *scrollMenuToLeft;
@property (strong, nonatomic) IBOutlet UIButton *scrollMenuToRight;
@property (strong, nonatomic) IBOutlet UIButton *_btnStepCate;
@property (strong, nonatomic) IBOutlet UIButton *_btnTecCate;

- (IBAction)lecBtn:(id)sender;
- (IBAction)teacherBtn:(id)sender;

- (IBAction)scrollMenuToLeft:(id)sender;
- (IBAction)scrollMenuToRight:(id)sender;
- (IBAction)touchCell:(id)sender;

- (IBAction)menuBtn:(id)sender;

@end

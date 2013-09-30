//
//  mgSearchMathVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@interface mgSearchMathVC : mgUIControllerCommon<UITableViewDataSource, UITableViewDelegate>{
    NSURLConnection *urlConnSearchMath;
    
    NSMutableData *mathData;
    
    NSMutableArray *mathArr;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) NSString *_sLecqCd;
@property (strong, nonatomic) NSString *_sLecqOrd;
@property (strong, nonatomic) NSString *_sLecPageType;
@property (strong, nonatomic) NSString *_sLecdomCd;
@property (strong, nonatomic) NSString *_sLecTecCd;
@property (strong, nonatomic) NSString *_sLecSection;
@property (strong, nonatomic) NSString *_sLecCategory;
@property (strong, nonatomic) NSString *_naviTitle;

@property (strong, nonatomic) IBOutlet UITableView *mathTableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *mathNavigationBar;

- (IBAction)backBtn:(id)sender;

@end

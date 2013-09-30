//
//  mgSearchMathView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "AppDelegate.h"
#import "mgSearchThirdView_iPad.h"

@interface mgSearchMathView_iPad : mgUIViewPadCommon{
    NSURLConnection *urlConnSearchMath;
    NSMutableData *mathData;
    NSMutableArray *mathArr;
    
    AppDelegate *_app;
    
    NSString *_sLecqCd;
    NSString *_sLecqOrd;
    NSString *_sLecPageType;
    NSString *_sLecdomCd;
    NSString *_sLecTecCd;
    NSString *_sLecSection;
    NSString *_sLecCategory;
    NSString *_naviTitle;
    
    mgSearchThirdView_iPad *thirdView;
}

@property (strong, nonatomic) IBOutlet UITableView *mathTable;

- (void)initMethod:(NSString *)qOrd qCd:(NSString *)qCd domCd:(NSString *)domCd type:(NSString *)type tecCd:(NSString *)tecCd category:(NSString *)category section:(NSString *)section title:(NSString *)title;

- (IBAction)backAction:(id)sender;

@end

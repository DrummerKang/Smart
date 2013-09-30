//
//  mgMyLecVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "mgLoginVC.h"

@interface mgMyLecVC : mgUIControllerCommon<UITableViewDataSource, UITableViewDelegate>{
    int lecCount;
    
    // 멀티코넥션을 사용함으로 따로따로 관리함
    NSURLConnection *urlConnDo;  // lec Doing
    NSURLConnection *urlConnAL;  // AutoLogin
    NSURLConnection *urlConnLec; // Lec list
    
    NSMutableData *doingData;
    NSMutableData *loginData;
    NSMutableData *lecData;
    
    NSDictionary *myLecDic;
    NSDictionary *pauseDic;
    
    NSInteger skipNum;
    
    NSString *subject;
    NSString *teacher;
    NSString *imgPath;
    
    NSString *app_no;
    NSString *app_seq;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *myLecNavigationBar;

@property (weak, nonatomic) IBOutlet UITableView *myLecTable;

@property (strong, nonatomic) IBOutlet UIImageView *noBgImage;

- (IBAction)menuBtn:(id)sender;

@end

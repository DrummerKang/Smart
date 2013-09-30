//
//  mgDeviceVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 22..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@interface mgCfgDeviceVC : mgUIControllerCommon<UITableViewDataSource, UITableViewDelegate>{
    NSURLConnection *urlConnDeviceList;
    
    NSMutableData *deviceData;
    
    NSMutableArray *deviceArr;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *deviceNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *deviceTable;
@property (strong, nonatomic) IBOutlet UIImageView *_noBgImage;

- (IBAction)backBtn:(id)sender;

@end

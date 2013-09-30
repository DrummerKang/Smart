//
//  mgNoticeVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "ASIHTTPRequest.h"

@interface mgNoticeVC : mgUIControllerCommon <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) IBOutlet UINavigationBar *noticeNavigationBar;
- (IBAction)backBtn:(id)sender;

@end

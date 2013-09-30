//
//  mgFaqVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 10..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "mgUIControllerCommon.h"

@interface mgFaqVC : mgUIControllerCommon <UITableViewDataSource, UITableViewDelegate,  NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) IBOutlet UINavigationBar *faqNavigationBar;

- (IBAction)backBtn:(id)sender;

@end


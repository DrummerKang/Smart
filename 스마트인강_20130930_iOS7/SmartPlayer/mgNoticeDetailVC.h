//
//  mgNoticeDetailVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"

@interface mgNoticeDetailVC : mgUIControllerCommon<UIWebViewDelegate>{
    
}

@property (strong, nonatomic) NSString *gidx;
@property (strong, nonatomic) IBOutlet UIWebView *_web;
@property (strong, nonatomic) NSString *noticeTitle;

@property (strong, nonatomic) IBOutlet UINavigationBar *detailNavigationBar;

- (IBAction)backBtn:(id)sender;

@end

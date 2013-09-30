//
//  mgFaqDetailVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 10..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"

@interface mgFaqDetailVC : mgUIControllerCommon<UIWebViewDelegate>{
    
}

@property (strong, nonatomic) NSString *fidx;
@property (strong, nonatomic) IBOutlet UIWebView *_web;
@property (strong, nonatomic) NSString *faqTitle;

@property (strong, nonatomic) IBOutlet UINavigationBar *detailNavigationBar;

- (IBAction)backBtn:(id)sender;

@end

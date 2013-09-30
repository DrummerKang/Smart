//
//  mgAskLecDetailVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@interface mgAskLecDetailVC : mgUIControllerCommon<UIWebViewDelegate>{
    AppDelegate *_app;
    
    NSString *title;
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *brd_cd;
    NSString *bidx;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *detailNavigationBar;
@property (strong, nonatomic) IBOutlet UIWebView *askDetailWebView;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *bidx;

- (IBAction)backBtn:(id)sender;

@end

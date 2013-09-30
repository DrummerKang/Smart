//
//  mgAskLecVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@interface mgAskLecVC : mgUIControllerCommon<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    AppDelegate *_app;
    
    NSString *brd_cd;
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
    NSString *myFlg;
    NSString *startRowNum;
    
    NSURLConnection *urlConnMyQna;
    NSURLConnection *urlConnQnaAll;
    NSURLConnection *urlConnDel;
    
    NSMutableData *myQnaData;
    NSMutableData *qnaALL;
    NSMutableData *delData;
    
    NSDictionary *qnaDic;
    
    int askCount;
    
    NSInteger editNum;
    
    float screenHeight;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *askListNavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *bgNoImage;

@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;

@property (strong, nonatomic) IBOutlet UIImageView *_imgBack1;

@property (weak, nonatomic) IBOutlet UITableView *askLecTable;

- (IBAction)myQnaBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myQnaBtn;

- (IBAction)allQnaBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *allQnaBtn;

- (IBAction)cellSelectedBtn:(id)sender;

- (IBAction)moveCloseBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *moveCloseBtn;

- (IBAction)moveOpenBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *moveOpenBtn;

- (IBAction)lecBackBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lecBackBtn;

@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
- (IBAction)downloadBtn:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

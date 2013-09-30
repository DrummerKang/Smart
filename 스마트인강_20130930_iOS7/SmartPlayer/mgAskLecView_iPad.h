//
//  mgAskLecView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "AppDelegate.h"
#import "mgAskLecDetailView_iPad.h"

@interface mgAskLecView_iPad : mgUIViewPadCommon<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *_app;
    mgAskLecDetailView_iPad *detailView;
    
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
    NSInteger delNum;
    
    int startAllIndex;
    int totalAllIndex;
    int currAllIndex;
    int startMyIndex;
    int totalMyIndex;
   
    NSInteger expandedRowIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *askTable;
@property (strong, nonatomic) IBOutlet UIImageView *bgNoImage;

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;

@property (strong, nonatomic) IBOutlet UIButton *openBtn;
- (IBAction)openBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *lecListBtn;
- (IBAction)lecListBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
- (IBAction)downloadBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *myLecBtn;
- (IBAction)myLecAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *allBtn;
- (IBAction)allAction:(id)sender;

- (void)initMethod:(NSString *)brd no:(NSString *)no seq:(NSString *)seq cd:(NSString *)cd nm:(NSString *)nm;

@end

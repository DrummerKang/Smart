//
//  mgAskLecWriteOptVC_iPad.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUIViewPadCommon.h"
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@protocol mgAskLecWriteOptVC_iPadDelegate <NSObject>

- (void)mgAskLecOptVC_iPad_touchClose:(NSString*)title code:(NSString *)code qChrType:(NSString*)type /* 0:강좌, 1:교재 */;
- (void)mgAskLecOptVC_iPad_Hidden;

@end

@interface mgAskLecWriteOptVC_iPad : mgUIViewPadCommon<UITableViewDataSource, UITableViewDelegate>{
    id <mgAskLecWriteOptVC_iPadDelegate> dlg;
    
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    
    NSURLConnection *urlConnQnaList;
    NSMutableData *qnaData;
    NSDictionary *qnaDic;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) id <mgAskLecWriteOptVC_iPadDelegate> dlg;
@property (strong, nonatomic) IBOutlet UITableView *_table;                 // 강의제목 선택 목록

@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;

- (void)initMethod;

@end

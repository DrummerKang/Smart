//
//  mgAskLecWriteOptVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 17..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"

@protocol mgAskLecWriteOptVCDelegate <NSObject>

- (void)mgAskLecOptVC_touchClose:(NSString*)title code:(NSString *)code qChrType:(NSString*)type /* 0:강좌, 1:교재 */;

@end

@interface mgAskLecWriteOptVC : mgUIControllerCommon<UITableViewDataSource, UITableViewDelegate>{
    id <mgAskLecWriteOptVCDelegate> delegate;
    
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    
    NSURLConnection *urlConnQnaList;
    NSMutableData *qnaData;
    NSDictionary *qnaDic;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) id <mgAskLecWriteOptVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *_table;                 // 강의제목 선택 목록
@property (strong, nonatomic) IBOutlet UINavigationBar *_nbNavigation;

@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;

- (IBAction)touchLecture:(id)sender;

@end

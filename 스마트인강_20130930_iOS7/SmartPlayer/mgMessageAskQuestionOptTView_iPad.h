//
//  mgMessageAskQuestionOptTView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "mgInputTextField.h"
#import "mgUIControllerCommon.h"

@protocol mgMessageOptTViewDelegate_iPad <NSObject>

- (void)mgMessageAskQuestionOptTView_iPad_touchClose:(NSString*)sid name:(NSString*)name;

@end

@interface mgMessageAskQuestionOptTView_iPad : mgUIViewPadCommon{
    id <mgMessageOptTViewDelegate_iPad> dlg;
    
    NSString *sMode;
    
    NSURLConnection *urlConnSearch;
    NSMutableData *searchData;
    NSDictionary *searchDic;
    
    int _nCheckedIndex;         // 체크된 인덱스
    NSMutableArray *_arrData;   // 데이터 배열
    
    NSMutableArray *marrRecentIDs; // 최근 발송 아이디
    
    NSInteger sectionCount;
}

@property (strong, nonatomic) id <mgMessageOptTViewDelegate_iPad> dlg;

@property (strong, nonatomic) IBOutlet UITableView *_table;                             // 강좌제목 선택 목록

@property (strong, nonatomic) IBOutlet UIImageView *_imgBack1;
@property (strong, nonatomic) IBOutlet UIImageView *_imgBack2;

@property (strong, nonatomic) IBOutlet mgInputTextField *searchText;
@property (strong, nonatomic) IBOutlet UIButton *nameSearchBtn;
@property (strong, nonatomic) IBOutlet UIButton *idSearchBtn;

- (IBAction)nameSearchBtn:(id)sender;

- (IBAction)idSearchBtn:(id)sender;

- (IBAction)searchBtn:(id)sender;

- (void)initMethod;

@end

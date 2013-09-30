//
//  mgMessageAskQuestionLecOpt1VC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 16..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgInputTextField.h"
#import "mgUIControllerCommon.h"

@protocol mgMessageAskQuestionLecOpt1VCDelegate <NSObject>

- (void)mgMessageAskQuestionLecOpt1VC_touchClose:(NSString*)sid name:(NSString*)name;

@end

@interface mgMessageAskQuestionLecOpt1VC : mgUIControllerCommon <UITableViewDataSource, UITableViewDelegate>{
    id <mgMessageAskQuestionLecOpt1VCDelegate> delegate;
    
    NSString *sMode;
    
    NSURLConnection *urlConnSearch;
    NSMutableData *searchData;
    NSDictionary *searchDic;
}

@property (strong, nonatomic) id <mgMessageAskQuestionLecOpt1VCDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *_table;                             // 강좌제목 선택 목록
@property (strong, nonatomic) IBOutlet UINavigationBar *_nbNavigation;

@property (strong, nonatomic) IBOutlet UIImageView *_imgBack1;
@property (strong, nonatomic) IBOutlet UIImageView *_imgBack2;

- (IBAction)touchCheck:(id)sender;

@property (strong, nonatomic) IBOutlet mgInputTextField *searchText;
@property (strong, nonatomic) IBOutlet UIButton *nameSearchBtn;
@property (strong, nonatomic) IBOutlet UIButton *idSearchBtn;

- (IBAction)nameSearchBtn:(id)sender;

- (IBAction)idSearchBtn:(id)sender;

- (IBAction)searchBtn:(id)sender;

@end

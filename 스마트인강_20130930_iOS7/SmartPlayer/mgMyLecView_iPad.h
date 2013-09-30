//
//  mgMyLecView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 31..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "AppDelegate.h"
#import "HTTPNetworkManager.h"
#import "CDNMoviePlayer.h"
#import "CDNPlayerViewController.h"
#import "PlayerControlViewController_iPad.h"
#import "mgAskLecView_iPad.h"

@interface mgMyLecView_iPad : mgUIViewPadCommon<CDNMoviePlayerDelegate>{
    AppDelegate *_app;
    
    mgAskLecView_iPad *askLecView;
    
    NSString *app_no;
    NSString *app_seq;
    NSString *chr_cd;
    NSString *chr_nm;
    NSString *brd_cd;
    NSString *free_yn;
    NSString *subject;
    NSString *teacher;
    NSString *imgPath;
    
    // 멀티코넥션을 사용함으로 따로따로 관리함
    NSURLConnection *urlConnPlay;           // play
    NSURLConnection *urlConnLec;            // Lec list
    NSURLConnection *urlConnDown;           // Down
    NSURLConnection *urlConnDeviceCheck;    // 기기등록여부
    NSURLConnection *urlConnBookMarkDel;    // 북마크 삭제
    NSURLConnection *urlConnDo;             // lec Doing
    
    NSMutableData *playData;
    NSMutableData *lecData;
    NSMutableData *downData;
    NSMutableData *deviceCheckData;
    NSMutableData *bookMarkDelData;
    NSMutableData *doingData;
    
    NSDictionary *myLecDic;
    
    int lecCount;
    int AutoOffsetY;
    
    NSArray *brd_cdArr;
    NSArray *brd_tec_nmArr;
    
    NSString *moveQuality;
    NSString *lec_cd;
    NSString *finishDay;
    
    //파라미터
    NSString *paramString;
    NSString *bookmarkString;
    NSString *bookmarkData;
    NSString *bookmarkUserID;
    NSString *bookmarkPos;
    NSString *bookmarkFinish;
    NSString *offline_period;
    
    //CDN Player
    PlayerControlViewController_iPad *controlViewController;
    CDNPlayerViewController *playerController;
    CDNMoviePlayer *player;
    NSString *playerURL;
    NSURL *contentURL;
    BOOL isAirPlay;
    BOOL from;
    BOOL pressedHomeButton;
    BOOL callConnected;
    BOOL isMute;
    BOOL isVolumeChanged;
    float prevVolume ;
    BOOL _sourceLoaded;
    int startPos;
    NSInteger posCheck;
    
    //다운로드 네트워크
    HTTPNetworkManager *requestDown;
    NSString *cid;
    NSString *downURL;
    NSString *downSmi;
    NSString *downName;
    
    NSInteger timeNum;
    NSString *time1;
    NSString *time2;
    NSString *time3;
    NSString *time4;
    NSString *time5;
    NSString *time6;
    NSString *time7;
    NSString *time8;
    NSString *time9;
    NSString *time10;
    
    UILabel *stopText;
    UIButton *stopON;
    UIButton *stopOFF;
    NSDictionary *footerDic;
    
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UIView *noItemView;
@property (strong, nonatomic) IBOutlet UITableView *lecTable;

@property (strong, nonatomic) IBOutlet UILabel *lecTitle;
@property (strong, nonatomic) IBOutlet UILabel *cls_nm;
@property (strong, nonatomic) IBOutlet UILabel *chr_ogz;
@property (strong, nonatomic) IBOutlet UILabel *make_nm;
@property (strong, nonatomic) IBOutlet UILabel *progress;
@property (strong, nonatomic) IBOutlet UILabel *std_sdt;
@property (strong, nonatomic) IBOutlet UILabel *std_edt;

@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;
@property (strong, nonatomic) NSString *free_yn;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *teacher;
@property (strong, nonatomic) NSString *imgPath;

@property (strong, nonatomic) NSArray *brd_cdArr;
@property (strong, nonatomic) NSArray *brd_tec_nmArr;

- (void)initMethod:(NSString *)no seq:(NSString *)seq cd:(NSString *)cd photo:(NSString *)photo nm:(NSString *)nm yn:(NSString *)yn subject:(NSString *)sub teacher:(NSString *)tec paht:(NSString *)path footer:(NSDictionary *)fDic;
- (void)noItem;

- (void)downloadCheck;

@property (strong, nonatomic) IBOutlet UIButton *moveBtn;
- (IBAction)moveBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lecQuestionBtn;
- (IBAction)lecQuestionBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
- (IBAction)downloadBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *move2Btn;
- (IBAction)move2Btn:(id)sender;

@end

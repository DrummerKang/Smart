//
//  mgMyLecListTVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 14..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPNetworkManager.h"
#import "mgUIControllerCommon.h"
#import "AppDelegate.h"
#import "CDNMoviePlayer.h"
#import "PlayerControlViewController.h"
#import "HTTPNetworkManager.h"
#import "CDNPlayerViewController.h"
#import "mgTableView.h"

@interface mgMyLecListTVC : mgUIControllerCommon<CDNMoviePlayerDelegate, mgTableViewDelegate, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>{
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
    
    NSString *moveQuality;
    NSString *lec_cd;
    NSString *finishDay;
    
    int lecCount;
    
    AppDelegate *_app;
    
    PlayerControlViewController *controlViewController;
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
    
    HTTPNetworkManager *requestDown;
    NSString *cid;
    NSString *downURL;
    NSString *downSmi;
    NSString *downName;
    
    //파라미터
    NSString *paramString;
    NSString *bookmarkString;
    NSString *bookmarkData;
    NSString *bookmarkUserID;
    NSString *bookmarkPos;
    NSString *bookmarkFinish;
    NSString *offline_period;
    
    NSArray *brd_cdArr;
    NSArray *brd_tec_nmArr;
    
    float screenHeight;
    
    NSInteger posCheck;
    
    NSInteger timeNum;
    NSString *time1;
    NSString *time2;
    NSString *time3;
    NSString *time4;
    
    UILabel *stopText;
    UIButton *stopON;
    UIButton *stopOFF;
    
    NSUserDefaults *defaults;
    
    NSInteger sdDownNumber;
    NSInteger hdDownNumber;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *lecListNavigationBar;

@property (strong, nonatomic) NSString *brd_cd;
@property (strong, nonatomic) NSString *app_no;
@property (strong, nonatomic) NSString *app_seq;
@property (strong, nonatomic) NSString *chr_cd;
@property (strong, nonatomic) NSString *chr_nm;
@property (strong, nonatomic) NSString *free_yn;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *teacher;
@property (strong, nonatomic) NSString *imgPath;

@property (strong, nonatomic) NSString *url_tec_photo;

@property (strong, nonatomic) NSDictionary *footerDic;

@property (strong, nonatomic) IBOutlet UIImageView *teacherPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *freeLecture;

@property (strong, nonatomic) IBOutlet UIImageView *subjectImage;
@property (strong, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (strong, nonatomic) IBOutlet UILabel *lecNm;          //강좌유형
@property (strong, nonatomic) IBOutlet UILabel *lecOgz;         //강좌구성
@property (strong, nonatomic) IBOutlet UILabel *lecMake;        //제작상태
@property (strong, nonatomic) IBOutlet UILabel *lecStartDay;    //시작일
@property (strong, nonatomic) IBOutlet UILabel *lecEndDay;      //종료일
@property (strong, nonatomic) IBOutlet UILabel *lecProgress;    //나의 진도

@property (weak, nonatomic) IBOutlet mgTableView *downloadListTable;

@property (strong, nonatomic) IBOutlet UIButton *moveBtn;
@property (strong, nonatomic) IBOutlet UIButton *move2Btn;
@property (strong, nonatomic) IBOutlet UIButton *lecQuestionBtn;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

- (IBAction)moveBtn:(id)sender;
- (IBAction)move2Btn:(id)sender;

- (IBAction)downloadingBtn:(id)sender;

- (IBAction)sdDownBtn:(id)sender;

- (IBAction)hdDownBtn:(id)sender;

- (IBAction)qnaBtn:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

//
//  mgDownloadListVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDNPlayerViewController.h"
#import "CDNPlayerViewWatermark.h"
#import "PlayerControlDownViewController_iPad.h"
#import "mgUIControllerPadCommon.h"

@interface mgDownloadListVC_iPad : mgUIControllerPadCommon<UITableViewDataSource, UITableViewDelegate, CDNPlayerViewControllerDelegate, CDNMoviePlayerDelegate>{
    UIViewController *lastViewController;
    BOOL isAirPlay;
    NSURL *urlAdd;
    
    CDNPlayerViewController *playerController;
    PlayerControlDownViewController_iPad *controlViewController;
    
    NSURL *contentURL;
	
	BOOL pressedHomeButton;
    BOOL callConnected;
    
    float prevVolume ;
    BOOL isMute;
    BOOL isVolumeChanged;
    BOOL isTouched;
    short touchStatus;
    
    BOOL from;
    
    NSTimeInterval lastTimeInterval;
    int runTimeCount;
    int runRateTimeCount;
    float playbackRate;
    
    BOOL _sourceLoaded;
    
    BOOL bExitByDup;
    
    int startPos;
    NSString *csHost;
    
    int posNum;
    NSString *cId;
    
    NSString *posStr;
    
    NSInteger posCheck;
    NSMutableDictionary *posDic;
    NSIndexPath *posIndexPath;
}

@property (strong, nonatomic) IBOutlet UIView *noItemView;

@property (weak, nonatomic) IBOutlet UITableView *downloadListTable;
@property (nonatomic, retain) CDNMoviePlayer	*player;
@property (nonatomic, retain) CDNPlayerViewWatermark *watermark;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

//
//  mgDownloadListTVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDNPlayerViewController.h"
#import "CDNPlayerViewWatermark.h"
#import "PlayerControlDownViewController.h"
#import "mgUIControllerCommon.h"

#define DATAKEY_ERROR @"_error"

@interface mgDownloadListTVC : mgUIControllerCommon<UITableViewDataSource, UITableViewDelegate, CDNPlayerViewControllerDelegate, CDNMoviePlayerDelegate>{
    UIViewController *lastViewController;
    BOOL isAirPlay;
    NSURL *urlAdd;
    
    CDNPlayerViewController *playerController;
    PlayerControlDownViewController *controlViewController;
    
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

@property (strong, nonatomic) IBOutlet UINavigationBar *downNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *downloadListTable;
@property (nonatomic, retain) CDNMoviePlayer	*player;
@property (nonatomic, retain) CDNPlayerViewWatermark *watermark;
@property (strong, nonatomic) IBOutlet UIImageView *noBgImage;

- (IBAction)menuBtn:(id)sender;

@end

//
//  mgSearchCategory2VC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "mgUIControllerCommon.h"
#import "CDNMoviePlayer.h"
#import "PlayerControlDownViewController.h"
#import "CDNPlayerViewController.h"

@interface mgSearchCategory2VC : mgUIControllerCommon <UIWebViewDelegate, CDNMoviePlayerDelegate>{
    AppDelegate *_app;
    
    NSString *fURL;
    
    PlayerControlDownViewController *controlViewController;
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
}

@property (strong, nonatomic) IBOutlet UINavigationBar *cate2NavigationBar;
@property (strong, nonatomic) IBOutlet UIWebView *searchWebView;

@property (strong, nonatomic) NSString *_sLecqCd;
@property (strong, nonatomic) NSString *_sLecqOrd;
@property (strong, nonatomic) NSString *_sLecPageType;
@property (strong, nonatomic) NSString *_sLecdomCd;
@property (strong, nonatomic) NSString *_sLecqTecCd;
@property (strong, nonatomic) NSString *_naviTitle;

- (IBAction)backBtn:(id)sender;

@end

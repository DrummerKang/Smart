//
//  mgSearchThirdView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "CDNMoviePlayer.h"
#import "PlayerControlDownViewController_iPad.h"
#import "CDNPlayerViewController.h"
#import "AppDelegate.h"

@interface mgSearchThirdView_iPad : mgUIViewPadCommon<UIWebViewDelegate, CDNMoviePlayerDelegate>{
    AppDelegate *_app;
    
    NSString *fURL;
    
    PlayerControlDownViewController_iPad *controlViewController;
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

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) IBOutlet UILabel *titleText;

- (void)initMethod:(NSString *)qOrd qCd:(NSString *)qCd domCd:(NSString *)domCd type:(NSString *)type tecCd:(NSString *)tecCd title:(NSString *)title;

- (IBAction)backBtn:(id)sender;

@end

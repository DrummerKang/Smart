//
//  CDNPlayerViewController.h
//
//  Copyright 2010 CDNetworks. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CDNMoviePlayer.h"
#import "PlayerControlViewController.h"
#import "CDNPlayerViewWatermark.h"

@protocol CDNPlayerViewControllerDelegate <NSObject>

- (void) onCDNPlayerViewControllerDismissed:(BOOL)userExit;

@end

@interface CDNPlayerViewController : NSObject<CDNMoviePlayerDelegate, UIAlertViewDelegate> {
    PlayerControlViewController *controlViewController;
    
	NSURL *contentURL;
	
	BOOL pressedHomeButton;
    BOOL callConnected;
    
    float prevVolume ;
    BOOL isMute;
    BOOL isVolumeChanged;
    BOOL isTouched;
    short touchStatus;
    
    BOOL from;
    
    //2.0
    NSTimeInterval lastTimeInterval;
    int runTimeCount;
    int runRateTimeCount;
    float playbackRate;
    
    BOOL _sourceLoaded;

    BOOL bExitByDup;
}

@property (nonatomic, retain) CDNMoviePlayer	*player;
@property (nonatomic, retain) CDNPlayerViewWatermark *watermark;

@property (nonatomic, assign) int startPos;

@property (nonatomic, retain) NSString *csHost;
@property (nonatomic) BOOL pressedHomeButton;
@property (nonatomic) BOOL callConnected;

- (int) currentMoviePos;
- (int) totalTime;
- (void)playMovieWithOptions:(NSURL*)url from:(BOOL)_from;
- (void)stopMovie;
- (IBAction) mute;
- (void) onPlayerBackground;
- (void) appIsTerminated;

@end


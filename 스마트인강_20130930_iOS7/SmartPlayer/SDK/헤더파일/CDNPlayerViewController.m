//
//  CDNPlayerViewController.m
//
//  Copyright 2010 CDNetworks. All rights reserved.
//


#import "CDNPlayerViewController.h"
#import "Common.h"
#import "NSString+URL.h"
#import "UIColor+RGBColor.h"
#import "AppDelegate.h"
#import "AquaAlertView.h"
#import "AppErrorHandler.h"
#import "mgDownloadListTVC.h"

#define MUTE 6000

typedef enum {
    ALERTVIEW_ERROR_FINISH = 1,
    ALERTVIEW_PLAY_CONTINUE
} ALERTVIEW_TAG;

@interface CDNPlayerViewController()
{
    BOOL _userExit;
    BOOL _endMovie;
    BOOL _showingMsg;
}

- (void) playMovie:(NSString*)urlString;

- (void) appIsTerminated;
- (void) clearOptionValue;

@end

@implementation CDNPlayerViewController

@synthesize pressedHomeButton;
@synthesize callConnected;
@synthesize startPos;
@synthesize watermark;
@synthesize csHost;
@synthesize player;

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    if (from == YES)
        return;
    
	player = nil;
    controlViewController = nil;
    
	contentURL = nil;
    
    pressedHomeButton = NO;
    callConnected = NO;
    _userExit = NO;
    _endMovie= NO;
}

- (CDNPlayerWatermarkInfo *) needWatermarkInfo{
    [[self watermark] setWatermark];
    return watermark.info;
}

- (void) onDupCurrentSessionEnable:(BOOL)result{
    if (!result) {
        _showingMsg = YES;
        [player stop];
        [AquaAlertView showWithId:99 title:ALERT_NOTICE_TITLE message:[AppErrorHandler
         messageFromCode:ERR_DUPLICATION] data:nil delegate:self type:AquaAlertViewTypeOK];
    }
}

- (void) closePlayer{
    [player stop];
}

- (void) clearOptionValue{
	if(contentURL){
		[contentURL release];
		contentURL = nil;
	}
}

- (void)addNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinished:)
												 name:CDNMoviePlayerFinishedPlaybackNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieStateChanged:)
												 name:CDNMoviePlayerStateChangedNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieLoaded:)
												 name:CDNMoviePlayerLoadedNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(changeVolume:) 
												 name:@"AVSystemController_SystemVolumeDidChangeNotification" 
											   object:nil];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerFinishedPlaybackNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void) onPlayerBackground{
    _userExit = YES;
}

- (int) currentMoviePos{
    if (player) {
        return [player getCurrentTime];
    }
    
    return 0;
}

- (int) totalTime{
    if(player) {
        return [player getTotalTime];
    }
    
    return 0;
}

- (void)playMovieWithOptions:(NSURL*)url from:(BOOL)_from;{
    from = _from;

	// parse the query string
	[self clearOptionValue];
    
    if ([url query] != nil) {
        NSString *urlquery = [url query];
        NSString* decrypted = nil;
        
        if ([urlquery hasPrefix:@"param="]) {
            urlquery = [urlquery substringFromIndex:6];
            decrypted = [CDNMoviePlayer decryptString:urlquery];
            if (decrypted == nil) {
                [AquaAlertView showWithId:CDDR_DL_PROTOCOL_INVALID_PARAMETER title:ALERT_NOTICE_TITLE message:[AppErrorHandler messageFromCode:CDDR_DL_PROTOCOL_INVALID_PARAMETER] data:nil delegate:self type:AquaAlertViewTypeOK];
                return;
            }
        }
        
        decrypted = [CDNMoviePlayer decryptString:urlquery];
        
        if ([decrypted length] == 0){
            decrypted = [url query];
        
        }else {
            NSString *auth = decrypted;
            NSRange start = [decrypted rangeOfString:@"d_id="];
        
            if (start.location != NSNotFound) {
                NSRange end = [decrypted rangeOfString:@"&" options:1 range:NSMakeRange(start.location, decrypted.length - start.location)];
            
                if (end.location != NSNotFound) {
                    start.length = end.location - start.location +1;
                    auth = [decrypted stringByReplacingCharactersInRange:start withString:@""];
                
                }else{
                    auth = [decrypted substringToIndex:start.location];
                }
                
                [CDNMoviePlayer setAuth:auth];
            
            }else{
                [CDNMoviePlayer setAuth:decrypted];
            }
        }
        
        NSString *contentUrl = nil;
        NSMutableDictionary *watermarkContext = [NSMutableDictionary dictionary];
        NSMutableDictionary *wmText = [NSMutableDictionary dictionary];
        [watermarkContext setValue:wmText forKey:@"wm_text"];
        BOOL hasWatermark = NO;
        NSArray* query = [decrypted componentsSeparatedByString:@"&"];
        NSMutableArray *qArr = [NSMutableArray arrayWithArray:query];

        for(NSString* queryStr in qArr){
            NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            NSString* value = [keyValue objectAtIndex:1];
            
            if([key isEqualToString:@"from"]){
                from = YES;
            
            }else if([key isEqualToString:@"url"]){
                contentUrl = [value urlDecodedString];
                contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            
            }else if([key isEqualToString:@"wm_text"]){
                [wmText setValue:value forKey:@"text"];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_color"]){
                [wmText setValue:value forKey:@"color"];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_size"]){
                [wmText setValue:value forKey:@"size"];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_shade_color"]){
                [wmText setValue:value forKey:@"shade_color"];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_padding"]){
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_pos"]){
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            
            }else if([key isEqualToString:@"wm_image"]){
                [watermarkContext setValue:[value urlDecodedString] forKey:key];
                hasWatermark = YES;
            }
        }
        
        if (hasWatermark) {
            self.watermark = [CDNPlayerViewWatermark watermarkWithOptions:watermarkContext];
        }
        
        NSString *port = [[url port] intValue]>0?[NSString stringWithFormat:@":%d",[[url port] intValue]]:@"";
        NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@://%@%@",[url scheme], [url host], port];
        if ([[url path] hasPrefix:@"/cddr_dnp/webstream"]) {
            [urlString appendFormat:@"/%@?%@", contentUrl, decrypted];
        
        }else {
            [urlString appendFormat:@"%@?%@",[url path], decrypted];
            [urlString appendFormat:@"&host=%@", [[urlString pathComponents] objectAtIndex:2]];
        }
        
        NSString *conUrl = [urlString stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        //NSLog(@"%@", conUrl);
        
        [self playMovie:conUrl];
    }else {
        NSMutableString* urlString = [[NSMutableString alloc] initWithString:[url absoluteString]];
        //NSLog(@"playMovie=%@", urlString);
        [self playMovie:urlString];
        [urlString release];
    }
}

- (void) playMovie:(NSString*)urlString{
    //  set device id
    //[CDNMoviePlayer getDeviceID];
    
    callConnected = NO;
    pressedHomeButton = NO;
    
    mgDownloadListTVC *mg = [[mgDownloadListTVC alloc] init];
    
    // play
    contentURL = [[NSURL alloc] initWithString:urlString];
    //NSLog(@" contentURL url :: %@", contentURL);
    player = [[CDNMoviePlayer alloc] initWithContentURL:contentURL parentView:mg bookmarkParam:URL_KEY_BOOKMARK_POSITION];
	[player setDelegate:self];
    
    //airPlay allow or not
	[player allowsAirPlay:NO];
    
    NSString *nibName = @"PlayerControlViewController";
    
	controlViewController = [[PlayerControlViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
	[player setControlView:[controlViewController view]];
	
    UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
    [button addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    
	// set image of UI control
	[player setControlImage:[NSArray arrayWithObjects:@"player_play_normal", @"player_pause_normal", nil] forControl:CONTROL_PLAY];
	[player setControlImage:[NSArray arrayWithObjects:@"player_full_normal", @"player_downsize_normal", nil] forControl:CONTROL_SCREEN_SCALING];
	
	// set stop Image as localization setting
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"ko"])
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    else
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    
	[self addNotification];
    
	[player play];
}

#pragma mark -
#pragma mark AquaAlertViewDelegate

- (void)onCloseAlertViewId:(int)alertId buttonType:(AquaAlertViewType)type data:(NSDictionary *)data{
    switch (alertId) {
        case 99:
            [self appIsTerminated];
            break;
    }
}

- (void) onChangedPlayrate:(float)rate{
    playbackRate = rate;
}

- (void) changeVolume:(NSNotification*)aNotification{
    if (isMute == YES){
        if(isVolumeChanged== NO) //mute에 의해 볼륨이 바뀐경우는 무시.
        {
            isVolumeChanged = YES;    
            return;
        }
        
        isMute = NO;
        
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        
    }
}

- (void)stopMovie{
	if(nil != player){
		[player stop];
	}
}

-(void) seekToStartPos{
    [player setCurrentTime:startPos];
    [player play];
    startPos = 0;
}

- (void) myMovieStateChanged:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *state = [userInfo objectForKey:@"playbackState"];
    
    MPMoviePlaybackState playbackState = (MPMoviePlaybackState)[state intValue];
    
    if (startPos > 0 && playbackState == MPMoviePlaybackStatePlaying) {
        if ([player getCurrentTime] > 2) {
            startPos = 0;
        
        }else {
            if (_sourceLoaded) {
                [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
            }
        }
    }
}

- (void) myMovieLoaded:(NSNotification*)aNotification{   
    _sourceLoaded = YES;
    if (startPos > 0) {
        
        if ([player getCurrentTime] > 2) {
            startPos = 0;
        }else {
            [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
        }
    }
}

- (void) myMovieFinished:(NSNotification*)aNotification{
    _endMovie = YES;
    
	[self removeNotification];
    
	// check the reason that playback ended
	NSDictionary *notiUserInfo = [aNotification userInfo];
    NSNumber *finishReason = nil;
    NSError *finishErrorInfo = nil;
	
    if(nil != notiUserInfo){
		finishReason = [notiUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
		finishErrorInfo = [notiUserInfo objectForKey:@"error"];
		
		//NSLog(@"Movie is finished. reason=%d. errorInfo=%@ errorcode : %d", [finishReason intValue], [finishErrorInfo description], [finishErrorInfo code]);
	}
	
    if(nil != controlViewController){
        [controlViewController release];
        controlViewController = nil;
    }
    
    _userExit = NO;
    if (finishReason && [finishReason intValue] == MPMovieFinishReasonUserExited) {
        _userExit = YES;
    }
    
    if (from == YES){
        [self clearOptionValue];
        
        if(nil != player){
            [player release];
            player = nil;
        }
        return;
    }
	
    if(nil != player){
		[player release];
		player = nil;
	}
    
    if (!_showingMsg) {
        [self appIsTerminated];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
        case 0:
        {  
            if(alertView.tag == ALERTVIEW_ERROR_FINISH){
                [self appIsTerminated];
            
            }else if(alertView.tag == CDDR_DL_PROTOCOL_INVALID_PARAMETER && !from){
                [self appIsTerminated];
            
            }else if(alertView.tag == ALERTVIEW_PLAY_CONTINUE){
                //NSLog(@"replay movie after phone call");
                
                NSMutableString* urlString = [[NSMutableString alloc] initWithString:[contentURL absoluteString]];
                
                if(contentURL){
                    [contentURL release];
                    contentURL = nil;
                }
                
                [self playMovie:urlString];
                
                [urlString release];
            }
        }
            break;
            
        case 1:
        {
            if(alertView.tag == ALERTVIEW_PLAY_CONTINUE){
                [self appIsTerminated];
            }
        }
            
        default:
            break;
	}
}

- (void) appIsTerminated{
    [self clearOptionValue];
	
	//NSLog(@"app is terminated");
    
    exit(EXIT_SUCCESS);
}

- (IBAction) mute{
    if (isMute == NO){
        prevVolume =  [[MPMusicPlayerController applicationMusicPlayer] volume];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_mute_normal" ofType:@"png"]] forState:UIControlStateNormal];
        isMute = YES;
        isVolumeChanged= NO;
    
    }else{
        isMute = NO;
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
    }
}

- (void)dealloc {
    if(nil != controlViewController){
        [controlViewController release];
        controlViewController = nil;
    }
    
	if(nil != player){
		[player release];
		player = nil;
	}
	
	[self clearOptionValue];
	
    [super dealloc];
}

@end

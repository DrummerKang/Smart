//
//  mgSearchCategory2VC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchCategory2VC.h"
#import "mgGlobal.h"
#import "AquaAlertView.h"
#import "AppErrorHandler.h"
#import "AquaContentHandler.h"
#import "NSString+URL.h"

#define MUTE 6000

@interface mgSearchCategory2VC ()

@end

@implementation mgSearchCategory2VC

@synthesize cate2NavigationBar;
@synthesize _sLecPageType;
@synthesize _sLecqOrd;
@synthesize _sLecqCd;
@synthesize _sLecdomCd;
@synthesize _sLecqTecCd;
@synthesize searchWebView;
@synthesize _naviTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [cate2NavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    cate2NavigationBar.translucent = NO;
    [cate2NavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString * url = nil;
    
    //학습주제별
    if([_sLecPageType isEqualToString:@"1"] == YES){
        url = [NSString stringWithFormat:@"%@%@?acc_key=%@&domCd=%@&pageType=%@&qCd=%@&qOrd=%@&os=ios", URL_DOMAIN, URL_SEARCH_CHR_LIST, [_app._account getAcc_key], _sLecdomCd, _sLecPageType, _sLecqCd, _sLecqOrd];
        
    //선생님별
    }else{
        url = [NSString stringWithFormat:@"%@%@?acc_key=%@&domCd=%@&pageType=%@&qCd=%@&qOrd=%@&qTecCd=%@&os=ios", URL_DOMAIN, URL_SEARCH_TEC_LIST, [_app._account getAcc_key], _sLecdomCd, _sLecPageType, _sLecqCd, _sLecqOrd, _sLecqTecCd];
    }

    [self startLoadBar];
    [self initLoadBar];
    
    searchWebView.delegate = self;
    searchWebView.scalesPageToFit = NO;
    [searchWebView sizeToFit];
    [searchWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [searchWebView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:searchWebView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setSearchWebView:nil];
    [super viewDidUnload];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma WebView Method

// 웹뷰가 컨텐츠를 읽기 전에 실행된다.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    fURL = [NSString stringWithFormat:@"%@", request.URL];
    
    webView.scalesPageToFit= YES;
    //클릭할 때 마다 실행된다.
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"User tapped a link.");
        fURL = [NSString stringWithFormat:@"%@", request.URL];
        NSLog(@"%@", fURL);
        
    } else if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"User submitted a form.");
    } else if (navigationType == UIWebViewNavigationTypeBackForward) {
        NSLog(@"User tapped the back or forward button.");
    } else if (navigationType == UIWebViewNavigationTypeReload) {
        NSLog(@"User tapped the reload button.");
    } else if (navigationType == UIWebViewNavigationTypeFormResubmitted) {
        NSLog(@"User resubmitted a form.");
    } else if (navigationType == UIWebViewNavigationTypeOther){
        NSLog(@"Some other action accurred.");
        fURL = [NSString stringWithFormat:@"%@", request.URL];
        NSLog(@"%@", fURL);
        
        if([fURL hasPrefix:@"http://"]){

        }else if([fURL hasPrefix:@"toapp:alert"]){
            [self showAlert:@"나의 찜목록에 리스트업 되었습니다. \n찜목록은 메가스터디 홈페이지에서 \n확인 가능합니다." tag:TAG_MSG_NONE];
            
        }else{
             NSArray *pathArray = [fURL componentsSeparatedByString:@"cnmpx://"];
             NSString *movieURL = [pathArray objectAtIndex:1];
             
             if([movieURL isEqualToString:@""] == YES){
                 return YES;
             
             }else{
                 isAirPlay = NO;
                 NSString *content = [NSString stringWithFormat:@"%@%d/%@", STREAMING_URL, [CDNMoviePlayer getPort], movieURL];
             
                 [self executePlayer:[NSURL URLWithString:content] pos:0];
             }
        }
    }
    return YES;
}

// 웹뷰가 컨텐츠를 읽기 시작한 후에 실행된다.
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self initLoadBar];
    [self startLoadBar];
}

// 웹뷰가 컨텐츠를 모두 읽은 후에 실행된다.
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoadBar];
}

// 컨텐츠를 읽는 도중 오류가 발생할 경우 실행된다.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self endLoadBar];
}

- (void) executePlayer:(NSURL *)url pos:(int)pos{
    contentURL = url;
    
    startPos = pos;
    //NSLog(@"%d", startPos);
    
    [self playMovieWithOptions:contentURL from:!isAirPlay];
}

- (void) clearOptionValue{
	if(contentURL)
	{
		contentURL = nil;
	}
}

- (void)playMovieWithOptions:(NSURL*)url from:(BOOL)_from;{
    from = _from;
    
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
        if ([decrypted length] == 0)
        {
            decrypted = [url query];
        }
        else {
            NSString *auth = decrypted;
            NSRange start = [decrypted rangeOfString:@"d_id="];
            if (start.location != NSNotFound) {
                NSRange end = [decrypted rangeOfString:@"&" options:1 range:NSMakeRange(start.location, decrypted.length - start.location)];
                if (end.location != NSNotFound) {
                    start.length = end.location - start.location +1;
                    auth = [decrypted stringByReplacingCharactersInRange:start withString:@""];
                }
                else
                {
                    auth = [decrypted substringToIndex:start.location];
                }
                [CDNMoviePlayer setAuth:auth];
            }
            else
            {
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
        
        for(NSString* queryStr in qArr)
        {
            NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            NSString* value = [keyValue objectAtIndex:1];
            
            if([key isEqualToString:@"from"])
            {
                from = YES;
            }
            else if([key isEqualToString:@"url"])
            {
                contentUrl = [value urlDecodedString];
                contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            }
            else if([key isEqualToString:@"wm_text"])
            {
                [wmText setValue:value forKey:@"text"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_color"])
            {
                [wmText setValue:value forKey:@"color"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_size"])
            {
                [wmText setValue:value forKey:@"size"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_shade_color"])
            {
                [wmText setValue:value forKey:@"shade_color"];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_padding"])
            {
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_pos"])
            {
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
            }
            else if([key isEqualToString:@"wm_image"])
            {
            }
        }
        
        NSString *port = [[url port] intValue]>0?[NSString stringWithFormat:@":%d",[[url port] intValue]]:@"";
        NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@://%@%@",[url scheme], [url host], port];
        if ([[url path] hasPrefix:@"/cddr_dnp/webstream"]) {
            [urlString appendFormat:@"/%@?%@", contentUrl, decrypted];
        }
        else {
            [urlString appendFormat:@"%@?%@",[url path], decrypted];
            [urlString appendFormat:@"&host=%@", [[urlString pathComponents] objectAtIndex:2]];
        }
        
        NSString *conUrl = [urlString stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        //NSLog(@"%@", conUrl);
        
        [self playMovie:conUrl];
        
    } else {
        NSMutableString* urlString = [[NSMutableString alloc] initWithString:[url absoluteString]];
        //NSLog(@"playMovie=%@", urlString);
        [self playMovie:urlString];
    }
}

//무비 플레이
- (void) playMovie:(NSString*)urlString{
    if (!playerController) {
        [CDNMoviePlayer terminate];
        if (![CDNMoviePlayer initialize:[AquaContentHandler basePath]]) {
        }
    }
    
//    [CDNMoviePlayer getDeviceID];
    
    callConnected = NO;
    pressedHomeButton = NO;
    
    contentURL = [[NSURL alloc] initWithString:urlString];
    //NSLog(@" contentURL url :: %@", contentURL);
    player = [[CDNMoviePlayer alloc] initWithContentURL:contentURL parentView:self bookmarkParam:0];
	[player setDelegate:self];
    
	[player allowsAirPlay:NO];
    
    NSString *nibName = @"PlayerControlDownViewController";
    
	controlViewController = [[PlayerControlDownViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
	[player setControlView:[controlViewController view]];
	
    UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
    [button addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    
	[player setControlImage:[NSArray arrayWithObjects:@"player_play_normal", @"player_pause_normal", nil] forControl:CONTROL_PLAY];
	[player setControlImage:[NSArray arrayWithObjects:@"player_full_normal", @"player_downsize_normal", nil] forControl:CONTROL_SCREEN_SCALING];
	
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"ko"])
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    else
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    [self addNotification];
    
	[player play];
}

//노티 추카
- (void)addNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinished:)
												 name:CDNMoviePlayerFinishedPlaybackNotification
											   object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(myMovieStateChanged:)
     name:CDNMoviePlayerStateChangedNotification
     object:nil];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieLoaded:)
												 name:CDNMoviePlayerLoadedNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(changeVolume:)
												 name:@"AVSystemController_SystemVolumeDidChangeNotification"
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatStart:)
                                                 name: CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatEnd:)
                                                 name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseSectionRepeat:) name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
}

- (void)myMovieFinished:(NSNotification *)noti {
    [self endLoadBar];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerFinishedPlaybackNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
    
    NSDictionary *notiUserInfo = [noti userInfo];
    
    if(nil != notiUserInfo){
        NSNumber *reason = [notiUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        NSError *errorInfo = [notiUserInfo objectForKey:@"error"];
        NSLog(@"Movie is finished. reason=%d. errorInfo=%@", [reason intValue], [errorInfo description]);
        
        if([reason intValue] == MPMovieFinishReasonPlaybackError) {
            NSString *msgStr = [NSString stringWithFormat:@"일시적인 오류입니다. \n 잠시 후 이용해주세요.(%d)", [reason intValue]];
            UIAlertView *notice = [ [UIAlertView alloc] initWithTitle:@"Error" message:msgStr delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [notice show];
        }
    }
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

- (void) changeVolume:(NSNotification*)aNotification{
    if (isMute == YES){
        //mute에 의해 볼륨이 바뀐경우는 무시.
        if(isVolumeChanged== NO){
            isVolumeChanged = YES;
            return;
        }
        
        isMute = NO;
        
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        
    }
}

- (IBAction) mute{
    if (isMute == NO){
        prevVolume =  [[MPMusicPlayerController applicationMusicPlayer] volume];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_mute_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_mute_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        isMute = YES;
        isVolumeChanged= NO;
        
    }else{
        isMute = NO;
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
    }
}

- (void) releaseSectionRepeat:(NSNotification*)aNotification {
    [controlViewController.description setText:@"구간반복을 해제합니다."];
}

- (void) setSectionRepeatStart:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *startTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatStartTimeUserInfoKey];
    
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate initWithTimeIntervalSinceReferenceDate:[startTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [timeF setDateFormat:@"HH:mm:ss"];
    
    NSString *timerStr = [timeF stringFromDate:currentDate];
    [controlViewController.description setText:[NSString stringWithFormat:@"구간반복 %@ ~", timerStr]];
}

- (void) setSectionRepeatEnd:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *endTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatEndTimeUserInfoKey];
    // display a message to label
    NSDate *playbackTime = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[endTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; [timeF setDateFormat:@"HH:mm:ss"];
    NSString *playbackTimeStr = [timeF stringFromDate:playbackTime];
    NSString *text = controlViewController.description.text;
    [controlViewController.description setText:[NSString stringWithFormat:@"%@ %@", text, playbackTimeStr]];
}

#pragma mark -
#pragma 회전 관련

- (BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end

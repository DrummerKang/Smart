//
//  CDNMoviePlayer.h
//
//  Copyright 2010 CDNetworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaPlayback.h>
#import <UIKit/UIKit.h>
#import "CDNPlayerWatermarkInfo.h"
#import "CDNDownloadContext.h"
#import "CDNContentInfo.h"
#import "CDNDownloadHeader.h"
#import "CDNWebPlayContentInfo.h"

// UI control tag
typedef enum {
	CONTROL_PLAY = 1,					// (img : 0-play, 1-pause)
	CONTROL_STOP,
	CONTROL_PLAYBACK_PROGRESS,			// UIProgressView, UISlider
	CONTROL_PLAYBACK_TIME,				// UILable
	CONTROL_REMAINING_PLAYBACK_TIME,	// UILable
	CONTROL_SEEKING_BACKWARD,
	CONTROL_SEEKING_FORWARD,
	CONTROL_SECTION_REPEAT,				// UIButton (img : 0-init, 1-begin, 2-repeat)
	CONTROL_BOOKMARK,
	CONTROL_SCREEN_SCALING,				// (img : 0-fill, 1-fit)
	CONTROL_INFO,
	CONTROL_RATE,						// UISlider, UIButton, UILable
    CONTROL_MULTI_BOOKMARK,             // add bookmark for multi bookmark support
    CONTROL_BOOKMARK_LIST               // show added bookmark list
} UI_CONTROL_TAG;



extern NSString * const CDNMoviePlayerFinishedPlaybackNotification;
extern NSString * const CDNMoviePlayerStateChangedNotification;
extern NSString * const CDNMoviePlayerLoadedNotification;

extern NSString * const CDNMoviePlayerSetSectionRepeatStartNotification;
extern NSString * const CDNMoviePlayerSetSectionRepeatEndNotification;
extern NSString * const CDNMoviePlayerReleaseSectionRepeatNotification;

extern NSString * const CDNMoviePlayerSectionRepeatStartTimeUserInfoKey;
extern NSString * const CDNMoviePlayerSectionRepeatEndTimeUserInfoKey;

//extern NSString * const CDNMoviePlayerMultiBookmarkNotification;
//extern NSString * const CDNMoviePlayerBookmarkListNotification;
// -----------------------------------------------------------------------------




@protocol CDNMoviePlayerDelegate;

@interface CDNMoviePlayer : NSObject {
@private
    id _internal; 
}

@property(nonatomic,assign) id<CDNMoviePlayerDelegate> delegate;

- (id) initWithContentURL:(NSURL*)contentURL parentView:(UIViewController*)parent;
- (id) initWithContentURL:(NSURL*)contentURL parentView:(UIViewController*)parent bookmarkParam:(NSString*)bookmarkParam;

// for UI
- (void) setControlView:(UIView*)view;
- (BOOL) setControlImage:(NSArray*)images forControl:(UI_CONTROL_TAG)tag;

- (void) play;
- (void) stop;
- (void) pause;
- (void) restart;
- (void) resetSectionRepeatInfo;

- (void) setCurrentTime:(NSTimeInterval)time;
- (NSTimeInterval) getCurrentTime;
- (NSTimeInterval) getTotalTime;    //total play time
- (NSTimeInterval) getTMTime;
- (NSTimeInterval) getPTTime;

- (float) getPlaybackRate;
+ (NSString*) getDeviceID;          // get device unique id
+ (NSString*) getOldDeviceID;       // 
//airPlay setting
- (void) allowsAirPlay:(BOOL) allow;

//api
+(BOOL) initialize:(NSString *)basePath;
+(BOOL) initialize_key_exchange:(NSString*)basePath newDeviceID:(NSString*)newDeviceID;
+(int)file_header_change:(NSString *)contentPath newDeviceID:(NSString *)newDeviceID;
+(NSArray *) getCustomerInfoList;
+(int) errCode;
+(void) terminate;
+(NSDictionary *)downloadContextWithParam:(NSString *)param;
+(CDNWebPlayContentInfo *)getWebContentInfo:(NSString *)param;
+(int) getPort;
+(CDNContentInfo *)getContentInfo:(NSString *)contentPath;
-(BOOL)sendDownloadNotify:(NSString *)customerId;
+(NSString *)decryptString:(NSString *)value;
+(NSString *)encryptString:(NSString *)value;
+(BOOL)registerDevice:(NSString *)param;
+(NSArray *)decryptDownloadContext:(NSString *)context;
+(CDNDownloadHeader *)getContentHeaderDownloadContext:(CDNDownloadContext *)downContext url:(NSString *)url cid:(NSString *)cid contentPath:(NSString *)contentPath;
+(CDNSession *)getDownloadTid:(CDNSession *)sessionDic;
+(BOOL)endDownload:(NSString *)contentPath session:(CDNSession *)sessionDic;
+(BOOL)deleteSessionInfo:(NSString *)contentPath session:(CDNSession *)sessionDic;
+(CDNDownloadHeader *)checkContinueDownloadContent:(NSString *)contentPath;
+(BOOL)isRightContentPlay:(NSString *)contentPath custId:(NSString *)custId userId:(NSString *)userId cid:(NSString *)cid network:(BOOL)networkEnable;
+(BOOL)updateContent:(NSString *)contentPath;
+(BOOL)deleteContent:(NSString *)contentPath;

+(void) setAuth:(NSString *)param;

+(NSString *)encryptBlowfish:(NSString *)value;
+(NSString *)decryptBlowfish:(NSString *)value;
+(int)getHashValue:(NSString *)value;
@end

@protocol CDNMoviePlayerDelegate <NSObject>

@optional
- (BOOL) doBookmark;
//- (BOOL) doMultiBookmark;
//- (BOOL) doBookmarkList;
- (void) onChangedPlayrate:(float)rate;
- (void) onDupCurrentSessionEnable:(BOOL)result;
- (CDNPlayerWatermarkInfo *) needWatermarkInfo;       //watermark delegate
@end

// -----------------------------------------------------------------------------

NSString* getCDNPlayerSDKVersion();
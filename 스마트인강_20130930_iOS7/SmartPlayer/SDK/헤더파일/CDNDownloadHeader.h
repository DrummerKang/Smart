//
//  DownloadHeader.h
//  CDNPlayerSDK
//
//  Created by CDNetworks on 12. 9. 15..
//

#import <UIKit/UIKit.h>
#import "CDNSession.h"

@interface CDNDownloadHeader : NSObject
@property (nonatomic, assign) unsigned long long contentSize;
@property (nonatomic, retain) NSString *drmHeader;
@property (nonatomic, assign) int drmHeaderLength;
@property (nonatomic, retain) CDNSession *session;
@end

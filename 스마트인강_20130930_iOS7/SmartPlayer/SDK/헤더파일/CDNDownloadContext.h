//
//  DownloadContext.h
//  CDNPlayerSDK
//
//  Created by CDNetworks on 12. 9. 15..
//

#import <UIKit/UIKit.h>

@interface CDNDownloadContext : NSObject
@property (nonatomic, retain) NSString *customerId;
@property (nonatomic, retain) NSString *downloadListUrl;
@property (nonatomic, retain) NSString *userId;
@end

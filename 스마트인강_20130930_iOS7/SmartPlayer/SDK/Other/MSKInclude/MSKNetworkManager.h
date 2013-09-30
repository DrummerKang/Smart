//
//  MSKNetworkManager.h
//  MSK_Include
//
//  Created by CDNetworks on 12. 3. 28..
//

#import <Foundation/Foundation.h>
#import "TTURLDataResponse.h"
#import "TTURLRequestQueue.h"
#import "TTURLRequest.h"
#import "TTURLRequestDelegate.h"

@protocol MSKNetworkManagerDelegate <NSObject>
- (void)requestDidFinishLoad:(id)result apiName:(NSString *)apiName;
@optional
- (void)requestDidFailLoadWithError:(NSError*)error apiName:(NSString *)apiName;
@end

@interface MSKNetworkManager : NSObject
{
    NSMutableDictionary *delegateDictionary;    
    NSMutableDictionary *requestDictionary;
    NSMutableDictionary *apiDictionary;
    int req;
}

@property (nonatomic, retain) NSString *apiDomain;

+ (id)sharedManager;
//-(NSDictionary *) syncCall:(NSString *)apiName param:(NSDictionary *)param method:(NSString *)method;
//-(NSDictionary *) syncCall:(NSString *)apiName param:(NSDictionary *)param;
//-(NSString *) stringWithUrl:(NSURL *)url;
-(void) postUrl:(NSString *)url data:(NSData *)data delegate:(id)delegate;
-(void) getUrl:(NSString *)url delegate:(id) delegate;
-(void) url:(NSString *)url param:(NSDictionary *)param delegate:(id) delegate;
-(void) call:(NSString *)apiName param:(NSDictionary *)param delegate:(id) delegate;
@end

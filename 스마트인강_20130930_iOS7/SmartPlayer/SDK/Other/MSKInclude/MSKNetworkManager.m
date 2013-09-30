//
//  MSKNetworkManager.m
//  MSK_Include
//
//  Created by CDNetworks on 12. 3. 28..
//

#import "MSKNetworkManager.h"
#import "Constants.h"
#import "NSString+URL.h"

static id sharedManager = nil;

@implementation MSKNetworkManager
@synthesize apiDomain;

+ (id)sharedManager {
	@synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [[self alloc] init];
		}
	}
	return sharedManager;
}

- (id)init{
    self = [super init];
    if (self) {
        delegateDictionary = [[NSMutableDictionary alloc] init];
        requestDictionary = [[NSMutableDictionary alloc] init];
        apiDictionary = [[NSMutableDictionary alloc] init];
        req = 0;
    }
    
    return self;
}

- (void)dealloc {
    [apiDomain release];
    self.apiDomain = nil;
    [super dealloc];
}

- (void)requestUrl:(NSString *)url{
    //NSLog(@"requestUrl : %@", url);
    
    //TTURLRequest* request = [TTURLRequest requestWithURL:url  delegate:self];
    TTURLRequest* request = [TTURLRequest requestWithURL:[url urlEncodedString]  delegate:self];
    
    request.tag = req;
    //    request.contentType = @"application/json; charset=utf-8";
	request.cachePolicy =  TTURLRequestCachePolicyNoCache;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
    NSNumber *tagNum = [NSNumber numberWithInt:request.tag];
    [requestDictionary setObject:request forKey:tagNum];
    [apiDictionary setObject:url forKey:tagNum];
	[request send];
    
    req++;
}

- (void)requestPostUrl:(NSString *)url data:(NSData *)postData{
    TTURLRequest* request = [TTURLRequest requestWithURL:url  delegate:self];
    request.tag = req;
    request.httpMethod = @"POST";
    //    request.contentType = @"application/json; charset=utf-8";
	request.cachePolicy =  TTURLRequestCachePolicyNoCache;
    request.httpBody = postData;
    request.contentType=@"application/x-www-form-urlencoded";
    
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
    NSNumber *tagNum = [NSNumber numberWithInt:request.tag];
    [requestDictionary setObject:request forKey:tagNum];
    [apiDictionary setObject:url forKey:tagNum];
	[request send];
    
    req++;
}

- (NSMutableString *)stringWithUrl:(NSString *)url params:(NSDictionary *)param{
    NSMutableString *fullURL  = [[NSMutableString stringWithString:url] autorelease];
    
    if (param && param.count > 0){
        [fullURL appendString:@"?"];
        
        for (id key in [param keyEnumerator]) {
            NSString* value = [param valueForKey:key];
            [fullURL appendFormat:@"%@=%@&",key,value];
        }
    }
    
    if ([fullURL hasSuffix:@"&"]) {
        [fullURL deleteCharactersInRange:NSMakeRange(fullURL.length-1, 1)];
    }
    
    return fullURL;
}

- (void) getUrl:(NSString *)url delegate:(id) delegate{
    //NSLog(@"url : %@", url);
    
    if (delegate){
        [delegateDictionary setObject:delegate forKey:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    }  
    
    [self requestUrl:url];
}

- (void) postUrl:(NSString *)url data:(NSData *)data delegate:(id)delegate{
    if (delegate){
        [delegateDictionary setObject:delegate forKey:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    }
    
    [self requestPostUrl:url data:data];
}

- (void) url:(NSString *)url param:(NSDictionary *)param delegate:(id) delegate{
    
    if (delegate){
        [delegateDictionary setObject:delegate forKey:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    }  
    
    NSMutableString *fullURL = [self stringWithUrl:url params:param];
    
    [self requestUrl:fullURL];
}

- (void) call:(NSString *)apiName param:(NSDictionary *)param delegate:(id) delegate{
    if (delegate){
        [delegateDictionary setObject:delegate forKey:apiName];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    }
    
    NSMutableString *fullURL = [self stringWithUrl:[NSMutableString stringWithFormat:@"%@/%@",apiDomain,apiName] params:param];
  
    [self requestUrl:fullURL];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    //NSLog(@"#######requestDidFinishLoad");
    TTURLDataResponse* response = request.response;
	id result;
    id<MSKNetworkManagerDelegate> delegate = nil;
    NSString *apiName = [apiDictionary objectForKey:[NSNumber numberWithInt:request.tag]];
    delegate = [delegateDictionary objectForKey:apiName];
    
    result = [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease];
    
    if (result == nil) {
        result = [[[NSString alloc] initWithData:response.data encoding:-2147481280] autorelease];
    }
    
    NSNumber *tagNum = [NSNumber numberWithInt:request.tag];
    [[TTURLRequestQueue mainQueue] cancelRequest:request];
	[requestDictionary removeObjectForKey:tagNum];
    [delegateDictionary removeObjectForKey:apiName];
    [apiDictionary removeObjectForKey:tagNum];
    
    NSArray *arr = [delegateDictionary allValues];
    if (arr || [arr count] == 0){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(requestDidFinishLoad: apiName:)])
        [delegate requestDidFinishLoad:result apiName:apiName];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //NSLog(@"#######didFailLoadWithError");
    //NSLog(@"error : %@", [error localizedDescription]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    
    id<MSKNetworkManagerDelegate> delegate = nil;
    NSString *apiName = [apiDictionary objectForKey:[NSNumber numberWithInt:request.tag]];
    delegate = [delegateDictionary objectForKey:apiName];    
    
    NSNumber *tagNum = [NSNumber numberWithInt:request.tag];
    [[TTURLRequestQueue mainQueue] cancelRequest:request];
	[requestDictionary removeObjectForKey:tagNum];
    [apiDictionary removeObjectForKey:tagNum];
    
    NSArray *arr = [delegateDictionary allValues];
    if (arr || [arr count] == 0){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(requestDidFailLoadWithError: apiName:)])
        [delegate requestDidFailLoadWithError:error apiName:apiName];
}

@end

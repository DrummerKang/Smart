//
//  NSString+URL.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (url) 

- (NSString*) urlEncodedString;
- (NSString*) urlDecodedString;

@end


@interface NSMutableString (urlQueryUtil)

- (void) urlAppendingValueToQuery:(NSString*)key value:(NSString*)value;
- (BOOL) urlReplacingValueOfQuery:(NSString*)key newValue:(NSString*)value;
- (BOOL) urlDeletingValueToQuery:(NSString*)key;
- (BOOL) urlDeletingValuesToQuery:(NSArray*)keys;

@end


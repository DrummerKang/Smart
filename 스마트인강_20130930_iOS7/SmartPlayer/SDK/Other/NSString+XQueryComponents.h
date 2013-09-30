//
//  NSString.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 28..
//

#import <Foundation/Foundation.h>

@interface NSString (XQueryComponents)
- (NSString *)stringByDecodingURLFormat;
- (NSString *)stringByEncodingURLFormat;
- (NSString *)stringByDecodingURLFormat:(BOOL)noRepChar;
- (NSString *)stringByEncodingURLFormat:(BOOL)noRepChar;
- (NSMutableDictionary *)dictionaryFromQueryComponents;
@end

@interface NSURL (XQueryComponents)
- (NSMutableDictionary *)queryComponents;
@end

@interface NSDictionary (XQueryComponents)
- (NSString *)stringFromQueryComponents;
@end

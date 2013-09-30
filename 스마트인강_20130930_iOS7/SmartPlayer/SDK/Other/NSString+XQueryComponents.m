//
//  NSString.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 28..
//

#import "NSString+XQueryComponents.h"

@implementation NSString (XQueryComponents)
- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)stringByEncodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)stringByDecodingURLFormat:(BOOL)noRepChar
{
    if (noRepChar) {
        NSString *result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return result;
    }
    
    return [self stringByDecodingURLFormat];
}

- (NSString *)stringByEncodingURLFormat:(BOOL)noRepChar
{
    if (noRepChar) {
        NSString *result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return result;
    }
    
    return [self stringByEncodingURLFormat];
}

- (NSMutableDictionary *)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
//        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
//        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        
        NSRange range = [keyValuePairString rangeOfString:@"="];
        if (range.location != NSNotFound) {
            
            NSString *key = [[keyValuePairString substringToIndex:range.location] stringByDecodingURLFormat:YES];
            NSString *value = [[keyValuePairString substringFromIndex:range.location+1] stringByDecodingURLFormat:YES];
            NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
            if(!results) // First object
            {
                results = [NSMutableArray arrayWithCapacity:1];
                [queryComponents setObject:results forKey:key];
            }
            [results addObject:value];
        }
        
    }
    return queryComponents;
}
@end

@implementation NSURL (XQueryComponents)
- (NSMutableDictionary *)queryComponents
{
    return [[self query] dictionaryFromQueryComponents];
}
@end

@implementation NSDictionary (XQueryComponents)
- (NSString *)stringFromQueryComponents
{
    NSString *result = nil;
    for(NSString *key in [self allKeys])
    {
        key = [key stringByEncodingURLFormat];
        NSArray *allValues = [self objectForKey:key];
        if([allValues isKindOfClass:[NSArray class]])
            for(NSString *value in allValues)
            {
                value = [[value description] stringByEncodingURLFormat];
                if(!result)
                    result = [NSString stringWithFormat:@"%@=%@",key,value];
                else 
                    result = [result stringByAppendingFormat:@"&%@=%@",key,value];
            }
        else {
            NSString *value = [[allValues description] stringByEncodingURLFormat];
            if(!result)
                result = [NSString stringWithFormat:@"%@=%@",key,value];
            else 
                result = [result stringByAppendingFormat:@"&%@=%@",key,value];
        }
    }
    return result;
}
@end

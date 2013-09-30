//
//  NSString+URL.m
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+URL.h"


@implementation NSString (url)

- (NSString*) urlEncodedString
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) urlDecodedString
{
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSMutableString (urlQueryUtil)

- (void) urlAppendingValueToQuery:(NSString*)key value:(NSString*)value
{
	NSRange range = [self rangeOfString:@"?"];
	if(NSNotFound == range.location)
	{
		[self appendString:@"?"];
	}
	
	[self appendFormat:@"%@=%@", key, value];
}

- (BOOL) urlReplacingValueOfQuery:(NSString*)key newValue:(NSString*)value
{
    BOOL ret = NO;
    
	NSRange queryRange = [self rangeOfString:@"?"];
	if(queryRange.location == NSNotFound || queryRange.location == self.length-1)
	{
		return ret;
	}
	
	NSString* queryString = [self substringFromIndex:queryRange.location+1];
	NSArray* query = [queryString componentsSeparatedByString:@"&"];
	for(NSString* queryStr in query)
	{
		NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
		NSString* keyTemp = [keyValue objectAtIndex:0];
		NSString* valueTemp = [keyValue objectAtIndex:1];
		
		if([keyTemp isEqualToString:key])
		{
			[self replaceCharactersInRange:[self rangeOfString:[NSString stringWithFormat:@"%@=%@", key, valueTemp]] 
								withString:[NSString stringWithFormat:@"%@=%@", key, value]];
			
			ret = YES;
            break;
		}
	}
    
    return ret;
}

- (BOOL) urlDeletingValueToQuery:(NSString*)key
{
    BOOL ret = NO;
    
	NSRange queryRange = [self rangeOfString:@"?"];
	if(queryRange.location == NSNotFound || queryRange.location == self.length-1)
	{
		return ret;
	}
	
	NSString* queryString = [self substringFromIndex:queryRange.location+1];
	NSArray* query = [queryString componentsSeparatedByString:@"&"];
	for(NSString* queryStr in query)
	{
		NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
		NSString* keyTemp = [keyValue objectAtIndex:0];
		NSString* valueTemp = [keyValue objectAtIndex:1];
		
		if([keyTemp isEqualToString:key])
		{
			[self deleteCharactersInRange:[self rangeOfString:[NSString stringWithFormat:@"%@=%@", key, valueTemp]]];
			
			[self replaceOccurrencesOfString:@"&&" 
								   withString:@"&"
									  options:NSLiteralSearch
										range:NSMakeRange(0, [self length])];
			[self replaceOccurrencesOfString:@"?&" withString:@"?"
									  options:NSLiteralSearch
										range:NSMakeRange(0, [self length])];
			
			ret = YES;
            break;
		}
	}
	
	if(query.count == 1)
	{
		[self deleteCharactersInRange:[self rangeOfString:@"?"]];
	}
    
    return ret;
}

- (BOOL) urlDeletingValuesToQuery:(NSArray*)keys
{
    BOOL ret = NO;
    
	NSRange queryRange = [self rangeOfString:@"?"];
	if(queryRange.location == NSNotFound || queryRange.location == self.length-1)
	{
		return ret;
	}
	
	NSString* queryString = [self substringFromIndex:queryRange.location+1];
	NSArray* query = [queryString componentsSeparatedByString:@"&"];

	NSInteger deleteValueCount = 0;
	for(NSString* key in keys)
	{
		for(NSString* queryStr in query)
		{
			NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
			NSString* keyTemp = [keyValue objectAtIndex:0];
			NSString* valueTemp = [keyValue objectAtIndex:1];
			
			if([keyTemp isEqualToString:key])
			{
				deleteValueCount++;
				
				[self deleteCharactersInRange:[self rangeOfString:[NSString stringWithFormat:@"%@=%@", key, valueTemp]]];
				
				[self replaceOccurrencesOfString:@"&&" 
										   withString:@"&"
											  options:NSLiteralSearch
												range:NSMakeRange(0, [self length])];
				[self replaceOccurrencesOfString:@"?&" withString:@"?"
										  options:NSLiteralSearch
											range:NSMakeRange(0, [self length])];
				
                ret = YES;
                break;
			}
		}
	}
	
	if(deleteValueCount && deleteValueCount == query.count)
	{
		[self deleteCharactersInRange:[self rangeOfString:@"?"]];
	}
	
	return ret;
}

@end


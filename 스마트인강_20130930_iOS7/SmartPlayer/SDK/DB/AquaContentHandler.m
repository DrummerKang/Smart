//
//  AquaContentHandler.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 7. 6..
//

#import "AquaContentHandler.h"

#define slashChar @"_%2F_"

@implementation AquaContentHandler

+ (NSString *)basePath{
    NSString *contentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return contentPath;
}

+ (NSArray *) splitPathString:(NSString *)path{
    NSArray *arrPaths = [[path stringByReplacingOccurrencesOfString:@"\\/" withString:slashChar] componentsSeparatedByString:@"/"];
    NSMutableArray *paths = [NSMutableArray array];
    
    for (int i = 0; i < arrPaths.count; i++) {
        NSString *title = [[arrPaths objectAtIndex:i] stringByReplacingOccurrencesOfString:@"_%2F_" withString:@"/"];
        [paths addObject:title];
    }
    
    return paths;
}

@end

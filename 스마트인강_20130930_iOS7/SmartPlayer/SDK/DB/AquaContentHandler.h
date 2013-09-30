//
//  AquaContentHandler.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 7. 6..
//

#import <Foundation/Foundation.h>

@interface AquaContentHandler : NSObject

+ (NSArray *) splitPathString:(NSString *)path;
+ (NSString *)basePath;

@end

//
//  CDNPlayerViewWatermark.h
//  eduManager
//
//  Created by CDNetworks on 12. 8. 27..
//

#import <UIKit/UIKit.h>
#import "CDNPlayerWatermarkInfo.h"

#define WATERMARK_TYPE_IMG 100
#define WATERMARK_TYPE_TEXT 101

@interface CDNPlayerViewWatermark : NSObject{
    NSString *customerId;
}

@property (nonatomic, assign) CDNPlayerWatermarkInfo *info;
@property (nonatomic, assign) int watermarkType;
@property (nonatomic, readonly) NSMutableData *watermarkData;

+ (CDNPlayerViewWatermark *)watermarkForCustomerId:(NSString *)custId;
+ (void) setDBWatermarkCustomerId:(NSString *)customerId context:(NSDictionary *)context;
+ (CDNPlayerViewWatermark *)watermarkWithOptions:(NSDictionary *)option;
- (id)initWithWatermarkCustomerId:(NSString *)custId;
- (void) setOptions:(NSDictionary *)dic;
- (void) setWatermark;

@end

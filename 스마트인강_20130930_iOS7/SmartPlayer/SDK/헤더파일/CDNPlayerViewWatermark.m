//
//  CDNPlayerViewWatermark.m
//  eduManager
//
//  Created by CDNetworks on 12. 8. 27..
//

#import "CDNPlayerViewWatermark.h"

#import "NSData-AES.h"
#import "AquaDBManager.h"
#import "UIDevice-Reachability.h"
#import "JSONKit.h"
#import "UIColor+RGBColor.h"

#define key @"edumanager2.0"

@implementation CDNPlayerViewWatermark
@synthesize watermarkType;
@synthesize watermarkData;
@synthesize info;

+ (CDNPlayerViewWatermark *)watermarkForCustomerId:(NSString *)custId{
    NSDictionary *dic = [[AquaDBManager sharedManager] selectCPWithCustomerId:custId];
   
    if (dic == nil) {
        return nil;
    }
    NSString *type = [dic objectForKey:@"type"];
    CDNPlayerViewWatermark *watermark = [[[self alloc] initWithWatermarkCustomerId:custId] autorelease];
    
    if ([type isEqualToString:@"img"]) {
        watermark.watermarkType = WATERMARK_TYPE_IMG;
    
    }else if([type isEqualToString:@"text"]){
        watermark.watermarkType = WATERMARK_TYPE_TEXT;
    }
    
    NSData *data = [dic objectForKey:@"data"];
    data = [data AESDecryptWithPassphrase:key];
    [watermark.watermarkData setData:data];
    
    NSData *optData = [dic objectForKey:@"options"];
    NSData *deOptData = [optData AESDecryptWithPassphrase:key];
    NSDictionary *options = [deOptData objectFromJSONData];
    [watermark setOptions:options];
    
    return watermark;
}

+ (CDNPlayerViewWatermark *)watermarkWithOptions:(NSDictionary *)option{
    CDNPlayerViewWatermark *watermark = [[CDNPlayerViewWatermark alloc] init];
    NSDictionary *text = [option objectForKey:@"wm_text"];
    
    if (text) {
        NSString *t = [text objectForKey:@"text"];
        if (t) {
            [watermark.watermarkData setData:[t dataUsingEncoding:NSUTF8StringEncoding]];
            watermark.watermarkType = WATERMARK_TYPE_TEXT;
        }
    }
    
    NSString *img = [option objectForKey:@"wm_image"];
    if (img && watermark.watermarkType != WATERMARK_TYPE_TEXT) {
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:img] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        //    [NSURLConnection connectionWithRequest:req delegate:self];
        NSData *sourceData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
        [req release];
        [watermark.watermarkData setData:sourceData];
        watermark.watermarkType = WATERMARK_TYPE_IMG;
    }
    
    [watermark setOptions:option];
    return [watermark autorelease];
}

- (id)initWithWatermarkCustomerId:(NSString *)custId{
    self = [super init];
    if (self) {
        customerId = custId;
        [customerId retain];
        
        info.showTimeSec = 5;
        info.hideTimeSec = 5;
    }
    
    return self;
}

- (void) setOptions:(NSDictionary *)dic{
    NSDictionary *text = [dic objectForKey:@"wm_text"];
    if (info == nil) {
        info = [[CDNPlayerWatermarkInfo alloc] init];
    }
    
    if (text) {
        self.info.textColor = [UIColor hexGetColor:[text objectForKey:@"color"]];
        self.info.textShadowColor = [UIColor hexGetColor:[text objectForKey:@"shade_color"]];
        self.info.textSize = [[text objectForKey:@"size"] intValue];        
    }
    
    self.info.position = [[dic objectForKey:@"wm_pos"] intValue];
    
    NSString *padding = [dic objectForKey:@"wm_padding"];
    if (padding && padding.length > 0) {
        NSArray *arrPadding = [padding componentsSeparatedByString:@","];
        if (arrPadding.count > 1) {
            self.info.paddingWidth = [[arrPadding objectAtIndex:0] intValue];
            self.info.paddingHeight = [[arrPadding objectAtIndex:1] intValue];
        }
    }    
}

- (void) setWatermarkDataFromDatabase{
    NSDictionary *dic = [[AquaDBManager sharedManager] selectCPWithCustomerId:customerId];
    if (dic) {  
        NSData *data = [dic objectForKey:@"data"];
        data = [data AESDecryptWithPassphrase:key];
        [self.watermarkData setData:data];
    }
}

+ (void) setDBWatermarkCustomerId:(NSString *)customerId context:(NSDictionary *)context{
    NSDictionary *text = [context objectForKey:@"wm_text"];
    if (text) {
        [self setDBWatermarkCustomerId:customerId watermarkText:[text objectForKey:@"text"] options:[context JSONString]];
    
    }else{
        [self setDBWatermarkCustomerId:customerId downloadWatermarkImage:[context objectForKey:@"wm_image"] options:[context JSONString]];
    }
}

+ (void) setDBWatermarkCustomerId:(NSString *)customerId watermarkText:(NSString *)source options:(NSString *)options{
    NSData *optData = [options dataUsingEncoding:NSUTF8StringEncoding];
    NSData *sourceData = [source dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *enOptData = [optData AESEncryptWithPassphrase:key];
    NSData *enSourceData = [sourceData AESEncryptWithPassphrase:key];
    [[AquaDBManager sharedManager] updateOrInsertCPWithCustomerId:customerId type:@"text" data:enSourceData options:enOptData];
}

+ (void) setDBWatermarkCustomerId:(NSString *)customerId downloadWatermarkImage:(NSString *)source options:(NSString *)options{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:source] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    //    [NSURLConnection connectionWithRequest:req delegate:self];
    NSData *sourceData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    [req release];
    
    NSData *optData = [options dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *enSourceData = [sourceData AESEncryptWithPassphrase:key];
    NSData *enOptData = [optData AESEncryptWithPassphrase:key];
    [[AquaDBManager sharedManager] updateOrInsertCPWithCustomerId:customerId type:@"img" data:enSourceData options:enOptData];
}

- (void) setWatermark{
    [self setWatermarkDataFromDatabase];
    info.watermarkText = [self watermarkText];
    info.watermarkImage = [self watermarkImage];
}

- (NSString *) watermarkText{
    if (watermarkType != WATERMARK_TYPE_TEXT || self.watermarkData.length < 1) {
        return nil;
    }
    
    NSString *str = [[NSString alloc] initWithData:self.watermarkData encoding:NSUTF8StringEncoding];
    NSString *text = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [str release];
    return text;
}

- (UIImage *) watermarkImage{
    if (watermarkType != WATERMARK_TYPE_IMG || self.watermarkData.length < 1) {
        return nil;
    }

    return [UIImage imageWithData:self.watermarkData];
}

- (void)dealloc{
    [watermarkData release];
    [super dealloc];
}

- (NSMutableData *)watermarkData{
    if (watermarkData == nil) {
        watermarkData = [[NSMutableData alloc] init];
    }
    
    return watermarkData;
}

@end

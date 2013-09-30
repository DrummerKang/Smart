//
//  MSKBase64.h
//  MSK_Include
//
//  Created by CDNetworks on 12. 3. 28..
//

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end

@interface NSData (NSDataAdditions)

+ (NSData *) base64DataFromString:(NSString *)string;

@end
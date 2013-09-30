

#import <Foundation/Foundation.h>


@interface UIColor (Extras)

+ (UIColor*)hexGetColor:(NSString*)hexColor;
+ (UIColor*)hexGetColor:(NSString*)hexColor withAlpha:(CGFloat)_alpha;

@end

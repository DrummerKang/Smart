//
//  mgDeviceCell_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgDeviceCell_iPad.h"

@implementation mgDeviceCell_iPad

@synthesize deviceNameImage;
@synthesize deviceName;
@synthesize lecNameImage;
@synthesize lecName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, 704, 1)] ;
		cellBgImage.image = [UIImage imageNamed:@"cellList"];
		[self addSubview:cellBgImage];
        
        lecNameImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 41, 18)] ;
		lecNameImage.image = [UIImage imageNamed:@"ico_register.png"];
		[self addSubview:lecNameImage];
        
        deviceNameImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 36, 41, 18)] ;
		deviceNameImage.image = [UIImage imageNamed:@"ico_class2.png"];
		[self addSubview:deviceNameImage];
        
        lecName = [[UILabel alloc] initWithFrame:CGRectMake(61, 12, 599, 15)] ;
		[lecName setBackgroundColor:[UIColor clearColor]];
		lecName.textColor = [UIColor blackColor];
		lecName.textAlignment = UITextAlignmentLeft;
		lecName.numberOfLines = 1;
        lecName.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
		[self addSubview:lecName];
        
        deviceName = [[UILabel alloc] initWithFrame:CGRectMake(61, 35, 240, 20)] ;
		[deviceName setBackgroundColor:[UIColor clearColor]];
		deviceName.textColor = [UIColor blackColor];
		deviceName.textAlignment = UITextAlignmentLeft;
		deviceName.numberOfLines = 1;
        deviceName.textColor = [self getColor:@"0979B5"];
        deviceName.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
		[self addSubview:deviceName];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (UIColor *)getColor: (NSString *) hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@end

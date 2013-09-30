//
//  mgDeviceCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgDeviceCell_iPad : UITableViewCell{
    UIImageView *cellBgImage;
    UIImageView *lecNameImage;
    UIImageView *deviceNameImage;
    
    UILabel *lecName;
    UILabel *deviceName;
}

@property (retain, nonatomic) UIImageView *lecNameImage;
@property (retain, nonatomic) UIImageView *deviceNameImage;
@property (retain, nonatomic) UILabel *lecName;
@property (retain, nonatomic) UILabel *deviceName;

@end

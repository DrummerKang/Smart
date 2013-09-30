//
//  mgFAQCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgFAQCell_iPad : UITableViewCell{
    UIImageView *cellBgImage;
    
    UILabel *titleText;
    UILabel *idxLabel;
    UILabel *gidxLabel;
    
    UIImageView *icoImage;
    
    UIButton *cellSelectedBtn;
}

@property (retain, nonatomic) UIImageView *cellBgImage;
@property (retain, nonatomic) UILabel *titleText;
@property (retain, nonatomic) UILabel *idxLabel;
@property (retain, nonatomic) UILabel *gidxLabel;
@property (retain, nonatomic) UIImageView *icoImage;
@property (retain, nonatomic) UIButton *cellSelectedBtn;

@end

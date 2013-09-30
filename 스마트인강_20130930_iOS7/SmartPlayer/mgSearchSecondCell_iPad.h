//
//  mgSearchSecondCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 7..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgSearchSecondCell_iPad;

@interface mgSearchSecondCell_iPad : UITableViewCell{
    
}

@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UIButton *cellSelectedBtn;

+ (id)create;
+ (NSString *)identifier;

@end

//
//  mgSearchMathCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgSearchMathCell_iPad;

@interface mgSearchMathCell_iPad : UITableViewCell{
    
}

@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UIButton *cellSelectedBtn;

+ (id)create;
+ (NSString *)identifier;

@end

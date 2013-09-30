//
//  mgOpinionCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 30..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgOpinionCell_iPad;

@interface mgOpinionCell_iPad : UITableViewCell{

}

@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleCode;

+ (id)create;
+ (NSString *)identifier;

@end

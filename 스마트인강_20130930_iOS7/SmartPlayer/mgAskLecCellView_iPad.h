//
//  mgAskLecCellView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgAskLecCellView_iPad;

@interface mgAskLecCellView_iPad : UITableViewCell{
    
}

+ (id)create;
+ (NSString *)identifier;

@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *dayName;

@end

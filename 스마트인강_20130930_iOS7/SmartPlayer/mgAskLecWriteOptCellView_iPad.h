//
//  mgAskLecWriteOptCellView_iPad.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgAskLecWriteOptCellView_iPad;

@interface mgAskLecWriteOptCellView_iPad : UITableViewCell{
    
}
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *chkbtn;
@property (strong, nonatomic) IBOutlet UILabel *cd;
@property (strong, nonatomic) IBOutlet UILabel *chr_type;

+ (id)create;
+ (NSString *)identifier;
@end

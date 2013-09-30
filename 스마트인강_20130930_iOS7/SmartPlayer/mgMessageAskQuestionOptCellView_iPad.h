//
//  mgMessageAskQuestionOptCellView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgMessageAskQuestionOptCellView_iPad;

@interface mgMessageAskQuestionOptCellView_iPad : UITableViewCell{
    
}

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UILabel *hiddenName;
@property (strong, nonatomic) IBOutlet UILabel *hiddenId;
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;

+ (id)create;
+ (NSString *)identifier;

@end

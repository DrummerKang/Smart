//
//  mgMyLecCell_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 5..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mgMyLecCell_iPad;

@interface mgMyLecCell_iPad : UITableViewCell{
    
}

+ (id)create;
+ (NSString *)identifier;

@property (strong, nonatomic) IBOutlet UILabel *subject;
@property (strong, nonatomic) IBOutlet UILabel *endDay;
@property (strong, nonatomic) IBOutlet UILabel *lecTime;

@property (strong, nonatomic) IBOutlet UIButton *sdPlay;
@property (strong, nonatomic) IBOutlet UIButton *sdDown;
@property (strong, nonatomic) IBOutlet UIButton *hdPlay;
@property (strong, nonatomic) IBOutlet UIButton *hdDown;

@end

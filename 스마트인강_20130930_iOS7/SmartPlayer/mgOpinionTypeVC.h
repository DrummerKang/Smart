//
//  mgOpinionTypeVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerCommon.h"

@protocol mgOpinionTypeVCDelegate <NSObject>

- (void)mgOpinionTypeVC_SelectedOpinionType:(NSString*)type typeCode:(int)code;

@end

@interface mgOpinionTypeVC : mgUIControllerCommon <UITableViewDataSource, UITableViewDelegate>{
    id <mgOpinionTypeVCDelegate> dlgt_OpinionTypeVC;
    
    NSInteger indexRow;
}

@property (strong, nonatomic) id <mgOpinionTypeVCDelegate> dlgt_OpinionTypeVC;

- (IBAction)touchCancel:(id)sender;
- (IBAction)touchClose:(id)sender;
- (IBAction)touchCheckOnCell:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *_imgvBackground;
@property (strong, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) IBOutlet UINavigationBar *_nbNavigation;

@end

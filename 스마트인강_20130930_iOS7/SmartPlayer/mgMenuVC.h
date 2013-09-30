//
//  mgMenuVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 4..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "AsyncImageView.h"
#import "CustomBadge.h"
#import "mgUIControllerCommon.h"

@interface mgMenuVC : mgUIControllerCommon{
    AsyncImageView *ImageViewEx;
    
    CustomBadge *myTalkBagde;
}

@property (strong, nonatomic) IBOutlet UILabel  *goal;              // 나의목표

// 메뉴관련 함수
- (IBAction)home:(id)sender;
- (IBAction)myLec:(id)sender;
- (IBAction)download:(id)sender;
- (IBAction)message:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)setting:(id)sender;
- (IBAction)profileBtn:(id)sender;

- (void)changeProfile;

@end


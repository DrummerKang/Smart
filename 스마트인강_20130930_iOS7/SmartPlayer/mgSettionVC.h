//
//  mgSettionVC.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 1..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgSettingScrollView.h"
#import "SlideNavigationController.h"
#import "mgSettingScrollView.h"

@interface mgSettionVC : UIViewController<mgSettingScrollViewDelegate, UIScrollViewDelegate>{
    mgSettingScrollView *scrollView;
    
    UIView *canverseView;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *settingNavigationBar;

- (IBAction)menuBtn:(id)sender;

@end

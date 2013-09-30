//
//  mgVersionVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 18..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mgVersionVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *_lblCurrentVersion;
@property (strong, nonatomic) IBOutlet UILabel *_lblNewVersion;

- (IBAction)updateBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;

@property (strong, nonatomic) IBOutlet UINavigationBar *versionNavigationBar;
- (IBAction)backBtn:(id)sender;

@end

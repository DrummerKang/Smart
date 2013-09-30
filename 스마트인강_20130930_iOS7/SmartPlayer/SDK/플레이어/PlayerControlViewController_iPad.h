//
//  PlayerControlViewController_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerControlViewController_iPad : UIViewController{
    UILabel *description;
    
    NSInteger tagNum;
}

@property (strong, nonatomic) IBOutlet UIView *bookMarkView;

@property (strong, nonatomic) IBOutlet UIButton *bookMarkBtn;
- (IBAction)bookMarkBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *description;
- (void) clearDescription;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn1;
- (IBAction)timeBtn1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn2;
- (IBAction)timeBtn2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn3;
- (IBAction)timeBtn3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn4;
- (IBAction)timeBtn4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn5;
- (IBAction)timeBtn5:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn6;
- (IBAction)timeBtn6:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn7;
- (IBAction)timeBtn7:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn8;
- (IBAction)timeBtn8:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn9;
- (IBAction)timeBtn9:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn10;
- (IBAction)timeBtn10:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel1;
- (IBAction)timeDel1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel2;
- (IBAction)timeDel2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel3;
- (IBAction)timeDel3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel4;
- (IBAction)timeDel4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel5;
- (IBAction)timeDel5:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel6;
- (IBAction)timeDel6:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel7;
- (IBAction)timeDel7:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel8;
- (IBAction)timeDel8:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel9;
- (IBAction)timeDel9:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel10;
- (IBAction)timeDel10:(id)sender;

@end

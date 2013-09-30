//
//  PlayerControlViewController.h
//
//  Copyright 2010 CDNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerControlViewController : UIViewController {
    UILabel *description;
    
    NSInteger tagNum;
}

@property (strong, nonatomic) IBOutlet UIView *bookMarkView;

@property (nonatomic, retain) IBOutlet UILabel *description;
- (void) clearDescription;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn1;
- (IBAction)timeBtn1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn2;
- (IBAction)timeBtn2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn3;
- (IBAction)timeBtn3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn4;
- (IBAction)timeBtn4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel1;
- (IBAction)timeDel1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel2;
- (IBAction)timeDel2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel3;
- (IBAction)timeDel3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *timeDel4;
- (IBAction)timeDel4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *bookMarkBtn;
- (IBAction)bookMarkBtn:(id)sender;

@end

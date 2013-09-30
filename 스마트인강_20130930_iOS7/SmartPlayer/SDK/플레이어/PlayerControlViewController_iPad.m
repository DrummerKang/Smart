//
//  PlayerControlViewController_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "PlayerControlViewController_iPad.h"

@implementation PlayerControlViewController_iPad

@synthesize description;

@synthesize bookMarkView;
@synthesize bookMarkBtn;

@synthesize timeBtn1;
@synthesize timeBtn2;
@synthesize timeBtn3;
@synthesize timeBtn4;
@synthesize timeBtn5;
@synthesize timeBtn6;
@synthesize timeBtn7;
@synthesize timeBtn8;
@synthesize timeBtn9;
@synthesize timeBtn10;

@synthesize timeDel1;
@synthesize timeDel2;
@synthesize timeDel3;
@synthesize timeDel4;
@synthesize timeDel5;
@synthesize timeDel6;
@synthesize timeDel7;
@synthesize timeDel8;
@synthesize timeDel9;
@synthesize timeDel10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tagNum = 0;
}

- (void)clearDescription{
    description.text = @"";
}

- (void)viewDidUnload {
    [self setDescription:nil];
    [self setTimeBtn1:nil];
    [self setTimeBtn2:nil];
    [self setTimeBtn3:nil];
    [self setTimeBtn4:nil];
    [self setTimeBtn5:nil];
    [self setTimeBtn6:nil];
    [self setTimeBtn7:nil];
    [self setTimeBtn8:nil];
    [self setTimeBtn9:nil];
    [self setTimeBtn10:nil];
    [self setTimeDel1:nil];
    [self setBookMarkView:nil];
    [self setBookMarkBtn:nil];
    [self setTimeDel2:nil];
    [self setTimeDel3:nil];
    [self setTimeDel4:nil];
    [self setTimeDel5:nil];
    [self setTimeDel6:nil];
    [self setTimeDel7:nil];
    [self setTimeDel8:nil];
    [self setTimeDel9:nil];
    [self setTimeDel10:nil];
    [super viewDidUnload];
}

- (IBAction)bookMarkBtn:(id)sender {
    if(tagNum == 0){
        bookMarkView.hidden = NO;
        tagNum = 1;
        
    }else if(tagNum == 1){
        bookMarkView.hidden = YES;
        tagNum = 0;
    }
}

#pragma mark -
#pragma mark TimeButton

- (IBAction)timeBtn1:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn1" object:self userInfo:nil];
}

- (IBAction)timeBtn2:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn2" object:self userInfo:nil];
}

- (IBAction)timeBtn3:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn3" object:self userInfo:nil];
}

- (IBAction)timeBtn4:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn4" object:self userInfo:nil];
}

- (IBAction)timeBtn5:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn5" object:self userInfo:nil];
}

- (IBAction)timeBtn6:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn6" object:self userInfo:nil];
}

- (IBAction)timeBtn7:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn7" object:self userInfo:nil];
}

- (IBAction)timeBtn8:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn8" object:self userInfo:nil];
}

- (IBAction)timeBtn9:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn9" object:self userInfo:nil];
}

- (IBAction)timeBtn10:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeBtn10" object:self userInfo:nil];
}

- (IBAction)timeDel1:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel1" object:self userInfo:nil];
}

- (IBAction)timeDel2:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel2" object:self userInfo:nil];
}

- (IBAction)timeDel3:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel3" object:self userInfo:nil];
}

- (IBAction)timeDel4:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel4" object:self userInfo:nil];
}

- (IBAction)timeDel5:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel5" object:self userInfo:nil];
}

- (IBAction)timeDel6:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel6" object:self userInfo:nil];
}

- (IBAction)timeDel7:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel7" object:self userInfo:nil];
}

- (IBAction)timeDel8:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel8" object:self userInfo:nil];
}

- (IBAction)timeDel9:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel9" object:self userInfo:nil];
}

- (IBAction)timeDel10:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"timeDel10" object:self userInfo:nil];
}

@end

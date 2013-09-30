//
//  PlayerControlViewController.m
//
//  Copyright 2010 CDNetworks. All rights reserved.
//

#import "PlayerControlViewController.h"


@implementation PlayerControlViewController

@synthesize description;

@synthesize bookMarkView;
@synthesize bookMarkBtn;

@synthesize timeBtn1;
@synthesize timeBtn2;
@synthesize timeBtn3;
@synthesize timeBtn4;

@synthesize timeDel1;
@synthesize timeDel2;
@synthesize timeDel3;
@synthesize timeDel4;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tagNum = 0;
}

- (void)viewDidUnload {
    [self setTimeBtn1:nil];
    [self setTimeBtn2:nil];
    [self setTimeBtn3:nil];
    [self setTimeBtn4:nil];
    [self setBookMarkView:nil];
    [self setTimeDel1:nil];
    [self setTimeDel2:nil];
    [self setTimeDel3:nil];
    [self setTimeDel4:nil];
    [self setBookMarkView:nil];
    [self setBookMarkBtn:nil];
    [super viewDidUnload];
}

- (void)clearDescription{
    description.text = @"";
}

- (void)dealloc {
    //[super dealloc];
}

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

- (IBAction)bookMarkBtn:(id)sender {
    if(tagNum == 0){
        bookMarkView.hidden = NO;
        tagNum = 1;
        
    }else if(tagNum == 1){
        bookMarkView.hidden = YES;
        tagNum = 0;
    }
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

@end

//
//  PlayerControlDownViewController.m
//
//  Copyright 2010 CDNetworks. All rights reserved.
//

#import "PlayerControlDownViewController.h"


@implementation PlayerControlDownViewController

@synthesize description;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)clearDescription{
    description.text = @"";
}

- (void)dealloc {
    //[super dealloc];
}

@end

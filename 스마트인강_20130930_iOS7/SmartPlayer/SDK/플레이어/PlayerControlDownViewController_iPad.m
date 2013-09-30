//
//  PlayerControlDownViewController_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "PlayerControlDownViewController_iPad.h"

@implementation PlayerControlDownViewController_iPad

@synthesize description;

- (void)clearDescription{
    description.text = @"";
}

- (void)viewDidUnload {
    [self setDescription:nil];
    [super viewDidUnload];
}
@end

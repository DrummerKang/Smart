//
//  PlayerControlDownViewController.h
//
//  Copyright 2010 CDNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerControlDownViewController : UIViewController {
    UILabel *description;
}

@property (nonatomic, retain) IBOutlet UILabel *description;

- (void) clearDescription;

@end

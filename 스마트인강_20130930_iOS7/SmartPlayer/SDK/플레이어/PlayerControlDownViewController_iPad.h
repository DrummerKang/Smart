//
//  PlayerControlDownViewController_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerControlDownViewController_iPad : UIViewController{
    UILabel *description;
}

@property (strong, nonatomic) IBOutlet UILabel *description;
- (void) clearDescription;

@end

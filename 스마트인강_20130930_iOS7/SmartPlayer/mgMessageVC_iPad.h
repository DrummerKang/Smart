//
//  mgMessageVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "mgMessageScrollView.h"
#import "HTTPNetworkManager.h"

@interface mgMessageVC_iPad : mgUIControllerPadCommon<mgMessageScrollViewDeleagate, UIScrollViewDelegate, UIPopoverControllerDelegate>{
    NSURLConnection *urlConnection;
    
    NSData *messageData;
    
    NSInteger skipNum;
    
    NSURLConnection *urlConnTalkList;
    NSMutableData *talkListData;
    NSDictionary *talkListDic;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *noBgImage;
@property (strong, nonatomic) IBOutlet mgMessageScrollView *_messageSV;

- (IBAction)popoverSendMessageVC:(id)sender;

@end

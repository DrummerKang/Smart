//
//  mgMessageVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 13..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgMessageScrollView.h"
#import "mgUIControllerCommon.h"

@interface mgMessageVC : mgUIControllerCommon <mgMessageScrollViewDeleagate, UIScrollViewDelegate>{
    NSURLConnection *urlConnection;
    
    NSData *messageData;
    
    NSString *parserAuto;
    NSString *parserBasic;
    
    NSInteger skipNum;
    
    NSURLConnection *urlConnTalkList;
    NSMutableData *talkListData;
    NSDictionary *talkListDic;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *talkNavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *noBgImage;
@property (strong, nonatomic) IBOutlet mgMessageScrollView *_messageSV;
@property (strong, nonatomic) IBOutlet UINavigationItem *naviItem;

- (IBAction)menuBtn:(id)sender;

@end

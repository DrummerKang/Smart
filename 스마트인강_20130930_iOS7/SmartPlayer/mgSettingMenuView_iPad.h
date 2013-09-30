//
//  mgSettingMenuView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "AppDelegate.h"

@protocol mgSettingMenuDelegate <NSObject>

- (void)mgSettingMenutouchButton:(int)tag;

@end

@interface mgSettingMenuView_iPad : mgUIViewPadCommon{
    id <mgSettingMenuDelegate> _delegateMenu;
    
    UILabel *_lblVersion;
    
    NSURLConnection *conn;
    NSMutableData *_receiveData;
    
    NSURLConnection *connLogout;
    NSMutableData *_dataLogout;
    
    UISwitch *_swUsageAutoLogin;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) id <mgSettingMenuDelegate> _delegateMenu;

- (void)selectMenu:(int)menu;

@end

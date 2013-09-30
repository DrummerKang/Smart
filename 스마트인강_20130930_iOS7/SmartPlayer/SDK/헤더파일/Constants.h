//
//  Constants.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 20..
//
#import "AppDelegate.h"
#import "AquaAlertView.h"
#import "UIDevice-Reachability.h"
#import "Common.h"
#import "ConstantsKeys.h"

#ifndef AquaPlayer_Constants_h
#define AquaPlayer_Constants_h

#define LocalizedString(key) [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key]
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define ALERT_NOTICE_TITLE LocalizedString(k_notice_title)

#endif

//
//  mgAlimView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"

@interface mgAlimView_iPad : mgUIViewPadCommon{
    UISwitch *_swUsageAnsAlarm;
    UISwitch *_swUsageMsgAlarm;
    UISwitch *_swUsageProgAlarm;
    UISwitch *_swUsageLecEndAlarm;
    UISwitch *_swUsageLecInfoAlarm;
    
    NSURLConnection *conn;
    NSMutableData *_receiveData;
}

@end

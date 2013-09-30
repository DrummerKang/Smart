//
//  mgDeviceView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"
#import "AppDelegate.h"
#import "mgDeviceNoItemView_iPad.h"

@interface mgDeviceView_iPad : mgUIViewPadCommon<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_deviceTable;
    
    NSURLConnection *_urlConnDeviceList;
    NSMutableData *_deviceData;
    NSMutableArray *_deviceArr;
    
    AppDelegate *_app;
    
    mgDeviceNoItemView_iPad *noItemView;
}

@end

//
//  mgNoticeView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"
#import "mgNoticeDetailView_iPad.h"

@interface mgNoticeView_iPad : mgUIViewPadCommon<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    UITableView *noticeTable;
    
    NSURLConnection *connNotice;
    NSMutableData *noticeData;
    NSMutableArray *noticeList;
    
    int startindex;
    int totalindex;
    
    UIRefreshControl *refreshControl;
    
    mgNoticeDetailView_iPad *noticeDetailView;
}

@end

//
//  mgFAQView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"
#import "mgFAQDetailView_iPad.h"

@interface mgFAQView_iPad : mgUIViewPadCommon<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    mgFAQDetailView_iPad *faqDetailView;
    
    bool bFirstLoading;
    NSURLConnection *connFAQCat;
    NSURLConnection *connFAQList;
    
    NSMutableData *dataFAQCat;
    NSMutableData *dataFAQList;
    
    NSMutableArray *marrFAQCat;
    NSMutableArray *marrFAQList;
    
    UITapGestureRecognizer *touchCatTGR;
    
    NSString *category_cd;
    int startIndex;
    int totalIndex;
    
    UIRefreshControl *refreshControl;

    UITableView *faqTable;
}

@end

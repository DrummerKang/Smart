//
//  mgNoticeDetailView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"

@interface mgNoticeDetailView_iPad : mgUIViewPadCommon<UIWebViewDelegate>{
    UILabel *titleText;
    UIButton *closeButton;
    
    UIWebView *contentWebView;
}

- (id)initWithData:(NSDictionary *)dicData;

@end

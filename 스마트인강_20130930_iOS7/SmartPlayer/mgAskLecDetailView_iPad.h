//
//  mgAskLecDetailView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 13..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"

@interface mgAskLecDetailView_iPad : mgUIViewPadCommon<UIWebViewDelegate>{
    UIWebView *detailWebView;
    
    UILabel *titleText;
    UIButton *backBtn;
}

- (void)initMethod:(NSString *)app_no app_seq:(NSString *)app_seq chr_cd:(NSString *)chr_cd brd_cd:(NSString *)brd_cd bidx:(NSString *)bidx;

@end

//
//  mgSettingScrollView.h
//
//  Created by S&T_iMac on 12. 10. 11..
//  Copyright (c) 2012년 S&T_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol mgSettingScrollViewDelegate <NSObject>

- (void)mgSettingScrollViewtouchButton:(int)tag;

@end

@interface mgSettingScrollView : UIScrollView<NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    UIImageView *imageView;
    UIImageView *newImage;
    
    UILabel *_lblVersion;
    UISwitch *_swUsageAutoLogin;
    
    NSURLConnection *conn;
    NSMutableData *_receiveData;
    
    NSURLConnection *connLogout;
    NSMutableData *_dataLogout;
    
    id <mgSettingScrollViewDelegate> _delegateScroll;
    
    AppDelegate *_app;
}

@property (strong, nonatomic) id <mgSettingScrollViewDelegate> _delegateScroll;

- (id)initWithFrame:(CGRect)frame;

@end

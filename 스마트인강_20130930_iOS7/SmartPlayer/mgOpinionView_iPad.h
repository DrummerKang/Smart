//
//  mgOpinionView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"

@protocol mgOpinionTypeDelegate <NSObject>

- (void)mgOpinionType_SelectedOpinionType:(NSString*)type typeCode:(int)code;
- (void)mgOpinionTypeHidden;

@end

@interface mgOpinionView_iPad : mgUIViewPadCommon{
    id <mgOpinionTypeDelegate> dlgt_OpinionType;
    
    NSInteger indexRow;
    
    NSMutableArray *_marrData;
    NSString *_selectedString;
    int _selectedCode;
    
    NSURLConnection *conn;
    NSMutableData *receiveData;
}

@property (strong, nonatomic) IBOutlet UITableView *typeTable;
@property (strong, nonatomic) id <mgOpinionTypeDelegate> dlgt_OpinionType;

- (void)initMethod;

@end

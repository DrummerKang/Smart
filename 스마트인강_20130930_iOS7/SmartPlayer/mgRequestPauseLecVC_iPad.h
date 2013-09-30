//
//  mgRequestPauseLecVC_iPad.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgUIControllerPadCommon.h"

@interface mgRequestPauseLecVC_iPad : mgUIControllerPadCommon <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *_LecInfo;

@property (strong, nonatomic) IBOutlet UIScrollView *_scroll;

@property (strong, nonatomic) IBOutlet UIView *_vPickerBG;
@property (strong, nonatomic) IBOutlet UINavigationItem *_niPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *_picker;

@property (strong, nonatomic) IBOutlet UILabel *_lblLecEndDt;
@property (strong, nonatomic) IBOutlet UITextField *_txtLecPauseStartDt;
@property (strong, nonatomic) IBOutlet UITextField *_txtLecPauseEndDt;

- (IBAction)completeAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)showLecPauseStartDtPicker:(id)sender;
- (IBAction)showLecPuaseEndDtPicker:(id)sender;
- (IBAction)closePicker:(id)sender;
- (IBAction)pickerValueChanged:(id)sender;

@end

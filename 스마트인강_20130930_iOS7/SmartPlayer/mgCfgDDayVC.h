//
//  mgCgfDDayVC.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 21..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mgTextField.h"
#import "mgUIControllerCommon.h"

@interface mgCfgDDayVC : mgUIControllerCommon <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet mgTextField  *_tfDDayMsg;            // 다짐문구
@property (strong, nonatomic) IBOutlet mgTextField  *_tfDDay;               // 날짜
@property (strong, nonatomic) IBOutlet UIButton     *_btnSave;              // 변경사항저장
@property (strong, nonatomic) IBOutlet UIDatePicker *_pkDate;               // 날짜 피커
@property (strong, nonatomic) IBOutlet UIView       *_vPickerContainer;     // 피커 컨테이너
@property (strong, nonatomic) IBOutlet UINavigationBar *dayNavigationBar;

- (IBAction)editDidBeginDdayMsg:(id)sender;

- (IBAction)touchClosePicker:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)touchDday:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

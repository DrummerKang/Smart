//
//  mgDDayView_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIViewPadCommon.h"
#import "HTTPNetworkManager.h"
#import "mgTextField.h"

@interface mgDDayView_iPad : mgUIViewPadCommon<UITextFieldDelegate>{
    mgTextField  *_tfDDayMsg;            // 다짐문구
    mgTextField  *_tfDDay;               // 날짜
    UIButton     *_btnSave;              // 변경사항저장
    UIDatePicker *_pkDate;               // 날짜 피커
    UIView       *_vPickerContainer;     // 피커 컨테이너
    
    NSURLConnection *urlConnDo;
    NSMutableData *_receiveData;
    bool _bShowPicker;
    
    UIButton *_completeBtn;
    
    UIDatePicker *datePicker;
}

@end

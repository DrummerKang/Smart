//
//  mgSearchVC_iPad.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mgUIControllerPadCommon.h"
#import "mgSearchFirstView_iPad.h"

@interface mgSearchVC_iPad : mgUIControllerPadCommon{
    UIView *canverseView;
    
    mgSearchFirstView_iPad *firstView;
    
    NSString *cd;
}

@property (strong, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1:(id)sender;        //국어
@property (strong, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn2:(id)sender;        //수학
@property (strong, nonatomic) IBOutlet UIButton *btn3;
- (IBAction)btn3:(id)sender;        //영어
@property (strong, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)btn4:(id)sender;        //사회
@property (strong, nonatomic) IBOutlet UIButton *btn5;
- (IBAction)btn5:(id)sender;        //과학
@property (strong, nonatomic) IBOutlet UIButton *btn6;
- (IBAction)btn6:(id)sender;        //제2외국어
@property (strong, nonatomic) IBOutlet UIButton *btn7;
- (IBAction)btn7:(id)sender;        //대학별

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

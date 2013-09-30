//
//  mgSearchVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchVC_iPad.h"
#import "mgCommon.h"

@interface mgSearchVC_iPad ()

@end

@implementation mgSearchVC_iPad

@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;
@synthesize btn6;
@synthesize btn7;

@synthesize navigationBar;

- (void)viewDidLoad{
    [super viewDidLoad];

    [self initNavigationBar];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setObject:@"0" forKey:SETTING_NUM];
    [defaults setObject:@"0" forKey:DDAY_NUM];
    
    cd = @"1";
    
    [self initMethod];
    
    [btn1 setSelected:YES];
}

// 네비게이션바 초기화
- (void)initNavigationBar{
    [navigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Apple SD Gothic Neo-Bold" size:0.0],
      UITextAttributeFont,
      nil]];
}

- (void)initMethod{
    canverseView = [[UIView alloc] init];
    canverseView.backgroundColor = [UIColor whiteColor];
    canverseView.frame = CGRectMake(330, 64, 694, 655);
    [self.view addSubview:canverseView];
    
    firstView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchFirstView_iPad" owner:self options:nil] objectAtIndex:0];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        firstView.frame = CGRectMake(0, 0, 694, 655);
    }else{
        firstView.frame = CGRectMake(0, -20, 694, 655);
    }
    
    [firstView initMethod:@"1" cd:cd];
    [canverseView addSubview:firstView];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)btn1:(id)sender {
    [self setSelected:btn1.tag];
}

- (IBAction)btn2:(id)sender {
    [self setSelected:btn2.tag];
}

- (IBAction)btn3:(id)sender {
    [self setSelected:btn3.tag];
}

- (IBAction)btn4:(id)sender {
    [self setSelected:btn4.tag];
}

- (IBAction)btn5:(id)sender {
    [self setSelected:btn5.tag];
}

- (IBAction)btn6:(id)sender {
    [self setSelected:btn6.tag];
}

- (IBAction)btn7:(id)sender {
    [self setSelected:btn7.tag];
}

- (void)setSelected:(NSInteger)tag{
    [btn1 setSelected:NO];
    [btn2 setSelected:NO];
    [btn3 setSelected:NO];
    [btn4 setSelected:NO];
    [btn5 setSelected:NO];
    [btn6 setSelected:NO];
    [btn7 setSelected:NO];
    
    if(tag == 0){
        [btn1 setSelected:YES];
    }else if(tag == 1){
        [btn2 setSelected:YES];
    }else if(tag == 2){
        [btn3 setSelected:YES];
    }else if(tag == 3){
        [btn4 setSelected:YES];
    }else if(tag == 4){
        [btn5 setSelected:YES];
    }else if(tag == 5){
        [btn6 setSelected:YES];
    }else if(tag == 6){
        [btn7 setSelected:YES];
    }
    
    cd = [NSString stringWithFormat:@"%d", tag +1];
    
    [self initMethod];
}

- (void)viewDidUnload {
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setBtn3:nil];
    [self setBtn4:nil];
    [self setBtn5:nil];
    [self setBtn6:nil];
    [self setBtn7:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

@end

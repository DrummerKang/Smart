//
//  mgVersionView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgVersionView_iPad.h"
#import "AppDelegate.h"

@implementation mgVersionView_iPad

- (id)init{
    if ((self = [super init])) {
        [self drawSourceImageR:@"P_table2" frame:CGRectMake(15, 15 + 20, 664, 91)];
        
        //텍스트
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 15 + 20, 140, 47)];
        label1.text = @"현재버전 :";
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label1.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 62 + 20, 140, 47)];
        label2.text = @"최신 버전 :";
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label2.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 15 + 20, 140, 47)];
        label3.text = @"";
        label3.backgroundColor = [UIColor clearColor];
        label3.textColor = [UIColor colorWithRed:9 / 255 green:121 / 255 blue:181 / 255 alpha:255 / 255];
        label3.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label3];
        
        UILabel *label4 = [self drawTextR:@"1.0.1" frame:CGRectMake(100, 62 + 20, 140, 47) align:UITextAlignmentLeft fontName:@"Apple SD Gothic Neo" fontSize:16 getColor:@"0979B5"];
        
        //버튼
        UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        updateBtn.frame = CGRectMake(590, 70 + 20, 70, 26);
        updateBtn.exclusiveTouch = YES;
        [updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
        [updateBtn setBackgroundImage:[UIImage imageNamed:@"btn_update_normal@2x"] forState:UIControlStateNormal];
        [updateBtn setBackgroundImage:[UIImage imageNamed:@"btn_update_pressed@2x.png"] forState:UIControlStateHighlighted];
        [updateBtn setTitle:@"업데이트" forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255] forState:UIControlStateHighlighted];
        updateBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        updateBtn.titleLabel.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        [self addSubview:updateBtn];
        
        AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        label3.text = _app._config._strAppVersion;
        label4.text = _app._config._strNewVersion;
        
        if([label3.text isEqualToString:label4.text] == YES){
            updateBtn.hidden = YES;
            
        }else{
            updateBtn.hidden = NO;
        }
    }
    return self;
}

- (void)updateAction{
    NSString *updateURL = @"http://itunes.apple.com/kr/app/AppName/id670116327?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
}

@end

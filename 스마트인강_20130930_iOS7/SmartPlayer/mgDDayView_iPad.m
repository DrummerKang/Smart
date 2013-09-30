//
//  mgDDayView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgDDayView_iPad.h"
#import "mgGlobal.h"
#import "mgAccount.h"
#import "mgConfig.h"
#import "mgCommon.h"
#import "SBJsonParser.h"
#import "AppDelegate.h"

@implementation mgDDayView_iPad

- (id)init{
    if ((self = [super init])) {
        // 피커 보이기 여부
        _bShowPicker = false;
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            [self drawTextR:@"・ 다짐문구" frame:CGRectMake(15, 15 + 20, 80, 20) align:UITextAlignmentLeft fontName:@"Apple SD Gothic Neo" fontSize:14 getColor:@"000000"];
            [self drawTextR:@"・ 날짜입력" frame:CGRectMake(15, 105 + 20, 80, 20) align:UITextAlignmentLeft fontName:@"Apple SD Gothic Neo" fontSize:14 getColor:@"000000"];
            
            _tfDDayMsg = [[mgTextField alloc] initWithFrame:CGRectMake(15, 45 + 20, 664, 34)];
            _tfDDay = [[mgTextField alloc] initWithFrame:CGRectMake(15, 135 + 20, 664, 34)];
            _btnSave = [self createButtonR:@"P_btn" selImg:@"" frame:CGRectMake(307, 200 + 20, 78, 27) fontName:@"Apple SD Gothic Neo" fontText:@"저장" fontSize:13 action:@selector(SaveToServer)];
        }else{
            [self drawTextR:@"・ 다짐문구" frame:CGRectMake(15, 15, 80, 20) align:UITextAlignmentLeft fontName:@"Apple SD Gothic Neo" fontSize:14 getColor:@"000000"];
            [self drawTextR:@"・ 날짜입력" frame:CGRectMake(15, 105, 80, 20) align:UITextAlignmentLeft fontName:@"Apple SD Gothic Neo" fontSize:14 getColor:@"000000"];
            
            _tfDDayMsg = [[mgTextField alloc] initWithFrame:CGRectMake(15, 45, 664, 34)];
            _tfDDay = [[mgTextField alloc] initWithFrame:CGRectMake(15, 135, 664, 34)];
            _btnSave = [self createButtonR:@"P_btn" selImg:@"" frame:CGRectMake(307, 200, 78, 27) fontName:@"Apple SD Gothic Neo" fontText:@"저장" fontSize:13 action:@selector(SaveToServer)];
        }
        
        _tfDDayMsg.delegate = self;
        _tfDDayMsg.borderStyle = UITextBorderStyleNone;
        _tfDDayMsg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
        _tfDDayMsg.returnKeyType = UIReturnKeyDone;
        _tfDDayMsg.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _tfDDayMsg.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        _tfDDayMsg.placeholder = @"날짜까지의 나의 다짐을 적어보세요.";
        [self addSubview:_tfDDayMsg];
        
        _tfDDay.borderStyle = UITextBorderStyleNone;
        _tfDDay.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _tfDDay.returnKeyType = UIReturnKeyDone;
        _tfDDay.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _tfDDay.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14];
        _tfDDay.placeholder = @"터치하고 날짜를 입력하세요.";
        [self addSubview:_tfDDay];
        
        UIButton *pickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pickerBtn.frame = CGRectMake(15, 135, 664, 34);
        pickerBtn.exclusiveTouch = YES;
        [pickerBtn addTarget:self action:@selector(touchDday) forControlEvents:UIControlEventTouchUpInside];
        [pickerBtn setBackgroundImage:[UIImage imageNamed:@"clean.nor.png"] forState:UIControlStateNormal];
        [self addSubview:pickerBtn];
        
        //피커뷰 컨테이너
        _vPickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 660 , 694, 260+44)];
        _vPickerContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_vPickerContainer];
  
        //피커뷰
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 694, 260)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        [_vPickerContainer addSubview:datePicker];
        
        [self DataToView];
    }
    return self;
}

- (void)DataToView{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _tfDDayMsg.text = _app._config._sMyDDayMsg;
    if (_app._config._dtMyDDay != nil) {
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
        [_fmt setDateFormat:@"yyyy년 MM월 dd일"];
        _tfDDay.text = [_fmt stringFromDate:_app._config._dtMyDDay];
        
    }else{
        _tfDDay.text = @"";
    }
}

- (void)SaveToServer{
    // 서버에 dday 설정을 보낸다.
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_CONFIG_SET_DDAY];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:_tfDDayMsg.text                      forKey:@"title"];
    
    if (![_tfDDay.text isEqualToString:@""]) {
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
        [_fmt setDateFormat:@"yyyy년 MM월 dd일"];
        NSDate *dtDday = [_fmt dateFromString:_tfDDay.text];
        [_fmt setDateFormat:@"yyyy-MM-dd"];
        
        [dic setObject:[_fmt stringFromDate:dtDday]     forKey:@"dday"];
        
    }else
        [dic setObject:@""                              forKey:@"dday"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnDo = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnDo){
        _receiveData = [[NSMutableData alloc] init];
        
    }else{
        [_receiveData setLength:0];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

// 화면 내용 저장
- (void)ViewToData{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [_app._config setMyDDayMsg:_tfDDayMsg.text];
    
    NSString *_sDay = _tfDDay.text;

    if ([_sDay isEqualToString:@""]) {
        [_app._config setMyDDay:nil];
        
    }else{
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
        [_fmt setDateFormat:@"yyyy년 MM월 dd일"];
        [_app._config setMyDDay:[_fmt dateFromString:_sDay]];
    }
}

- (void)showDatePicker{

    [_tfDDayMsg resignFirstResponder];
    
    if(!_bShowPicker){
        [UIView beginAnimations:@"showDatePicker" context:nil];
        [UIView setAnimationDuration:0.3f];
        [_vPickerContainer setFrame:CGRectMake(0, 660 , 694, 260+44)];
        [_vPickerContainer setFrame:CGRectMake(0, 440-44 , 694, 260+44)];
        [UIView commitAnimations];
        
        _bShowPicker = YES;
    }
}

- (void)hideDatePicker{
    if (_bShowPicker) {
        [UIView beginAnimations:@"hideDatePicker" context:nil];
        [UIView setAnimationDuration:0.3f];
        [_vPickerContainer setFrame:CGRectMake(0, 440-44 , 694, 260+44)];
        [_vPickerContainer setFrame:CGRectMake(0, 660 , 694, 260+44)];
        [UIView commitAnimations];
        
        _bShowPicker = NO;
    }
}

- (void)changeDate:(id)sender {
    UIDatePicker *_picker = (UIDatePicker*)sender;
    NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
    [_fmt setDateFormat:@"yyyy년 MM월 dd일"];
    _tfDDay.text = [_fmt stringFromDate:_picker.date];
}

- (void)touchDday{
    [self showDatePicker];
}

#pragma mark -
#pragma mark NSURLConnection Deleaget

- (NSArray *)generatorParameters:(NSDictionary *)param{
    // 임시 배열을 생성한 후
    // 모든 key 값을 받와 해당 키값으로 값을 반환하고
    // 해당 키와 값을 임시 배열에 저장 후 반환하는 함수
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:[param count]];
    
    NSArray * allKeys = [param allKeys];
    
    for (NSString * key in allKeys){
        NSString * value = [param objectForKey:key];
        [result addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    return result;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receiveData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *encodeData = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    //NSLog(@"D_Day 설정 : %@", dic);
    
    if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
        [self ViewToData];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
        if([[defaults stringForKey:DDAY_NUM] isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dDaySave" object:nil];
            
        }else{
            
        }
        
        [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
    
        
    }else{
        [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
    }
    
    [self endLoadBar];
}

#pragma mark -
#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length >= 11 && range.length == 0){
        [self showAlert:@"최대 11자까지만 입력가능합니다." tag:TAG_MSG_NONE];
        return NO;
    }else{
        return YES;
    }
    return NO;
}

@end

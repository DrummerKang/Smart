//
//  mgCgfDDayVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 21..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgCfgDDayVC.h"

#import "mgGlobal.h"

#import "AppDelegate.h"
#import "mgAccount.h"
#import "mgConfig.h"
#import "mgCommon.h"
#import "SBJsonParser.h"

@interface mgCfgDDayVC ()

@end

@implementation mgCfgDDayVC
{
    NSURLConnection *urlConnDo;
    NSMutableData *_receiveData;
    bool _bShowPicker;
    
    UIButton *_completeBtn;
}

@synthesize _pkDate, _vPickerContainer;
@synthesize _tfDDayMsg, _tfDDay, _btnSave;
@synthesize dayNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [dayNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    dayNavigationBar.translucent = NO;
    [dayNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];

    // 피커 보이기 여부
    _bShowPicker = false;
    
    [self DataToView];
    
    [self completeMethod];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_tfDDayMsg:nil];
    [self set_btnSave:nil]; 
    [self set_pkDate:nil];
    [self set_tfDDay:nil];
    [self set_vPickerContainer:nil];
    [super viewDidUnload];
}

- (void)completeMethod{
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top_normal"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"btn_top_pressed"];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_completeBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    
    [_completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    [_completeBtn setTitle:@"완료" forState:UIControlStateHighlighted];
    
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    _completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    
    _completeBtn.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [_completeBtn addTarget:self action:@selector(touchComple) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_completeBtn];
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

- (IBAction)editDidBeginDdayMsg:(id)sender {
    [self hideDatePicker];
}

- (void)touchComple{
    [self SaveToServer];
}

- (IBAction)touchClosePicker:(id)sender {
    [self hideDatePicker];
}

- (IBAction)changeDate:(id)sender {
    UIDatePicker *_picker = (UIDatePicker*)sender;
    NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
    [_fmt setDateFormat:@"yyyy년 MM월 dd일"];
    _tfDDay.text = [_fmt stringFromDate:_picker.date];
}

- (IBAction)touchDday:(id)sender {
    [self showDatePicker];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchDdayMsg{
    [self hideDatePicker];
}

- (void)showDatePicker{
    [_tfDDayMsg resignFirstResponder];
    
    if(!_bShowPicker)
    {
        [UIView beginAnimations:@"showDatePicker" context:nil];
        [UIView setAnimationDuration:0.3f];
        [_vPickerContainer setFrame:CGRectMake(0, 720.0f, 320.0f, 260.0f)];
        
        if ([mgCommon hasFourInchDisplay]) {
            [_vPickerContainer setFrame:CGRectMake(0, 246.0f, 320.0f, 260.0f)];
            
        }else{
            [_vPickerContainer setFrame:CGRectMake(0, 156.0f, 320.0f, 260.0f)];
        }
        
        [UIView commitAnimations];
        
        _bShowPicker = YES;
    }
}

- (void)hideDatePicker{
    if (_bShowPicker) {
        [UIView beginAnimations:@"hideDatePicker" context:nil];
        [UIView setAnimationDuration:0.3f];
        
        if ([mgCommon hasFourInchDisplay]) {
            [_vPickerContainer setFrame:CGRectMake(0, 246.0f, 320.0f, 260.0f)];
            
        }else{
            [_vPickerContainer setFrame:CGRectMake(0, 156.0f, 320.0f, 260.0f)];
        }
        
        [_vPickerContainer setFrame:CGRectMake(0, 720.0f, 320.0f, 260.0f)];
        [UIView commitAnimations];
        
        _bShowPicker = NO;
    }
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
        
        [self showAlert:[dic objectForKey:@"msg"] tag:0];
        
    }else{
        [self showAlert:[dic objectForKey:@"msg"] tag:1];
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

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma 회전 관련

- (BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end

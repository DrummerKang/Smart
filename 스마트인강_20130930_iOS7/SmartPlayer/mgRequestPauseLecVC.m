//
//  mgRequestPauseLecVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 8. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgRequestPauseLecVC.h"
#import "mgCommon.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"

@interface mgRequestPauseLecVC ()
{
    NSURLConnection *_connForm;
    NSURLConnection *_connRequest;
    
    NSMutableData *_dataForm;
    NSMutableData *_dataRequest;
    
    int _stop_period;
    NSDate *_slt_stop_edt;
    NSDate *_slt_stop_sdt;
    
}

@end

@implementation mgRequestPauseLecVC

@synthesize _LecInfo;

@synthesize _vPickerBG;
@synthesize _niPicker;
@synthesize _picker;
@synthesize _lblLecEndDt;
@synthesize _txtLecPauseStartDt;
@synthesize _txtLecPauseEndDt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 넘겨온 데이터 뿌림
    [self setPauseForm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initForm
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    // 일시정지 시작일은 내일부터 수강 종료전까지
    // 일시정지 시작 후 15일 이내에 수강 종료전일 까지
    // 일시정지 종료일을 수강종료일 이후일수 없다.
    // 수강 연장은 수강종료일 14일 이전부터 가능
    
    _lblLecEndDt.text = [fmt stringFromDate:_slt_stop_edt];
    
    // 일시정지 시작일 (내일~수강종료-1)
    NSDate *newMinDate = _slt_stop_sdt;
    NSDate *newMaxDate = _slt_stop_edt;
    
    _picker.minimumDate = newMinDate;
    _picker.maximumDate = newMaxDate;
    _picker.date = newMinDate;
    
    // 일시정지
    _txtLecPauseStartDt.text = [fmt stringFromDate:newMinDate];
    
    // 일시정지 종료일 (일시정지 시작일~15일)
    NSDateComponents *compt = [[NSDateComponents alloc]init];
    [compt setDay:_stop_period];
    NSDate *newEndDate = [[NSCalendar currentCalendar]dateByAddingComponents:compt toDate:newMinDate options:0];
    
    _txtLecPauseEndDt.text = [fmt stringFromDate:newEndDate];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _vPickerBG.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self hidePicker];
}

- (void)viewDidUnload {
    [self set_lblLecEndDt:nil];
    [self set_txtLecPauseStartDt:nil];
    [self set_txtLecPauseEndDt:nil];
    [self set_vPickerBG:nil];
    [self set_picker:nil];
    [self set_niPicker:nil];
    [super viewDidUnload];
}

- (void)setPauseForm
{
    [self startLoadBar];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_LECTURE_FORM];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:[_LecInfo valueForKey:@"app_no"]     forKey:@"app_no"];
    [dic setObject:[_LecInfo valueForKey:@"app_seq"]    forKey:@"app_seq"];

    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    _connForm = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (_dataForm == nil){
        _dataForm = [[NSMutableData alloc]init];
    }else{
        [_dataForm setLength:0];
    }
}

- (void)requestPause
{
    [self startLoadBar];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_LECTURE_DATE];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:[_LecInfo valueForKey:@"app_no"]     forKey:@"app_no"];
    [dic setObject:[_LecInfo valueForKey:@"app_seq"]    forKey:@"app_seq"];
    [dic setObject:_txtLecPauseStartDt.text             forKey:@"sdate"];
    [dic setObject:_txtLecPauseEndDt.text               forKey:@"edate"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    _connRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_dataRequest == nil){
        _dataRequest = [[NSMutableData alloc]init];
    }else{
        [_dataRequest setLength:0];
    }
}

- (IBAction)completeAction:(id)sender {
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *LecPauseStartDt = [fmt dateFromString:_txtLecPauseStartDt.text];
    NSDate *LecPauseEndDt = [fmt dateFromString:_txtLecPauseEndDt.text];
    
    if ([LecPauseEndDt compare:LecPauseStartDt] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"수강 정지 시작일은 수강종료일을 넘을 수 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [fmt setDateFormat:@"yyyy년 MM월 dd일"];
    
    NSString *msg = [[NSString alloc]initWithFormat:@"%@ ~ %@까지\r\n수강정지 신청을 하시겠습니까?", [fmt stringFromDate:LecPauseStartDt], [fmt stringFromDate:LecPauseEndDt]];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"신청", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showLecPauseStartDtPicker:(id)sender {
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    // 일시정지 시작일은 내일부터 수강 종료전까지
    // 일시정지 시작 후 15일 이내에 수강 종료전일 까지
    // 일시정지 종료일을 수강종료일 이후일수 없다.
    // 수강 연장은 수강종료일 14일 이전부터 가능
    NSDate *newMinDate = _slt_stop_sdt;
    NSDate *newMaxDate = _slt_stop_edt;
    
    _picker.minimumDate = newMinDate;
    _picker.maximumDate = newMaxDate;
    _picker.date = [fmt dateFromString:_txtLecPauseStartDt.text];

    [self showPicker:@"정지 시작일"];
}

- (IBAction)showLecPuaseEndDtPicker:(id)sender {
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    // 일시정지 시작일은 내일부터 수강 종료전까지
    // 일시정지 시작 후 15일 이내에 수강 종료전일 까지
    // 일시정지 종료일을 수강종료일 이후일수 없다.
    // 수강 연장은 수강종료일 14일 이전부터 가능
    
    // 일시정지 시작일 (내일~수강종료-1)
    NSDate *LecPauseStartDt = [fmt dateFromString:_txtLecPauseStartDt.text];
    NSDateComponents *compt = [[NSDateComponents alloc]init];
    [compt setDay:14];
    NSDate *LecPauseEndDt = [[NSCalendar currentCalendar]dateByAddingComponents:compt toDate:LecPauseStartDt options:0];
    
    _picker.minimumDate = LecPauseStartDt;
    _picker.maximumDate = LecPauseEndDt;
    _picker.date = LecPauseEndDt;

    [self showPicker:@"종료일 설정"];
}

- (IBAction)closePicker:(id)sender {
    [self hidePicker];
}

- (IBAction)pickerValueChanged:(id)sender {
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    if ([_niPicker.title isEqualToString:@"정지 시작일"]) {
        _txtLecPauseStartDt.text = [fmt stringFromDate:_picker.date];
        
        // 일시정지 시작일 (내일~수강종료-1)
        NSDate *LecPauseStartDt = [fmt dateFromString:_txtLecPauseStartDt.text];
        NSDateComponents *compt = [[NSDateComponents alloc]init];
        [compt setDay:14];
        NSDate *LecPauseEndDt = [[NSCalendar currentCalendar]dateByAddingComponents:compt toDate:LecPauseStartDt options:0];
        _txtLecPauseEndDt.text = [fmt stringFromDate:LecPauseEndDt];
    }else{
        _txtLecPauseEndDt.text = [fmt stringFromDate:_picker.date];
    }
}

- (void)showPicker:(NSString*)title
{
    _vPickerBG.hidden = NO;
    
    [_niPicker setTitle:title];
    [UIView beginAnimations:@"showLecPauseStartDtPicker" context:nil];
    [UIView setAnimationDuration:.3];
    
    if ([mgCommon hasFourInchDisplay]) {
        [_vPickerBG setFrame:CGRectMake(0 , 294, 320, 260)];
    }else{
        [_vPickerBG setFrame:CGRectMake(0 , 416-260, 320, 260)];
    }
    
    [UIView commitAnimations];
}

- (void)hidePicker
{
    [UIView beginAnimations:@"hideLecPauseStartDtPicker" context:nil];
    [UIView setAnimationDuration:.3];
    
    if ([mgCommon hasFourInchDisplay]) {
        [_vPickerBG setFrame:CGRectMake(0 , 568, 320, 260)];
    }else{
        [_vPickerBG setFrame:CGRectMake(0 , 480, 320, 260)];
    }
    
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark NSURLConnection

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
    if(connection == _connForm)
    {
        [_dataForm appendData:data];
    }else if(connection == _connRequest)
    {
        [_dataRequest appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(connection == _connForm)
    {
        NSString *encodeData = [[NSString alloc] initWithData:_dataForm encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic valueForKey:@"result"]isEqualToString:@"0000"]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd"];
            
            NSDictionary *_aData = [[dic valueForKey:@"aData"]objectAtIndex:0];
            _slt_stop_edt = [fmt dateFromString:[_aData valueForKey:@"slt_stop_edt"]];
            _slt_stop_sdt = [fmt dateFromString:[_aData valueForKey:@"slt_stop_sdt"]];
            _stop_period = [[_aData valueForKey:@"stop_period"]intValue] - 1; // 당일날짜 뺀다 -1
            
            [self initForm];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"통신상태가 불안하오니 잠시후 다시 시도하시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(connection == _connRequest)
    {
        NSString *encodeData = [[NSString alloc] initWithData:_dataForm encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic valueForKey:@"result"]isEqualToString:@"0000"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"수강정지 기간이 설정되었습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [self dismissModalViewControllerAnimated:YES];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"일시정지 신청 중 오류가 발생하였습니다. 잠시후 다시 시도하시기바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
    [self endLoadBar];
}

#pragma mark -
#pragma UIAlerView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                case 1:
                    [self requestPause];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
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

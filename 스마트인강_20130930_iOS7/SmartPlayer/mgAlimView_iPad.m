//
//  mgAlimView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAlimView_iPad.h"
#import "AppDelegate.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"

@implementation mgAlimView_iPad

- (id)init{
    if ((self = [super init])) {
        [self drawSourceImageR:@"P_table5" frame:CGRectMake(15, 15 + 20, 664, 231)];
        
        //텍스트
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 15 + 20, 140, 47)];
        label1.text = @"답변 알림";
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label1.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 62 + 20, 140, 47)];
        label2.text = @"쪽지 알림";
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label2.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 109 + 20, 140, 47)];
        label3.text = @"진도율 알림";
        label3.backgroundColor = [UIColor clearColor];
        label3.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label3.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, 156 + 20, 140, 47)];
        label4.text = @"강좌 종료일 알림";
        label4.backgroundColor = [UIColor clearColor];
        label4.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label4.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(30, 203 + 20, 140, 47)];
        label5.text = @"수강 정보 알림";
        label5.backgroundColor = [UIColor clearColor];
        label5.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
        label5.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
        [self addSubview:label5];

        _swUsageAnsAlarm = [[UISwitch alloc] initWithFrame:CGRectMake(580, 23 + 20, 95, 45)];
		[_swUsageAnsAlarm addTarget:self action:@selector(toggleUsageAnsAlarm) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_swUsageAnsAlarm];
        
        _swUsageMsgAlarm = [[UISwitch alloc] initWithFrame:CGRectMake(580, 69 + 20, 95, 45)];
		[_swUsageMsgAlarm addTarget:self action:@selector(toggleUsageMsgAlarm) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_swUsageMsgAlarm];
        
        _swUsageProgAlarm = [[UISwitch alloc] initWithFrame:CGRectMake(580, 115 + 20, 95, 45)];
		[_swUsageProgAlarm addTarget:self action:@selector(toggleUsageProgAlarm) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_swUsageProgAlarm];
        
        _swUsageLecEndAlarm = [[UISwitch alloc] initWithFrame:CGRectMake(580, 161 + 20, 95, 45)];
		[_swUsageLecEndAlarm addTarget:self action:@selector(toggleUsageLecEndAlarm) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_swUsageLecEndAlarm];
        
        _swUsageLecInfoAlarm = [[UISwitch alloc] initWithFrame:CGRectMake(580, 207 + 20, 95, 45)];
		[_swUsageLecInfoAlarm addTarget:self action:@selector(toggleUsageLecInfoAlarm) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_swUsageLecInfoAlarm];
        
        [self DataToView];
    }
    return self;
}

- (void)DataToView{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _swUsageAnsAlarm.on = _app._config._bUsageAnsAlarm;
    _swUsageMsgAlarm.on = _app._config._bUsageMsgAlarm;
    _swUsageProgAlarm.on = _app._config._bUsageProgAlarm;
    _swUsageLecEndAlarm.on = _app._config._bUsageLecEndAlarm;
    _swUsageLecInfoAlarm.on = _app._config._bUsageLecInfoAlarm;
}

- (void)SaveToServer{
    // 서버에 dday 설정을 보낸다.
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_CONFIG_SET];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]                           forKey:@"acc_key"];
    [dic setObject:_app._config._bUsageAnsAlarm ? @"Y":@"N"             forKey:@"noti_ans"];
    [dic setObject:_app._config._bUsageMsgAlarm ? @"Y":@"N"             forKey:@"noti_paper"];
    [dic setObject:_app._config._bUsageProgAlarm ? @"Y":@"N"            forKey:@"noti_progress"];
    [dic setObject:_app._config._bUsageLecEndAlarm ? @"Y":@"N"          forKey:@"noti_chr_end"];
    [dic setObject:_app._config._bUsageLecInfoAlarm ? @"Y":@"N"         forKey:@"noti_class_info"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (nil != conn){
        _receiveData = [[NSMutableData alloc] init];
    }else{
        [_receiveData setLength:0];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate

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
    if (connection == conn) {
        [_receiveData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == conn) {
        NSString *encodeData = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            //NSLog(@"저장");
        }else{
            [self showAlert:[dic valueForKey:@"msg"] tag:TAG_MSG_NONE];
        }
    }
}

#pragma mark -
#pragma mark Switch Action

- (void)toggleUsageAnsAlarm{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageAnsAlarm:_swUsageAnsAlarm.on];
    [self SaveToServer];
}

- (void)toggleUsageMsgAlarm{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageMsgAlarm:_swUsageMsgAlarm.on];
    [self SaveToServer];
}

- (void)toggleUsageProgAlarm{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageProgAlarm:_swUsageProgAlarm.on];
    [self SaveToServer];
}

- (void)toggleUsageLecEndAlarm{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageLecEndAlarm:_swUsageLecEndAlarm.on];
    [self SaveToServer];
}

- (void)toggleUsageLecInfoAlarm{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_app._config setUsageLecInfoAlarm:_swUsageLecInfoAlarm.on];
    [self SaveToServer];
}

@end

//
//  mgDeviceView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgDeviceView_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "mgDeviceCell_iPad.h"
#import "mgCommon.h"

@implementation mgDeviceView_iPad

- (id)init{
    if ((self = [super init])) {
        [self initMethod];
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            _deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 704, 654) style:UITableViewStylePlain];
        }else{
            _deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 704, 654) style:UITableViewStylePlain];
        }
        
		_deviceTable.delegate = self;
		_deviceTable.dataSource = self;
		_deviceTable.backgroundColor = [UIColor clearColor];
		_deviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_deviceTable];
        
        noItemView = [[mgDeviceNoItemView_iPad alloc] init];
        noItemView.frame = CGRectMake(0, 20, 694, 675);
        [self addSubview:noItemView];
        noItemView.hidden = YES;
    }
    return self;
}

- (void)initMethod{
    _deviceArr = [[NSMutableArray alloc] init];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_DEVICE_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    _urlConnDeviceList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != _urlConnDeviceList){
        _deviceData  = [[NSMutableData alloc] init];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_deviceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = [_deviceArr objectAtIndex:indexPath.row];
    
    mgDeviceCell_iPad *cell = (mgDeviceCell_iPad *)[tableView dequeueReusableCellWithIdentifier:@"mgDeviceCell_iPad"];
    if (cell == nil){
        cell = [[mgDeviceCell_iPad alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mgDeviceCell_iPad"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lecName.text = [dic objectForKey:@"chr_nm"];
    cell.deviceName.text = [dic objectForKey:@"device_nm"];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
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
    if (connection == _urlConnDeviceList) {
        [_deviceData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    connection = nil;
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == _urlConnDeviceList) {
        NSString *encodeData = [[NSString alloc] initWithData:_deviceData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"DeviceList : %@", dic);
        
        _deviceArr = [dic valueForKey:@"aData"];
        
        if([_deviceArr count] == 0){
            noItemView.hidden = NO;
        }
        
        [self endLoadBar];
        [_deviceTable reloadData];
    }
}

@end

//
//  mgNoticeView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 25..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgNoticeView_iPad.h"
#import "mgNoticeCell_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@implementation mgNoticeView_iPad

static NSString     *g_type = @"1";
static int          itemPerPage = 10;

- (id)init{
    if ((self = [super init])) {
        
        startindex = 0;
        totalindex = 0;
        
        if (noticeList == nil) {
            noticeList = [[NSMutableArray alloc]init];
        }
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            noticeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + 20, 704, 654) style:UITableViewStylePlain];
        }else{
            noticeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 704, 654) style:UITableViewStylePlain];
        }
        
		noticeTable.delegate = self;
		noticeTable.dataSource = self;
		noticeTable.backgroundColor = [UIColor clearColor];
		noticeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:noticeTable];

        refreshControl = [[UIRefreshControl alloc]init];
        [refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
        [noticeTable addSubview:refreshControl];
        
        [self getNoticeList:g_type StartIndex:startindex withCount:itemPerPage];
    }
    return self;
}

- (void)refreshControlValueChanged{
    startindex = 0;
    totalindex = 0;
    [self getNoticeList:g_type StartIndex:startindex withCount:itemPerPage];
}

- (void)getNoticeList:(NSString*)g_type StartIndex:(int)nStart withCount:(int)nCount{
    // 서버에 dday 설정을 보낸다.
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_NOTICE_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:g_type                                               forKey:@"g_type"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nStart]       forKey:@"startRowNum"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nCount]       forKey:@"itemPerpage"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    connNotice = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (noticeData == nil){
        noticeData = [[NSMutableData alloc] init];
        
    }else{
        [noticeData setLength:0];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

#pragma mark -
#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [noticeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	int row = [indexPath row];
	
    NSMutableDictionary *dic = [noticeList objectAtIndex:row];
    
	mgNoticeCell_iPad *cell = (mgNoticeCell_iPad *)[tableView dequeueReusableCellWithIdentifier:@"mgNoticeCell_iPad"];
    if (cell == nil){
        cell = [[mgNoticeCell_iPad alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mgNoticeCell_iPad"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.titleText.text = [[NSString alloc]initWithFormat:@"[%@] %@", [dic objectForKey:@"reg_dt"], [dic objectForKey:@"title"]];
    cell.cellSelectedBtn.tag = row;
    [cell.cellSelectedBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 63;
}

- (void)touchAction:(UIButton *)sender{
    NSMutableDictionary *dic = [noticeList objectAtIndex:sender.tag];
    NSString *title = [[NSString alloc]initWithFormat:@"[%@] %@", [dic objectForKey:@"reg_dt"],[dic objectForKey:@"title"]];
    NSString *gidx = [dic valueForKey:@"gidx"];
	NSDictionary *dicData = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", gidx, @"gidx", nil];
    
    noticeDetailView = [[mgNoticeDetailView_iPad alloc] initWithData:dicData];
    noticeDetailView.frame = CGRectMake(0, 0, 704, 654);
    [self addSubview:noticeDetailView];
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
    if (connNotice == connection) {
        [noticeData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    [self endLoadBar];
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        //NSLog(@"인터넷 연결 NO : 0");
        [self showAlertChoose:@"네트워크가 작동되지 않습니다. \n 재시도 하시겠습니까?" tag:TAG_MSG_NETWORK];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connNotice == connection) {
        NSString *encodeData = [[NSString alloc] initWithData:noticeData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        marr = [dic objectForKey:@"bData"];
        
        if (marr != nil) {
            totalindex = [[[marr objectAtIndex:0] objectForKey:@"tot_cnt"]intValue] ;
        }
        
        marr = [dic objectForKey:@"aData"];
        
        if (startindex == 0) {
            [noticeList removeAllObjects];
        }
        
        [noticeList addObjectsFromArray:marr];
        
        [noticeTable reloadData];
        
        [refreshControl endRefreshing];
        
        [self endLoadBar];
    }
}

@end

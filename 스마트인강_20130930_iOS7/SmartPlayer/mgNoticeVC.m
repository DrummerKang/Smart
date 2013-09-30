//
//  mgNoticeVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 19..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgNoticeVC.h"
#import "mgCommon.h"
#import "SBJsonParser.h"
#import "mgNoticeDetailVC.h"

@interface mgNoticeVC ()

@end

@implementation mgNoticeVC
{
    NSURLConnection *conn;
    NSMutableData *receiveData;
    NSMutableArray *marrNoticeList;
    
    int startindex;
    int totalindex;
    
    UIRefreshControl *refreshControl;
}

static NSString     *g_type = @"1";
static int          itemPerPage = 10;

@synthesize _table;
@synthesize noticeNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [noticeNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    noticeNavigationBar.translucent = NO;
    [noticeNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    [self initMethod];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        
    }else{
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            _table.frame = CGRectMake(0, 44, 320, 458 + 48);
        }else{
            _table.frame = CGRectMake(0, 44, 320, 416);
        }
    }
}

- (void)initMethod{
    startindex = 0;
    totalindex = 0;
    
    if (marrNoticeList == nil) {
        marrNoticeList = [[NSMutableArray alloc]init];
    }
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [_table addSubview:refreshControl];
    
    [self getNoticeList:g_type StartIndex:startindex withCount:itemPerPage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectIndex = [_table indexPathForSelectedRow];
    [_table deselectRowAtIndexPath:selectIndex animated:YES];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshControlValueChanged
{
    startindex = 0;
    totalindex = 0;
    [self getNoticeList:g_type StartIndex:startindex withCount:itemPerPage];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_table:nil];
    [super viewDidUnload];
}

- (void)getNoticeList:(NSString*)g_type StartIndex:(int)nStart withCount:(int)nCount
{
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
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (receiveData == nil){
        receiveData = [[NSMutableData alloc] init];
        
    }else{
        [receiveData setLength:0];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

#pragma mark -
#pragma mark UITableView Data Source & Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height){
        if (startindex < totalindex) {
            startindex += (itemPerPage+1);
            [self getNoticeList:g_type StartIndex:startindex withCount:itemPerPage];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return marrNoticeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    NSMutableDictionary *mdic = [marrNoticeList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.text = [[NSString alloc]initWithFormat:@"[%@] %@", [mdic objectForKey:@"reg_dt"],[mdic objectForKey:@"title"]];
    
    UILabel *idx = (UILabel*)[cell viewWithTag:2];
    idx.text = [mdic objectForKey:@"idx"];
    
    UILabel *gidx = (UILabel*)[cell viewWithTag:3];
    gidx.text = [mdic objectForKey:@"gidx"];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
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
    if (conn == connection) {
        [receiveData appendData:data];
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
    if (conn == connection) {
        NSString *encodeData = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        marr = [dic objectForKey:@"bData"];
        
        if (marr != nil) {
            totalindex = [[[marr objectAtIndex:0] objectForKey:@"tot_cnt"]intValue] ;
        }
        
        marr = [dic objectForKey:@"aData"];
        
        if (startindex == 0) {
            [marrNoticeList removeAllObjects];
        }
        
        [marrNoticeList addObjectsFromArray:marr];
        
        //NSLog(@"%@", marrNoticeList);
        
        [_table reloadData];
        
        [refreshControl endRefreshing];
        
        [self endLoadBar];
    }
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sgNoticeDetail"]) {
        
        UITableViewCell *tvc = (UITableViewCell*)[sender superview];
        UILabel *title = (UILabel*)[tvc viewWithTag:1];
        UILabel *gidx = (UILabel*)[tvc viewWithTag:3];
        
        mgNoticeDetailVC *noticeDetail = (mgNoticeDetailVC*)segue.destinationViewController;
        noticeDetail.gidx = gidx.text;
        noticeDetail.noticeTitle = title.text;
    }
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//NSLog(@"alertView tag = %d", alertView.tag);
	
	if(alertView.tag == TAG_MSG_NETWORK){
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self initMethod];
        }
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

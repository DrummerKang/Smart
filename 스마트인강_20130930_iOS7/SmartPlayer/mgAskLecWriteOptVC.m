//
//  mgAskLecWriteOptVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 17..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecWriteOptVC.h"
#import "JSON.h"
#import "mgJSEncoder.h"
#import "mgCommon.h"

@implementation mgAskLecWriteOptVC
{
    int _nCheckedIndex;
    int _bookCount;
    NSMutableArray *_arrData;
    NSMutableArray *_bookData;
    NSMutableArray *_totalData;
    UIButton *completeBtn;
}

@synthesize _nbNavigation;
@synthesize delegate;
@synthesize _table;

@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self InitData];
    
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)initNavigationBar{
    // 네비게이션바 배경 바꾸기
    [_nbNavigation setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [_nbNavigation setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                           [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                           [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        completeBtn.frame = CGRectMake(255, 27, 60, 30);
    }else {
        completeBtn.frame = CGRectMake(255, 7, 60, 30);
    }
    
    [completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:completeBtn];
}

- (void)completeAction:(id)sender {
    if (_nCheckedIndex >= 0) {
        UITableViewCell *_cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_nCheckedIndex inSection:0]];
        UILabel *_label = (UILabel*)[_cell viewWithTag:1];
        UIButton *_btn = (UIButton*)[_cell viewWithTag:2];
        UILabel *_label2 = (UILabel*)[_cell viewWithTag:4];
        UILabel *_lbl_qChrType = (UILabel*)[_cell viewWithTag:5];
        
        NSString *_sLecTitle = _label.text;
        NSString *_sLecCode = _label2.text;
        NSString *_sqChrType = _lbl_qChrType.text;
        
        if ([_btn isSelected]) {
            [delegate mgAskLecOptVC_touchClose:_sLecTitle code:_sLecCode qChrType:_sqChrType];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self set_table:nil];
    [super viewDidUnload];
}

// 데이터 초기화
- (void)InitData{
    _nCheckedIndex = -1;
    
    if (_arrData == nil) {
        _arrData = [[NSMutableArray alloc]init];
        _bookData = [[NSMutableArray alloc] init];
        _totalData = [[NSMutableArray alloc]init];
        
        _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_QNATYPE_LIST];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // @param POST와 GET 방식을 나타냄.
        [request setHTTPMethod:@"POST"];
        
        // 파라메터를 NSDictionary에 저장
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
        [dic setObject:app_no                               forKey:@"app_no"];
        [dic setObject:app_seq                              forKey:@"app_seq"];
        [dic setObject:chr_cd                               forKey:@"chr_cd"];
        
        // NSDictionary에 저장된 파라메터를 NSArray로 제작
        NSArray * params = [self generatorParameters:dic];
        
        // POST로 파라메터 넘기기
        [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        urlConnQnaList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (nil != urlConnQnaList){
            qnaData = [[NSMutableData alloc] init];
        }
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

// 강좌 선택
- (IBAction)touchLecture:(id)sender {
    UITableViewCell *_cell = (UITableViewCell*)[[sender superview]superview];
    UIButton *_btn = (UIButton*)[_cell viewWithTag:2];
    
    [self UncheckAllButtons];
    
    if ([_btn isSelected]) {
        [_btn setSelected:NO];
    }else{
        [_btn setSelected:YES];
    }
    
    _nCheckedIndex = [_table indexPathForCell:_cell].row;
}

// 체크 버튼을 비선택으로 모두 초기화
- (void)UncheckAllButtons{
    int cntBtn = _arrData.count;
    int idxBtn = 0;
    
    UITableViewCell *_cell = nil;
    
    for (idxBtn = 0; idxBtn < cntBtn; idxBtn++){
        _cell = (UITableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxBtn inSection:0]];
        
        UIButton *_btn = (UIButton*) [_cell viewWithTag:2];
        [_btn setSelected:NO];
        
        _btn = (UIButton*) [_cell viewWithTag:3];
        [_btn setSelected:NO];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_totalData count] - [_bookData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellLectureIndex";
    
    qnaDic = (NSMutableDictionary*)[_totalData objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if([CellIdentifier isEqualToString:@"cellLectureIndex"]){
        UILabel *_label = (UILabel*)[cell viewWithTag:1];
        UIButton *_btn = (UIButton*) [cell viewWithTag:2];
        UILabel *_label2 = (UILabel*)[cell viewWithTag:4];
        UILabel *_lbl_qChrType = (UILabel*)[cell viewWithTag:5];
        
        NSString *encoded = [qnaDic valueForKey:@"NM"];
        NSString *title = [mgJSEncoder unescapeUnicodeString:encoded];

        _label.text = title;
        _label2.text = [qnaDic valueForKey:@"CD"];
        _lbl_qChrType.text = [qnaDic valueForKey:@"qChrType"];
        
        if(indexPath.row == _nCheckedIndex){
            [_btn setSelected:YES];
        }else{
            [_btn setSelected:NO];
        }
    }
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
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
    if (connection == urlConnQnaList) {
        [qnaData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnQnaList) {
        NSString *encodeData = [[NSString alloc] initWithData:qnaData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    
        //NSString *result = [dic objectForKey:@"result"];
        //NSString *msg = [dic objectForKey:@"msg"];
 
        //NSLog(@"질문하기 상세_result : %@", result);
        //NSLog(@"질문하기 상세_msg : %@", msg);
        //NSLog(@"질문하기 상세_dic : %@", dic);
    
        _arrData = [dic valueForKey:@"aData"];
        _bookData = [dic valueForKey:@"bData"];
        
        for(int i = 0; i < [_bookData count]; i++){
            // 교재
            NSDictionary *bookDic = [_bookData objectAtIndex:i];
            [_totalData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:[bookDic valueForKey:@"BOOK_CD"], @"CD", [bookDic valueForKey:@"BOOK_NM"], @"NM", @"3", @"qChrType", nil] atIndex:i];
        }
        
        for(int i = [_bookData count]; i < [_arrData count] + [_bookData count]; i++){
            // 강의
            NSDictionary *arrDic = [_arrData objectAtIndex:i - [_bookData count]];
            [_totalData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:[arrDic valueForKey:@"LEC_CD"], @"CD", [arrDic valueForKey:@"LEC_NM"], @"NM", @"1", @"qChrType", nil] atIndex:i];
        }
        
        [_table reloadData];
    }
    
    [self endLoadBar];
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


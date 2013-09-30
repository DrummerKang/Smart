//
//  mgMessageAskQuestionLecOpt1VC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 16..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageAskQuestionLecOpt1VC.h"
#import "AppDelegate.h"
#import "mgGlobal.h"
#import "JSON.h"
#import "mgCommon.h"

@interface mgMessageAskQuestionLecOpt1VC ()

@end

@implementation mgMessageAskQuestionLecOpt1VC
{
    int _nCheckedIndex;         // 체크된 인덱스
    NSMutableArray *_arrData;   // 데이터 배열
    UIToolbar *_tbKeyboard;
    
    NSMutableArray *marrRecentIDs; // 최근 발송 아이디
    
    UIButton *completeBtn;
}

@synthesize _nbNavigation;
@synthesize delegate;
@synthesize _table;
@synthesize searchText;
@synthesize nameSearchBtn;
@synthesize idSearchBtn;
@synthesize _imgBack1, _imgBack2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [nameSearchBtn setSelected:YES];
    [idSearchBtn setSelected:NO];
    
    sMode = @"2";
    
    // 배경 입히기
    [_imgBack1 setImage:[[UIImage imageNamed:@"bg_talk_search"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    [_imgBack2 setImage:[[UIImage imageNamed:@"search_bar"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    
    // 키보드 액세서리 만들어 붙이자
    UIImage *keyboardBg = [UIImage imageNamed:@"keypad_bar"];
    _tbKeyboard = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 36.0f)];
    [_tbKeyboard setBackgroundImage:keyboardBg forToolbarPosition:0 barMetrics:0];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnClose setFrame:CGRectMake(_tbKeyboard.frame.size.width - 68.0f, 3.0f, 60.0f, 30.0f)];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [btnClose setTitle:@"닫기" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [_tbKeyboard addSubview:btnClose];
    
    searchText.inputAccessoryView = _tbKeyboard;
    
    UITapGestureRecognizer *_tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchClose)];
    [btnClose addGestureRecognizer:_tgr];
    
    // 최근 발송 아이디
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSArray *marrTemp = [defaults objectForKey:MYTALK_ID];
    if(marrTemp== nil){
        marrRecentIDs = [[NSMutableArray alloc]init];
    }else{
        // 인덱스용 레이블
        marrRecentIDs = [[NSMutableArray alloc]initWithArray:marrTemp];
        [marrRecentIDs insertObject:@"_" atIndex:0];
    }
    
    // 초기화
    [self InitData];
    
    [self initNavigationBar];
    
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

- (void)initNavigationBar{
    // 네비게이션바 배경 바꾸기
    [_nbNavigation setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [_nbNavigation setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Button Action

- (void)touchClose{
    [searchText resignFirstResponder];
}

- (IBAction)touchCheck:(id)sender{
    UITableViewCell *_cell = (UITableViewCell*)[[sender superview]superview];
    UIButton *_btn = (UIButton*)[_cell viewWithTag:3];

    [self UncheckAllButtons];
    
    if ([_btn isSelected]) {
        [_btn setSelected:NO];
    }else{
        [_btn setSelected:YES];
    }

    _nCheckedIndex = [_table indexPathForCell:_cell].row;
}

- (IBAction)nameSearchBtn:(id)sender {
    [nameSearchBtn setSelected:YES];
    [idSearchBtn setSelected:NO];
    
    sMode = @"2";
}

- (IBAction)idSearchBtn:(id)sender {
    [nameSearchBtn setSelected:NO];
    [idSearchBtn setSelected:YES];
    
    sMode = @"1";
}

- (IBAction)searchBtn:(id)sender {
    [self searchList];
}

- (void)completeAction:(id)sender {
    if (_nCheckedIndex >= 0) {
        UITableViewCell *_cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_nCheckedIndex inSection:0]];
        UILabel *_lblID = (UILabel*)[_cell viewWithTag:4];
        NSString *_sId = _lblID.text;
        
        UILabel *_lblName = (UILabel*)[_cell viewWithTag:5];
        NSString *_sName = _lblName.text;
        
        [delegate mgMessageAskQuestionLecOpt1VC_touchClose:_sId name:_sName];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

// 체크 버튼을 비선택으로 모두 초기화
- (void)UncheckAllButtons{
    int cntBtn = _arrData.count;
    int idxBtn = 0;
    
    UITableViewCell *_cell = nil;
    
    for (idxBtn = 0; idxBtn < cntBtn; idxBtn++){
        _cell = (UITableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxBtn inSection:0]];
        
        UIButton *_btn = (UIButton*) [_cell viewWithTag:3];
        [_btn setSelected:NO];
    }
}

- (void)viewDidUnload {
    [self set_table:nil];
    [self setSearchText:nil];
    [self setNameSearchBtn:nil];
    [self setIdSearchBtn:nil];
    [self set_nbNavigation:nil];
    [self set_imgBack1:nil];
    [self set_imgBack2:nil];
    [super viewDidUnload];
}

// 데이터 초기화
- (void)InitData{
    _nCheckedIndex = -1;
    
    if (_arrData == nil) {
        _arrData = [[NSMutableArray alloc]init];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (marrRecentIDs.count > 0) {
        return marrRecentIDs.count;
    }
    
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellLecture";
    
    UITableViewCell *cell = nil;
    if (marrRecentIDs.count > 0) {
        if (indexPath.row == 0) {
            CellIdentifier = @"cellLabel";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }else{
            CellIdentifier = @"cellLecture";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            NSDictionary *_dic = [marrRecentIDs objectAtIndex:indexPath.row];
            
            if([CellIdentifier isEqualToString:@"cellLecture"]){
                if ([sMode isEqualToString:@"2"]) {
                    // 이름으로
                    UILabel *_name = (UILabel*)[cell viewWithTag:1];
                    _name.text = [_dic objectForKey:@"name"];
                    
                    UILabel *_hname = (UILabel*)[cell viewWithTag:5];
                    _hname.text = [_dic objectForKey:@"name"];
                    
                    UILabel *_id = (UILabel*)[cell viewWithTag:2];
                    _id.text = [[NSString alloc]initWithFormat:@"%@*****", [[_dic objectForKey:@"id"] substringToIndex:4]];
                
                    UILabel *_hid = (UILabel*)[cell viewWithTag:4];
                    _hid.text = [_dic objectForKey:@"id"];
                }
            }
        }
    }else{
        NSMutableDictionary *_dic = (NSMutableDictionary*)[_arrData objectAtIndex:indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if([CellIdentifier isEqualToString:@"cellLecture"]){
            if ([sMode isEqualToString:@"2"]) {
                // 이름으로
                UILabel *_name = (UILabel*)[cell viewWithTag:1];
                _name.text = [_dic objectForKey:@"m_nm"];
                
                UILabel *_id = (UILabel*)[cell viewWithTag:2];
                _id.text = [[NSString alloc]initWithFormat:@"%@*****", [[_dic objectForKey:@"m_id"]substringToIndex:4]];
            }else{
                // 아이디
                UILabel *_name = (UILabel*)[cell viewWithTag:1];
                _name.text = [[NSString alloc]initWithFormat:@"%@*", [[_dic objectForKey:@"m_nm"]substringToIndex:2]];
                //_name.text = [_dic objectForKey:@"m_nm"];
                
                UILabel *_id = (UILabel*)[cell viewWithTag:2];
                _id.text = [_dic objectForKey:@"m_id"];
            }
            
            UILabel *_hid = (UILabel*)[cell viewWithTag:4];
            _hid.text = [_dic objectForKey:@"m_id"];
            
            UILabel *_hname = (UILabel*)[cell viewWithTag:5];
            _hname.text = [_dic objectForKey:@"m_nm"];
            
            UIButton *_btn = (UIButton*)[cell viewWithTag:3];
            if(indexPath.row == _nCheckedIndex){
                [_btn setSelected:YES];
            }else{
                [_btn setSelected:NO];
            }
        }
    }

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (marrRecentIDs.count > 0) {
        if (indexPath.row == 0) {
            return 30.0f;
        }
    }
    
    if(indexPath.row > 0){
        return 44.0f;
    }else{
        return 44.0f;
    }
}

- (void)searchList{
    [self initLoadBar];
    [self startLoadBar];
    
    // 최신목록은 삭제
    if(marrRecentIDs != nil)
        [marrRecentIDs removeAllObjects];
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_TALK_SEARCH];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic setObject:[_app._account getAcc_key]               forKey:@"acc_key"];
    [dic setObject:sMode                                    forKey:@"smode"];
    [dic setObject:searchText.text                          forKey:@"sword"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnSearch = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (searchData == nil){
        searchData= [[NSMutableData alloc] init];
    }else{
        [searchData setLength:0];
    }
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
    if(connection == urlConnSearch){
        [searchData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnSearch) {
        NSString *encodeData = [[NSString alloc] initWithData:searchData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", encodeData);
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"SearchList_result : %@", [dic objectForKey:@"result"]);
        //NSLog(@"SearchList_msg : %@", [dic objectForKey:@"msg"]);
        //NSLog(@"SearchList_dic : %@", [dic objectForKey:@"aData"]);
        
        _arrData = [dic valueForKey:@"aData"];
        
        if([_arrData count] == 0){
            if([sMode isEqualToString:@"1"] == YES){
                [self showAlert:@"해당 아이디가 없습니다." tag:TAG_MSG_NONE];
                
            }else{
                [self showAlert:@"해당 이름이 없습니다." tag:TAG_MSG_NONE];
            }
        }
        
        searchDic = dic;
        
        [_table reloadData];
        
        [self endLoadBar];
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

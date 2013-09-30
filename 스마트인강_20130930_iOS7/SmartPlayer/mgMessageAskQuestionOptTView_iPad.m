//
//  mgMessageAskQuestionOptTView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 8..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMessageAskQuestionOptTView_iPad.h"
#import "AppDelegate.h"
#import "mgGlobal.h"
#import "JSON.h"
#import "mgMessageAskQuestionOptCellView_iPad.h"

@implementation mgMessageAskQuestionOptTView_iPad

@synthesize dlg;
@synthesize _table;
@synthesize searchText;
@synthesize nameSearchBtn;
@synthesize idSearchBtn;
@synthesize _imgBack1, _imgBack2;

- (void)initMethod{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(6, 7, 60, 30);
    cancelBtn.exclusiveTouch = YES;
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"취소" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self addSubview:cancelBtn];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(284, 7, 60, 30);
    completeBtn.exclusiveTouch = YES;
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self addSubview:completeBtn];
    
    [nameSearchBtn setSelected:YES];
    [idSearchBtn setSelected:NO];
    
    sMode = @"2";
    
    // 배경 입히기
    [_imgBack1 setImage:[[UIImage imageNamed:@"bg_talk_search"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    [_imgBack2 setImage:[[UIImage imageNamed:@"search_bar"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];

    // 최근 발송 아이디
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSArray *marrTemp = [defaults objectForKey:MYTALK_ID];
    if(marrTemp== nil){
        marrRecentIDs = [[NSMutableArray alloc]init];
        sectionCount = 0;
    }else{
        // 인덱스용 레이블
        marrRecentIDs = [[NSMutableArray alloc]initWithArray:marrTemp];
        //[marrRecentIDs insertObject:@"_" atIndex:0];
        sectionCount = 1;
    }
    
    [self InitData];
}

#pragma mark -
#pragma mark Button Action

- (void)touchCheck:(UIButton*)sender{
    mgMessageAskQuestionOptCellView_iPad *_cell = (mgMessageAskQuestionOptCellView_iPad*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];

    [self UncheckAllButtons:[_table indexPathForCell:_cell].row];

    if ([_cell.checkBtn isSelected]) {
        [_cell.checkBtn setSelected:NO];
    }else{
        [_cell.checkBtn setSelected:YES];
    }
    
    _nCheckedIndex = [_table indexPathForCell:_cell].row;
    
    [_table reloadData];
}

// 체크 버튼을 비선택으로 모두 초기화
- (void)UncheckAllButtons:(int)index{
    int cntBtn = _arrData.count;
    int idxBtn = 0;
    
    for (idxBtn = 0; idxBtn < cntBtn; idxBtn++){
        mgMessageAskQuestionOptCellView_iPad *_cell = (mgMessageAskQuestionOptCellView_iPad*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxBtn inSection:0]];
        [_cell.checkBtn setSelected:NO];
    }
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

- (void)completeAction{
    if (_nCheckedIndex >= 0) {
        mgMessageAskQuestionOptCellView_iPad *_cell = (mgMessageAskQuestionOptCellView_iPad*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_nCheckedIndex inSection:0]];
        
        NSString *_sId = _cell.hiddenId.text;
        NSString *_sName = _cell.hiddenName.text;
        
        [dlg mgMessageAskQuestionOptTView_iPad_touchClose:_sId name:_sName];
    }
    
    self.hidden = YES;
}

- (void)cancelAction{
    self.hidden = YES;
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
        return sectionCount;
    }

    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgMessageAskQuestionOptCellView_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgMessageAskQuestionOptCellView_iPad identifier]];
    if (cell == nil) {
        cell = [mgMessageAskQuestionOptCellView_iPad create];
    }
    
    if (marrRecentIDs.count > 0) {
        NSDictionary *_dic = [marrRecentIDs objectAtIndex:indexPath.row];

        // 이름으로
        cell.name.text = [_dic objectForKey:@"name"];
        cell.userId.text = [[NSString alloc]initWithFormat:@"%@*****", [[_dic objectForKey:@"id"] substringToIndex:4]];
        
        cell.hiddenId.text = [_dic objectForKey:@"id"];
        cell.hiddenName.text = [_dic objectForKey:@"name"];
        
    }else{
        NSDictionary *_dic = [_arrData objectAtIndex:indexPath.row];
        
        if ([sMode isEqualToString:@"2"]) {
            // 이름으로
            cell.name.text = [_dic objectForKey:@"m_nm"];
            cell.userId.text = [[NSString alloc]initWithFormat:@"%@*****", [[_dic objectForKey:@"m_id"] substringToIndex:4]];
            
        }else{
            // 아이디
            cell.name.text = [[NSString alloc]initWithFormat:@"%@*", [[_dic objectForKey:@"m_nm"]substringToIndex:2]];
            cell.userId.text = [_dic objectForKey:@"m_id"];
        }
        
        cell.hiddenId.text = [_dic objectForKey:@"m_id"];
        cell.hiddenName.text = [_dic objectForKey:@"m_nm"];
        
        if(indexPath.row == _nCheckedIndex){
            [cell.checkBtn setSelected:YES];
        }else{
            [cell.checkBtn setSelected:NO];
        }
        
        cell.checkBtn.tag = indexPath.row;
        [cell.checkBtn addTarget:self action:@selector(touchCheck:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(sectionCount == 0){
        return 0.0f;
    }
    
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *_customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 30)];

    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 125, 21)];
    titleName.text = @"쪽지를 보냈던 아이디";
    titleName.backgroundColor = [UIColor clearColor];
    titleName.textColor = [self getColor:@"0979B5"];
    titleName.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:12];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 350, 30)];
    [bgView setImage:[UIImage imageNamed:@"bg_stit@2x.png"]];
    
    [_customView addSubview:bgView];
    [_customView addSubview:titleName];
    
    return _customView;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)searchList{
    sectionCount = 0;
    
    [self initLoadBar];
    [self homeLoadBar];
    
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

@end

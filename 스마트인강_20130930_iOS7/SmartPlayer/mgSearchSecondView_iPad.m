//
//  mgSearchSecondView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchSecondView_iPad.h"
#import "mgSearchSecondCell_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"

@implementation mgSearchSecondView_iPad

@synthesize secondTable;
@synthesize titleText;

- (void)initMethod:(NSString *)class section:(NSString *)section category:(NSString *)category qCd:(NSString *)qCd qOrd:(NSString *)qOrd type:(NSString *)type domCd:(NSString *)domCd title:(NSString *)title{
    _sLecqTecCd = qOrd;
    _sLecdomCd = domCd;
    _sLecPageType = type;
    _sLecqCd = qCd;
    _sLecqOrd = qOrd;
    _sLecCategory = category;
    _sLecSection = section;
    _sLecClass = class;
    
    //선생님
    if([_sLecPageType isEqualToString:@"2"] == YES){
        titleText.text = @"개설분야";
        
        //학습
    }else{
        titleText.text = @"주제";
    }
    
    [self initData];
}

- (void)initData{
    [self initLoadBar];
    [self startLoadBar];
    
    if (_marrData == nil) {
        _marrData = [[NSMutableArray alloc]init];
    }
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_SEARCH_LIST];
    //NSLog(@"%@", url);
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]               forKey:@"acc_key"];
    [dic setObject:_sLecdomCd                               forKey:@"domCd"];       //영역
    [dic setObject:_sLecPageType                            forKey:@"pageType"];    //구분
    [dic setObject:_sLecqCd                                 forKey:@"qCd"];         //코드
    [dic setObject:@""                                      forKey:@"qOrd"];
    [dic setObject:_sLecqTecCd                              forKey:@"qTecCd"];      //선생님코드
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnSearchList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnSearchList){
        searchListData = [[NSMutableData alloc] init];
    }
}

#pragma mark -
#pragma mark UITableView DataSrouce & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _marrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgSearchSecondCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgSearchSecondCell_iPad identifier]];
    if (cell == nil) {
        cell = [mgSearchSecondCell_iPad create];
    }
    
    NSDictionary *dic = [_marrData objectAtIndex:indexPath.row];
    
    cell.titleText.text = [dic valueForKey:@"qNM"];
    
    cell.tag = indexPath.row;
    [cell.cellSelectedBtn addTarget:self action:@selector(touchCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

#pragma mark -
#pragma mark Button Action

- (void)touchCell:(id)sender{
    if([_sLecdomCd isEqualToString:@"2"] == YES){
        if([_sLecPageType isEqualToString:@"2"] == YES){
            mgSearchSecondCell_iPad *cell = (mgSearchSecondCell_iPad*)[[sender superview]superview];
            NSIndexPath *indexpath = [secondTable indexPathForCell:cell];
            
            NSDictionary *dic = [_marrData objectAtIndex:indexpath.row];
            
            thirdView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchThirdView_iPad" owner:self options:nil] objectAtIndex:0];
            thirdView.frame = CGRectMake(0, 0, 694, 655);
            _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
            [thirdView initMethod:[dic valueForKey:@"qOrd"] qCd:[dic valueForKey:@"qCd"] domCd:_sLecdomCd type:_sLecPageType tecCd:_sLecqTecCd title:_naviTitle];
            [self addSubview:thirdView];
            
            return;
        
        }else if([_sLecPageType isEqualToString:@"1"] == YES){
            mgSearchSecondCell_iPad *cell = (mgSearchSecondCell_iPad*)[[sender superview]superview];
            NSIndexPath *indexpath = [secondTable indexPathForCell:cell];
            
            NSDictionary *dic = [_marrData objectAtIndex:indexpath.row];
            
            mathView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchMathView_iPad" owner:self options:nil] objectAtIndex:0];
            mathView.frame = CGRectMake(0, 0, 694, 655);
            _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
            [mathView initMethod:[dic valueForKey:@"qOrd"] qCd:_sLecqCd domCd:_sLecdomCd type:_sLecPageType tecCd:_sLecqTecCd category:_sLecCategory section:_sLecSection title:_naviTitle];
            [self addSubview:mathView];
        }
        
    }else{
        mgSearchSecondCell_iPad *cell = (mgSearchSecondCell_iPad*)[[sender superview]superview];
        NSIndexPath *indexpath = [secondTable indexPathForCell:cell];
        
        NSDictionary *dic = [_marrData objectAtIndex:indexpath.row];
        
        thirdView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchThirdView_iPad" owner:self options:nil] objectAtIndex:0];
        thirdView.frame = CGRectMake(0, 0, 694, 655);
        _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
        [thirdView initMethod:[dic valueForKey:@"qOrd"] qCd:[dic valueForKey:@"qCd"] domCd:_sLecdomCd type:_sLecPageType tecCd:_sLecqTecCd title:_naviTitle];
        [self addSubview:thirdView];
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
    if (connection == urlConnSearchList) {
        [searchListData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    connection = nil;
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnSearchList) {
        NSString *encodeData = [[NSString alloc] initWithData:searchListData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"SearchList_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"SearchList_msg : %@", [dic valueForKey:@"msg"]);
        //NSLog(@"SearchList_dic : %@", dic);
        
        NSMutableArray *menuDataArr = [dic valueForKey:@"menuData"];
        
        NSDictionary *menuNM = [menuDataArr objectAtIndex:0];
        
        _marrData = [menuNM valueForKey:@"subData"];
        
        [self endLoadBar];
        
        if([_marrData count] == 0){
            return;
        }
        
        [secondTable reloadData];
    }
}

- (IBAction)backBtn:(id)sender {
    self.hidden = YES;
}

@end

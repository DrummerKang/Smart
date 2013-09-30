//
//  mgSearchFirstView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 6..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchFirstView_iPad.h"
#import "mgSearchFirstCell_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"

@implementation mgSearchFirstView_iPad

@synthesize _btnStepCate;
@synthesize _btnTecCate;
@synthesize firstTable;

- (void)initMethod:(NSString *)type cd:(NSString *)cd{
    [_btnStepCate setSelected:YES];
    
    _pageType = type;
    
    if([cd isEqualToString:@"3"] == YES){
        _domCd = @"5";
    }else if([cd isEqualToString:@"5"] == YES){
        _domCd = @"4";
    }else if([cd isEqualToString:@"4"] == YES){
        _domCd = @"3";
    }else{
        _domCd = cd;
    }
    
    [self dataLoad];
}

- (void)dataLoad{
    [self initLoadBar];
    [self searchLoadBar];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *URL = nil;
    if([_pageType isEqualToString:@"1"]){
        URL = URL_SEARCH_LIST;
    }else{
        URL = URL_SEARCH_LIST2;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:_domCd                               forKey:@"domCd"];
    [dic setObject:_pageType                            forKey:@"pageType"];
    [dic setObject:@""                                  forKey:@"qCd"];
    [dic setObject:@""                                  forKey:@"qOrd"];
    [dic setObject:@""                                  forKey:@"qTecCd"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnSearch = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnSearch){
        searchData = [[NSMutableData alloc] init];
    }
}

// 카테고리 스크롤뷰 초기화
- (void)initCategoryScrollV{
    BOOL isNew = false;
    
    for(int i = 0; i < [searchArr count]; i++){
        NSDictionary *menuNM = [searchArr objectAtIndex:i];
        //NSLog(@"nm : %@", menuNM);
        
        NSArray *subArr = [menuNM valueForKey:@"subData"];
        
        for(int j = 0; j < [subArr count]; j++){
            NSDictionary *subData = [subArr objectAtIndex:j];
            
            if ([subData valueForKey:@"qNew"] == nil) {
                isNew = false;
            }else{
                if([[subData valueForKey:@"qNew"]isEqualToString:@"Y"])
                    isNew = true;
                else
                    isNew = false;
            }
            
            
            [self addCategoryItem:[subData valueForKey:@"qNM"] isNew:isNew inSection:[menuNM valueForKey:@"menuNM"]];
        }
    }
    
    sectionCount = [searchArr count];
    [firstTable reloadData];
}

//카테고리 추가
- (void)addCategoryItem:(NSString*)name isNew:(BOOL)new inSection:(NSString *)section{
    if([_dicData objectForKey:section] == nil){
        NSMutableArray *_arrSection = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:name, @"name", new ? @"Y" : @"N" , @"new", nil], nil];
        
        [_dicData setObject:_arrSection forKey:section];
        [_arrHeaderOrder addObject:section];
        
    }else{
        NSMutableArray *_arrSection = (NSMutableArray*)[_dicData objectForKey:section];
        
        [_arrSection addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:name, @"name", new ? @"Y" : @"N", @"new", nil]];
        
        [_dicData setObject:_arrSection forKey:section];
    }
}

#pragma mark -
#pragma mark UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrHeaderOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *_arr = (NSMutableArray*)[_dicData objectForKey:[_arrHeaderOrder objectAtIndex:section]];

    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgSearchFirstCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgSearchFirstCell_iPad identifier]];
    if (cell == nil) {
        cell = [mgSearchFirstCell_iPad create];
    }
    
    int nSection = indexPath.section;
    int nRow = indexPath.row;
    
    UIImageView *newImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_new"]];
    [cell addSubview:newImage];
    
    //        NSMutableArray *_arr = (NSMutableArray*)[_dicData.allValues objectAtIndex:nSection];
    NSMutableArray *_arr = (NSMutableArray*)[_dicData objectForKey:[_arrHeaderOrder objectAtIndex:nSection]];
    
    cell.titleText.text = (NSString*)[[_arr objectAtIndex:nRow]valueForKey:@"name"];
    CGSize textSize = [[cell.titleText text] sizeWithFont:[cell.titleText font]];
    CGFloat strikeWidth = textSize.width;
    
    if ([[[_arr objectAtIndex:nRow]valueForKey:@"new"]isEqualToString:@"N"]) {
        newImage.hidden = true;
    }else{
        [newImage setFrame:CGRectMake(20 + strikeWidth + 5, 13, 23, 22)];
        newImage.hidden = false;
    }
    
    cell.tag = indexPath.row;
    [cell.cellSelectedBtn addTarget:self action:@selector(touchCell:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *_customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 694, 40)];
    
    UIImage *imgBackground = nil;
    UILabel *titleName;
    
    //    NSString *section_nm = [[_dicData allKeys]objectAtIndex:section];
    NSString *section_nm = [_arrHeaderOrder objectAtIndex:section];
    
    for(int i = 0; i < sectionCount; i++){
        NSString *imgName = [NSString stringWithFormat:@"P_ta_tit0%d", section+1];
        imgBackground = [UIImage imageNamed:imgName];
        
        titleName = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 252, 19)];
        titleName.text = section_nm;
        titleName.backgroundColor = [UIColor clearColor];
        titleName.textColor = [UIColor colorWithRed:255 / 255 green:255 / 255 blue:255 / 255 alpha:255 / 255];
        titleName.shadowColor = [UIColor colorWithRed:0 / 255 green:0 / 255 blue:0 / 255 alpha:0.3];
        titleName.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
    }
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 694, 40)];
    [bgView setImage:imgBackground];
    
    [_customView addSubview:bgView];
    [_customView addSubview:titleName];
    
    return _customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

#pragma mark -
#pragma mark Button Action

- (void)touchCell:(id)sender{
    mgSearchFirstCell_iPad *cell = (mgSearchFirstCell_iPad*)[[sender superview]superview];
    NSIndexPath *indexpath = [firstTable indexPathForCell:cell];
    
    _sLecSection = [[NSString alloc]initWithFormat:@"%@", [_arrHeaderOrder objectAtIndex:indexpath.section]];
    NSMutableArray *arr = (NSMutableArray*)[_dicData objectForKey:_sLecSection];
    _sLecCategory = [[NSString alloc]initWithFormat:@"%@", [[arr objectAtIndex:indexpath.row]valueForKey:@"name"]];
    
    //NSLog(@"%@", _sLecClass);
    //NSLog(@"%@", _sLecSection);
    //NSLog(@"%@", _sLecCategory);
    //NSLog(@"%@", _dicData);
    
    NSDictionary *dic = [searchArr objectAtIndex:indexpath.section];
    //NSLog(@"dic : %@", [dic valueForKey:@"subData"]);
    NSArray *dicArr = [dic valueForKey:@"subData"];
    NSDictionary *cellDic = [dicArr objectAtIndex:indexpath.row];
    
    _qCd = [cellDic valueForKey:@"qCd"];
    _qOrd = [cellDic valueForKey:@"qOrd"];
    
    if([_pageType isEqualToString:@"1"] == YES){
        naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecClass, _sLecSection, _sLecCategory];
    }else if([_pageType isEqualToString:@"2"] == YES){
        naviTitle = [[NSString alloc]initWithFormat:@"%@/%@", _sLecClass, _sLecCategory];
    }
    
    secondView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchSecondView_iPad" owner:self options:nil] objectAtIndex:0];
    secondView.frame = CGRectMake(0, 0, 694, 655);
    [secondView initMethod:_sLecClass section:_sLecSection category:_sLecCategory qCd:_qCd qOrd:_qOrd type:_pageType domCd:_domCd title:naviTitle];
    [self addSubview:secondView];
}

- (IBAction)lecBtn:(id)sender {
    [_btnStepCate setSelected:YES];
    [_btnTecCate setSelected:NO];
    
    _pageType = @"1";
    
    [self dataLoad];
}

- (IBAction)teacherBtn:(id)sender {
    [_btnStepCate setSelected:NO];
    [_btnTecCate setSelected:YES];
    
    _pageType = @"2";
    
    [self dataLoad];
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
    if (connection == urlConnSearch) {
        [searchData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self endLoadBar];
    connection = nil;
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        //NSLog(@"인터넷 연결 NO : 0");
        [self showAlertChoose:@"네트워크가 작동되지 않습니다. \n 재시도 하시겠습니까?" tag:TAG_MSG_NETWORK];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnSearch) {
        NSString *encodeData = [[NSString alloc] initWithData:searchData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"Search_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"Search_msg : %@", [dic valueForKey:@"msg"]);
        //NSLog(@"Search_dic : %@", dic);
        
        searchArr = [[NSMutableArray alloc] init];
        _dicData = [[NSMutableDictionary alloc]init];
        _arrHeaderOrder = [[NSMutableArray alloc]init];
        searchArr = [dic valueForKey:@"menuData"];
        
        [self endLoadBar];
        
        if([searchArr count] == 0){
            return;
        }
        
        [self initCategoryScrollV];
        
        searchDic = dic;
    }
}

@end

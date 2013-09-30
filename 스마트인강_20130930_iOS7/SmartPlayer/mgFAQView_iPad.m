//
//  mgFAQView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgFAQView_iPad.h"
#import "SBJsonParser.h"
#import "mgGlobal.h"
#import "mgFAQCell_iPad.h"
#import "mgCommon.h"

@implementation mgFAQView_iPad

static int itemPerPage = 10;

- (id)init{
    if ((self = [super init])) {
        [self initMethod];
        
        // 7.0이상
        if([mgCommon osVersion_7]){
            faqTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 48 + 20, 704, 606) style:UITableViewStylePlain];
        }else{
            faqTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, 704, 606) style:UITableViewStylePlain];
        }
    
		faqTable.delegate = self;
		faqTable.dataSource = self;
		faqTable.backgroundColor = [UIColor clearColor];
		faqTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:faqTable];
    }
    return self;
}

- (void)initMethod{
    if(marrFAQCat == nil){
        marrFAQCat = [[NSMutableArray alloc]init];
    }
    
    if(marrFAQList == nil){
        marrFAQList = [[NSMutableArray alloc]init];
    }
    
    startIndex = 0;
    totalIndex = 0;
    
    [self getFAQCateFromServer];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [faqTable addSubview:refreshControl];
    
    bFirstLoading = true;
}

- (void)refreshControlValueChanged{
    startIndex = 0;
    totalIndex = 0;
    
    for(UIView *view in self.subviews){
        if ([[[NSString alloc]initWithFormat:@"%@", [view class]]isEqualToString:@"UIButton"]) {
            UIButton *btn = (UIButton*)view;
            if ([btn isSelected]) {
                //NSLog(@"%@, %d", view, view.tag);
                
                //NSLog(@"%@", [marrFAQCat objectAtIndex:view.tag-1]);
                
                category_cd = [[marrFAQCat objectAtIndex:view.tag-1]valueForKey:@"cat_cd"];
            }
        }
    }
    
    if (![category_cd isEqualToString:@""] || category_cd != nil) {
        [self getFAQCateFromList:category_cd StartIndex:startIndex withCount:itemPerPage];
    }
}

- (void)getFAQCateFromServer{
    // 서버에 dday 설정을 보낸다.
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_FAQ_CAT];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:url]];
    
    connFAQCat = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != connFAQCat){
        dataFAQCat = [[NSMutableData alloc] init];
    }else{
        [dataFAQCat setLength:0];
    }
}

- (void)getFAQCateFromList:(NSString*)category StartIndex:(int)nStart withCount:(int)nCount{
    // 서버에 dday 설정을 보낸다.
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_FAQ_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    [dic setObject:category                                             forKey:@"cat_cd"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nStart]       forKey:@"startRowNum"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nCount]       forKey:@"itemPerpage"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    connFAQList = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (dataFAQList == nil){
        dataFAQList = [[NSMutableData alloc] init];
    }else{
        [dataFAQList setLength:0];
    }
    
    [self initLoadBar];
    [self startLoadBar];
}

- (void)touchCategory:(id)sender{
    UITapGestureRecognizer *tgr = (UITapGestureRecognizer*)sender;
    UIButton *btn = (UIButton*)tgr.view;
    
    [self touchCategoryWithButton:btn];
}

- (void)touchCategoryWithButton:(UIButton*)button{
    [self resetButtons];
    [button setSelected:YES];
    
    NSString *category = button.titleLabel.text;
    
    int nCnt = marrFAQCat.count;
    int nIdx = 0;
    if (nCnt > 0) {
        for (nIdx = 0; nIdx < nCnt; nIdx++) {
            NSString *cate_nm = [[marrFAQCat objectAtIndex:nIdx]objectForKey:@"cat_nm"];
            if ([cate_nm isEqualToString:category]) {
                startIndex = 0;
                totalIndex = 0;
                category_cd = [[marrFAQCat objectAtIndex:nIdx]objectForKey:@"cat_cd"];
                
                [self getFAQCateFromList:category_cd StartIndex:startIndex withCount:itemPerPage];
            }
        }
    }
}

- (void)resetButtons{
    for (UIView *view in self.subviews) {
        if ([view class] == [UIButton class]) {
            UIButton *btn = (UIButton*)view;
            [btn setSelected:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height){
        for (UIView *view in self.subviews) {
            if ([[[NSString alloc]initWithFormat:@"%@",[view class]]isEqualToString:@"UIButton"]) {
                UIButton *btn = (UIButton*)view;
                if ([btn isSelected]) {
                    category_cd = [marrFAQCat objectAtIndex:btn.tag-1];
                }
            }
        }
        
        if (startIndex < totalIndex) {
            startIndex += (itemPerPage+1);
            [self getFAQCateFromList:category_cd StartIndex:startIndex withCount:itemPerPage];
        }
    }
}

#pragma mark -
#pragma mark UITableView Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return marrFAQList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = [marrFAQList objectAtIndex:indexPath.row];
    
    mgFAQCell_iPad *cell = (mgFAQCell_iPad *)[tableView dequeueReusableCellWithIdentifier:@"mgFAQCell_iPad"];
    if (cell == nil){
        cell = [[mgFAQCell_iPad alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mgFAQCell_iPad"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.titleText.text = [[NSString alloc]initWithFormat:@"[%@] %@", [dic objectForKey:@"cat_nm"], [dic objectForKey:@"title"]];
    cell.cellSelectedBtn.tag = indexPath.row;
    [cell.cellSelectedBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)touchAction:(UIButton *)sender{
    NSMutableDictionary *dic = [marrFAQList objectAtIndex:sender.tag];
    NSString *title = [[NSString alloc]initWithFormat:@"[%@] %@", [dic objectForKey:@"cat_nm"],[dic objectForKey:@"title"]];
    NSString *fidx = [dic valueForKey:@"fidx"];
	NSDictionary *dicData = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", fidx, @"fidx", nil];
    
    faqDetailView = [[mgFAQDetailView_iPad alloc] initWithData:dicData];
    faqDetailView.frame = CGRectMake(0, 0, 704, 654);
    [self addSubview:faqDetailView];
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
    if (connFAQCat == connection) {
        [dataFAQCat appendData:data];
    }else if(connFAQList == connection){
        [dataFAQList appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    [self endLoadBar];
    
    if([ASIHTTPRequest isNetworkReachableViaWWAN] == 0){
        ////NSLog(@"인터넷 연결 NO : 0");
        [self showAlertChoose:@"네트워크가 작동되지 않습니다. \n 재시도 하시겠습니까?" tag:TAG_MSG_NETWORK];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connFAQCat == connection) {
        NSString *encodeData = [[NSString alloc] initWithData:dataFAQCat encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            marrFAQCat = [dic objectForKey:@"aData"];
            
            if([marrFAQCat count] == 0){
                return;
            }
            
            CGFloat btn_width = 704.0f / marrFAQCat.count;
            int idx = 0;
            
            for (NSMutableDictionary *cate in marrFAQCat) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                // 7.0이상
                if([mgCommon osVersion_7]){
                    [btn setFrame:CGRectMake(idx * btn_width, 0 + 20, btn_width, 48)];
                }else{
                    [btn setFrame:CGRectMake(idx * btn_width, 0, btn_width, 48)];
                }
                
                [btn setBackgroundImage:[[UIImage imageNamed:@"_btn_faq_normal"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateNormal];
                [btn setBackgroundImage:[[UIImage imageNamed:@"_btn_faq_pressed"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[[UIImage imageNamed:@"_btn_faq_pressed"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateSelected];
                
                [btn setTitle:[[marrFAQCat objectAtIndex:idx]objectForKey:@"cat_nm"] forState:UIControlStateNormal];
                [btn setTitle:[[marrFAQCat objectAtIndex:idx]objectForKey:@"cat_nm"] forState:UIControlStateHighlighted];
                [btn setTitle:[[marrFAQCat objectAtIndex:idx]objectForKey:@"cat_nm"] forState:UIControlStateSelected];
                
                [btn setTitleColor:[[UIColor alloc]initWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [btn setTitleColor:[[UIColor alloc]initWithRed:0.0f/255.0f green:142.0f/255.0f blue:216.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
                [btn setTitleColor:[[UIColor alloc]initWithRed:0.0f/255.0f green:142.0f/255.0f blue:216.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
                
                btn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:15];
                btn.tag = idx+1;
                
                touchCatTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCategory:)];
                [btn addGestureRecognizer:touchCatTGR];
                
                [self addSubview:btn];
                
                idx++;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if(connFAQList == connection){
        NSString *encodeData = [[NSString alloc] initWithData:dataFAQList encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        if ([[dic objectForKey:@"result"]isEqualToString:@"0000"]) {
            
            totalIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"tot_cnt"]intValue];
            
            NSMutableArray *marr = [dic objectForKey:@"aData"];
            if (startIndex == 0) {
                [marrFAQList removeAllObjects];
            }
            [marrFAQList addObjectsFromArray:marr];
            
            [faqTable reloadData];
            
            [refreshControl endRefreshing];
            
        }else{
            [self showAlert:[dic objectForKey:@"msg"] tag:TAG_MSG_NONE];
            
            [refreshControl endRefreshing];
        }
    }
    
    if (bFirstLoading) {
        if (marrFAQCat.count > 0) {
            NSMutableDictionary *dic = [marrFAQCat objectAtIndex:0];
            NSString *cat_nm = [dic objectForKey:@"cat_nm"];
            NSString *cat_cd = [dic objectForKey:@"cat_cd"];
            
            for (UIView *view in self.subviews) {
                if ([view class] == [UIButton class]) {
                    UIButton *btn = (UIButton*)view;
                    
                    if ([btn.titleLabel.text isEqualToString:cat_nm]) {
                        startIndex = 0;
                        totalIndex = 0;
                        [self getFAQCateFromList:cat_cd StartIndex:startIndex withCount:itemPerPage];
                        
                        [btn setSelected:YES];
                    }
                }
            }
        }
        
        bFirstLoading = false;
    }
    
    [self endLoadBar];
}

@end

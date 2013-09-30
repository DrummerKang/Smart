//
//  mgAskLecView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecView_iPad.h"
#import "AquaDBManager.h"
#import "mgAskLecCellView_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"

@implementation mgAskLecView_iPad

@synthesize askTable;
@synthesize bgNoImage;
@synthesize imgBg;
@synthesize openBtn;
@synthesize closeBtn;
@synthesize lecListBtn;
@synthesize downloadBtn;
@synthesize myLecBtn;
@synthesize allBtn;

static int itemAllPage = 10;
static int itemMyPage = 10;
static int CURR_IDX = 0;

- (void)initMethod:(NSString *)brd no:(NSString *)no seq:(NSString *)seq cd:(NSString *)cd nm:(NSString *)nm{
    expandedRowIndex = -1;
    
    brd_cd = brd;
    app_no = no;
    app_seq = seq;
    chr_cd = cd;
    chr_nm = nm;
    
    startAllIndex = 0;
    totalAllIndex = 0;
    startMyIndex = 0;
    totalMyIndex = 0;
    
    [myLecBtn setSelected:YES];
    
    [imgBg setImage:[[UIImage imageNamed:@"P_bg_tab"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self myLecAction:nil];
    [self myQna:startMyIndex count:totalMyIndex];
}

//내 질문
- (void)myQna:(int)nStart count:(int)nCount{
    myFlg = @"Y";
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_QNA_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
    [dic setObject:app_no                               forKey:@"app_no"];
    [dic setObject:app_seq                              forKey:@"app_seq"];
    [dic setObject:chr_cd                               forKey:@"chr_cd"];
    [dic setObject:myFlg                                forKey:@"myflg"];
    [dic setObject:@"0"                                 forKey:@"startRowNum"];
    [dic setObject:@"10"                                forKey:@"itemPerPage"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnMyQna = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (myQnaData == nil){
        myQnaData = [[NSMutableData alloc] init];
    }else{
        [myQnaData setLength:0];
    }
    
    //[self initLoadBar];
    //[self startLoadBar];
}

//전체 질문
- (void)myAll:(int)nStart count:(int)nCount idx:(int)idx{
    myFlg = @"N";
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_QNA_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [dic setObject:[_app._account getAcc_key]                       forKey:@"acc_key"];
    [dic setObject:app_no                                           forKey:@"app_no"];
    [dic setObject:app_seq                                          forKey:@"app_seq"];
    [dic setObject:chr_cd                                           forKey:@"chr_cd"];
    [dic setObject:myFlg                                            forKey:@"myflg"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nStart]   forKey:@"startRowNum"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", nCount]   forKey:@"itemPerPage"];
    [dic setObject:[[NSString alloc]initWithFormat:@"%d", idx]   forKey:@"CURR_IDX"];
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnQnaAll = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (qnaALL == nil){
        qnaALL = [[NSMutableData alloc] init];
    }else{
        [qnaALL setLength:0];
    }
    
    [self initLoadBar];
    [self homeLoadBar];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (askCount > 0) {
        bgNoImage.hidden = YES;
    }
    return askCount + (expandedRowIndex != -1 ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgAskLecCellView_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgAskLecCellView_iPad identifier]];
    if (cell == nil) {
        cell = [mgAskLecCellView_iPad create];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:indexPath.row];
    NSInteger dataIndex = [self dataIndexForRowIndex:indexPath.row];
    NSLog(@"%d", dataIndex);
    
    BOOL expandedCell = expandedRowIndex != -1 && expandedRowIndex + 1 == indexPath.row;
    
    if (!expandedCell){
        cell.titleName.text = [aData valueForKey:@"TITLE"];
        cell.userName.text = [aData valueForKey:@"NM"];
        cell.dayName.text = [aData valueForKey:@"DT"];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 31, 18)];
        [cell addSubview:leftImage];
        
        if([[aData valueForKey:@"DS_FLG"] isEqual:@"교재"] == YES){
            leftImage.image = [UIImage imageNamed:@"_icon_BookType.png"];
            
        }else{
            leftImage.image = [UIImage imageNamed:@"ico_lecture"];
        }
        
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(631, 29, 48, 18)];
        [cell addSubview:rightImage];
        
        if([[aData valueForKey:@"RES_FLG"] isEqual:@"0"] == YES){
            rightImage.image = [UIImage imageNamed:@"_icon_waitAnswer"];
            
        }else{
            rightImage.image = [UIImage imageNamed:@"_icon_cpltAnswer"];
        }
        
        return cell;

    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expanded"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"expanded"];

        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(55, 10, 77, 28);
        detailBtn.exclusiveTouch = YES;
        [detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_normal"] forState:UIControlStateNormal];
        [detailBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_pressed"] forState:UIControlStateHighlighted];
        [detailBtn setTitle:@"상세보기" forState:UIControlStateNormal];
        [detailBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateNormal];
        [detailBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateHighlighted];
        detailBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        detailBtn.tag = indexPath.row;
        [cell addSubview:detailBtn];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(138, 10, 77, 28);
        editBtn.exclusiveTouch = YES;
        [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_normal"] forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_pressed"] forState:UIControlStateHighlighted];
        [editBtn setTitle:@"수정하기" forState:UIControlStateNormal];
        [editBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateNormal];
        [editBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateHighlighted];
        editBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        editBtn.tag = indexPath.row;
        [cell addSubview:editBtn];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(221, 10, 77, 28);
        [delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_normal"] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"P_btn_list_pressed"] forState:UIControlStateHighlighted];
        [delBtn setTitle:@"삭제하기" forState:UIControlStateNormal];
        [delBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateNormal];
        [delBtn setTitleColor:[self getColor:@"555555"] forState:UIControlStateHighlighted];
        delBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
        delBtn.tag = indexPath.row;
        [cell addSubview:delBtn];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellList"]];
        lineImage.frame = CGRectMake(0, 49, 694, 1);
        [cell addSubview:lineImage];
        
        //답변완료
        if([[aData valueForKey:@"RES_FLG"] isEqual:@"1"] == YES){
            return cell;
            
        //미답변
        }else if([[aData valueForKey:@"RES_FLG"] isEqual:@"0"] == YES){
            //PC작성
            if([[aData valueForKey:@"MB_FLG"] isEqual:@"0"] == YES){
                return cell;
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
                [editBtn setSelected:NO];
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"2"] == YES){
                [detailBtn setEnabled:NO];
                [editBtn setEnabled:NO];
            }
            
        //모바일 작성
        }else if([[aData valueForKey:@"MB_FLG"] isEqual:@"1"] == YES){
            if([[aData valueForKey:@"MY_FLG"] isEqual:@"0"] == YES){
                return cell;
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
            }
        }
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (expandedRowIndex != -1 && indexPath.row == expandedRowIndex + 1)
        return 50;
    
    return 67;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:row];

    //답변완료
    if([[aData valueForKey:@"RES_FLG"] isEqual:@"1"] == YES){
        NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
        NSDictionary *dic = [aDataArr objectAtIndex:row];
        
        detailView = [[mgAskLecDetailView_iPad alloc] init];
        [detailView initMethod:app_no app_seq:app_seq chr_cd:chr_cd brd_cd:[dic valueForKey:@"BRD_CD"] bidx:[dic valueForKey:@"BIDX"]];
        detailView.frame = CGRectMake(0, 0, 694, 675);
        [self addSubview:detailView];
        
        return nil;
    
    //미답변
    }else if([[aData valueForKey:@"RES_FLG"] isEqual:@"0"] == YES){
        //PC작성
        if([[aData valueForKey:@"MB_FLG"] isEqual:@"0"] == YES){
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dic = [aDataArr objectAtIndex:row];
            
            detailView = [[mgAskLecDetailView_iPad alloc] init];
            [detailView initMethod:app_no app_seq:app_seq chr_cd:chr_cd brd_cd:[dic valueForKey:@"BRD_CD"] bidx:[dic valueForKey:@"BIDX"]];
            detailView.frame = CGRectMake(0, 0, 694, 675);
            [self addSubview:detailView];
            
            return nil;
            
        }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
        }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"2"] == YES){
        }
    
    //모바일 작성
    }else if([[aData valueForKey:@"MB_FLG"] isEqual:@"1"] == YES){
        if([[aData valueForKey:@"MY_FLG"] isEqual:@"0"] == YES){
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dic = [aDataArr objectAtIndex:row];
            
            detailView = [[mgAskLecDetailView_iPad alloc] init];
            [detailView initMethod:app_no app_seq:app_seq chr_cd:chr_cd brd_cd:[dic valueForKey:@"BRD_CD"] bidx:[dic valueForKey:@"BIDX"]];
            detailView.frame = CGRectMake(0, 0, 694, 675);
            [self addSubview:detailView];
            
            return nil;
        }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
        }
    }
    
    BOOL preventReopen = NO;
    
    if (row == expandedRowIndex + 1 && expandedRowIndex != -1)
        return nil;
    
    [tableView beginUpdates];
    
    if (expandedRowIndex != -1){
        NSInteger rowToRemove = expandedRowIndex + 1;
        
        preventReopen = row == expandedRowIndex;
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    NSInteger rowToAdd = -1;
    if (!preventReopen){
        rowToAdd = row + 1;
        expandedRowIndex = row;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [tableView endUpdates];
    
    return nil;
}

- (NSInteger)dataIndexForRowIndex:(NSInteger)row
{
    if (expandedRowIndex != -1 && expandedRowIndex <= row)
    {
        if (expandedRowIndex == row)
            return row;
        else
            return row - 1;
    }
    else
        return row;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height)
    {
        if([myFlg isEqualToString:@"Y"] == YES){
            if (startMyIndex < totalMyIndex) {
                startMyIndex += (itemMyPage);
                [self myQna:0 count:itemMyPage + 10];
            }
            
        }else if([myFlg isEqualToString:@"N"] == YES){
            if (startAllIndex < totalAllIndex) {
                startAllIndex += (itemAllPage);
                [self myAll:0 count:itemAllPage + 10 idx:currAllIndex];
            }
        }
    }
}

#pragma mark -
#pragma mark Button Action

- (void)detailAction:(UIButton *)sender{
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *dic = [aDataArr objectAtIndex:sender.tag - 1];
    
    detailView = [[mgAskLecDetailView_iPad alloc] init];
    [detailView initMethod:app_no app_seq:app_seq chr_cd:chr_cd brd_cd:[dic valueForKey:@"BRD_CD"] bidx:[dic valueForKey:@"BIDX"]];
    detailView.frame = CGRectMake(0, 0, 694, 675);
    [self addSubview:detailView];
}

- (void)editAction:(UIButton *)sender{
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *dic = [aDataArr objectAtIndex:sender.tag - 1];
    
    NSDictionary *editDic = [NSDictionary dictionaryWithObjectsAndKeys:app_no, @"app_no", app_seq, @"app_seq", chr_cd, @"chr_cd", [dic objectForKey:@"BRD_CD"], @"brd_cd", [dic objectForKey:@"BIDX"], @"bidx", nil];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"lecEdit" object:self userInfo:editDic];
}

- (void)delAction:(UIButton *)sender{
    delNum = sender.tag - 1;
    
    [self showAlertChoose:@"강좌에 대한 질문을 삭제하시겠습니까?" tag:TAG_MSG_LECDEL];
}

- (IBAction)openBtn:(id)sender {
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    
    if([downloadArr count] == 0){
        downloadBtn.hidden = YES;
    }
    
    [self closeMove];
}

- (IBAction)closeBtn:(id)sender {
    [self downloadCheck];
    
    openBtn.hidden = NO;
    closeBtn.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationRepeatCount:1];
    
    [lecListBtn setFrame:CGRectMake(544+160, 603, 114, 44)];
    [downloadBtn setFrame:CGRectMake(614, 603, 44, 44)];
    
    [UIView commitAnimations];
}

- (IBAction)lecListBtn:(id)sender {
    self.hidden = YES;
}

- (void)downloadCheck{
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    
    if([downloadArr count] == 0){
        downloadBtn.hidden = YES;
        
    }else{
        downloadBtn.hidden = NO;
    }
}

- (void)closeMove{
    closeBtn.hidden = NO;
    openBtn.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationRepeatCount:1];
    
    [lecListBtn setFrame:CGRectMake(544, 603, 114, 44)];
    [downloadBtn setFrame:CGRectMake(492, 603, 44, 44)];
    
    [UIView commitAnimations];
}

- (IBAction)downloadBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PopupDownloadList" object:nil];
}

- (IBAction)myLecAction:(id)sender {
    [myLecBtn setSelected:YES];
    [allBtn setSelected:NO];
    
    startMyIndex = 0;
    itemMyPage = 10;
    
    [self myQna:startMyIndex count:itemMyPage];
}

- (IBAction)allAction:(id)sender {
    [myLecBtn setSelected:NO];
    [allBtn setSelected:YES];
    
    startAllIndex = 0;
    itemAllPage = 10;
    CURR_IDX = 0;
    [self myAll:startAllIndex count:itemAllPage idx:CURR_IDX];
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
    if (connection == urlConnMyQna) {
        [myQnaData appendData:data];
    }else if(connection == urlConnQnaAll){
        [qnaALL appendData:data];
    }else if(connection == urlConnDel){
        [delData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // NSURLConnection 연결 이후 오류 발생시 호출
    connection = nil;
    
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnMyQna) {
        NSString *encodeData = [[NSString alloc] initWithData:myQnaData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        NSArray *dicArr = [dic valueForKey:@"aData"];
        askCount = [dicArr count];
        qnaDic = dic;
        
        //NSLog(@"My질문_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"My질문_msg : %@", [dic valueForKey:@"msg"]);
        //NSLog(@"My질문_dic : %@", dic);
        
        totalMyIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"TOT_CNT"]intValue];
        
        if(askCount == 0){
            bgNoImage.hidden = NO;
        }
        
        [self endLoadBar];
        [askTable reloadData];
        
    }else if(connection == urlConnQnaAll){
        NSString *encodeData = [[NSString alloc] initWithData:qnaALL encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        NSArray *dicArr = [dic valueForKey:@"aData"];
        askCount = [dicArr count];
        qnaDic = dic;
        
        //NSLog(@"All질문_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"All질문_msg : %@", [dic valueForKey:@"msg"]);
        //NSLog(@"All질문_dic : %@", dic);
        
        totalAllIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"TOT_CNT"]intValue];
        currAllIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"CURR_IDX"]intValue];
        
        if(askCount == 0){
            bgNoImage.hidden = NO;
        }else{
            bgNoImage.hidden = YES;
        }
        
        [askTable reloadData];
        
    }else if(connection == urlConnDel){
        NSString *encodeData = [[NSString alloc] initWithData:delData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"질문삭제_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"질문삭제_msg : %@", [dic valueForKey:@"msg"]);
        
        if([[dic valueForKey:@"result"] isEqualToString:@"0000"] == YES){
            [self showAlert:[dic valueForKey:@"msg"] tag:TAG_MSG_QNA_DEL];
            
        }else{
            [self showAlert:[dic valueForKey:@"msg"] tag:TAG_MSG_NONE];
        }
    }
    
    [self endLoadBar];
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_QNA_DEL){
        if([myFlg isEqualToString:@"Y"] == YES){
            [self myQna:startMyIndex count:totalMyIndex];
            
        }else if([myFlg isEqualToString:@"N"] == YES){
            [self myAll:startAllIndex count:totalAllIndex idx:currAllIndex];
        }
    }
	
	if ( alertView.tag == TAG_MSG_LECDEL ) {
        if(buttonIndex == 1){
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dicData = [aDataArr objectAtIndex:delNum];
            
            NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_QNADEL];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            // @param POST와 GET 방식을 나타냄.
            [request setHTTPMethod:@"POST"];
            
            // 파라메터를 NSDictionary에 저장
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:7];
            
            [dic setObject:[_app._account getAcc_key]           forKey:@"acc_key"];
            [dic setObject:app_no                               forKey:@"app_no"];
            [dic setObject:app_seq                              forKey:@"app_seq"];
            [dic setObject:chr_cd                               forKey:@"chr_cd"];
            [dic setObject:[dicData valueForKey:@"BRD_CD"]      forKey:@"brd_cd"];
            [dic setObject:[dicData valueForKey:@"BIDX"]        forKey:@"bidx"];
            [dic setObject:@"del"                               forKey:@"method"];
            
            // NSDictionary에 저장된 파라메터를 NSArray로 제작
            NSArray * params = [self generatorParameters:dic];
            
            // POST로 파라메터 넘기기
            [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
            urlConnDel = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (nil != urlConnDel){
                delData = [[NSMutableData alloc] init];
            }
        }
    }
}

@end

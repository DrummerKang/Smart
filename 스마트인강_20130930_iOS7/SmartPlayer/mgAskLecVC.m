//
//  mgAskLecVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 5. 20..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgAskLecVC.h"
#import "mgGlobal.h"
#import "JSON.h"
#import "mgAskLecDetailVC.h"
#import "mgAskLecEditVC.h"
#import "mgAskLecDetailVC.h"
#import "mgAskLecWriteVC.h"
#import "AquaDBManager.h"
#import "mgCommon.h"

@interface mgAskLecVC ()
{
    int startAllIndex;
    int totalAllIndex;
    int currAllIndex;
    int startMyIndex;
    int totalMyIndex;
    
    UIButton *questionBtn;
}

@end

@implementation mgAskLecVC

@synthesize askLecTable;
@synthesize myQnaBtn;
@synthesize allQnaBtn;

@synthesize brd_cd;
@synthesize app_no;
@synthesize app_seq;
@synthesize chr_cd;
@synthesize chr_nm;

@synthesize moveOpenBtn;
@synthesize moveCloseBtn;
@synthesize lecBackBtn;
@synthesize downloadBtn;

@synthesize _imgBack1;

@synthesize bgNoImage;
@synthesize askListNavigationBar;

static int itemAllPage = 10;
static int itemMyPage = 10;
static int CURR_IDX = 0;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [askListNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    askListNavigationBar.translucent = NO;
    [askListNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                           [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                           [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    startAllIndex = 0;
    totalAllIndex = 0;
    startMyIndex = 0;
    totalMyIndex = 0;
    
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // 배경 입히기
    [_imgBack1 setImage:[[UIImage imageNamed:@"bg_talk_search"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self myQnaBtn:nil];
    [self myQna:startMyIndex count:totalMyIndex];
    
    questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        questionBtn.frame = CGRectMake(255, 27, 60, 30);
    }else {
        questionBtn.frame = CGRectMake(255, 7, 60, 30);
    }
    
    [questionBtn addTarget:self action:@selector(questionAction) forControlEvents:UIControlEventTouchUpInside];
    [questionBtn setTitle:@"질문하기" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self.view addSubview:questionBtn];
}

- (void)viewDidUnload {
    [self setAskLecTable:nil];
    [self setMyQnaBtn:nil];
    [self setAllQnaBtn:nil];
    [self set_imgBack1:nil];
    [self setLecBackBtn:nil];
    [self setMoveOpenBtn:nil];
    [self setMoveCloseBtn:nil];
    [self setBgNoImage:nil];
    [self setDownloadBtn:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    [self downloadCheck];
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
    
    [self initLoadBar];
    [self startLoadBar];
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
    [self startLoadBar];
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
    return askCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"myQnaAnsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:indexPath.row];
    
    UILabel* titleName = (UILabel*)[cell viewWithTag:1];
    titleName.text = [aData valueForKey:@"TITLE"];
    
    UILabel* infoName = (UILabel*)[cell viewWithTag:2];
    infoName.text = [aData valueForKey:@"NM"];
    
    UIImageView *lecBookImage = (UIImageView *)[cell viewWithTag:4];
    if([[aData valueForKey:@"DS_FLG"] isEqual:@"교재"] == YES){
        lecBookImage.image = [UIImage imageNamed:@"_icon_BookType.png"];
        
    }else{
        lecBookImage.image = [UIImage imageNamed:@"ico_lecture"];
    }
    
    UIImageView *answerImage = (UIImageView *)[cell viewWithTag:5];
    if([[aData valueForKey:@"RES_FLG"] isEqual:@"0"] == YES){
        answerImage.image = [UIImage imageNamed:@"_icon_waitAnswer"];
        
    }else{
        answerImage.image = [UIImage imageNamed:@"_icon_cpltAnswer"];
    }
    
    UILabel* day = (UILabel*)[cell viewWithTag:3];
    day.text = [aData valueForKey:@"DT"];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
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

- (IBAction)cellSelectedBtn:(id)sender {
    NSIndexPath *indexPath = [askLecTable indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSInteger nIndex = indexPath.row;
    //NSLog(@"nIndex : %d", nIndex);
    
    NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
    NSDictionary *aData = [aDataArr objectAtIndex:nIndex];
    
    //답변완료
    if([[aData valueForKey:@"RES_FLG"] isEqual:@"1"] == YES){
        UIStoryboard *_newStoryboard = nil;
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail4" bundle:nil];
        }else{
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail" bundle:nil];
        }

        mgAskLecDetailVC *_detailVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecDetailVC"];
        NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
        NSDictionary *dic = [aDataArr objectAtIndex:nIndex];
        
        UITableViewCell *cell = (UITableViewCell*)[[sender superview]superview];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        
        _detailVC.title = title.text;
        _detailVC.app_no = app_no;
        _detailVC.app_seq = app_seq;
        _detailVC.chr_cd = chr_cd;
        _detailVC.brd_cd = [dic valueForKey:@"BRD_CD"];
        _detailVC.bidx = [dic valueForKey:@"BIDX"];
        [self.navigationController pushViewController:_detailVC animated:YES];
        
        return;
        
    //미답변
    }else if([[aData valueForKey:@"RES_FLG"] isEqual:@"0"] == YES){
        //PC작성
        if([[aData valueForKey:@"MB_FLG"] isEqual:@"0"] == YES){
            if([[aData valueForKey:@"MY_FLG"] isEqual:@"0"] == YES){
                UIStoryboard *_newStoryboard = nil;
                //4인치 화면
                if ([mgCommon hasFourInchDisplay]) {
                    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail4" bundle:nil];
                }else{
                    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail" bundle:nil];
                }
                
                mgAskLecDetailVC *_detailVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecDetailVC"];
                NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
                NSDictionary *dic = [aDataArr objectAtIndex:nIndex];
                
                UITableViewCell *cell = (UITableViewCell*)[[sender superview]superview];
                UILabel *title = (UILabel*)[cell viewWithTag:1];
                
                _detailVC.title = title.text;
                _detailVC.app_no = app_no;
                _detailVC.app_seq = app_seq;
                _detailVC.chr_cd = chr_cd;
                _detailVC.brd_cd = [dic valueForKey:@"BRD_CD"];
                _detailVC.bidx = [dic valueForKey:@"BIDX"];
                [self.navigationController pushViewController:_detailVC animated:YES];
                
                return;
                
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
                editNum = nIndex;
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"상세보기", @"삭제하기", nil];
                sheet.actionSheetStyle = UIActionSheetStyleDefault;
                sheet.tag = 0;
                [sheet showInView:self.view];
                
                return;
            
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"2"] == YES){
                editNum = nIndex;
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"삭제하기", nil];
                sheet.actionSheetStyle = UIActionSheetStyleDefault;
                sheet.tag = 2;
                [sheet showInView:self.view];
                
                return;
            }
        
            //모바일 작성
        }else if([[aData valueForKey:@"MB_FLG"] isEqual:@"1"] == YES){
            if([[aData valueForKey:@"MY_FLG"] isEqual:@"0"] == YES){
                UIStoryboard *_newStoryboard = nil;
                //4인치 화면
                if ([mgCommon hasFourInchDisplay]) {
                    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail4" bundle:nil];
                }else{
                    _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail" bundle:nil];
                }
                
                mgAskLecDetailVC *_detailVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecDetailVC"];
                NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
                NSDictionary *dic = [aDataArr objectAtIndex:nIndex];
                
                UITableViewCell *cell = (UITableViewCell*)[[sender superview]superview];
                UILabel *title = (UILabel*)[cell viewWithTag:1];
                
                _detailVC.title = title.text;
                _detailVC.app_no = app_no;
                _detailVC.app_seq = app_seq;
                _detailVC.chr_cd = chr_cd;
                _detailVC.brd_cd = [dic valueForKey:@"BRD_CD"];
                _detailVC.bidx = [dic valueForKey:@"BIDX"];
                [self.navigationController pushViewController:_detailVC animated:YES];
                
                return;
                
            }else if([[aData valueForKey:@"MY_FLG"] isEqual:@"1"] == YES){
                editNum = nIndex;
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                sheet.tag = 1;
                [sheet addButtonWithTitle:@"상세보기"];
                [sheet addButtonWithTitle:@"수정하기"];
                [sheet addButtonWithTitle:@"삭제하기"];
                
                [sheet addButtonWithTitle:@"취소"];
                sheet.cancelButtonIndex = sheet.numberOfButtons-1;
                
                [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
                
                return;
            }
        }
    }
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

- (IBAction)downloadBtn:(id)sender {
    [self openMove];
    
    if (_app._downloadVC != nil) {
        [self.navigationController pushViewController:_app._downloadVC animated:YES];
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeMove{
    moveCloseBtn.hidden = YES;
    moveOpenBtn.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationRepeatCount:1];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            [lecBackBtn setFrame:CGRectMake(-114, 509, 114, 44)];
            [downloadBtn setFrame:CGRectMake(30, 509, 44, 44)];
            
        }else{
            [lecBackBtn setFrame:CGRectMake(-114, 424, 114, 44)];
            [downloadBtn setFrame:CGRectMake(30, 424, 44, 44)];
        }
        
    }else {
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            [lecBackBtn setFrame:CGRectMake(-114, 489, 114, 44)];
            [downloadBtn setFrame:CGRectMake(30, 489, 44, 44)];
            
        }else{
            [lecBackBtn setFrame:CGRectMake(-114, 404, 114, 44)];
            [downloadBtn setFrame:CGRectMake(30, 404, 44, 44)];
        }
    }
    
    [UIView commitAnimations];
    
    [lecBackBtn removeFromSuperview];
    [self.view addSubview:lecBackBtn];
    
    [downloadBtn removeFromSuperview];
    [self.view addSubview:downloadBtn];
}

- (void)openMove{
    moveCloseBtn.hidden = NO;
    moveOpenBtn.hidden = YES;
}

- (IBAction)moveCloseBtn:(id)sender {
    [self downloadCheck];
    
    [self closeMove];
}

- (IBAction)moveOpenBtn:(id)sender {
    [self downloadCheck];
    
    moveOpenBtn.hidden = YES;
    moveCloseBtn.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationRepeatCount:1];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            [lecBackBtn setFrame:CGRectMake(30, 509, 114, 44)];
            [downloadBtn setFrame:CGRectMake(146, 509, 44, 44)];
            
        }else{
            [lecBackBtn setFrame:CGRectMake(30, 424, 114, 44)];
            [downloadBtn setFrame:CGRectMake(146, 424, 44, 44)];
        }
        
    }else {
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            [lecBackBtn setFrame:CGRectMake(30, 489, 114, 44)];
            [downloadBtn setFrame:CGRectMake(146, 489, 44, 44)];
            
        }else{
            [lecBackBtn setFrame:CGRectMake(30, 404, 114, 44)];
            [downloadBtn setFrame:CGRectMake(146, 404, 44, 44)];
        }
    }
    
    [UIView commitAnimations];
    
    [lecBackBtn removeFromSuperview];
    [self.view addSubview:lecBackBtn];
    
    [downloadBtn removeFromSuperview];
    [self.view addSubview:downloadBtn];
}

- (IBAction)lecBackBtn:(id)sender {
    [self closeMove];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)myQnaBtn:(id)sender {
    [myQnaBtn setSelected:YES];
    [allQnaBtn setSelected:NO];
    
    startMyIndex = 0;
    itemMyPage = 10;
    
    [self myQna:startMyIndex count:itemMyPage];
}

- (IBAction)allQnaBtn:(id)sender {
    [myQnaBtn setSelected:NO];
    [allQnaBtn setSelected:YES];
    
    startAllIndex = 0;
    itemAllPage = 10;
    CURR_IDX = 0;    
    [self myAll:startAllIndex count:itemAllPage idx:CURR_IDX];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 0){
        //상세보기
        if(buttonIndex == 0){
            UIStoryboard *_newStoryboard = nil;
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail" bundle:nil];
            }
            
            mgAskLecDetailVC *_detailVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecDetailVC"];
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dic = [aDataArr objectAtIndex:editNum];
            _detailVC.app_no = app_no;
            _detailVC.app_seq = app_seq;
            _detailVC.chr_cd = chr_cd;
            _detailVC.brd_cd = [dic valueForKey:@"BRD_CD"];
            _detailVC.bidx = [dic valueForKey:@"BIDX"];
            [self.navigationController pushViewController:_detailVC animated:YES];
        }
        
        //삭제하기
        if (buttonIndex == 1){
            [self showAlertChoose:@"강좌에 대한 질문을 삭제하시겠습니까?" tag:TAG_MSG_LECDEL];
        }
    
    }else if(actionSheet.tag == 1){
        //상세보기
        if(buttonIndex == 0){
            UIStoryboard *_newStoryboard = nil;
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskDetail" bundle:nil];
            }
            
            mgAskLecDetailVC *_detailVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecDetailVC"];
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dic = [aDataArr objectAtIndex:editNum];
            _detailVC.app_no = app_no;
            _detailVC.app_seq = app_seq;
            _detailVC.chr_cd = chr_cd;
            _detailVC.brd_cd = [dic valueForKey:@"BRD_CD"];
            _detailVC.bidx = [dic valueForKey:@"BIDX"];
            [self.navigationController pushViewController:_detailVC animated:YES];
        }
        
        //수정하기
        if(buttonIndex == 1){
            UIStoryboard *_newStoryboard = nil;
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskEdit4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyAskEdit" bundle:nil];
            }
            
            mgAskLecEditVC *_editVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecEditVC"];
            NSArray *aDataArr = [qnaDic objectForKey:@"aData"];
            NSDictionary *dic = [aDataArr objectAtIndex:editNum];
            _editVC.app_no = app_no;
            _editVC.app_seq = app_seq;
            _editVC.chr_cd = chr_cd;
            _editVC.brd_cd = [dic valueForKey:@"BRD_CD"];
            //NSLog(@"%@", [dic valueForKey:@"BRD_CD"]);
            _editVC.bidx = [dic valueForKey:@"BIDX"];
            [self.navigationController pushViewController:_editVC animated:YES];
        }
        
        //삭제하기
        if (buttonIndex == 2){
            [self showAlertChoose:@"강좌에 대한 질문을 삭제하시겠습니까?" tag:TAG_MSG_LECDEL];
        }
    
    }else if(actionSheet.tag == 2){
        //삭제하기
        if (buttonIndex == 0){
            [self showAlertChoose:@"강좌에 대한 질문을 삭제하시겠습니까?" tag:TAG_MSG_LECDEL];
        }
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
        
        [self endLoadBar];
        
        totalMyIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"TOT_CNT"]intValue];
        
        if([dicArr count] == 0){
            bgNoImage.hidden = NO;
        }
        
        [askLecTable reloadData];
        
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
        
        [self endLoadBar];
        
        totalAllIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"TOT_CNT"]intValue];
        currAllIndex = [[[[dic objectForKey:@"bData"]objectAtIndex:0]objectForKey:@"CURR_IDX"]intValue];        
        if([dicArr count] == 0){
            bgNoImage.hidden = NO;
        }
        
        [askLecTable reloadData];
        
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
}

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//NSLog(@"alertView tag = %d", alertView.tag);
    
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
            NSDictionary *dicData = [aDataArr objectAtIndex:editNum];
            
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

- (void)questionAction{
    UIStoryboard *_newStoryboard = nil;
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLecList4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLecList" bundle:nil];
    }
    
    mgAskLecWriteVC *_writeVC = [_newStoryboard instantiateViewControllerWithIdentifier:@"mgAskLecWriteVC"];
    _writeVC.brd_cd = brd_cd;
    _writeVC.app_no = app_no;
    _writeVC.app_seq = app_seq;
    _writeVC.chr_cd = chr_cd;
    _writeVC.chr_nm = chr_nm;
    [self.navigationController pushViewController:_writeVC animated:YES];
    
    [self openMove];
    
    if([myFlg isEqualToString:@"Y"] == YES){
        [self myQna:startMyIndex count:totalMyIndex];
        [self myQnaBtn:nil];
        
    }else if([myFlg isEqualToString:@"N"] == YES){
        [self myAll:startAllIndex count:totalAllIndex idx:currAllIndex];
        [self allQnaBtn:nil];
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

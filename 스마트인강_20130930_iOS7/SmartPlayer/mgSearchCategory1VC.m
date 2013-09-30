//
//  mgSearchCategory1VC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 28..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchCategory1VC.h"
#import "mgSearchCategory2VC.h"
#import "mgSearchMathVC.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@interface mgSearchCategory1VC ()
{
    NSMutableArray *_marrData;
}

@end

@implementation mgSearchCategory1VC

@synthesize cate1NavigationBar;
@synthesize _table;
@synthesize _sLecClass, _sLecSection, _sLecCategory, _sLecqCd, _sLecqOrd, _sLecPageType, _sLecdomCd, _sLecqTecCd;
@synthesize titleText;
@synthesize _naviTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _sLecqTecCd = _sLecqOrd;
    
    //선생님
    if([_sLecPageType isEqualToString:@"2"] == YES){
        titleText.text = @"개설분야";
    
    //학습
    }else{
        titleText.text = @"주제";
    }
    
    [self initData];
    
    [cate1NavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    cate1NavigationBar.translucent = NO;
    [cate1NavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectIndex = [_table indexPathForSelectedRow];
    [_table deselectRowAtIndexPath:selectIndex animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_table:nil];
    [self setTitleText:nil];
    [super viewDidUnload];
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

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView DataSrouce & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%d", [_marrData count]);
    return _marrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"mgCategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dic = [_marrData objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = [dic valueForKey:@"qNM"];
    
    return cell;
}

- (IBAction)cellSelectedBtn:(id)sender {
    NSIndexPath *indexPath = [_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSInteger nIndex = indexPath.row;
    NSLog(@"%d", nIndex);
    
    if([_sLecdomCd isEqualToString:@"2"] == YES){
        if([_sLecPageType isEqualToString:@"2"] == YES){
            UIStoryboard *_newStoryboard = nil;
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search" bundle:nil];
            }
            
            mgSearchCategory2VC *nextVC = [_newStoryboard instantiateViewControllerWithIdentifier: @"mgSearchCategory2VC"];
            
            NSDictionary *dic = [_marrData objectAtIndex:indexPath.row];
            nextVC._sLecqOrd = [dic valueForKey:@"qOrd"];
            nextVC._sLecqCd = [dic valueForKey:@"qCd"];
            nextVC._sLecdomCd = _sLecdomCd;
            nextVC._sLecPageType = _sLecPageType;
            nextVC._sLecqTecCd = _sLecqTecCd;
            _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
            nextVC._naviTitle = _naviTitle;
            
            [self.navigationController pushViewController:nextVC animated:YES];
            
            return;
            
        }else if([_sLecPageType isEqualToString:@"1"] == YES){
            UIStoryboard *_newStoryboard = nil;
            //4인치 화면
            if ([mgCommon hasFourInchDisplay]) {
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search4" bundle:nil];
            }else{
                _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search" bundle:nil];
            }
            
            mgSearchMathVC *nextVC = [_newStoryboard instantiateViewControllerWithIdentifier: @"mgSearchMathVC"];
            NSDictionary *dic = [_marrData objectAtIndex:indexPath.row];
            nextVC._sLecqOrd = [dic valueForKey:@"qOrd"];
            nextVC._sLecqCd = _sLecqCd;
            nextVC._sLecdomCd = _sLecdomCd;
            nextVC._sLecPageType = _sLecPageType;
            nextVC._sLecTecCd = _sLecqTecCd;
            nextVC._sLecCategory = _sLecCategory;
            nextVC._sLecSection = _sLecSection;
            _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
            nextVC._naviTitle = _naviTitle;
            
            [self.navigationController pushViewController:nextVC animated:YES];
            
            return;
        }
        
    }else{
        UIStoryboard *_newStoryboard = nil;
        //4인치 화면
        if ([mgCommon hasFourInchDisplay]) {
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search4" bundle:nil];
        }else{
            _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search" bundle:nil];
        }
        
        mgSearchCategory2VC *nextVC = [_newStoryboard instantiateViewControllerWithIdentifier: @"mgSearchCategory2VC"];
        
        NSDictionary *dic = [_marrData objectAtIndex:indexPath.row];
        nextVC._sLecqOrd = [dic valueForKey:@"qOrd"];
        nextVC._sLecqCd = [dic valueForKey:@"qCd"];
        nextVC._sLecdomCd = _sLecdomCd;
        nextVC._sLecPageType = _sLecPageType;
        nextVC._sLecqTecCd = _sLecqTecCd;
        _naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecSection, _sLecCategory, [dic valueForKey:@"qNM"]];
        nextVC._naviTitle = _naviTitle;
        
        [self.navigationController pushViewController:nextVC animated:YES];
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
        //NSLog(@"%@", encodeData);
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

        [_table reloadData];
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

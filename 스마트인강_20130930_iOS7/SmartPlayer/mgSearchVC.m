//
//  mgSearchVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 27..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchVC.h"

#import "mgSearchCategory1VC.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJsonParser.h"
#import "mgGlobal.h"
#import "mgCommon.h"

@interface mgSearchVC ()
{
    NSString *_sLecClass;       // 과목
    NSString *_sLecSection;     // 과목 섹션
    NSString *_sLecCategory;    // 과목 섹션의 카테고리
    NSString *naviTitle;
    
    NSMutableDictionary *_dicData;
    NSMutableArray *_arrHeaderOrder;
    CustomBadge *badge;
}

@end

@implementation mgSearchVC

@synthesize _table;
@synthesize _slideV;
@synthesize scrollMenuToLeft;
@synthesize scrollMenuToRight;
@synthesize _btnStepCate;
@synthesize _btnTecCate;
@synthesize searchNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBadge];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [searchNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    searchNavigationBar.translucent = NO;
    [searchNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    //뱃지 카운트(수강강좌 + 마이톡)
    if (badge == nil) {
        badge = [CustomBadge customBadgeWithString:@"0" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        [badge setFrame:CGRectMake(26, 2, 26, 24)];
        [searchNavigationBar addSubview:badge];
        [self setBadge];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];
    scrollMenuToLeft.hidden = YES;
    
    _pageType = @"1";
    _domCd = @"4";
    _sLecClass = @"영어";
    
    [self dataLoad];
    [self initSlideV];
    
    [self lecBtn:nil];
    
    [_slideV setButton:@"영어" setSelected:YES];
}

- (void)dataLoad{
    [self initLoadBar];
    [self startLoadBar];
    
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

- (void)setBadge
{
    if (badge != nil) {
        if ([UIApplication sharedApplication].applicationIconBadgeNumber <= 0) {
            badge.hidden = YES;
        }else{
            [badge autoBadgeSizeWithString:[[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber]];
            badge.hidden = NO;
        }
    }
}

// 슬라이드 버튼뷰 초기화
- (void)initSlideV{
    _slideV._dlgtSlideV = self;
    _slideV.bounces = NO;
    
    [_slideV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"_btn_slidebutton_default"]]];
    
    [_slideV setScrollEnabled:YES];
    [_slideV setShowsHorizontalScrollIndicator:NO];
    
    [_slideV addButton:@"국어"];
    [_slideV addButton:@"수학"];
    [_slideV addButton:@"영어"];
    [_slideV addButton:@"사회"];
    [_slideV addButton:@"과학"];
    [_slideV addButton:@"제2외"];
    [_slideV addButton:@"대학별"];
    
    [_slideV setButton:@"영어" setSelected:YES];
}

//스크롤 좌우
-(void)scrollViewDidScroll:(UIScrollView*)scrollView{    
    if(scrollView.contentOffset.x > 40){
        scrollMenuToLeft.hidden = NO;
        scrollMenuToRight.hidden = YES;
        return;
    
    }else if(scrollView.contentOffset.x < 80){
        scrollMenuToRight.hidden = NO;
        scrollMenuToLeft.hidden = YES;
        return;
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
    [_table reloadData];
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TalkReceived" object:nil];
    [self set_slideV:nil];
    [self set_table:nil];
    [self setScrollMenuToLeft:nil];
    [self setScrollMenuToRight:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark mgButtonSlideV Delegate

- (void)mgButtonSlideV_touchButton:(id)button tag:(int)tag{
    _sLecClass = button;
    _domCd = [NSString stringWithFormat:@"%d", tag + 1];
    //NSLog(@"%@", button);
    //NSLog(@"%@", _domCd);
    
    if([_sLecClass isEqualToString:@"국어"] == YES){
        _domCd = @"1";
        
    }else if([_sLecClass isEqualToString:@"수학"] == YES){
        _domCd = @"2";
        
    }else if([_sLecClass isEqualToString:@"사회"] == YES){
        _domCd = @"3";
        
    }else if([_sLecClass isEqualToString:@"과학"] == YES){
        _domCd = @"4";
        
    }else if([_sLecClass isEqualToString:@"영어"] == YES){
        _domCd = @"5";
        
    }else if([_sLecClass isEqualToString:@"제2외"] == YES){
        _domCd = @"6";
        
    }else if([_sLecClass isEqualToString:@"대학별"] == YES){
        _domCd = @"7";
    }
    
    [self dataLoad];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)menuBtn:(id)sender {
    SlideNavigationController *vc = (SlideNavigationController*)self.parentViewController;
    if ([vc isMenuOpen]) {
        [vc closeSlide];
    }else{
        [vc openSlide];
    }
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

- (IBAction)scrollMenuToLeft:(id)sender {
    [_slideV scrollToLeft];
}

- (IBAction)scrollMenuToRight:(id)sender {
    [_slideV scrollToRight];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell!=nil)
    {
        UILabel *_label = (UILabel*)[cell viewWithTag:1];
        UIImageView *_newImage = (UIImageView*)[cell viewWithTag:2];
        
        int nSection = indexPath.section;
        int nRow = indexPath.row;
        
//        NSMutableArray *_arr = (NSMutableArray*)[_dicData.allValues objectAtIndex:nSection];
        NSMutableArray *_arr = (NSMutableArray*)[_dicData objectForKey:[_arrHeaderOrder objectAtIndex:nSection]];
        
        _label.text = (NSString*)[[_arr objectAtIndex:nRow]valueForKey:@"name"];
        CGSize textSize = [[_label text] sizeWithFont:[_label font]];
        CGFloat strikeWidth = textSize.width;
  
        if ([[[_arr objectAtIndex:nRow]valueForKey:@"new"]isEqualToString:@"N"]) {
            _newImage.hidden = true;
        }else{
            [_newImage setFrame:CGRectMake(20 + strikeWidth + 5, 11, 23, 22)];
            _newImage.hidden = false;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *_customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIImage *imgBackground = nil;
    UILabel *titleName;
    
//    NSString *section_nm = [[_dicData allKeys]objectAtIndex:section];
    NSString *section_nm = [_arrHeaderOrder objectAtIndex:section];

    for(int i = 0; i < sectionCount; i++){
        NSString *imgName = [NSString stringWithFormat:@"ta_tit0%d", section+1];
        imgBackground = [UIImage imageNamed:imgName];
        
        titleName = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 252, 19)];
        titleName.text = section_nm;
        titleName.backgroundColor = [UIColor clearColor];
        titleName.textColor = [UIColor colorWithRed:255 / 255 green:255 / 255 blue:255 / 255 alpha:255 / 255];
        titleName.shadowColor = [UIColor colorWithRed:0 / 255 green:0 / 255 blue:0 / 255 alpha:0.3];
        titleName.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16];
    }
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [backgroundView setImage:imgBackground];
    
    [_customView addSubview:backgroundView];
    [_customView addSubview:titleName];
    
    return _customView;
}

- (IBAction)touchCell:(id)sender {
    UITableViewCell *cell = (UITableViewCell*)[[sender superview]superview];
    NSIndexPath *indexpath = [_table indexPathForCell:cell];
    
    _sLecSection = [[NSString alloc]initWithFormat:@"%@", [_arrHeaderOrder objectAtIndex:indexpath.section]];
    NSMutableArray *arr = (NSMutableArray*)[_dicData objectForKey:_sLecSection];
    _sLecCategory = [[NSString alloc]initWithFormat:@"%@", [[arr objectAtIndex:indexpath.row]valueForKey:@"name"]];
    
    //NSLog(@"%@", _sLecClass);
    //NSLog(@"%@", _sLecSection);
    //NSLog(@"%@", _sLecCategory);
    //NSLog(@"%@", _dicData);
    
    NSDictionary *dic = [searchArr objectAtIndex:indexpath.section];
    NSArray *dicArr = [dic valueForKey:@"subData"];
    NSDictionary *cellDic = [dicArr objectAtIndex:indexpath.row];
    
    _qCd = [cellDic valueForKey:@"qCd"];
    _qOrd = [cellDic valueForKey:@"qOrd"];
    
    UIStoryboard *_newStoryboard = nil;
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search" bundle:nil];
    }
    
    mgSearchCategory1VC *nextVC = [_newStoryboard instantiateViewControllerWithIdentifier: @"mgSearchCategory1VC"];
    
    if([_pageType isEqualToString:@"1"] == YES){
        naviTitle = [[NSString alloc]initWithFormat:@"%@/%@/%@", _sLecClass, _sLecSection, _sLecCategory];
    }else if([_pageType isEqualToString:@"2"] == YES){
        naviTitle = [[NSString alloc]initWithFormat:@"%@/%@", _sLecClass, _sLecCategory];
    }
    
    nextVC._sLecClass = _sLecClass;
    nextVC._sLecSection = _sLecSection;
    nextVC._sLecCategory = _sLecCategory;
    nextVC._sLecqCd = _qCd;
    nextVC._sLecqOrd = _qOrd;
    nextVC._sLecPageType = _pageType;
    nextVC._sLecdomCd = _domCd;
    nextVC._naviTitle = naviTitle;
    
    [self.navigationController pushViewController:nextVC animated:YES];
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

#pragma mark -
#pragma mark alertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//NSLog(@"alertView tag = %d", alertView.tag);
	
	if(alertView.tag == TAG_MSG_NETWORK){
        if(buttonIndex == 0){
            [self showAlert:@"알수없는 에러가 발생하였습니다. \n 강좌보관함/설정만 \n 이용 가능합니다." tag:TAG_MSG_NONE];
        }else if(buttonIndex == 1){
            [self dataLoad];
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

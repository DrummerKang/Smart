//
//  mgDownloadListVC_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 23..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgDownloadListVC_iPad.h"
#import "Constants.h"
#import "AquaDBManager.h"
#import "AquaContentHandler.h"
#import "AppErrorHandler.h"
#import "CDNMovieSecurityManager.h"
#import "CDNMoviePlayer.h"
#import "NSString+URL.h"
#import "mgCommon.h"
#import "AppDelegate.h"

#define MUTE 6000
#define DEST_PATH   [NSHomeDirectory() stringByAppendingString:@"/Documents/meg/"]

typedef enum {
    ALERTVIEW_ERROR_FINISH = 1,
    ALERTVIEW_PLAY_CONTINUE
} ALERTVIEW_TAG;

@interface mgDownloadListVC_iPad (){
    BOOL _userExit;
    BOOL _endMovie;
    BOOL _showingMsg;
    
    UIButton *editBtn;
    UIButton *completeBtn;
    
    NSMutableArray *_marrData;
    CustomBadge *badge;
}

- (void) playMovie:(NSString*)urlString;
- (void) appIsTerminated;
- (void) clearOptionValue;

@end

@implementation mgDownloadListVC_iPad

@synthesize noItemView;
@synthesize downloadListTable;
@synthesize player;
@synthesize watermark;
@synthesize navigationBar;

- (id)init {
    self = [super init];
    if (self) {
        [self drawSourceImageR:@"bg_top" frame:CGRectMake(0, 0, 1024, 44)];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setObject:@"0" forKey:SETTING_NUM];
    [defaults setObject:@"0" forKey:DDAY_NUM];
    
    // 뱃지
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];
    [self initNavigationBar];
    
    if (from == YES)
        return;
    
	player = nil;
    controlViewController = nil;
    
	contentURL = nil;
    
    pressedHomeButton = NO;
    callConnected = NO;
    _userExit = NO;
    _endMovie= NO;
    
    // 통지센터 연결
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnDownloaded) name:@"LectureDownloaded" object:nil];
    
    // 테이블뷰에 소스 및 대리자 연결
    downloadListTable.delegate = self;
    downloadListTable.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 데이터 적재
    [self loadData];
    
    // 값이 없으면 빈페이지
    if([_marrData count] == 0){
        noItemView.hidden = NO;
    }else{
        noItemView.hidden = YES;
    }
    
    [downloadListTable reloadData];
    
    [self setBadge];
    NSIndexPath *selectIndex = [downloadListTable indexPathForSelectedRow];
    [downloadListTable deselectRowAtIndexPath:selectIndex animated:YES];
}


- (void)OnDownloaded{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:@"1"];
    
    [self loadData];
    
    [downloadListTable reloadData];
}

- (void)loadData{
    // 데이터 초기화
    NSMutableArray *arrContents = nil;
    if (arrContents == nil) {
        arrContents = [[NSMutableArray alloc] init];
    }else{
        [arrContents removeAllObjects];
    }
    
    if (_marrData == nil) {
        _marrData = [[NSMutableArray alloc] init];
    }else{
        [_marrData removeAllObjects];
    }
    
    //모든 컨텐츠 정보 얻기
    AppDelegate* _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *arr = (NSMutableArray *)[[AquaDBManager sharedManager] selectAllIDContent:[_app._account getUserID]];
    [arrContents setArray:arr];
    
    //섹션 및 데이터 추출
    NSString *chr_nm = @"", *teacher = @"", *imgPath = @"", *subject = @"";
    for(int i = 0; i < [arrContents count]; i++){
        NSDictionary *dic = [arrContents objectAtIndex:i];
        
        chr_nm = [dic valueForKey:@"chr_nm"];
        teacher = [dic valueForKey:@"teacher"];
        imgPath = [dic valueForKey:@"imgPath"];
        subject = [dic valueForKey:@"subject"];
        
        // 섹션추가
        if ([self getIndexForCategory:chr_nm teacher:teacher subject:subject] < 0) {
            [_marrData addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:chr_nm, @"chr_nm", teacher, @"teacher", imgPath, @"imgPath", subject, @"subject", nil]];
        }
        
        //NSLog(@"chr_nm=%@, teacher=%@, subject=%@", chr_nm, teacher, subject);
        
        [self addItem:dic chr_nm:chr_nm teacher:teacher subejct:subject];
    }
    
    //NSLog(@"%@", _marrData);
}

- (int)getIndexForCategory:(NSString*)chr_nm teacher:(NSString*)teacher subject:(NSString*)subject
{
    int cnt = _marrData.count;
    int idx = 0;
    
    for (idx = 0; idx < cnt; idx ++) {
        NSMutableDictionary *_dic = (NSMutableDictionary*)[_marrData objectAtIndex:idx];
        if ([[_dic valueForKey:@"chr_nm"]isEqualToString:chr_nm] && [[_dic valueForKey:@"teacher"]isEqualToString:teacher] && [[_dic valueForKey:@"subject"]isEqualToString:subject]) {
            return idx;
        }
    }
    
    return -1;
}

- (void)addItem:(NSDictionary*)item chr_nm:(NSString *)chr_nm teacher:(NSString*)teacher subejct:(NSString*)subject
{
    int nIndex = [self getIndexForCategory:chr_nm teacher:teacher subject:subject];
    if (nIndex < 0) {
        return;
    }
    
    NSMutableDictionary *_category = (NSMutableDictionary*)[_marrData objectAtIndex:nIndex];
    
    NSMutableArray *_arrData = [_category objectForKey:@"lecData"];
    if (_arrData == nil) {
        _arrData = [[NSMutableArray alloc]init];
    }
    
    [_arrData addObject:item];
    
    [_category setObject:_arrData forKey:@"lecData"];
    
    [_marrData replaceObjectAtIndex:nIndex withObject:_category];
}

// 네비게이션 좌측 바버튼
- (void)initNavigationBar{
    // 네비게이션바 배경 바꾸기
    [navigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Apple SD Gothic Neo" size:0.0],
      UITextAttributeFont,
      nil]];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(957, 7, 60, 30);
    editBtn.exclusiveTouch = YES;
    [editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [editBtn setTitle:@"편집" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [navigationBar addSubview:editBtn];
    
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(957, 7, 60, 30);
    completeBtn.exclusiveTouch = YES;
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [navigationBar addSubview:completeBtn];
    completeBtn.hidden = YES;
}

- (void)setBadge
{
    if (badge != nil) {
        if ([UIApplication sharedApplication].applicationIconBadgeNumber <= 0) {
            badge.hidden = YES;
        }else{
            badge.badgeText = [[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber];
            badge.hidden = NO;
        }
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TalkReceived" object:nil];
    [self setDownloadListTable:nil];
    [self setNavigationBar:nil];
    [self setNoItemView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Button Action

- (void)editAction{
    editBtn.hidden = YES;
    completeBtn.hidden = NO;
    
    [downloadListTable setEditing:YES animated:YES];
}

- (void)completeAction{
    [downloadListTable setEditing:NO animated:YES];
    
    editBtn.hidden = NO;
    completeBtn.hidden = YES;
}

#pragma mark -
#pragma mark TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _marrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *_arr = (NSMutableArray*)[[_marrData objectAtIndex:section]valueForKey:@"lecData"];

    //NSLog(@"count = %d, section_dix = %d", _arr.count, section);
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"downlistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell != nil) {
        NSDictionary *_lec = (NSDictionary*)[[[_marrData objectAtIndex:indexPath.section]objectForKey:@"lecData"]objectAtIndex:indexPath.row];
        
        UILabel *_label = (UILabel*)[cell viewWithTag:1];
        _label.text = [_lec valueForKey:@"title"];
        
        UILabel *_dayLabel = (UILabel*)[cell viewWithTag:3];
        _dayLabel.text = [_lec valueForKey:@"finish"];
        
        UIImageView *image = (UIImageView *)[cell viewWithTag:2];
        
        if([[_lec valueForKey:@"moveQuality"] isEqualToString:@"high"] == YES){
            [image setImage:[UIImage imageNamed:@"_btn_icon_HD"]];
        }else{
            [image setImage:[UIImage imageNamed:@"_btn_icon_SD"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item = [[[_marrData objectAtIndex:indexPath.section]objectForKey:@"lecData"]objectAtIndex:indexPath.row];
    
    //NSLog(@"play lec info : %@", item);
    //NSLog(@"%d", indexPath.row);
    
    NSString *pos= [item valueForKey:@"pos"];
    //NSLog(@"pos : %@", pos);
    posStr = pos;
    
    cId = [item valueForKey:@"cId"];
    
    if ([[item objectForKey:@"contentPath"] length] < 1) {
        [self tableView:self.downloadListTable didSelectRowAtIndexPath:indexPath];
        
    }else{
        CDNContentInfo *info = [CDNMoviePlayer getContentInfo:[item objectForKey:@"contentPath"]];
        NSLog(@"%d", info.expired);
        [CDNMoviePlayer updateContent:[item objectForKey:@"contentPath"]];
        NSLog(@"errorCode : %d", [CDNMoviePlayer errCode]);
        
        if ([CDNMoviePlayer errCode] != 0) {
            if([CDNMoviePlayer errCode] != -601){
                [self showAlert:[AppErrorHandler messageCode:[CDNMoviePlayer errCode]] tag:TAG_MSG_NONE];
                //return;
            }
        }
    }
    
    // 오프라인인지 확인
    AppDelegate* _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if(_app._ReachStatus == COMM_NOTACCESS)
    {
        // 여기까지 오면 플레이 가능한 영상임
        // 오프라인일 때 값을 체크 하여 빈 값이면 현재 시간을 저장하고
        // 저장된 값이 있으면 현재일과 7일 이상 차이나면 플레이 못하게 한다.
        NSString *lastOfflinePlayDate = [item valueForKey:@"lastOfflinePlayDate"];
        NSDateFormatter *_fmt = [[NSDateFormatter alloc]init];
        [_fmt setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        if ([lastOfflinePlayDate isEqualToString:@""] || lastOfflinePlayDate == nil) {
            // 빈값이라면 현재 시간을 저장, 현재 시간부터 7일이 지날때까지 오프로만 접속하면 그 이후엔 접속하지 못하게 한다.
            [[AquaDBManager sharedManager]updateLastOfflinePlayDate:[_fmt stringFromDate:[NSDate date]] cId:[item valueForKey:@"cId"]];
        }else{
            NSDate *dtLastOfflinePlayDate = [_fmt dateFromString:lastOfflinePlayDate];
            
            NSUInteger unitFlags = NSDayCalendarUnit;
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:unitFlags fromDate:dtLastOfflinePlayDate toDate:[NSDate date] options:0];
            
            // offlinePeriod를 읽어오나, 값이 혹 없을 경우 7일
            NSString *offlinePeriod = [item valueForKey:@"offlinePeriod"];
            int nofflinePeriod;
            if ([offlinePeriod isEqualToString:@""] || offlinePeriod != nil) {
                nofflinePeriod = 7;
            }else{
                nofflinePeriod = [offlinePeriod intValue];
            }
            //NSLog(@"%d", [components day]);
            if ([components day] > nofflinePeriod) {
                [self showAlert:@"오프라인 유효기간이 지난 강좌입니다.\n온라인으로 전환하여 플레이해주십시오." tag:TAG_MSG_NONE];
                return;
            }
        }
    }else{
        // 온라인으로 정상적으로 플레이 할때 다시 빈값으로 초기화
        [[AquaDBManager sharedManager]updateLastOfflinePlayDate:@"" cId:[item valueForKey:@"cId"]];
    }
    
    if([pos isEqual:@"0"] == YES){
        posNum = 0;
        
    }else{
        posNum = [[item valueForKey:@"pos"] intValue];
        
        posDic = item;
        posIndexPath = indexPath;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"Play를 중간에 중단하셨습니다." delegate:self cancelButtonTitle:@"이어보기" otherButtonTitles:@"처음부터 보기" ,nil];
        [alert show];
        alert.tag = TAG_MSG_STREMCONTINUE;
        
        return;
    }
    
    [self executePlayerWithContentData:item viewController:self];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 98.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableDictionary *_mdicSection = [_marrData objectAtIndex:section];
    //NSLog(@"%@", _mdicSection);
    
    CGRect rtScreen = [mgCommon getScreenFrame];
    // 가로모드라서 세로값을 넣음
    int width = rtScreen.size.height;
    
    UIView *_customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 98)];
    [_customView setBackgroundColor:[self getColor:@"e5e9f1"]];
    
    //배경
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 1006, 75)];
    //bgImage.image = [[UIImage imageNamed:@"P_box_cnt2"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    bgImage.image = [UIImage imageNamed:@"P_box_cnt2"];
    [_customView addSubview:bgImage];
    
    //배경라인 위
    UIImageView *bgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, width, 2)];
    bgLine.image = [UIImage imageNamed:@"line_blue"];
    [_customView addSubview:bgLine];
    
    //배경라인 밑
    UIImageView *bgLineDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, 97, width, 1)];
    bgLineDown.image = [UIImage imageNamed:@"cellList"];
    [_customView addSubview:bgLineDown];
    
    //선생님 이미지
    UIImageView *photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(21, 23, 52, 52)];
    NSString *ImageURL = [_mdicSection valueForKey:@"imgPath"];
    
    if (![ImageURL isEqualToString:@""]) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [photoImage setImage:image];
        photoImage.layer.cornerRadius = 5.0f;
        photoImage.layer.masksToBounds = YES;
        photoImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        photoImage.layer.borderWidth = 1.0f;
        photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [_customView addSubview:photoImage];
    }else{
        [photoImage setImage:[UIImage imageNamed:@"thumb_noimg.png"]];
    }
    
    //과목이미지
    UIImageView *subjectImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 41, 41)];
    NSString *sub = [_mdicSection valueForKey:@"subject"];
    //NSLog(@"%@", sub);
    if([sub isEqualToString:@"국어"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_korean"]];
    else if([sub isEqualToString:@"수학"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_math"]];
    else if([sub isEqualToString:@"영어"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_english"]];
    else if([sub isEqualToString:@"사회"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_society"]];
    else if([sub isEqualToString:@"과학"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_science"]];
    else if([sub isEqualToString:@"제2외국어"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_language"]];
    else if([sub isEqualToString:@"전공"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_major"]];
    else if([sub isEqualToString:@"논술"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_essay"]];
    else if([sub isEqualToString:@"구술"])
        [subjectImage setImage:[UIImage imageNamed:@"ico_talk"]];
    [_customView addSubview:subjectImage];
    
    //선생님 이름
    UILabel *teacherName = [[UILabel alloc]initWithFrame:CGRectMake(84, 23, 280, 15)];
    teacherName.backgroundColor = [UIColor clearColor];
    teacherName.numberOfLines = 1;
    teacherName.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
    teacherName.font = [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:14];
    teacherName.text = [[NSString alloc] initWithFormat:@"%@", [_mdicSection objectForKey:@"teacher"]];
    [_customView addSubview:teacherName];
    
    //강좌제목
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(84, 42, 900, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.textColor = [UIColor colorWithRed:38 / 255 green:38 / 255 blue:38 / 255 alpha:255 / 255];
    label.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:12];
    label.text = [[NSString alloc] initWithFormat:@"%@", [_mdicSection objectForKey:@"chr_nm"]];
    [_customView addSubview:label];
    
    return _customView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)getIndexFromIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"%@", indexPath);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSMutableArray *lecData = (NSMutableArray*)[[_marrData objectAtIndex:indexPath.section]objectForKey:@"lecData"];
        NSMutableDictionary *item = (NSMutableDictionary*)[lecData objectAtIndex:indexPath.row];
        
        [downloadListTable beginUpdates];
        
        [[AquaDBManager sharedManager] deleteContent:[item valueForKey:@"cId"]];
        
        //[self editAction];
        
        NSString *delContentName = [NSString stringWithFormat:@"%@.cnm", [item valueForKey:@"cId"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[DEST_PATH stringByAppendingPathComponent:delContentName] error:NULL];
        
        NSError *error = nil;
        if (error != nil) {
            //NSLog(@"delete file error : %@", [error localizedDescription]);
        }else{
            //NSLog(@"delete %@, freespace = %f GB", delContentName, [mgCommon freeDiskspace]/1073741824.0f);
            
            [lecData removeObjectAtIndex:indexPath.row];
            
            if (lecData.count < 1) {
                [downloadListTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [_marrData removeObjectAtIndex:indexPath.section];
                //NSLog(@"%@", _marrData);
            }else{
                [downloadListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [downloadListTable endUpdates];
            
            if([_marrData count] == 0){
                noItemView.hidden = NO;
            }else{
                noItemView.hidden = YES;
            }
        }
        
        //[self editAction];
        
        [downloadListTable reloadData];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -
#pragma mark Player Method

- (void) executePlayerWithContentData:(NSDictionary *)contentData viewController:(UIViewController *)viewController{
    lastViewController = viewController;
    
    //  pos는 이어보기를 위한 정보
    [self executePlayerWithContentData:contentData pos:posNum];
}

- (void) executePlayerWithContentData:(NSDictionary *)contentData pos:(int)pos{
    CDNMovieSecurityManager *securityManager = [CDNMovieSecurityManager sharedManager];
    //이미 연결되어 있는 경우도 있으므로.
    //플레이 되기 전에 체크해준다.
    [securityManager checkCurrencScreen];
    
    [(NSMutableDictionary *)contentData setValue:[NSNumber numberWithInt:pos] forKey:@"pos"];
    [NSThread detachNewThreadSelector:@selector(isRightContentPlay:) toTarget:self withObject:contentData];
}

- (void)isRightContentPlay:(NSMutableDictionary *)contentData{
    [self performSelectorOnMainThread:@selector(playMovieWithContentData:) withObject:contentData waitUntilDone:NO];
}

- (void) playMovieWithContentData:(NSDictionary *)contentData{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground) {
        return;
    }
    
    if (lastViewController) {
        if([self.navigationController visibleViewController] != lastViewController)
        {
            lastViewController = nil;
            return;
        }
    }
    
    isAirPlay = NO;
    lastViewController = nil;
    int pos = [[contentData objectForKey:@"pos"] intValue];
    int nPort = [CDNMoviePlayer getPort];
    NSString *strurl = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/cddr_dnp%@", nPort, [contentData objectForKey:@"contentPath"]];
    [self executePlayer:[NSURL URLWithString:strurl] pos:pos];
}

- (void) executePlayer:(NSURL *)url pos:(int)pos{
    //Player가 시작되려고 할 때 화면을 체크해준다..(이미 연결되어 있는 경우에는 노티피케이션에 걸리지 않으므로..
    CDNMovieSecurityManager *securityManager = [CDNMovieSecurityManager sharedManager];
    [securityManager checkCurrencScreen];
    
	NSArray *URLSchemes = [self getURLSchemes];
	NSInteger index = [URLSchemes indexOfObject:[url scheme]];
    
	if(NSNotFound != index){
        NSString *scheme = [NSString stringWithFormat:@"%@://", [URLSchemes objectAtIndex:index]];
		int nPort = [CDNMoviePlayer getPort];
        
        NSString *strurl = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/", nPort];
		NSURL *_contentURL = [NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:scheme withString:strurl]];
        urlAdd = _contentURL;
        
    }else{
        urlAdd = url;
	}
    
    startPos = pos;
    csHost = [url host];
    
    [self playMovieWithOptions:url from:!isAirPlay];
}

- (NSArray*) getURLSchemes{
	NSMutableArray *schemes = [NSMutableArray array];
    
	NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    
	for(NSDictionary *type in urlTypes){
		NSArray *urlSchmes = [type objectForKey:@"CFBundleURLSchemes"];
		for(NSString *scheme in urlSchmes){
			[schemes addObject:scheme];
		}
	}
    
	return schemes;
}

- (void) clearOptionValue{
	if(contentURL){
		contentURL = nil;
	}
}

- (void)playMovieWithOptions:(NSURL*)url from:(BOOL)_from;{
    from = _from;
    
	[self clearOptionValue];
    
    NSMutableArray* optionKeys = [NSMutableArray array];
    NSLog(@"optionKeys : %@", optionKeys);
    
    if ([url query] != nil) {
        NSString *urlquery = [url query];
        NSString* decrypted = nil;
        
        if ([urlquery hasPrefix:@"param="]) {
            urlquery = [urlquery substringFromIndex:6];
            decrypted = [CDNMoviePlayer decryptString:urlquery];
            if (decrypted == nil) {
                return;
            }
        }
        
        decrypted = [CDNMoviePlayer decryptString:urlquery];
        
        if ([decrypted length] == 0){
            decrypted = [url query];
            
        }else {
            NSString *auth = decrypted;
            NSRange start = [decrypted rangeOfString:@"d_id="];
            if (start.location != NSNotFound) {
                NSRange end = [decrypted rangeOfString:@"&" options:1 range:NSMakeRange(start.location, decrypted.length - start.location)];
                if (end.location != NSNotFound) {
                    start.length = end.location - start.location +1;
                    auth = [decrypted stringByReplacingCharactersInRange:start withString:@""];
                    
                }else{
                    auth = [decrypted substringToIndex:start.location];
                }
                [CDNMoviePlayer setAuth:auth];
                
            }else{
                [CDNMoviePlayer setAuth:decrypted];
            }
        }
        
        NSString *contentUrl = nil;
        NSMutableDictionary *watermarkContext = [NSMutableDictionary dictionary];
        NSMutableDictionary *wmText = [NSMutableDictionary dictionary];
        [watermarkContext setValue:wmText forKey:@"wm_text"];
        BOOL hasWatermark = NO;
        NSArray* query = [decrypted componentsSeparatedByString:@"&"];
        NSMutableArray *qArr = [NSMutableArray arrayWithArray:query];
        
        for(NSString* queryStr in qArr){
            NSArray* keyValue = [queryStr componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            NSString* value = [keyValue objectAtIndex:1];
            
            if([key isEqualToString:@"from"]){
                from = YES;
                
            }else if([key isEqualToString:@"url"]){
                contentUrl = [value urlDecodedString];
                contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                
            }else if([key isEqualToString:@"wm_text"]){
                [wmText setValue:value forKey:@"text"];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_color"]){
                [wmText setValue:value forKey:@"color"];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_size"]){
                [wmText setValue:value forKey:@"size"];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_shade_color"]){
                [wmText setValue:value forKey:@"shade_color"];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_padding"]){
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_pos"]){
                [watermarkContext setValue:value forKey:key];
                hasWatermark = YES;
                
            }else if([key isEqualToString:@"wm_image"]){
                [watermarkContext setValue:[value urlDecodedString] forKey:key];
                hasWatermark = YES;
            }
        }
        
        if (hasWatermark) {
            self.watermark = [CDNPlayerViewWatermark watermarkWithOptions:watermarkContext];
        }
        
        // convert bookmark position
        NSString *port = [[url port] intValue]>0?[NSString stringWithFormat:@":%d",[[url port] intValue]]:@"";
        NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@://%@%@",[url scheme], [url host], port];
        if ([[url path] hasPrefix:@"/cddr_dnp/webstream"]) {
            [urlString appendFormat:@"/%@?%@", contentUrl, decrypted];
            
        }else {
            [urlString appendFormat:@"%@?%@",[url path], decrypted];
            [urlString appendFormat:@"&host=%@", [[urlString pathComponents] objectAtIndex:2]];
        }
        
        NSString *conUrl = [urlString stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        //NSLog(@"%@", conUrl);
        [self playMovie:conUrl];
        
    }else {
        NSMutableString* urlString = [[NSMutableString alloc] initWithString:[url absoluteString]];
        //NSLog(@"playMovie=%@", urlString);
        [self playMovie:urlString];
    }
}

- (void) playMovie:(NSString*)urlString{
    callConnected = NO;
    pressedHomeButton = NO;
    
    contentURL = [[NSURL alloc] initWithString:urlString];
    player = [[CDNMoviePlayer alloc] initWithContentURL:contentURL parentView:self bookmarkParam:posStr];
	[player setDelegate:self];
    
	[player allowsAirPlay:NO];
    
	controlViewController = [[PlayerControlDownViewController_iPad alloc] initWithNibName:@"PlayerControlDownViewController_iPad" bundle:nil];
	[player setControlView:[controlViewController view]];
    
    UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
    [button addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    
	[player setControlImage:[NSArray arrayWithObjects:@"player_play_normal", @"player_pause_normal", nil] forControl:CONTROL_PLAY];
	[player setControlImage:[NSArray arrayWithObjects:@"player_full_normal", @"player_downsize_normal", nil] forControl:CONTROL_SCREEN_SCALING];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"ko"])
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
    else
        [player setControlImage:[NSArray arrayWithObjects:@"btn_top_player_normal", nil] forControl:CONTROL_STOP];
    
	[self addNotification];
    
	[player play];
}

- (void) seekToStartPos{
    if(posCheck == 0){
        [player setCurrentTime:startPos];
        [player play];
        
    }else if(posCheck == 1){
        [player setCurrentTime:0];
        [player play];
    }
}

- (void)addNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinished:)
												 name:CDNMoviePlayerFinishedPlaybackNotification
											   object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(myMovieStateChanged:)
     name:CDNMoviePlayerStateChangedNotification
     object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieLoaded:)
												 name:CDNMoviePlayerLoadedNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(changeVolume:)
												 name:@"AVSystemController_SystemVolumeDidChangeNotification"
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatStart:)
                                                 name: CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSectionRepeatEnd:)
                                                 name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseSectionRepeat:) name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
}

- (void) myMovieFinished:(NSNotification*)aNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerFinishedPlaybackNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
    
    //마지막 재생한 날짜로 업데이트
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    NSString *strNow = [fmt stringFromDate:now];
    //NSLog(@"%@", strNow);
    
    [[AquaDBManager sharedManager] updateFinishDay:strNow cId:cId];
    
    if([player getTotalTime] <= [player getCurrentTime]){
        [[AquaDBManager sharedManager] updatePos:0 cId:cId];
        
    }else{
        [[AquaDBManager sharedManager] updatePos:[player getCurrentTime] cId:cId];
        //NSLog(@"%f", [player getCurrentTime]);
    }
    
    _endMovie = YES;
    
	[self removeNotification];
    /*
     
     NSDictionary *notiUserInfo = [aNotification userInfo];
     NSNumber *finishReason = nil;
     NSError *finishErrorInfo = nil;
     
     if(nil != notiUserInfo){
     finishReason = [notiUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
     finishErrorInfo = [notiUserInfo objectForKey:@"error"];
     
     //NSLog(@"Movie is finished. reason=%d. errorInfo=%@ errorcode : %d", [finishReason intValue], [finishErrorInfo description], [finishErrorInfo code]);
     }
     
     if(nil != controlViewController){
     controlViewController = nil;
     }
     
     // 데이터 적재
     [self loadData];
     
     _userExit = NO;
     if (finishReason && [finishReason intValue] == MPMovieFinishReasonUserExited) {
     _userExit = YES;
     }
     
     if (from == YES){
     [self clearOptionValue];
     
     if(nil != player){
     player = nil;
     }
     
     return;
     }
     
     if(nil != player){
     player = nil;
     }
     
     if (!_showingMsg) {
     [self appIsTerminated];
     }
     */
    
    NSDictionary *notiUserInfo = [aNotification userInfo];
    
    if(nil != notiUserInfo){
        NSNumber *reason = [notiUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        NSError *errorInfo = [notiUserInfo objectForKey:@"error"];
        NSLog(@"Movie is finished. reason=%d. errorInfo=%@", [reason intValue], [errorInfo description]);
        
        if([reason intValue] == MPMovieFinishReasonPlaybackError) {
            NSString *msgStr = [NSString stringWithFormat:@"일시적인 오류입니다. \n 잠시 후 이용해주세요.(%d)", [reason intValue]];
            UIAlertView *notice = [ [UIAlertView alloc] initWithTitle:@"Error" message:msgStr delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [notice show];
        }
    }
    
    [self loadData];
    [downloadListTable reloadData];
}

- (void) myMovieStateChanged:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *state = [userInfo objectForKey:@"playbackState"];
    
    MPMoviePlaybackState playbackState = (MPMoviePlaybackState)[state intValue];
    
    if (startPos > 0 && playbackState == MPMoviePlaybackStatePlaying) {
        if ([player getCurrentTime] > 2) {
            startPos = 0;
            
        }else {
            if (_sourceLoaded) {
                [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
            }
        }
    }
}

- (void) myMovieLoaded:(NSNotification*)aNotification{
    _sourceLoaded = YES;
    if (startPos > 0) {
        if ([player getCurrentTime] > 2) {
            startPos = 0;
            
        }else {
            [self performSelector:@selector(seekToStartPos) withObject:nil afterDelay:0.5];
        }
    }
}

- (void) changeVolume:(NSNotification*)aNotification{
    if (isMute == YES){
        //mute에 의해 볼륨이 바뀐경우는 무시.
        if(isVolumeChanged== NO){
            isVolumeChanged = YES;
            return;
        }
        
        isMute = NO;
        
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
    }
}

- (IBAction) mute{
    if (isMute == NO){
        prevVolume =  [[MPMusicPlayerController applicationMusicPlayer] volume];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        isMute = YES;
        isVolumeChanged= NO;
        
    }else{
        isMute = NO;
        UIButton *button = (UIButton *)[controlViewController.view viewWithTag:MUTE] ;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_normal" ofType:@"png"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_sound_pressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:prevVolume];
    }
}

- (void) releaseSectionRepeat:(NSNotification*)aNotification {
    [controlViewController.description setText:@"구간반복을 해제합니다."];
}

- (void) setSectionRepeatStart:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *startTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatStartTimeUserInfoKey];
    
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate initWithTimeIntervalSinceReferenceDate:[startTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [timeF setDateFormat:@"HH:mm:ss"];
    
    NSString *timerStr = [timeF stringFromDate:currentDate];
    [controlViewController.description setText:[NSString stringWithFormat:@"구간반복 %@ ~", timerStr]];
}

- (void) setSectionRepeatEnd:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *endTime = [userInfo valueForKey:CDNMoviePlayerSectionRepeatEndTimeUserInfoKey];
    // display a message to label
    NSDate *playbackTime = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[endTime doubleValue]];
    NSDateFormatter *timeF = [[NSDateFormatter alloc] init];
    [timeF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; [timeF setDateFormat:@"HH:mm:ss"];
    NSString *playbackTimeStr = [timeF stringFromDate:playbackTime];
    NSString *text = controlViewController.description.text;
    [controlViewController.description setText:[NSString stringWithFormat:@"%@ %@", text, playbackTimeStr]];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerFinishedPlaybackNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerSetSectionRepeatStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDNMoviePlayerReleaseSectionRepeatNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

#pragma mark -
#pragma mark AlertView Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == ALERTVIEW_ERROR_FINISH){
        [self appIsTerminated];
        
    }else if(alertView.tag == CDDR_DL_PROTOCOL_INVALID_PARAMETER && !from){
        [self appIsTerminated];
        
    }else if(alertView.tag == ALERTVIEW_PLAY_CONTINUE){
        //NSLog(@"replay movie after phone call");
        
        NSMutableString* urlString = [[NSMutableString alloc] initWithString:[contentURL absoluteString]];
        
        if(contentURL){
            contentURL = nil;
        }
        
        [self playMovie:urlString];
    }
    
	if(alertView.tag == ALERTVIEW_PLAY_CONTINUE){
        [self appIsTerminated];
    }
    
    //이어보기 체크
    if(alertView.tag == TAG_MSG_STREMCONTINUE){
        //이어보기
        if(buttonIndex == 0){
            posCheck = 0;
            //처음부터 보기
        }else if(buttonIndex == 1){
            posCheck = 1;
        }
        
        cId = [posDic valueForKey:@"cId"];
        
        if ([[posDic objectForKey:@"contentPath"] length] < 1) {
            [self tableView:self.downloadListTable didSelectRowAtIndexPath:posIndexPath];
            
        }else{
            [self executePlayerWithContentData:posDic viewController:self];
        }
    }
}

- (void)appIsTerminated{
    [self clearOptionValue];
	
	//NSLog(@"app is terminated");
    
    exit(EXIT_SUCCESS);
}

#pragma mark -
#pragma mark CDNPlayerViewControllerDelegate

- (void)onCDNPlayerViewControllerDismissed:(BOOL)userExit{
    if (userExit) {
        
    }
}

@end

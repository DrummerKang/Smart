//
//  DownViewController.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 11..
//

#import "DownViewController.h"
#import "DownViewCell.h"
#import "AquaAlertView.h"
#import "Constants.h"
#import "AquaDBManager.h"
#import "MSKBase64.h"
#import "AquaContentHandler.h"
#import "AppErrorHandler.h"
#import "CDNMoviePlayer.h"
#import "mgGlobal.h"
#import "AppDelegate.h"
#import "mgCommon.h"
#import "JSONKit.h"

#define DATAKEY_ERROR @"_error"
#define DATAKEY_STATE @"_state"

#define DEST_PATH   [NSHomeDirectory() stringByAppendingString:@"/Documents/meg/"]
#define slashChar @"_%2F_"

@implementation DownViewController

@synthesize tableView;
@synthesize arrContents;
@synthesize downloadSession;
@synthesize contentPath;
@synthesize fileHandle;
@synthesize downloadHeader;
@synthesize downloadCell;
@synthesize downloadConnection;
@synthesize downloadContext;
@synthesize countNum;
@synthesize completeView;
@synthesize downNavigationBar;

static NSString *workingSessionID = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    //NSLog(@"func1");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentDownloadIndex = -1;
        downloadReady=YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:NSStringFromClass([DownViewController class]) object:nil];
        
        // 통신관련 통지
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:NOTI_REACHABILTY_CHANGE object:nil];
        
        // 초기화
        if (arrContents == nil) {
            arrContents = [[NSMutableArray alloc] init];
            
            [arrContents setArray:(NSMutableArray *)[[AquaDBManager sharedManager] selectDownloadContentWithCustomerId:nil cid:nil]];
        }
        
        workingSessionID = [[NSString alloc]initWithFormat:@""];
        nRetry = 0;
        afterDelete = false;
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    //NSLog(@"func2");
    [super viewDidLoad];
    
    completeView.hidden = YES;
    delNumber = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [downNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    downNavigationBar.translucent = NO;
    [downNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                           [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                           [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    if (self.tableView != nil) {
        self.tableView._dlgt_mgTableView = self;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
}

- (void)reachabilityChanged:(id)sender
{
    //NSLog(@"func3");
    if ([[sender valueForKey:@"object"]isEqualToString:@"0"]) {
        // 연결 실패일떄 처리
        [self onDisconnected];
    }else{
        // 연결 일때 처리
        [self onDisconnected];
        [self onConnected];
    }
}

// 통신연결시
- (void)onConnected
{
    //NSLog(@"통신연결성공");

    if (currentDownloadIndex > -1) {
        [self performSelector:@selector(downloadContentAt:) withObject:[NSNumber numberWithInt:currentDownloadIndex] afterDelay:0.1];
    }
}

// 통신실패시
- (void)onDisconnected
{
    //NSLog(@"통신연결실패");
    
    // 모든세션 초기화
    workingSessionID = [[NSString alloc]initWithFormat:@""];
    nRetry = 0;
    
    // 모든 상태 일시정지
    int cnt = arrContents.count;
    int idx = 0;
    for (idx=0; idx<cnt; idx++) {
        DownViewCell *cell = (DownViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if (cell != nil) {
            [cell setHasSession:NO];
            cell.state = DownViewCellStatePause;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    completeView.hidden = YES;
    //NSLog(@"func4");
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidUnload{
    //NSLog(@"func5");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_REACHABILTY_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSStringFromClass([DownViewController class]) object:nil];
    [self setDelBtn:nil];
    [self setCountNum:nil];
    [self setCompleteView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"func6");
    
    if ([workingSessionID isEqualToString:@""] && arrContents.count > 0) {
        [self downloadAt:0]; // 현재 진행중인 작업이 없고 받을 목록이 있다면 다운로드 해라
    }
}

#pragma mark -
#pragma mark functions

- (void) refreshTableView{
    //NSLog(@"func9");
    if (currentDownloadIndex >= 0) {
        return;
    }
    
    //[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextDownload) object:nil];
    
    currentDownloadIndex = -1;
    [self nextDownload];
    [tableView reloadData];
}

- (NSMutableArray *)arrContents{
    //NSLog(@"func10");
    if (arrContents == nil) {
        arrContents = [[NSMutableArray alloc] init];
        
        [arrContents setArray:(NSMutableArray *)[[AquaDBManager sharedManager] selectDownloadContentWithCustomerId:nil cid:nil]];
    }
    
    return arrContents;
}

//완료버튼
- (IBAction)completeBtn:(id)sender {
    if ([[mgCommon getDeviceModel]isEqualToString:@"iPad"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DismissDownloadList" object:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//강좌보관함 버튼
- (IBAction)downloadListBtn:(id)sender {
    if ([[mgCommon getDeviceModel]isEqualToString:@"iPad"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeTabBarAfterDismiss" object:nil];
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:@"1"];
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"DOWNLOADLIST" forKey:@"downloadList"];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"downloadList" object:self userInfo:dic];
    }
}

//전체삭제
- (IBAction)delBtn:(id)sender {
    if (![workingSessionID isEqualToString:@""]) {
        [self showAlertChoose:@"현재 다운로드 중입니다.\n내용 전체를 삭제하시겠습니까?" tag:TAG_MSG_DOWNALLDEL];
    }
}

- (void)deleteAllItems{
    //NSLog(@"func11");
    
    afterDelete = true;
    
    NSMutableArray *downloadCIDArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllCID:downloadCIDArr];
    //NSLog(@"%d", [downloadCIDArr count]);
    
    for(int i = 0; i < [downloadCIDArr count]; i++){
        NSMutableDictionary *item = [downloadCIDArr objectAtIndex:i];
        NSString *delContentName = [NSString stringWithFormat:@"%@.cnm", [item valueForKey:@"cId"]];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[DEST_PATH stringByAppendingPathComponent:delContentName] error:NULL];
    }

    [[AquaDBManager sharedManager] deleteTableAllDataWithTableName];
    
    //NSLog(@"%d", [downloadCIDArr count]);
    
    [arrContents removeAllObjects];
    //NSLog(@"removeAllObjects");
    
    downloadReady = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(self.fileHandle){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    
    self.downloadConnection = nil;
    
    if (![CDNMoviePlayer deleteSessionInfo:contentPath session:downloadSession]) {
        //NSLog(@"cententPath=%@, downloadSession=%@", contentPath, downloadSession);
    }
    
    [tableView reloadData];
    
    [self showAlert:@"전체삭제가 완료되었습니다." tag:TAG_MSG_DOWN_BACK];
}

- (void)addItem:(NSDictionary *)dicData param:(NSString *)param{
    //NSLog(@"func12");
    [self refreshTableView];
    
    NSString *decryptParam = [CDNMoviePlayer decryptString:param];
    NSLog(@"decrypt : %@", decryptParam);
    
    NSDictionary *contexts =[CDNMoviePlayer downloadContextWithParam:param];
    
    if (contexts) {
        //NSLog(@"download context is not null");
        downloadContext = [contexts objectForKey:@"downloadcontext"];
        //NSLog(@"%@", downloadContext);
        if (downloadContext) {
            NSDictionary *watermarkContext = [contexts objectForKey:@"watermarkcontext"];
            
            if (watermarkContext) {
                //[CDNPlayerViewWatermark setDBWatermarkCustomerId:downloadContext.customerId context:watermarkContext];
            }
        }
    }
    
    cidNum = [dicData valueForKey:@"VODID"];
    NSString *downloadUrl = [dicData valueForKey:@"VODURL"];
    NSString *path = [dicData valueForKey:@"VODNAME"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@.cnm", [AquaContentHandler basePath], downloadContext.customerId, cidNum];
    NSString *lecCD = [dicData valueForKey:@"LEC_CD"];
    NSString *moveQuality = [dicData valueForKey:@"MOVEQUALITY"];
    NSString *chr_nm = [dicData valueForKey:@"CHR_NM"];
    NSString *subject = [dicData valueForKey:@"SUBJECT"];
    NSString *teacher = [dicData valueForKey:@"TEACHER"];
    NSString *imgPath = [dicData valueForKey:@"IMGPATH"];
    NSString *finish = [dicData valueForKey:@"FINISHDAY"];
    NSString *offline_period = [dicData valueForKey:@"OFFLINEPERIOD"];
    //NSString *smi = [dicData valueForKey:@"smi"];

    NSDictionary *contextDic = [NSDictionary dictionaryWithObjectsAndKeys:downloadContext.customerId,@"customerid",downloadContext.downloadListUrl,@"download_list_url",downloadContext.userId,@"userid", nil];
    
    NSDictionary *dic = [[AquaDBManager sharedManager] getDownloadDictionaryWithCid:cidNum userId:self.downloadContext.userId customerId:downloadContext.customerId downloadListUrl:downloadUrl path:path downloadContext:[contextDic JSONString] filePath:filePath lecCD:lecCD moveQuality:moveQuality chr_nm:chr_nm subject:subject teacher:teacher imgPath:imgPath finish:finish pos:@"0" offlinePeriod:offline_period lastOfflinePlayDate:@""];
    
    if ([[AquaDBManager sharedManager] insertDownloadContentWithDictionary:dic]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL ret = [fileManager fileExistsAtPath:filePath];
        
        if (ret) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    
    NSMutableArray *arr2 = (NSMutableArray *)[[AquaDBManager sharedManager] selectDownloadContentWithCustomerId:nil cid:nil];
    for (int i = 0; i < arr2.count; i++) {
        NSDictionary *row = [arr2 objectAtIndex:i];

        if (![self IsSameLecCD:[row valueForKey:@"lecCD"]]) {
            [arrContents addObject:row];
        }   
    }
}

- (bool)IsSameLecCD:(NSString*)lecCD
{
    //NSLog(@"func13");
    
    int cnt = arrContents.count;
    int idx = 0;
    for (idx=0; idx < cnt; idx++) {
        if ([[[arrContents objectAtIndex:idx]valueForKey:@"lecCD"]isEqualToString:lecCD]) {
            return true;
        }
    }
    
    return false;
}

- (int)addObjects:(NSArray *)arr{
    //NSLog(@"func14");
    
    int cnt = 0;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *data = [arr objectAtIndex:i];
        NSString *cid = [data objectForKey:@"cid"];
        NSString *downloadUrl = [data objectForKey:@"url"];
        NSString *path = [data objectForKey:@"path"];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@.cnm", [AquaContentHandler basePath], downloadContext.customerId, cid];
        NSString *lecCD = [data objectForKey:@"LEC_CD"];
        NSString *moveQuality = [data valueForKey:@"MOVEQUALITY"];
        NSString *chr_nm = [data valueForKey:@"CHR_NM"];
        NSString *subject = [data valueForKey:@"SUBJECT"];
        NSString *teacher = [data valueForKey:@"TEACHER"];
        NSString *imgPath = [data valueForKey:@"IMGPATH"];
        NSString *finish = [data valueForKey:@"FINISHDAY"];
        NSString *offline_period = [data valueForKey:@"OFFLINEPERIOD"];
        
        NSDictionary *contextDic = [NSDictionary dictionaryWithObjectsAndKeys:downloadContext.customerId,@"customerid",downloadContext.downloadListUrl,@"download_list_url",downloadContext.userId,@"userid", nil];
        
        NSDictionary *dic = [[AquaDBManager sharedManager] getDownloadDictionaryWithCid:cid userId:downloadContext.userId customerId:downloadContext.customerId downloadListUrl:downloadUrl path:path downloadContext:[contextDic JSONString] filePath:filePath lecCD:lecCD moveQuality:moveQuality chr_nm:chr_nm subject:subject teacher:teacher imgPath:imgPath finish:finish pos:@"0" offlinePeriod:offline_period lastOfflinePlayDate:@""];
        
        if ([[AquaDBManager sharedManager] insertDownloadContentWithDictionary:dic]) {
            cnt++;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL ret = [fileManager fileExistsAtPath:filePath];
            
            if (ret) {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
    
    NSMutableArray *arr2 = (NSMutableArray *)[[AquaDBManager sharedManager] selectDownloadContentWithCustomerId:nil cid:nil];
    for (int i = 0; i < arr2.count; i++) {
        NSDictionary *row = [arr2 objectAtIndex:i];
        
        if (![self IsSameLecCD:[row valueForKey:@"lecCD"]]) {
            [arrContents addObject:row];
        }
    }
    
    [tableView reloadData];
    return cnt;
}

- (void) downloadAt:(int)index{
    //NSLog(@"func15");
    
    [self performSelector:@selector(downloadContentAt:) withObject:[NSNumber numberWithInt:index] afterDelay:0.1];
}

- (void) nextDownload{
    //NSLog(@"download index : %d", currentDownloadIndex+1);
    
    if (currentDownloadIndex < 0 && arrContents.count > 0) {
        currentDownloadIndex = 0; // 현재 선택된 것이 없고 다운받을 것이 없는 것이 아니라면 첨 것 부터 받아
    }
    
    //NSLog(@"download index : %d", currentDownloadIndex);
    //NSLog(@"freespace = %f GB", [mgCommon freeDiskspace]/1073741824.0f);
    
    [self performSelector:@selector(downloadContentAt:) withObject:[NSNumber numberWithInt:currentDownloadIndex] afterDelay:0.1];
    //[self performSelector:@selector(downloadContentAt:) withObject:[NSNumber numberWithInt:currentDownloadIndex+1] afterDelay:0.1];
}

- (void) setFinishForCellIndex:(int)index{
    //NSLog(@"func17");
    
    NSMutableDictionary *data = [arrContents objectAtIndex:index];
    [data setValue:[NSNumber numberWithInt:DownViewCellStateFinished] forKey:DATAKEY_STATE];

    workingSessionID = [[NSString alloc]initWithFormat:@""];
    nRetry = 0;
    [self disableAllAccBtn];
}

- (void)downloadCancel{
    //NSLog(@"func18");
    
    [self.downloadConnection cancel];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    currentDownloadIndex = -1;
    downloadReady = YES;
    self.downloadConnection = nil;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadContentAt:(NSNumber *)num{
    //NSLog(@"func19");
    
    if (num) {
        currentDownloadIndex = [num intValue];
        
        if (currentDownloadIndex >= [self.arrContents count]) {
            currentDownloadIndex = -1;
            
            if (self.arrContents.count > 0) {
                [self performSelector:@selector(nextDownload) withObject:nil afterDelay:3];
            }
            
            return;
        }
    }
    
    [tableView reloadData];
    
    NSDictionary *data = [arrContents objectAtIndex:currentDownloadIndex];
    
    if ([data objectForKey:DATAKEY_STATE]) {
        DownViewCellState state = (DownViewCellState)[[data objectForKey:DATAKEY_STATE] intValue];
        
        if (state == DownViewCellStateFinished) {
            [self nextDownload];
            return;
        }
    }
    
    downloadReady = NO;
    
    [self performSelectorInBackground:@selector(getContentHeaderDownloadContext:) withObject:[NSNumber numberWithInt:currentDownloadIndex]];
}

- (void)getContentHeaderDownloadContext:(NSNumber *)index{
    //NSLog(@"func20");
    
    if (index == nil) {
        return;
    }
    
    @autoreleasepool {
        //NSLog(@"arr : %@", arrContents);
        
        //[tableView reloadData];
        
        NSDictionary *data = [arrContents objectAtIndex:[index intValue]];
        NSString *downloadUrl = [data objectForKey:@"downloadListUrl"];
        NSString *downContext = [data objectForKey:@"downloadContext"];
        NSString *custId = [data objectForKey:@"customerId"];
        NSString *cid = [data objectForKey:@"cId"];
        
        self.contentPath = [NSString stringWithFormat:@"/%@/%@.cnm", custId, cid];
        //NSLog(@"contentPath : %@", contentPath);
        //NSLog(@"downloadSession : %@", self.downloadSession);

        downloadContext = nil;
        if (!downContext) {
            //context = [APPDELEGATE downloadContext];
            
        }else {
            NSDictionary *contextDic = [downContext objectFromJSONString];
            //NSLog(@"contextDic : %@", contextDic);
            downloadContext = [[CDNDownloadContext alloc] init];
            downloadContext.customerId = [contextDic objectForKey:@"customerid"];
            downloadContext.downloadListUrl = [contextDic objectForKey:@"download_list_url"];
            downloadContext.userId = [contextDic objectForKey:@"userid"];

        if([[mgCommon getDeviceModel]isEqualToString:@"iPad"])
            {
                [APPDELEGATE setDownloadContext:downloadContext];
            }else{
                [APPDELEGATE setDownloadContext:downloadContext];   
            }
        }
        
        CDNDownloadHeader *downHeader = nil;
        
        NSString *filePath = [data objectForKey:@"filePath"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL ret = [fileManager fileExistsAtPath:filePath];
        if (ret) {
            
            if (self.downloadSession != nil) {
                if ([workingSessionID isEqualToString:@""] || workingSessionID == nil) {
                     //NSLog(@"Empty Session = %@", self.downloadSession.sid);
                    workingSessionID = [[NSString alloc]initWithFormat:@"%@",  self.downloadSession.sid];
                }
                
                if (![workingSessionID isEqualToString:self.downloadSession.sid]) {
                    //NSLog(@"Difference Session > %@ != %@", workingSessionID, self.downloadSession.sid);
                    return;
                }
            }else{
                if ([workingSessionID isEqualToString:@""]) {
                    //NSLog(@"Empty Session = %@", self.downloadSession.sid);
                    workingSessionID = [[NSString alloc]initWithFormat:@"%@",  self.downloadSession.sid];
                }else
                    return;
            }
            
            downHeader = [CDNMoviePlayer getContentHeaderDownloadContext:downloadContext url:downloadUrl cid:cid contentPath:contentPath];
            //NSLog(@"이어받기 시작");

            DownViewCell *cell = (DownViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]];
            [cell hasSession:true];
        }else {

            if (self.downloadSession != nil) {
                if ([workingSessionID isEqualToString:@""] || workingSessionID == nil) {
                    //NSLog(@"Empty Session = %@", self.downloadSession.sid);
                    workingSessionID = [[NSString alloc]initWithFormat:@"%@",  self.downloadSession.sid];
                }
                
                if (![workingSessionID isEqualToString:self.downloadSession.sid]) {
                    //NSLog(@"Difference Session > %@ != %@", workingSessionID, self.downloadSession.sid);
                    return;
                }
            }else{
                if ([workingSessionID isEqualToString:@""]) {
                    //NSLog(@"Empty Session = %@", self.downloadSession.sid);
                    workingSessionID = [[NSString alloc]initWithFormat:@"%@",  self.downloadSession.sid];
                }else
                    return;
            }
            
            NSLog(@"context : %@", downloadContext);
            NSLog(@"url : %@\n,cid : %@\n, contentPath : %@", downloadUrl, cid, contentPath);
            downHeader = [CDNMoviePlayer getContentHeaderDownloadContext:downloadContext url:downloadUrl cid:cid contentPath:contentPath];
            //NSLog(@"새로받기 시작");
            DownViewCell *cell = (DownViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]];
            [cell hasSession:true];
        }
        
        [self performSelectorOnMainThread:@selector(downloadCurrentFile:) withObject:downHeader waitUntilDone:NO];
    }
}

- (void)downloadCurrentFile:(CDNDownloadHeader *)downHeader{
    //NSLog(@"func21");
    
    if (currentDownloadIndex < 0) {
        return;
    }
    
    if (arrContents.count <= 0) {
        return;
    }
    
    if (downHeader) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSDictionary *data = [arrContents objectAtIndex:currentDownloadIndex];
        NSString *custId = [data objectForKey:@"customerId"];
        NSString *downloadUrl = [data objectForKey:@"url"];
        
        if (downloadUrl == nil) {
            downloadUrl = [data objectForKey:@"downloadListUrl"];
        }
        
        BOOL ret = [fileManager fileExistsAtPath:[data objectForKey:@"filePath"]];
        self.downloadSession = downHeader.session;
        
        unsigned long long header = downHeader.drmHeaderLength;
        unsigned long long content = downHeader.contentSize;
        
        NSString *fullPath = [[AquaContentHandler basePath] stringByAppendingPathComponent:contentPath];
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
        
        if(fileHandle == nil) {
            NSString *dir = [[AquaContentHandler basePath] stringByAppendingPathComponent:custId];
            
            if ([fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil]) {
                if ([fileManager createFileAtPath:fullPath contents:nil attributes:nil]) {
                    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
                    
                }else {
                    return;
                }
                
            }else {
                return;
            }
            
        } else {
            [fileHandle seekToEndOfFile];
        }
        
        if (fileHandle == nil) {
            return;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSDictionary *dic = [fileManager attributesOfFileSystemForPath:[paths lastObject] error:nil];
        unsigned long long freeSize = [[dic objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
        unsigned long long size = content;
        
        if (ret) {
            unsigned long long filesize = [fileHandle seekToEndOfFile];
            
            if (content > filesize) {
                size = content - filesize;
                
            }else{
                //삭제?
            }
        }
        
        if (size > freeSize) {
            return;
        }
        
        CDNSession *session = [CDNMoviePlayer getDownloadTid:self.downloadSession];
        if (session) {
            //NSLog(@"SESSION_SID=%@ , SESSION_TID=%@", session.sid, session.tid);
            self.downloadSession = session;
            
            NSURL *url = [NSURL URLWithString:downloadUrl];
            [[AquaDBManager sharedManager] updateDownloadContentWithId:[[data objectForKey:@"_id"] intValue] totalSize:content];
            [data setValue:[NSString stringWithFormat:@"%llu", content] forKey:@"totalSize"];
            self.downloadConnection = nil;
            
            if (ret){
                //NSLog(@"이어서 파일쓰기 시작");
                downBytes = [fileHandle seekToEndOfFile] - header;
                
                if (downBytes+header >= content) {
                    //NSLog(@"이미 다받음");
                    [self finishDownloadFile];
                    return;
                }
                
                NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
                [req setValue:[NSString stringWithFormat:@"sid=%@;tid=%@",downloadSession.sid,downloadSession.tid] forHTTPHeaderField:@"Cookie"];
                [req setValue:[NSString stringWithFormat:@"%d", downloadSession.hash] forHTTPHeaderField:@"X-Auth-hash"];
                [req setValue:[NSString stringWithFormat:@"bytes=%llu-%llu", downBytes+4110, content+4110-1] forHTTPHeaderField:@"Range"];
                //NSLog(@"Range : bytes=%llu-%llu", downBytes+4110, content+4110-1);
                self.downloadConnection = [NSURLConnection connectionWithRequest:req delegate:self];
                [req release];
                
            }else{
                //NSLog(@"새로운 파일쓰기 시작");
                downBytes = 0;
                [fileHandle seekToFileOffset:0];
                
                NSData *data = [NSData base64DataFromString:downHeader.drmHeader];
                [fileHandle writeData:data];
                [fileHandle seekToEndOfFile];
                
                NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
                [req setValue:[NSString stringWithFormat:@"sid=%@;tid=%@",downloadSession.sid,downloadSession.tid] forHTTPHeaderField:@"Cookie"];
                [req setValue:[NSString stringWithFormat:@"%d", downloadSession.hash] forHTTPHeaderField:@"X-Auth-hash"];
                [req setValue:[NSString stringWithFormat:@"bytes=4110-%llu", content+4110-1] forHTTPHeaderField:@"Range"];
                //NSLog(@"Range : bytes=4110-%llu", content+4110-1);
                self.downloadConnection = [NSURLConnection connectionWithRequest:req delegate:self];
                [req release];
            }
            
            self.downloadHeader = downHeader;
            //NSLog(@"start : %llu", downBytes);
            self.downloadCell = (DownViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentDownloadIndex inSection:0]];
            self.downloadCell.state = DownViewCellStateDownloading;
        }
    }
}

- (void)enableAllAccBtn
{
    int cnt = arrContents.count;
    int idx = 0;
    for (idx=0; idx<cnt; idx++) {
        DownViewCell *cell = (DownViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if (cell != nil) {
            cell.stateImageView.enabled = YES;
        }
    }
}

- (void)disableAllAccBtn
{
    int cnt = arrContents.count;
    int idx = 0;
    for (idx=0; idx<cnt; idx++) {
        DownViewCell *cell = (DownViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if (cell != nil) {
            cell.stateImageView.enabled = NO;
            [cell setHasSession:NO];
        }
    }
}

- (void)onAccClick:(DownViewCell *)cell at:(int)index{
    //NSLog(@"func22");
    
    // 이어받기 버튼 누르면 작업중 세션은 초기화 시킨다.
    workingSessionID = [[NSString alloc]initWithFormat:@""];
    nRetry = 0;
    
    
    if (cell.state == DownViewCellStateDownloading && currentDownloadIndex == index) {
        if (!downloadReady) {
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(getContentHeaderDownloadContext:) object:[NSNumber numberWithInt:index]];
            downloadReady = YES;
        }
        
        [self downloadCancel];
        
        cell.state = DownViewCellStatePause;
        
        self.downloadCell = nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self enableAllAccBtn];
        
    }else if(cell.state == DownViewCellStatePause){
        if (currentDownloadIndex >= 0 && downloadConnection) {
            [AquaAlertView showWithId:0 title:LocalizedString(k_notice_title) message:LocalizedString(k_one_content_download) data:nil delegate:nil type:AquaAlertViewTypeOK];
            return;
        }
        
        [cell hasSession:false];
        
        self.downloadCell = cell;

        [self downloadAt:index];
        
        [self disableAllAccBtn];
        
    }else if(cell.state == DownViewCellStateExpired){
        NSDictionary *data = [arrContents objectAtIndex:index];
        int errCode = [[data objectForKey:DATAKEY_ERROR] intValue];
        
        if (errCode == APP_DOWNLOAD_CONNECTION_ERROR || errCode == CDDR_DL_NETWORK_ERROR) {
            if (currentDownloadIndex < 0 && [UIDevice networkAvailable]) {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:index] forKey:@"index"];
                [AquaAlertView showCustomTypeWithId:APP_DOWNLOAD_CONNECTION_ERROR title:LocalizedString(k_notice_title) message:LocalizedString(k_connet_network) data:dic delegate:self button1:LocalizedString(k_retry_btn) button2:LocalizedString(k_cancel_btn)];
            }
            
        }else {
            [AquaAlertView showWithId:0 title:LocalizedString(k_notice_title) message:[AppErrorHandler messageFromCode:errCode] data:nil delegate:nil type:AquaAlertViewTypeOK];
        }
    }
}

#pragma mark -
#pragma mark NSURLConectionDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response {
    
    //NSLog(@"func23");
    
    //NSLog(@"%d",[response statusCode]);
    
    if ([response statusCode] == 403){
        return nil;
    }
    
    if ([response statusCode] == 302) {
        downloadReady = YES;
        //NSLog(@"302 : %@", [response allHeaderFields]);
        NSString *url = [[response allHeaderFields] objectForKey:@"Location"];
        [[arrContents objectAtIndex:currentDownloadIndex] setValue:url forKey:@"url"];
        self.downloadConnection = nil;
        return nil;
    }
    
    //NSLog(@"didReceiveResponse : %@", [response allHeaderFields]);
    
    NSMutableDictionary *data = [arrContents objectAtIndex:currentDownloadIndex];
    [data removeObjectForKey:DATAKEY_ERROR];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    //NSLog(@"func24");
    
    //NSLog(@"%d",[response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"func24");
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle seekToEndOfFile];
    downBytes += [data length];
    
    if (downloadHeader) {
        unsigned long long content = downloadHeader.contentSize;
        NSArray *arr = [tableView indexPathsForVisibleRows];
        
        for (int i = 0; i < arr.count; i++) {
            int idx = [[arr objectAtIndex:i] row];
            
            if (idx == currentDownloadIndex) {
                DownViewCell *cell = (DownViewCell *)[tableView cellForRowAtIndexPath:[arr objectAtIndex:i]];
                [cell setSize:downBytes total:content];
                break;
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"func25");
    
    downloadReady = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(self.fileHandle){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    
    if (downloadConnection == connection) {
        self.downloadConnection = nil;
    }
    
    if (![CDNMoviePlayer deleteSessionInfo:contentPath session:downloadSession]) {
    }
    
    if (currentDownloadIndex > -1) {
        DownViewCell *cell = (DownViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentDownloadIndex inSection:0]];
        [cell setHasSession:false];
        cell.state = DownViewCellStatePause;
        [[arrContents objectAtIndex:currentDownloadIndex]setValue:DownViewCellStatePause forKey:DATAKEY_STATE];
        workingSessionID = [[NSString alloc]initWithFormat:@""];
//        nRetry = 0;
    }
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if ((nRetry < 3) && (_app._ReachStatus != COMM_NOTACCESS)) {
        [self downloadAt:currentDownloadIndex];
    }else{
        nRetry = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"현재 통신상태가 좋지 않습니다.\n잠시후 다시 시도하여 주십시요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"func26");
    
    if (self.downloadConnection != connection) {
        return;
    }
    
    downloadReady = YES;
    
    self.downloadConnection = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [AquaContentHandler basePath],contentPath];
    [[AquaDBManager sharedManager] deleteDownloadContentWithFilePath:filePath];
    
    [self finishDownloadFile];
    
    if (![CDNMoviePlayer endDownload:contentPath session:self.downloadSession]) {
        //[AquaAlertView showWithTitle:@"ERROR" message:LocalizedString(@"") data:nil delegate:nil type:AquaAlertViewTypeOK];
    }
    
    [self nextDownload];
}

- (void) finishDownloadFile{
    //NSLog(@"func27");
    
    if (currentDownloadIndex < arrContents.count) {
        NSDictionary *data = [arrContents objectAtIndex:currentDownloadIndex];
        NSString *custId = [data objectForKey:@"customerId"];
        NSString *cid = [data objectForKey:@"cId"];
        NSString *userid = [data objectForKey:@"userId"];
        NSString *path = [data objectForKey:@"path"];
        NSString *lecCD = [data objectForKey:@"lecCD"];
        NSString *moveQuality = [data objectForKey:@"moveQuality"];
        NSString *chr_nm = [data valueForKey:@"chr_nm"];
        NSString *subject = [data valueForKey:@"subject"];
        NSString *teacher = [data valueForKey:@"teacher"];
        NSString *imgPath = [data valueForKey:@"imgPath"];
        NSString *finish = [data valueForKey:@"finish"];
        NSString *offline_period = [data valueForKey:@"offlinePeriod"];
        
        //NSLog(@"path : %@", path);
        if ([path hasPrefix:@"/"]) {
            path = [path substringFromIndex:1];
        }
        
        NSArray *arrPaths = [AquaContentHandler splitPathString:path];
        NSString *parent = @"";
        NSString *customer = [arrPaths objectAtIndex:0];
        NSString *category = [arrPaths objectAtIndex:1];
        NSString *title = nil;
        
        for (int i = 0; i < arrPaths.count; i++) {
            title = [arrPaths objectAtIndex:i];
        }
        NSString *curTime = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]];
        //NSLog(@"current content : %@", contentPath);
        
        if ([[AquaDBManager sharedManager] insertContentWithCustomerId:custId cId:cid userId:userid path:path parent:parent title:title contentPath:contentPath customer:customer category:category saveTime:curTime lecCD:lecCD moveQuality:moveQuality chr_nm:chr_nm subject:subject teacher:teacher imgPath:imgPath finish:finish pos:@"0" offlinePeriod:offline_period lastOfflinePlayDate:@""]){
        }
        
        if ([[AquaDBManager sharedManager] deleteDownloadContentWithId:[[data objectForKey:@"_id"] intValue]]) {
            [self setFinishForCellIndex:currentDownloadIndex];
        }
        
        delNumber = 0;
        NSString *alertStr = [NSString stringWithFormat:@"[%@] 강좌 다운이 완료 되었습니다.", title];
        
        //[self showAlert:alertStr tag:TAG_MSG_NONE];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LectureDownloaded" object:nil];
        
        [self fireLocalPushMessage:alertStr];
    }
    
    [arrContents removeObjectAtIndex:currentDownloadIndex];
    //NSLog(@"[arrContents removeObjectAtIndex:currentDownloadIndex]");
    [tableView reloadData];
}

#pragma mark -
#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"func28");
    NSString *countStr = [NSString stringWithFormat:@"총 %d강", [arrContents count]];
    countNum.text = countStr;
    
    //NSLog(@"Download Count : %d", arrContents.count);
    
    //다운로드 다되면 view
    NSMutableArray *downloadArr = [[NSMutableArray alloc] init];
    [[AquaDBManager sharedManager] downloadingAllLecCD:downloadArr];
    if([downloadArr count] == 0){
        if(delNumber == 0){
            completeView.hidden = NO;
        }
    }
    
    return arrContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"func29");
    
    DownViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:[DownViewCell identifier]];
    if (cell == nil) {
        cell = [DownViewCell create];
    }
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    NSMutableDictionary *data = [arrContents objectAtIndex:indexPath.row];
    NSNumber *state = [data objectForKey:DATAKEY_STATE];
    
    if (state) {
        cell.state = (DownViewCellState)[state intValue];
        
    }else {
        NSNumber *err = [data objectForKey:DATAKEY_ERROR];
        
        if (err) {
            cell.state = DownViewCellStateExpired;
            
        }else {
            if (currentDownloadIndex == indexPath.row){
                cell.state = DownViewCellStateDownloading;
                
            }else
                cell.state = DownViewCellStatePause;
        }
    }
    
    NSString *file = [data objectForKey:@"filePath"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *totSize = [numFormatter numberFromString:[data objectForKey:@"totalSize"]];
        [numFormatter release];
        
        unsigned long long total = [totSize unsignedLongLongValue];
        unsigned long long current = 0;
        
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
        current = [[fileInfo objectForKey:NSFileSize] unsignedLongLongValue];
        [cell setSize:current total:total];
        
    }else {
        [cell setSize:0 total:0];
    }
    
    NSString *path = [data objectForKey:@"path"];
    NSLog(@"%@", path);
    NSArray *arrPaths = [AquaContentHandler splitPathString:path];
    NSMutableString *title = [NSMutableString string];
    
    for (int i = 0; i < arrPaths.count-1; i++) {
        if (i == arrPaths.count - 2) {
            [title appendString:[arrPaths objectAtIndex:i]];
            
        }else {
            [title appendFormat:@"%@/",[arrPaths objectAtIndex:i]];
        }
    }
    
    NSString *subTitle = nil;
    NSArray *seqArray = [[arrPaths objectAtIndex:arrPaths.count-1] componentsSeparatedByString:@"."];
    
    if([seqArray count] == 3){
        NSString *str1 = [seqArray objectAtIndex:1];
        NSString *str2 = [seqArray objectAtIndex:2];
        subTitle = [NSString stringWithFormat:@"%@.%@", str1, str2];
    }else if([seqArray count] == 2){
        subTitle = [seqArray objectAtIndex:1];
    }else{
        subTitle = [arrPaths objectAtIndex:arrPaths.count-1];
    }
    
    cell.subTitleLabel.text = subTitle;//[arrPaths objectAtIndex:arrPaths.count-1];
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (float) tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"func30");
    
    return 60;
}

- (void)mgTableViewBeginReloadData
{
    ;
}
- (void)mgTableViewEndReloadData
{
    // 테이블 리로드후 세션유무 체크해서 없으면
    // 전부 다운로드 가능 상태로 바꿈
    
    if (afterDelete == true) {
        [self enableAllAccBtn];
        afterDelete = false;
    }
    
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}

- (void)delAction:(UIButton *)sender{
    delNumber = 1;
    
    //NSLog(@"func31");
    afterDelete = true;
    
    //NSLog(@"%d", sender.tag);
    
    NSDictionary *data = [self.arrContents objectAtIndex:sender.tag];
    
    if ([[AquaDBManager sharedManager] deleteDownloadContentWithId:[[data objectForKey:@"_id"] intValue]]) {
        [self setFinishForCellIndex:sender.tag];
    }
    
    //NSLog(@"cententPath=%@, downloadSession=%@", contentPath, downloadSession);
    
    if (![CDNMoviePlayer deleteSessionInfo:contentPath session:downloadSession]) {
        //NSLog(@"cententPath=%@, downloadSession=%@", contentPath, downloadSession);
    }
    
    [self.arrContents removeObjectAtIndex:sender.tag];
    //NSLog(@"[self.arrContents removeObjectAtIndex:sender.tag]");
    
    [tableView reloadData];
    
    [self showAlert:@"취소되었습니다." tag:TAG_MSG_NONE];
}

- (void)fireLocalPushMessage:(NSString*)message
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if (localNotif == nil)
        return;
    
    //localNotif.fireDate = itemDate;
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification details
    localNotif.alertBody = message;
	// Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:message forKey:@"message"];
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    
}

#pragma mark -
#pragma UIAlertView 관련

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_MSG_DOWNALLDEL){
        if(buttonIndex == 1){
            delNumber = 1;
            [self deleteAllItems];
        }
    }
    
    if(alertView.tag == TAG_MSG_DOWN_BACK){
        [self.navigationController popViewControllerAnimated:YES];
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

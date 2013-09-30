//
//  mgMenuVC.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 6. 4..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgMenuVC.h"
#import "AppDelegate.h"
#import "mgMainProfileVC.h"
#import "mgMessageVC.h"
#import "mgCommon.h"

@implementation mgMenuVC

@synthesize goal;

- (id)init{
    if(self == [super init]){
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //강좌보관함 이동
    NSNotificationCenter *downListNC = [NSNotificationCenter defaultCenter];
    [downListNC addObserver:self selector:@selector(downloadList:) name:@"downloadList" object:nil];
    
    //마이톡 푸시노티
    NSNotificationCenter *ncTalk = [NSNotificationCenter defaultCenter];
    [ncTalk addObserver:self selector:@selector(talk:) name:@"talk" object:nil];
    
    //수강중인 강좌 푸시 노티
    NSNotificationCenter *ncLec = [NSNotificationCenter defaultCenter];
    [ncLec addObserver:self selector:@selector(lec:) name:@"lec" object:nil];
    
    //마이톡 뱃지
    //NSNotificationCenter *ncTalkBadge = [NSNotificationCenter defaultCenter];
    //[ncTalkBadge addObserver:self selector:@selector(badge:) name:@"talk_badge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadge) name:@"RefreshBadge" object:nil];

    //프로필 리로드
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(reloadLog:) name:@"reloadProfile" object:nil];

    if (myTalkBagde == nil) {
        myTalkBagde = [CustomBadge customBadgeWithString:@"0" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        myTalkBagde.frame = CGRectMake(94, 204, 30, 30);
        [self.view addSubview:myTalkBagde];
    }
    
    [self setBadge];
}

- (void)refreshBadge{
    [self setBadge];
}

- (void)setBadge{
    if (myTalkBagde != nil) {
        if ([UIApplication sharedApplication].applicationIconBadgeNumber <= 0) {
            myTalkBagde.hidden = YES;
        }else{
            [myTalkBagde autoBadgeSizeWithString:[[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber]];
            myTalkBagde.hidden = NO;
        }
    }
}

- (void)reloadLog:(NSNotification *)note{

    [self changeProfile];
}

- (void)viewWillAppear:(BOOL)animated{
    [self changeProfile];
}

- (void)changeProfile{
    NSLog(@"mgMenu::changeProfile");\
    
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // 초상화
    NSURL *url = [NSURL URLWithString:_app._config._sMyImage];
    
    //썸네일 이미지
    // 7.0이상
    if([mgCommon osVersion_7]){
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(14, 30, 40, 40)];
    }else {
        ImageViewEx = [[AsyncImageView alloc] initWithFrame:CGRectMake(14, 8, 40, 40)];
    }
    
    ImageViewEx.backgroundColor = [UIColor clearColor];
    ImageViewEx.layer.cornerRadius = 5.0f;
    ImageViewEx.layer.masksToBounds = YES;
    ImageViewEx.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ImageViewEx.layer.borderWidth = 1.0f;
    ImageViewEx.IsThumbNainSave = YES;
    [ImageViewEx SetImageViewParentRect:YES];
    [ImageViewEx SetImage:[UIImage imageNamed:@"thumb_noimg"]];
    ImageViewEx.notImagePath = @"thumb_noimg";
    [ImageViewEx loadImageFromURL:url];
    [self.view addSubview:ImageViewEx];
    
    goal.text = _app._config._sNickName;
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshBadge" object:nil];
    [self setGoal:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Button Action

- (void)touchProfileImage:(id)sender {
    UIStoryboard *_newStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MainProfile4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MainProfile" bundle:nil];
    }
    
    mgMainProfileVC *_profileVC = [_newStoryboard instantiateInitialViewController];
    _profileVC.navigationItem.title = @"내 프로필";
    [self.navigationController pushViewController:_profileVC animated:YES];
}

- (IBAction)home:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Main" bundle: nil];
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgHomeVC"];
    
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)myLec:(id)sender {
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLec4" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MyLec" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgMyLecVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)download:(id)sender {
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
       mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_DownList4" bundle: nil];
    }else{
       mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_DownList" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgDownloadListTVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)message:(id)sender {
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Msg4" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Msg" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgMessageVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)search:(id)sender {
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search4" bundle: nil];
        
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Search" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgSearchVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)setting:(id)sender {
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Setting4" bundle: nil];
        
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Setting" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgSettionVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (IBAction)profileBtn:(id)sender {
    UIStoryboard *_newStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MainProfile4" bundle:nil];
    }else{
        _newStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_MainProfile" bundle:nil];
    }
	
	UIViewController *vc ;
	vc = [_newStoryboard instantiateViewControllerWithIdentifier: @"cfgProfile"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

#pragma mark -
#pragma mark MYTALK PUSH

//마이톡 푸시 -> 마이톡 페이지로
- (void)talk:(NSNotification *)note{
    NSString *text = [[note userInfo] objectForKey:@"talk"];
    NSLog(@"talk : %@", text);
    
    [self talkNext:nil];
}

- (void)talkNext:(id)sender{
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Msg4" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Msg4" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgMessageVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

//마이톡 푸시 카운트
- (void)badge:(NSNotification *)note{
     NSString *badge = [[NSString alloc]initWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber];
    
    if (myTalkBagde == nil) {
        myTalkBagde = [CustomBadge customBadgeWithString:badge withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        myTalkBagde.frame = CGRectMake(94, 204, 30, 30);
        [self.view addSubview:myTalkBagde];
    }
    
    if ([badge isEqualToString:@"0"])
        myTalkBagde.hidden = YES;
    else{
        [myTalkBagde autoBadgeSizeWithString:badge];
        myTalkBagde.hidden = NO;
    }
}

#pragma mark -
#pragma mark LEC PUSH

//수강중인 강좌 푸시 -> 수강중인 강좌 페이지로
- (void)lec:(NSNotification *)note{
    NSString *text = [[note userInfo] objectForKey:@"lec"];
    NSLog(@"lec : %@", text);
    
    [self lecNext:nil];
}

- (void)lecNext:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_Main" bundle: nil];
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgMyLecVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

//강좌보관함 이동
- (void)downloadList:(id)sender{
    UIStoryboard *mainStoryboard = nil;
    
    //4인치 화면
    if ([mgCommon hasFourInchDisplay]) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_DownList4" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"SBiPn_DownList" bundle: nil];
    }
	
	UIViewController *vc ;
	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"mgDownloadListTVC"];
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
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

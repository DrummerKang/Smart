//
//  mgTabBarController.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 26..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgTabBarController.h"
#import "mgHomeVC_iPad.h"
#import "mgDownloadListVC_iPad.h"
#import "mgMessageVC_iPad.h"
#import "mgSearchVC_iPad.h"
#import "mgSettingVC_iPad.h"

enum{
    HOME_BUTTON_TAG             = 0,
    DOWNSTORAGE_BUTTON_TAG      = 1,
    MYTALK_BUTTON_TAG           = 2,
    SEARCH_BUTTON_TAG           = 3,
    SETTING_BUTTON_TAG          = 4,
    MAX_BUTTON_COUNT            = 5
};

@implementation mgTabBarController

@synthesize homeBtn;
@synthesize downStorageBtn;
@synthesize myTalkBtn;
@synthesize searchBtn;
@synthesize settingBtn;

@synthesize homeViewController;
@synthesize downListViewController;
@synthesize msgViewController;
@synthesize searchViewController;
@synthesize settingViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

#pragma mark -
#pragma mark -TabBar button 설정

//기본 탭바를 숨긴다.
- (void)hideTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

//탭바 버튼을 생성한다.
- (void)addCustomElements{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dDaySave:) name:@"dDaySave" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveTab:) name:@"moveTab" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadge) name:@"TalkReceived" object:nil];
    
    buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 719, 1024, 49)];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menubar"]];
    bgView.frame = CGRectMake(0, 0, 1024, 49);
    [buttonBgView addSubview:bgView];
    [self.view addSubview:buttonBgView];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"menu01"] forState:UIControlStateNormal];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"P_menu01_pressed"] forState:UIControlStateHighlighted];
    homeBtn.adjustsImageWhenHighlighted = NO;
    [homeBtn setFrame:CGRectMake(260, 2, 80, 45)];
    [homeBtn setTag:HOME_BUTTON_TAG];
    [homeBtn setImage:[UIImage imageNamed:@"P_menu01_pressed"] forState:UIControlStateSelected];
    [homeBtn setSelected:YES];

    downStorageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downStorageBtn setFrame:CGRectMake(366, 2, 80, 45)];
    [downStorageBtn setBackgroundImage:[UIImage imageNamed:@"menu02"] forState:UIControlStateNormal];
    [downStorageBtn setBackgroundImage:[UIImage imageNamed:@"P_menu02_pressed"] forState:UIControlStateHighlighted];
    [downStorageBtn setTag:DOWNSTORAGE_BUTTON_TAG];
    downStorageBtn.adjustsImageWhenHighlighted = NO;
    
    myTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myTalkBtn setFrame:CGRectMake(472,2, 80, 45)];
    [myTalkBtn setBackgroundImage:[UIImage imageNamed:@"menu03"] forState:UIControlStateNormal];
    [myTalkBtn setBackgroundImage:[UIImage imageNamed:@"P_menu03_pressed"] forState:UIControlStateHighlighted];
    [myTalkBtn setTag:MYTALK_BUTTON_TAG];
    myTalkBtn.adjustsImageWhenHighlighted = NO;
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(578, 2, 80, 45)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"menu04"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"P_menu04_pressed"] forState:UIControlStateHighlighted];
    [searchBtn setTag:SEARCH_BUTTON_TAG];
    searchBtn.adjustsImageWhenHighlighted = NO;
    
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(684, 2, 80, 45)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"menu05"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"P_menu05_pressed"] forState:UIControlStateHighlighted];
    [settingBtn setTag:SETTING_BUTTON_TAG];
    settingBtn.adjustsImageWhenHighlighted = NO;
    
	[buttonBgView addSubview:homeBtn];
	[buttonBgView addSubview:downStorageBtn];
	[buttonBgView addSubview:myTalkBtn];
    [buttonBgView addSubview:searchBtn];
	[buttonBgView addSubview:settingBtn];
	
	[homeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[downStorageBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[myTalkBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[settingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //selectBtnIndex = HOME_BUTTON_TAG;
    
    if (myTalkBagde == nil) {
        myTalkBagde = [CustomBadge customBadgeWithString:@"3" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        myTalkBagde.frame = CGRectMake(527, 0, 30, 30);
        [buttonBgView addSubview:myTalkBagde];
    }
    
    [self setBadge];
}

- (void)dDaySave:(NSNotification *)note{
    [self buttonClicked:0];
}

- (void)moveTab:(NSNotification *)note{
    [self buttonNum:2];
    [self moveView:1];
    [self setBadge];
}

#pragma mark-
#pragma mark 탭바 버튼 이벤트

- (void)buttonClicked:(UIButton*)btn{
    int nTag = btn.tag;
    NSLog(@"nTag = %d",nTag);
    
    switch (nTag) {
        case HOME_BUTTON_TAG:
        {
            int count = homeViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [homeViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = HOME_VIEW;
        }
            break;
            
        case DOWNSTORAGE_BUTTON_TAG:
        {
            int count = downListViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [downListViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = DOWNSTORAGE_VIEW;
        }
            break;
        
        case MYTALK_BUTTON_TAG:
        {
            int count = msgViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [msgViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = MYTALKE_VIEW;
        }
            break;
            
        case SEARCH_BUTTON_TAG:
        {
            int count = searchViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [searchViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = SEARCH_VIEW;
        }
            break;
            
        case SETTING_BUTTON_TAG:
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults synchronize];
            [defaults setObject:@"0" forKey:DDAY_NUM];
            
            int count = settingViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [settingViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = SETTING_VIEW;
        }
            break;
    }
    
    [homeBtn setSelected:NO];
    [downStorageBtn setSelected:NO];
    [myTalkBtn setSelected:NO];
    [searchBtn setSelected:NO];
    [settingBtn setSelected:NO];
    
    if(nTag == 0){
        [homeBtn setSelected:YES];
        [homeBtn setImage:[UIImage imageNamed:@"P_menu01_pressed"] forState:UIControlStateSelected];
        
    }else if(nTag == 1){
        [downStorageBtn setSelected:YES];
        [downStorageBtn setImage:[UIImage imageNamed:@"P_menu02_pressed"] forState:UIControlStateSelected];
    
    }else if(nTag == 2){
        [myTalkBtn setSelected:YES];
        [myTalkBtn setImage:[UIImage imageNamed:@"P_menu03_pressed"] forState:UIControlStateSelected];
        
    }else if(nTag == 3){
        [searchBtn setSelected:YES];
        [searchBtn setImage:[UIImage imageNamed:@"P_menu04_pressed"] forState:UIControlStateSelected];
        
    }else if(nTag == 4){
        [settingBtn setSelected:YES];
        [settingBtn setImage:[UIImage imageNamed:@"P_menu05_pressed"] forState:UIControlStateSelected];
    }
    
    //selectBtnIndex = nTag;
}

#pragma mark-
#pragma 탭바 뷰 초기화

//각 뷰의 컨트롤러를 초기 화 한다.
- (void)InitViewController{
    viewArray = [[NSMutableArray alloc] init] ;
    UINavigationController* navi = nil;
    
    UIStoryboard *_homeStoryBoard = [UIStoryboard storyboardWithName:@"SBiPd_Home" bundle:nil];
    self.homeViewController = [_homeStoryBoard instantiateInitialViewController];
    navi = [self MakeViewcontroll:self.homeViewController];
    navi.navigationBarHidden = YES;
    [viewArray addObject:navi];
    
    UIStoryboard *_downStrouBoard = [UIStoryboard storyboardWithName:@"SBiPd_DownList" bundle:nil];
    self.downListViewController = [_downStrouBoard instantiateInitialViewController];
    navi = [self MakeViewcontroll:self.downListViewController];
    navi.navigationBarHidden = YES;
    [viewArray addObject:navi];
    
    UIStoryboard *_msgStroyBoard = [UIStoryboard storyboardWithName:@"SBiPd_Message" bundle:nil];
    self.msgViewController = [_msgStroyBoard instantiateInitialViewController];
    navi = [self MakeViewcontroll:self.msgViewController];
    navi.navigationBarHidden = YES;
    [viewArray addObject:navi];
    
    UIStoryboard *_searchStoryBoard = [UIStoryboard storyboardWithName:@"SBiPd_Search" bundle:nil];
    self.searchViewController = [_searchStoryBoard instantiateInitialViewController];
    navi = [self MakeViewcontroll:self.searchViewController];
    navi.navigationBarHidden = YES;
    [viewArray addObject:navi];
    
    UIStoryboard *_settingStoryBoard = [UIStoryboard storyboardWithName:@"SBiPd_Setting" bundle:nil];
    self.settingViewController = [_settingStoryBoard instantiateInitialViewController];
    navi = [self MakeViewcontroll:self.settingViewController];
    navi.navigationBarHidden = YES;
    [viewArray addObject:navi];
    
    self.viewControllers = viewArray;
    [self.moreNavigationController.navigationBar setHidden:YES];
    
    [self hideTabBar];
	[self addCustomElements];
}

/**
 * @brief 뷰컨트롤러의 네비게이션 컨트롤러를 생성 하여 반환한다.
 * @param controll : 뷰컨트롤러
 * @return 네비게이션 컨트롤
 */
- (UINavigationController*)MakeViewcontroll:(UIViewController*)controll{
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controll];
    return  navi;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)buttonNum:(int)num{
    [homeBtn setSelected:NO];
    [downStorageBtn setSelected:NO];
    [myTalkBtn setSelected:NO];
    [searchBtn setSelected:NO];
    [settingBtn setSelected:NO];
    
    if(num == 0){
        [homeBtn setSelected:YES];
        [homeBtn setImage:[UIImage imageNamed:@"P_menu01_pressed"] forState:UIControlStateSelected];
        
    }else if(num == 1){
        [downStorageBtn setSelected:YES];
        [downStorageBtn setImage:[UIImage imageNamed:@"P_menu02_pressed"] forState:UIControlStateSelected];
        
    }else if(num == 2){
        [myTalkBtn setSelected:YES];
        [myTalkBtn setImage:[UIImage imageNamed:@"P_menu03_pressed"] forState:UIControlStateSelected];
        
    }else if(num == 3){
        [searchBtn setSelected:YES];
        [searchBtn setImage:[UIImage imageNamed:@"P_menu04_pressed"] forState:UIControlStateSelected];
        
    }else if(num == 4){
        [settingBtn setSelected:YES];
        [settingBtn setImage:[UIImage imageNamed:@"P_menu05_pressed"] forState:UIControlStateSelected];
    }
}

- (void)moveView:(int)num{
    int nTag = num;
    NSLog(@"nTag = %d",nTag);
    
    switch (nTag) {
        case 0:
        {
            int count = homeViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [homeViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = HOME_VIEW;
        }
            break;
            
        case 1:
        {
            int count = msgViewController.navigationController.viewControllers.count -1;
            if(count > 0){
                UIViewController* controller = [msgViewController.navigationController.viewControllers objectAtIndex:count];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
            self.selectedIndex = MYTALKE_VIEW;
        }
            break;
    }
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

@end

//
//  mgTabBarController.h
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 7. 26..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

enum{
    HOME_VIEW,              //홈
    DOWNSTORAGE_VIEW,       //다운로드
    MYTALKE_VIEW,           //마이톡
    SEARCH_VIEW,            //강좌찾기
    SETTING_VIEW            //설정
};

@class mgHomeVC_iPad;
@class mgDownloadListVC_iPad;
@class mgMessageVC_iPad;
@class mgSearchVC_iPad;
@class mgSettingVC_iPad;

@interface mgTabBarController : UITabBarController{
    NSMutableArray* viewArray;
    
    UIView* buttonBgView;
    
    int selectBtnIndex ;
    
    CustomBadge *myTalkBagde;
}

@property(nonatomic,retain) UIButton *homeBtn;
@property(nonatomic,retain) UIButton *downStorageBtn;
@property(nonatomic,retain) UIButton *myTalkBtn;
@property(nonatomic,retain) UIButton *searchBtn;
@property(nonatomic,retain) UIButton *settingBtn;

@property(nonatomic,retain) mgHomeVC_iPad *homeViewController;
@property(nonatomic,retain) mgDownloadListVC_iPad *downListViewController;
@property(nonatomic,retain) mgMessageVC_iPad *msgViewController;
@property(nonatomic,retain) mgSearchVC_iPad *searchViewController;
@property(nonatomic,retain) mgSettingVC_iPad *settingViewController;

//기본 뎁바를 숨긴다.
- (void)hideTabBar;

//텝바 버튼을 생성한다.
- (void)addCustomElements;

//각 뷰의 컨트롤러를 초기 화 한다.
- (void)InitViewController;

/**
 * @brief 뷰컨트롤러의 네비게이션 컨트롤러를 생성 하여 반환한다.
 * @param controll : 뷰컨트롤러
 * @return 네비게이션 컨트롤
 */
- (UINavigationController*)MakeViewcontroll:(UIViewController*)controll;

- (void)buttonNum:(int)num;

- (void)moveView:(int)num;

@end

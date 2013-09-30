//
//  mgVersionVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 6. 18..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgVersionVC.h"
#import "AppDelegate.h"

@interface mgVersionVC ()

@end

@implementation mgVersionVC

@synthesize _lblCurrentVersion, _lblNewVersion;
@synthesize updateBtn;
@synthesize versionNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [versionNavigationBar setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    versionNavigationBar.translucent = NO;
    [versionNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                                  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                                  [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    [self loadVersion];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_lblCurrentVersion:nil];
    [self set_lblNewVersion:nil];
    [self setUpdateBtn:nil];
    [super viewDidUnload];
}

- (void)loadVersion{
    AppDelegate *_app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _lblCurrentVersion.text = _app._config._strAppVersion;
    _lblNewVersion.text = _app._config._strNewVersion;
    
    if([_lblCurrentVersion.text isEqualToString:_lblNewVersion.text] == YES){
        updateBtn.hidden = YES;
        
    }else{
        updateBtn.hidden = NO;
    }
}

#pragma mark -
#pragma mark Button Action

- (IBAction)updateBtn:(id)sender {
    NSString *updateURL = @"http://itunes.apple.com/kr/app/AppName/id670116327?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

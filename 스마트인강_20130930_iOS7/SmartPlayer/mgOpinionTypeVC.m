//
//  mgOpinionTypeVC.m
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 5. 29..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgOpinionTypeVC.h"
#import "SBJsonParser.h"
#import "mgCommon.h"

@interface mgOpinionTypeVC ()
{
    NSMutableArray *_marrData;
    NSString *_selectedString;
    int _selectedCode;
    
    NSURLConnection *conn;
    NSMutableData *receiveData;
}

@end

@implementation mgOpinionTypeVC

@synthesize dlgt_OpinionTypeVC;

@synthesize _imgvBackground;
@synthesize _table;
@synthesize _nbNavigation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self initNavigationBar];
    
    _selectedString = @"";
    if (_marrData == nil) {
        _marrData = [[NSMutableArray alloc]init];
    }
    _selectedCode = 0;
    
    [self initLoadBar];
    [self startLoadBar];
    
    [self getOpinionTitleType];
    
    indexRow = -1;
}

- (void)viewDidUnload {
    [self set_table:nil];
    [self set_imgvBackground:nil];
    [self set_nbNavigation:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

// 네비게이션 좌측 바버튼
- (void)initNavigationBar{
    // 네비게이션바 배경 바꾸기
    [_nbNavigation setBackgroundImage:[[UIImage imageNamed:@"_bg_navigator"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forBarMetrics:UIBarMetricsDefault];
    [_nbNavigation setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],UITextAttributeTextColor,
                                               [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,
                                               [UIFont fontWithName:@"Apple SD Gothic Neo Bold" size:0.0],UITextAttributeFont,nil]];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    
    // 7.0이상
    if([mgCommon osVersion_7]){
        completeBtn.frame = CGRectMake(255, 27, 60, 30);
        cancelBtn.frame = CGRectMake(7, 27, 60, 30);

    }else{
        completeBtn.frame = CGRectMake(255, 7, 60, 30);
        cancelBtn.frame = CGRectMake(7, 7, 60, 30);
    }
    
    [completeBtn addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    
    [cancelBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"취소" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    
    [self.view addSubview:completeBtn];
    [self.view addSubview:cancelBtn];
}

// 네비게이션 좌측 바버튼 눌렀을때 처리
- (void)touchBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchClose:(id)sender {
    [dlgt_OpinionTypeVC mgOpinionTypeVC_SelectedOpinionType:_selectedString typeCode:_selectedCode];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchCheckOnCell:(id)sender {
    //NSLog(@"%@", sender);
    UITableViewCell *cell = (UITableViewCell*)[[sender superview]superview];
    
    UIButton *_btn = (UIButton*)sender;
    if ([_btn isSelected] == false) {
        [_btn setSelected:YES];
        
        [self clearCheckExceptMe:[_table indexPathForCell:cell].row];
        
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        _selectedString = title.text;
        
        UILabel *cd = (UILabel*)[cell viewWithTag:3];
        _selectedCode = [cd.text intValue];
        
    }else{
        [_btn setSelected:NO];
    }
    
    indexRow = [_table indexPathForCell:cell].row;
}

- (void)clearCheckExceptMe:(int)index{
    int cntCell = _marrData.count;
    int idxCell = 0;
    
    for (idxCell = 0; idxCell < cntCell; idxCell++) {
        if (idxCell != index) {
            UITableViewCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCell inSection:0]];
            UIButton *btn = (UIButton*)[cell viewWithTag:2];
            [btn setSelected:NO];
        }
    }
}

- (void)getOpinionTitleType
{
    NSString *addr = [[NSString alloc]initWithFormat:@"%@%@", URL_DOMAIN, URL_OPI_TYPE];
    NSURL *url = [[NSURL alloc]initWithString:addr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (receiveData == nil) {
        receiveData = [[NSMutableData alloc]init];
    }else{
        [receiveData setLength:0];
    }
}

#pragma mark -
#pragma mark UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _marrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellOpinionType";
    
    NSMutableDictionary *dic = [_marrData objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.opaque = NO;
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.text = [dic objectForKey:@"t_title"];
    
    UILabel *cd = (UILabel*)[cell viewWithTag:3];
    cd.text = [dic objectForKey:@"t_cd"];
    
    UIButton *_btn = (UIButton*)[cell viewWithTag:2];
    
    if(indexPath.row == indexRow){
        [_btn setSelected:YES];
    }else{
        [_btn setSelected:NO];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -
#pragma mark NSURLConnection Deleagate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *encodeData = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
    
    //NSLog(@"%@", dic);
    
    if ([[dic objectForKey:@"result"] isEqualToString:@"0000"] == YES) {
        _marrData = [dic objectForKey:@"aData"];
        
        if([_marrData count] == 0){
            return;
        }
        
        [_table reloadData];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self endLoadBar];
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

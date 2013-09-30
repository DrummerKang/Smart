//
//  mgOpinionView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 9..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgOpinionView_iPad.h"
#import "mgOpinionCell_iPad.h"
#import "SBJsonParser.h"
#import "mgGlobal.h"

@implementation mgOpinionView_iPad

@synthesize dlgt_OpinionType;
@synthesize typeTable;

- (void)initMethod{
    _selectedString = @"";
    if (_marrData == nil) {
        _marrData = [[NSMutableArray alloc]init];
    }
    _selectedCode = 0;
    
    [self initLoadBar];
    [self homeLoadBar];
    
    [self getOpinionTitleType];
    
    indexRow = -1;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(6, 7, 60, 30);
    cancelBtn.exclusiveTouch = YES;
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"취소" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self addSubview:cancelBtn];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(284, 7, 60, 30);
    completeBtn.exclusiveTouch = YES;
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_normal"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_top_pressed"] forState:UIControlStateHighlighted];
    [completeBtn setTitle:@"완료" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:13];
    [self addSubview:completeBtn];
}

- (void)touchCheckOnCell:(UIButton*)sender {
    mgOpinionCell_iPad *_cell = (mgOpinionCell_iPad*)[typeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
 
    if ([_cell.checkBtn isSelected] == false) {
        [_cell.checkBtn setSelected:YES];
        
        [self clearCheckExceptMe:[typeTable indexPathForCell:_cell].row];
        
        _selectedString = _cell.titleText.text;
        
        _selectedCode = [_cell.titleCode.text intValue];
        
    }else{
        [_cell.checkBtn setSelected:NO];
    }
    
    indexRow = [typeTable indexPathForCell:_cell].row;
}

- (void)clearCheckExceptMe:(int)index{
    int cntCell = _marrData.count;
    int idxCell = 0;
    
    for (idxCell = 0; idxCell < cntCell; idxCell++) {
        if (idxCell != index) {
            mgOpinionCell_iPad *cell = (mgOpinionCell_iPad*)[typeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCell inSection:0]];
            [cell.checkBtn setSelected:NO];
        }
    }
}

- (void)getOpinionTitleType{
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
    mgOpinionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgOpinionCell_iPad identifier]];
    if (cell == nil) {
        cell = [mgOpinionCell_iPad create];
    }
    
    NSMutableDictionary *dic = [_marrData objectAtIndex:indexPath.row];
    
    cell.opaque = NO;
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    cell.titleText.text = [dic objectForKey:@"t_title"];
    cell.titleCode.text = [dic objectForKey:@"t_cd"];
        
    if(indexPath.row == indexRow){
        [cell.checkBtn setSelected:YES];
    }else{
        [cell.checkBtn setSelected:NO];
    }
    
    cell.checkBtn.tag = indexPath.row;
    [cell.checkBtn addTarget:self action:@selector(touchCheckOnCell:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
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
        
        [typeTable reloadData];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self endLoadBar];
}

#pragma mark -
#pragma mark Button Action

- (void)cancelAction{
    [dlgt_OpinionType mgOpinionTypeHidden];
    self.hidden = YES;
}

- (void)completeAction{
    [dlgt_OpinionType mgOpinionType_SelectedOpinionType:_selectedString typeCode:_selectedCode];
    
    self.hidden = YES;
}

@end

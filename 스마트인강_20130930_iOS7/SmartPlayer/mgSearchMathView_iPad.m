//
//  mgSearchMathView_iPad.m
//  SmartPlayer
//
//  Created by MegaStudy_iMac on 13. 8. 12..
//  Copyright (c) 2013년 MegaStudy_iMac. All rights reserved.
//

#import "mgSearchMathView_iPad.h"
#import "mgGlobal.h"
#import "SBJsonParser.h"
#import "mgSearchMathCell_iPad.h"

@implementation mgSearchMathView_iPad

@synthesize mathTable;

- (void)initMethod:(NSString *)qOrd qCd:(NSString *)qCd domCd:(NSString *)domCd type:(NSString *)type tecCd:(NSString *)tecCd category:(NSString *)category section:(NSString *)section title:(NSString *)title{
    _sLecqOrd = qOrd;
    _sLecqCd = qCd;
    _sLecdomCd = domCd;
    _sLecPageType = type;
    _sLecTecCd = tecCd;
    _sLecCategory = category;
    _sLecSection = section;
    _naviTitle = title;
    
    [self initLoadBar];
    [self startLoadBar];
    
    mathArr = [[NSMutableArray alloc] init];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", URL_DOMAIN, URL_SEARCH_LIST];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //NSLog(@"%@", url);
    //NSLog(@"%@", [_app._account getAcc_key]);
    //NSLog(@"%@", _sLecdomCd);
    //NSLog(@"%@", _sLecqCd);
    //NSLog(@"%@", _sLecqOrd);
    //NSLog(@"%@", _sLecPageType);
    //NSLog(@"%@", _sLecTecCd);
    
    // @param POST와 GET 방식을 나타냄.
    [request setHTTPMethod:@"POST"];
    
    // 파라메터를 NSDictionary에 저장
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [dic setObject:[_app._account getAcc_key]               forKey:@"acc_key"];
    [dic setObject:_sLecdomCd                               forKey:@"domCd"];
    [dic setObject:_sLecPageType                            forKey:@"pageType"];
    [dic setObject:_sLecqCd                                 forKey:@"qCd"];
    [dic setObject:_sLecqOrd                                forKey:@"qOrd"];
    [dic setObject:_sLecTecCd                               forKey:@"qTecCd"];
    
    // NSDictionary에 저장된 파라메터를 NSArray로 제작
    NSArray * params = [self generatorParameters:dic];
    
    // POST로 파라메터 넘기기
    [request setHTTPBody:[[params componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    urlConnSearchMath = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (nil != urlConnSearchMath){
        mathData = [[NSMutableData alloc] init];
    }
}

#pragma mark -
#pragma mark UITableView DataSrouce & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mathArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mgSearchMathCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:[mgSearchMathCell_iPad identifier]];
    if (cell == nil) {
        cell = [mgSearchMathCell_iPad create];
    }
    
    NSDictionary *dic = [mathArr objectAtIndex:indexPath.row];
    
    cell.titleText.text = [dic valueForKey:@"qNM"];
    
    cell.tag = indexPath.row;
    [cell.cellSelectedBtn addTarget:self action:@selector(touchCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

#pragma mark -
#pragma mark Button Action

- (void)touchCell:(id)sender{
    mgSearchMathCell_iPad *cell = (mgSearchMathCell_iPad*)[[sender superview]superview];
    NSIndexPath *indexpath = [mathTable indexPathForCell:cell];
    
    NSDictionary *dic = [mathArr objectAtIndex:indexpath.row];
    
    thirdView = [[[NSBundle mainBundle] loadNibNamed:@"mgSearchThirdView_iPad" owner:self options:nil] objectAtIndex:0];
    thirdView.frame = CGRectMake(0, 0, 694, 655);
    [thirdView initMethod:[dic valueForKey:@"qOrd"] qCd:[dic valueForKey:@"qCd"] domCd:_sLecdomCd type:_sLecPageType tecCd:_sLecTecCd title:_naviTitle];
    [self addSubview:thirdView];
}

- (IBAction)backAction:(id)sender {
    self.hidden = YES;
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
    if (connection == urlConnSearchMath) {
        [mathData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    connection = nil;
    [self endLoadBar];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == urlConnSearchMath) {
        NSString *encodeData = [[NSString alloc] initWithData:mathData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:encodeData error:NULL];
        
        //NSLog(@"Math_result : %@", [dic valueForKey:@"result"]);
        //NSLog(@"Math_msg : %@", [dic valueForKey:@"msg"]);
        NSLog(@"Math_dic : %@", dic);
        
        NSMutableArray *menuDataArr = [dic valueForKey:@"menuData"];
        
        if([menuDataArr count] == 0){
            [self endLoadBar];
            return;
        }
        
        NSDictionary *menuNM = [menuDataArr objectAtIndex:0];
        
        mathArr = [menuNM valueForKey:@"subData"];
        
        [self endLoadBar];
        
        if([mathArr count] == 0){
            return;
        }
        
        [mathTable reloadData];
    }
}

@end

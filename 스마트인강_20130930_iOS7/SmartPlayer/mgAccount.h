//
//  mgAccount.h
//  SmartPlayer
//
//  Created by 메가스터디 on 13. 3. 22..
//  Copyright (c) 2013년 메가스터디. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol mgAccountProtocol <NSObject>
- (void)changeAccount:(id)account;
@optional
- (void)userLogin;
- (void)userLogOff;
@end

@interface mgAccount : NSObject
{
    id <mgAccountProtocol> delegate;
}

@property (strong,nonatomic) id <mgAccountProtocol> delegate;

-(void)setUserID:(NSString*)userID;
-(NSString*)getUserID;

-(void)setUserPwd:(NSString*)userPwd;
-(NSString*)getUserPwd;

-(void)setIsLogin:(bool)bIsLogin;
-(bool)getIsLogin;

-(void)setUsageAutoLogin:(bool)bUsageAutoLogin;
-(bool)getUsageAutoLogin;

-(void)setSkip:(bool)bIsSkip;
-(bool)getIsSkip;

-(void)setDeviceCheck:(bool)bIsDeviceCheck;
-(bool)getIsDeviceCheck;

-(void)setReqKey:(NSString*)req_key;
-(NSString*)getReq_key;

-(void)setAccKey:(NSString*)acc_key;
-(NSString*)getAcc_key;

-(void)setEncInfo:(NSString*)enc_info;
-(NSString*)getEnc_info;

-(void)setToken:(NSString*)token;
-(NSString*)getToken;

-(NSString*)toString;

@end

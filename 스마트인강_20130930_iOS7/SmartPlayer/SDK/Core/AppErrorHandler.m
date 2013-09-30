//
//  AppErrorHandler.m
//  eduManager
//
//  Created by CDNetworks on 12. 7. 13..
//

#import "AppErrorHandler.h"

@implementation AppErrorHandler

+ (NSString *)messageFromCode:(int)errCode{
    NSString *key = nil;
    
    switch (errCode) {
        case APP_NOT_ALLOW_3G_DOWNLOAD:
            key = k_connet_network;
            break;
            
        case APP_DOWNLOAD_CONNECTION_ERROR:
            key = @"k_APP_DOWNLOAD_CONNECTION_ERROR";
            break;
            
        case APP_PLAYER_NOT_FOUND:
            key = @"k_APP_PLAYER_NOT_FOUND";
            break;
            
        case APP_PLAYER_AUTHENTICATION_FAILED:
            key = @"k_APP_PLAYER_AUTHENTICATION_FAILED";
            break;
            
        case APP_PLAYER_CONNECTION_FAIL:
            key = @"k_APP_PLAYER_CONNECTION_FAIL";
            break;
            
        case APP_CONTENT_EXPIRED:
            key = k_content_renewer;
            break;
            
        case APP_NO_FREE_SIZE:
            key = k_nospace;
            break;
            
        case ERR_DUPLICATION:
            key = k_err_duplication;
            break;
            
        case CONTENT_UPDATE_TEXT:
            key = k_content_update_text;
            break;
            
        case APP_CONTENT_UNKNOWN:
            key = k_customer_xml;
            break;
            
        default:
            return [super messageFromCode:errCode];
    }
    
    NSString *ret = LocalizedString(key);
    
    if (ret==nil) {
        ret = key;
    }
    
    return ret;
}

+ (NSString *)messageCode:(int)errCode{
    NSString *key = nil;
    
    switch (errCode) {
        case 205:
            key = DOWN_ISSUE;
            break;
            
        case 401:
            key = DOWN_NO_USER;
            break;
            
        case 201:
            key = DOWN_NO_LIC;
            break;
            
        case 302:
            key = DOWN_NO_DEVICE;
            break;
            
        case 305:
            key = DOWN_DEVICE;
            break;
            
        case 202:
            key = DOWN_FINISH;
            break;
            
        case -535:
            key = DOWN_TIME_NOT_START;
            break;
            
        case -536:
            key = DOWN_TIME_EXPIRED;
            break;
            
        case -537:
            key = DOWN_OFFLINE_REQUIRED;
            break;
            
        case -401:
            key = DOWN_COMMON;
            break;
            
        default:
            return [super messageCode:errCode];
    }
    
    NSString *ret = LocalizedString(key);
    
    if (ret==nil) {
        ret = key;
    }
    
    return ret;
}

@end

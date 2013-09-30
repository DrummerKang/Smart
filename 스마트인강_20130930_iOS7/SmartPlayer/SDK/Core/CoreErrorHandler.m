//
//  CoreErrorHandler.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 27..
//

#import "CoreErrorHandler.h"

@implementation CoreErrorHandler

+ (NSString *)messageFromCode:(int)errCode{
    NSString *key = nil;
    
    switch (errCode) {
        case CDDR_DL_PROTOCOL_CUSTOMER_SERVER_ERROR:
            key = @"k_CDDR_DL_PROTOCOL_CUSTOMER_SERVER_ERROR";
            break;
            
        case CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_ERROR:
            key = @"k_CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_ERROR";
            break;
            
        case CDDR_DL_PROTOCOL_CUSTOMER_SERVER_NOT_FOUND:
            key = @"k_CDDR_DL_PROTOCOL_CUSTOMER_SERVER_NOT_FOUND";
            break;
            
        case CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_NOT_FOUND:
            key = @"k_CDDR_DL_PROTOCOL_AQUA_DRM_SERVER_NOT_FOUND";
            break;
            
        case CDDR_DL_PROTOCOL_INVALID_PARAMETER:
            key = @"k_CDDR_DL_PROTOCOL_INVALID_PARAMETER";
            break;
            
        case CDDR_DL_PROTOCOL_RIGHT_NOT_FOUND:
            key = @"k_CDDR_DL_PROTOCOL_RIGHT_NOT_FOUND";
            break;
            
        case CDDR_DL_PROTOCOL_RIGHT_EXPIRED:
            key = @"k_CDDR_DL_PROTOCOL_RIGHT_EXPIRED";
            break;
            
        case CDDR_DL_PROTOCOL_RIGHT_VALID:
            key = @"k_CDDR_DL_PROTOCOL_RIGHT_VALID";
            break;
            
        case CDDR_DL_PROTOCOL_UPDATED_RIGHT:
            key = @"k_CDDR_DL_PROTOCOL_UPDATED_RIGHT";
            break;
            
        case CDDR_DL_PROTOCOL_ISSUE_RIGHT:
            key = @"k_CDDR_DL_PROTOCOL_ISSUE_RIGHT";
            break;
            
        case CDDR_DL_PROTOCOL_RIGHT_NOT_STARTED:
            key = @"k_CDDR_DL_PROTOCOL_RIGHT_NOT_STARTED";
            break;
            
        case CDDR_DL_PROTOCOL_ALREADY_REGISTERED_DEVICE:
            key = @"k_CDDR_DL_PROTOCOL_ALREADY_REGISTERED_DEVICE";
            break;
            
        case CDDR_DL_PROTOCOL_UNREGISTER_DEVICE:
            key = @"k_CDDR_DL_PROTOCOL_UNREGISTER_DEVICE";
            break;
            
        case CDDR_DL_PROTOCOL_DEVICE_IS_REGISTERED_BY_ANOTHER_USER:
            key = @"k_CDDR_DL_PROTOCOL_DEVICE_IS_REGISTERED_BY_ANOTHER_USER";
            break;
            
        case CDDR_DL_PROTOCOL_USER_EXCEEDED_ALLOWED_DEVICE_COUNT:
            key = @"k_CDDR_DL_PROTOCOL_USER_EXCEEDED_ALLOWED_DEVICE_COUNT";
            break;
            
        case CDDR_DL_PROTOCOL_USER_NOT_FOUND:
            key = @"k_CDDR_DL_PROTOCOL_USER_NOT_FOUND";
            break;
            
        case CDDR_DNP_PROTOCOL_INVALID_HASH:
            key = @"k_CDDR_DNP_PROTOCOL_INVALID_HASH";
            break;
            
        case CDDR_DNP_PROTOCOL_EXPIRED_HASH:
            key = @"k_CDDR_DNP_PROTOCOL_EXPIRED_HASH";
            break;
            
        case CDDR_DL_CHECK_RIGHT_EXPIRED:
            key = k_content_info_error;
            break;
            
        case CDDR_DL_CONTENT_HEADER_TIME_NOT_START:
            //-Content의 사용기간이 아직시작되지 않았습니다.
            key = k_CDDR_DL_CONTENT_HEADER_TIME_NOT_START;
            break;
            
        case CDDR_DL_CONTENT_HEADER_TIME_EXPIRED:
            //-Content의 사용기간이 만료되었습니다.
            key = k_CDDR_DL_CONTENT_HEADER_TIME_EXPIRED;
            break;
            
        case CDDR_DL_CONTENT_OFFLINE_EXPIRED_ONLINE_REQUIRED:
            key = k_CDDR_DL_CONTENT_OFFLINE_EXPIRED_ONLINE_REQUIRED;
            break;
            
        case CDDR_DL_NETWORK_ERROR:
            key = k_connet_network;
            break;
            
        default:
            return [NSString stringWithFormat:@"%@(%d)", LocalizedString(k_err_system), errCode];
            break;
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
            return [NSString stringWithFormat:@"%@(%d)", LocalizedString(k_err_system), errCode];
    }
    
    NSString *ret = LocalizedString(key);
    
    if (ret==nil) {
        ret = key;
    }
    
    return ret;
}

@end

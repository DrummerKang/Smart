//
//  AquaAlertView.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 12..
//

#import <UIKit/UIKit.h>

typedef enum {
    AquaAlertViewTypeOK,
    AquaAlertViewTypeYES,
    AquaAlertViewTypeNO,
    AquaAlertViewTypeYESNO,
    AquaAlertViewTypeCustomButton1,
    AquaAlertViewTypeCustomButton2
}AquaAlertViewType;

#define ALERT_SETTING_3G_DOWNLOAD 11
#define ALERT_WEBPLAY_FAIL 12
#define ALERT_JAILBRAKE 13
#define ALERT_UPDATE 14
#define ALERT_DOWNLOAD_CONTENT_MODIFY 15
#define ALERT_DOWNLOAD_BY_SETTING 16

@protocol AquaAlertViewDelegate <NSObject>

- (void)onCloseAlertViewId:(int)alertId buttonType:(AquaAlertViewType)type data:(NSDictionary *)data;

@end

@interface AquaAlertView : UIView

@property (nonatomic, assign) id delegate;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;
@property (retain, nonatomic) IBOutlet UIButton *btnCenter;

+ (void) setNavigationController:(UINavigationController *)controller;
- (void) show;
+ (void) showWithId:(int)alertId title:(NSString *)title message:(NSString *)message data:(NSDictionary *)data delegate:(id)delegate type:(AquaAlertViewType)type;
+ (void) showCustomTypeWithId:(int)alertId title:(NSString *)title message:(NSString *)message data:(NSDictionary *)data delegate:(id)delegate button1:(NSString *)button1 button2:(NSString *)button2;

@end

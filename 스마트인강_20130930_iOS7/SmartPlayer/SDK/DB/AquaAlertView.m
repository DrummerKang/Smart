//
//  AquaAlertView.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 12..
//

#import "AquaAlertView.h"
#import "UIColor+RGBColor.h"
#import "Constants.h"

static AquaAlertView *alert;
static UINavigationController *navi;
static BOOL forceClosed;

@implementation AquaAlertView
@synthesize titleLabel;
@synthesize textLabel;
@synthesize btnLeft;
@synthesize btnRight;
@synthesize btnCenter;
@synthesize backgroundImageView;
@synthesize delegate;
@synthesize data;


+ (void) setNavigationController:(UINavigationController *)controller{
    navi = controller;
}

- (void) onClick:(UIButton *)sender{
    forceClosed = NO;
    int _id = self.tag;
    int type = sender.tag;
    
    if (delegate && [delegate respondsToSelector:@selector(onCloseAlertViewId:buttonType:data:)]) {
        [delegate onCloseAlertViewId:_id buttonType:type data:data];
    }
    
    if (!forceClosed) {
        [self close];
    }
}

- (void) close{
    [self removeFromSuperview];
    alert = nil;
}

+(void) showWithId:(int)alertId title:(NSString *)title message:(NSString *)message data:(NSDictionary *)data delegate:(id)delegate type:(AquaAlertViewType)type{
    if (alert) {
        if (alert.tag == ALERT_UPDATE) {
            return;
            
        }else{
            forceClosed = YES;
            [alert close];
        }
    }
    
    UINib *nib = [UINib nibWithNibName:@"AquaAlertView" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    alert = [arr objectAtIndex:0];
    alert.frame = [[UIApplication sharedApplication] keyWindow].frame;
    alert.tag = alertId;
    alert.backgroundImageView.image = [[UIImage imageNamed:@"diaglog.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:56];
    alert.titleLabel.text = title;
    alert.textLabel.text = message;
    alert.delegate = delegate;
    alert.data = data;
    [alert.btnLeft addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [alert.btnRight addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [alert.btnCenter addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (type) {
        case AquaAlertViewTypeOK:
            alert.btnLeft.hidden = YES;
            alert.btnRight.hidden = YES;
            [alert.btnCenter setTitle:LocalizedString(k_done_btn) forState:UIControlStateNormal];
            alert.btnCenter.tag = AquaAlertViewTypeOK;
            break;
            
        case AquaAlertViewTypeYESNO:
            alert.btnCenter.hidden = YES;
            [alert.btnLeft setTitle:LocalizedString(k_ok_btn) forState:UIControlStateNormal];
            [alert.btnRight setTitle:LocalizedString(k_cancel_btn) forState:UIControlStateNormal];
            alert.btnLeft.tag = AquaAlertViewTypeYES;
            alert.btnRight.tag = AquaAlertViewTypeNO;
            break;
            
        default:
            alert.btnLeft.hidden = YES;
            alert.btnRight.hidden = YES;
            [alert.btnCenter setTitle:LocalizedString(k_done_btn) forState:UIControlStateNormal];
            alert.btnCenter.tag = AquaAlertViewTypeOK;
            break;
    }
    
    [alert show];
}

+ (void) showCustomTypeWithId:(int)alertId title:(NSString *)title message:(NSString *)message data:(NSDictionary *)data delegate:(id)delegate button1:(NSString *)button1 button2:(NSString *)button2{
    if (alert) {
        return;
    }
    
    UINib *nib = [UINib nibWithNibName:@"AquaAlertView" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    alert = [arr objectAtIndex:0];
    
    alert.tag = alertId;
    alert.backgroundImageView.image = [[UIImage imageNamed:@"diaglog.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:56];
    alert.titleLabel.text = title;
    alert.textLabel.text = message;
    alert.delegate = delegate;
    alert.data = data;
    [alert.btnLeft addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [alert.btnRight addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [alert.btnCenter addTarget:alert action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (button1 && button2) {
        alert.btnCenter.hidden = YES;
        [alert.btnLeft setTitle:button1 forState:UIControlStateNormal];
        [alert.btnRight setTitle:button2 forState:UIControlStateNormal];
        alert.btnLeft.tag = AquaAlertViewTypeCustomButton1;
        alert.btnRight.tag = AquaAlertViewTypeCustomButton2;
        
    }else {
        alert.btnLeft.hidden = YES;
        alert.btnRight.hidden = YES;
        [alert.btnCenter setTitle:button1?button1:button2 forState:UIControlStateNormal];
        alert.btnCenter.tag = AquaAlertViewTypeCustomButton1;
    }
    
    [alert show];
}


- (void) show {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    if (win == nil) {
        [self performSelector:@selector(show) withObject:nil afterDelay:0.5];
        return;
    }
    
    self.frame = win.frame;
    [navi.view addSubview:self];
    [navi.view bringSubviewToFront:self];
}

- (void)dealloc {
    [titleLabel release];
    [textLabel release];
    [btnLeft release];
    [btnRight release];
    [btnCenter release];
    [backgroundImageView release];
    [super dealloc];
}

@end

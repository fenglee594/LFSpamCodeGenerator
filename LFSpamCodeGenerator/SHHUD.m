//
//  SHHUD.m
//  SHSDK
//
//  Created by 李峰 on 2018/8/1.
//  Copyright © 2018年 ShenHai. All rights reserved.
//

#import "SHHUD.h"
#import "JGProgressHUD.h"

typedef NS_ENUM(NSUInteger,EHUDResultType) {
    EHUDResultNormalType = 0,
    EHUDResultSuccessType,
    EHUDResultErrorType,
};

#define SMKeyWindow [UIApplication sharedApplication].keyWindow

@implementation SHHUD

JGProgressHUD *HUD;
+ (JGProgressHUD*)hud
{
    if (!HUD) {
        HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
        HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
        JGProgressHUDFadeAnimation *an = [JGProgressHUDFadeAnimation animation];
        HUD.animation = an;
        HUD.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return HUD;
}

+ (void)HUDShowWithType:(EHUDResultType)type title:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    self.hud.layoutChangeAnimationDuration = 0.0;
    self.hud.indicatorView = nil;
    self.hud.textLabel.text = title;
    self.hud.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    if (type) {
        
        self.hud.indicatorView = type == EHUDResultSuccessType?[[JGProgressHUDSuccessIndicatorView alloc] init]:[[JGProgressHUDErrorIndicatorView alloc] init];
        
    }
    //self.hud.square = type;
    self.hud.position = JGProgressHUDPositionCenter;
    
    [self.hud showInView:SMKeyWindow];
    [self.hud dismissAfterDelay:1 animated:YES];
    HUD = nil;
}

+ (void)HUDInfo:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    [self HUDShowWithType:EHUDResultNormalType title:title];
    //[SVProgressHUD showInfoWithStatus:title];
}

+ (void) HUDSuccess:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    [self HUDShowWithType:EHUDResultSuccessType title:title];
    //[SVProgressHUD showSuccessWithStatus:title];
}


+ (void) HUDError:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    [self HUDShowWithType:EHUDResultErrorType title:title];
    //[SVProgressHUD showInfoWithStatus:title];
}

+ (void) HUDLoading:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    [self HUDHide];
    self.hud.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    self.hud.textLabel.text = title;
    self.hud.square = YES;
    [self.hud showInView:SMKeyWindow];
    //[SVProgressHUD showWithStatus:title];
}

+ (void)HUDShieldLoading:(NSString *)title
{
    if ([title isKindOfClass:[NSNull class]] ) {
        title = nil;
    }
    [self HUDHide];
    self.hud.textLabel.text = title;
    [self.hud showInView:SMKeyWindow];
    //[SVProgressHUD showWithStatus:title maskType:SVProgressHUDMaskTypeClear];
}


+ (void) HUDHide
{
    [self.hud dismiss];
    HUD = nil;
    //[SVProgressHUD dismiss];
}

+ (void)HUDProgress:(float)progress status:(NSString *)status
{
    if ([status isKindOfClass:[NSNull class]] ) {
        status = nil;
    }
    [self showRingHUDWithProgress:progress status:status];
    //[SVProgressHUD showProgress:progress status:status];
}

+ (void)HUDShieldProgress:(float)progress status:(NSString *)status

{
    if ([status isKindOfClass:[NSNull class]] ) {
        status = nil;
    }
    self.hud.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    [self showRingHUDWithProgress:progress status:status];
    //[SVProgressHUD showProgress:progress status:status maskType:SVProgressHUDMaskTypeClear];
}


+ (void)showRingHUDWithProgress:(float)progress status:(NSString *)status {
    
    self.hud.indicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:HUD.style];
    self.hud.detailTextLabel.text = [NSString stringWithFormat:@"完成 %.0f%%",progress];
    [HUD setProgress:progress animated:NO];
    self.hud.textLabel.text = status;
    self.hud.square = YES;
    [self.hud showInView:SMKeyWindow];
    self.hud.layoutChangeAnimationDuration = 0.0;
}

@end

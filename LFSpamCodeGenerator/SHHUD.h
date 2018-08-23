//
//  SHHUD.h
//  SHSDK
//
//  Created by 李峰 on 2018/8/1.
//  Copyright © 2018年 ShenHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHHUD : NSObject

+ (void)HUDInfo:(NSString *)title;

+ (void) HUDSuccess:(NSString *)title;

+ (void) HUDError:(NSString *)title;

+ (void) HUDLoading:(NSString *)title;

+ (void)HUDShieldLoading:(NSString *)title;


+ (void) HUDHide;

+ (void)HUDProgress:(float)progress status:(NSString *)status;

+ (void)HUDShieldProgress:(float)progress
                   status:(NSString *)status;

@end

//
//  JGProgressHUDInfoIndicatorView.m
//  OMENGO_NEW
//
//  Created by 梁尚嘉 on 2017/6/1.
//  Copyright © 2017年 Kamfat. All rights reserved.
//

#import "JGProgressHUDInfoIndicatorView.h"

@implementation JGProgressHUDInfoIndicatorView


- (instancetype)initWithContentView:(UIView *__unused)contentView {
    
//     NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JGProgressHUD class]] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"]];
//
//     NSString *imgPath = [resourceBundle pathForResource:@"HUDSuccess_42x42_" ofType:@"png"];
    
    self = [super initWithImage:/*[UIImage imageWithContentsOfFile:imgPath]*/[UIImage imageNamed:@"HUDWarning_42x42_"]];

    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Info",);
}
@end

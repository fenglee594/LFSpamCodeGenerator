//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    /*
     NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JGProgressHUD class]] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"]];

     NSString *imgPath = [resourceBundle pathForResource:@"HUDSuccess_42x42_" ofType:@"png"];
     */
    self = [super initWithImage:/*[UIImage imageWithContentsOfFile:imgPath]*/[UIImage imageNamed:@"HUDWarning_42x42_"]];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

@end

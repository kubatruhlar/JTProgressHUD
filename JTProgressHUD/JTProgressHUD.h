//
//  JTProgressHUD.h
//  JTProgressHUD
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTProgressHUDStyle) {
    JTProgressHUDStyleDefault = 0,
    JTProgressHUDStyleGradient
};

typedef NS_ENUM(NSInteger, JTProgressHUDTransition) {
    JTProgressHUDTransitionDefault = 0,
    JTProgressHUDTransitionFade,
    JTProgressHUDTransitionNone
};

typedef NS_ENUM(NSInteger, JTProgressHUDView) {
    JTProgressHUDViewBuiltIn = 0 // Same as nil
};

@interface JTProgressHUD : UIView

/**
 View: Is your custom view (eg. Animated UIImageView or whatever you want).
 Style: Is the style of the background. Usually it is the dark color between the view and the rest of the app.
 Transition: Showing and hiding transitions.
 BackgroundAlpha: The biggest alpha for the background.
 All parameters can be setup separately.
 */
+ (void)showWithView:(UIView *)view style:(JTProgressHUDStyle)style transition:(JTProgressHUDTransition)transition backgroundAlpha:(CGFloat)backgroundAlpha;
+ (void)show;
+ (void)showWithView:(UIView *)view;
+ (void)showWithStyle:(JTProgressHUDStyle)style;
+ (void)showWithTransition:(JTProgressHUDTransition)transition;
+ (void)showWithBackgroundAlpha:(CGFloat)backgroundAlpha;

+ (void)hide;
+ (void)hideWithTransition:(JTProgressHUDTransition)transition;

+ (BOOL)isVisible;

@end

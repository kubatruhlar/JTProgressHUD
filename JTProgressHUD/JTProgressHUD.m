//
//  JTProgressHUD.m
//  JTProgressHUD
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "JTProgressHUD.h"

static JTProgressHUD *sharedInstance = nil;
static CGFloat kBGColorAlphaMax = 0.75;
static CGFloat kBGColorAlphaSkip = 0.3;
static CGFloat kAnimationDuration = 0.3;
static CGFloat kAnimationCycleDuration = 1.5;
static CGFloat kCircleWidth = 50.0;
static CGFloat kBorderWidth = 3.0;

@interface JTProgressHUD()

@property (nonatomic, strong) UIColor *styleColor1;
@property (nonatomic, strong) UIColor *styleColor2;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *staticCircle;
@property (nonatomic, strong) UIView *movingCircle;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) JTProgressHUDTransition transition;
@property (nonatomic, assign) JTProgressHUDStyle style;

@end

@implementation JTProgressHUD

#pragma mark - Initialization
+ (JTProgressHUD *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [self new];
        [sharedInstance initialize];
    });
    
    return sharedInstance;
}

- (void)initialize {
    // Base
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    sharedInstance.alpha = 0.0;
    sharedInstance.customView = [UIView new];
    
    // Observing
    [sharedInstance createObservers];
}

- (void)createObservers {
    [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(changeFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeFrame {
    sharedInstance.backgroundView.center = [UIApplication sharedApplication].keyWindow.center;
    sharedInstance.staticCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.movingCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.customView.center = sharedInstance.backgroundView.center;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:sharedInstance];
}

#pragma mark - Visibility
- (BOOL)isVisible {
    return (sharedInstance.alpha == 1.0);
}

+ (BOOL)isVisible {
    return [sharedInstance isVisible];
}

#pragma mark - Displaying
+ (void)show {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn];
}

+ (void)showWithView:(UIView *)view {
    [JTProgressHUD showWithView:view style:JTProgressHUDStyleGradient transition:JTProgressHUDTransitionDefault backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithStyle:(JTProgressHUDStyle)style {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn style:style transition:JTProgressHUDTransitionDefault backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithTransition:(JTProgressHUDTransition)transition {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn style:JTProgressHUDStyleGradient transition:transition backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithBackgroundAlpha:(CGFloat)backgroundAlpha {
    [JTProgressHUD showWithView:JTProgressHUDViewBuiltIn style:JTProgressHUDStyleGradient transition:JTProgressHUDTransitionDefault backgroundAlpha:backgroundAlpha];
}

+ (void)showWithView:(UIView *)view style:(JTProgressHUDStyle)style transition:(JTProgressHUDTransition)transition backgroundAlpha:(CGFloat)backgroundAlpha {
    if ([[JTProgressHUD sharedInstance] isVisible]) {
        return;
    }
    
    // Properties
    sharedInstance.styleColor1 = [[UIColor blackColor] colorWithAlphaComponent:backgroundAlpha - kBGColorAlphaSkip];
    sharedInstance.styleColor2 = [[UIColor blackColor] colorWithAlphaComponent:backgroundAlpha];
    sharedInstance.transition = transition;
    sharedInstance.customView = view;
    sharedInstance.style = style;
    sharedInstance.alpha = 1.0;
    
    // Style
    if (!style) {
        style = JTProgressHUDStyleDefault;
    }
    switch (style) {
        case JTProgressHUDStyleDefault:
            [sharedInstance createSolidBackground];
            [sharedInstance addBackgroundBelowHUD];
            break;
        case JTProgressHUDStyleGradient:
            [sharedInstance createGradientBackground];
            [sharedInstance addBackgroundBelowHUD];
            break;
        default:
            break;
    }
    
    // View
    if (view) {
        sharedInstance.customView.center = sharedInstance.backgroundView.center;
        [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.customView];
    } else {
        [sharedInstance createDefaultLoadingView];
    }
    
    // Transition and animation
    sharedInstance.customView.alpha = 0.0;
    switch (transition) {
        case JTProgressHUDTransitionDefault:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(0.0, 0.0);
            break;
        case JTProgressHUDTransitionFade:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            break;
        case JTProgressHUDTransitionNone:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            break;
        default:
            break;
    }
    CGFloat delay = (transition != JTProgressHUDTransitionNone) ? kAnimationDuration : 0.0;
    [UIView animateWithDuration:delay animations:^{
        sharedInstance.customView.alpha = 1.0;
        sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.backgroundView.alpha = 1.0;
    } completion:nil];
}

+ (void)hide {
    [JTProgressHUD hideWithTransition:JTProgressHUDTransitionDefault];
}

+ (void)hideWithTransition:(JTProgressHUDTransition)transition {
    if (![[JTProgressHUD sharedInstance] isVisible]) {
        return;
    }
    
    CGFloat delay = (transition != JTProgressHUDTransitionNone) ? kAnimationDuration : 0.0;
    
    [UIView animateWithDuration:delay animations:^{
        sharedInstance.backgroundView.alpha = 0.0;
        
        if (sharedInstance.transition == JTProgressHUDTransitionDefault) {
            CGFloat multiplier = [[UIScreen mainScreen] scale];
            sharedInstance.customView.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
        }
        
        sharedInstance.customView.alpha = 0.0;
        sharedInstance.staticCircle.alpha = 0.0;
        sharedInstance.movingCircle.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [sharedInstance.customView removeFromSuperview];
        [sharedInstance.staticCircle removeFromSuperview];
        [sharedInstance.movingCircle removeFromSuperview];
        [sharedInstance.backgroundView removeFromSuperview];
        sharedInstance.alpha = 0.0;
    }];
}

#pragma mark - JTProgressHUDStyle
- (void)createSolidBackground {
    sharedInstance.backgroundView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    sharedInstance.backgroundView.backgroundColor = _styleColor2;
    sharedInstance.backgroundView.userInteractionEnabled = true;
    sharedInstance.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sharedInstance.backgroundView.alpha = 0.0;
}

- (void)createGradientBackground {
    CGFloat biggerSize = MAX([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height);
    UIImage *gradientImage = [sharedInstance jt_imageWithRadialGradientSize:CGSizeMake(biggerSize, biggerSize) innerColor:sharedInstance.styleColor1 outerColor:sharedInstance.styleColor2 center:CGPointMake(0.5, 0.5) radius:0.85];
    sharedInstance.backgroundView = [[UIImageView alloc] initWithImage:gradientImage];
    sharedInstance.backgroundView.userInteractionEnabled = true;
    sharedInstance.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    sharedInstance.backgroundView.alpha = 0.0;
    sharedInstance.backgroundView.center = [UIApplication sharedApplication].keyWindow.center;
}

- (void)addBackgroundBelowHUD {
    [sharedInstance.backgroundView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.backgroundView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:sharedInstance.backgroundView];
}

- (UIImage *)jt_imageWithRadialGradientSize:(CGSize)size innerColor:(UIColor *)innerColor outerColor:(UIColor *)outerColor center:(CGPoint)center radius:(CGFloat)radius {
    UIGraphicsBeginImageContext(size);
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha;
    [innerColor getRed:&sRed green:&sGreen blue:&sBlue alpha:&sAlpha];
    [outerColor getRed:&eRed green:&eGreen blue:&eBlue alpha:&eAlpha];
    CGFloat components[8] = { sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha};
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    center = CGPointMake(center.x * size.width, center.y * size.height);
    CGPoint startPoint = center;
    CGPoint endPoint = center;
    radius = MIN(size.width, size.height) * radius;
    CGFloat startRadius = 0;
    CGFloat endRadius = radius;
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, startPoint, startRadius, endPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    UIImage *gradientImg;
    gradientImg = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    return gradientImg;
}

#pragma mark - JTProgressHUDView

- (void)createDefaultLoadingView {
    // Default setup
    sharedInstance.staticCircle = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.movingCircle = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.staticCircle.layer.shouldRasterize = true;
    sharedInstance.staticCircle.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Animation
    sharedInstance.staticCircle.alpha = 0.0;
    sharedInstance.movingCircle.alpha = 0.0;
    
    if (sharedInstance.transition == JTProgressHUDTransitionDefault) {
        sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(0.0, 0.0);
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    
    sharedInstance.staticCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.movingCircle.center = sharedInstance.backgroundView.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.movingCircle];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.staticCircle];
    
    // Animation
    CGFloat delay = (sharedInstance.transition != JTProgressHUDTransitionNone) ? kAnimationDuration : 0.0;
    
    [UIView animateWithDuration:delay animations:^{
        sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.staticCircle.alpha = 1.0;
        sharedInstance.movingCircle.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:kAnimationCycleDuration delay:delay options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseOut animations:^{
        sharedInstance.movingCircle.alpha = 0.0;
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.25, 1.25);
        sharedInstance.movingCircle.layer.borderWidth = kBorderWidth / 3;
        
    } completion:^(BOOL finished) {
        sharedInstance.movingCircle.alpha = 1.0;
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.movingCircle.layer.borderWidth = kBorderWidth;
    }];
}

- (UIView *)createCircleWithWidth:(CGFloat)size {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCircleWidth, kCircleWidth)];
    circle.layer.cornerRadius = kCircleWidth / 2;
    circle.layer.borderWidth = kBorderWidth;
    circle.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    circle.layer.masksToBounds = true;
    return circle;
}

@end

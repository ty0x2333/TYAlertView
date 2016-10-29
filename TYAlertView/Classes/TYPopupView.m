//
//  TYPopupView.m
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import "TYPopupView.h"
#import "TYPopupViewController.h"
#import "TYAlertBackgroundWindow.h"
#import <QuartzCore/CAAnimation.h>

/**
 *  same as UIAlertView
 *  @{
 */
static CGFloat const kTYPopupViewContentViewCornerRadius = 20.f;
/**
 *  @}
 */

static CGFloat const kTYPopupViewDefaultShadowRadius = 4.f;

static CGFloat const kTYPopupViewTransitionAnimationBounceMinScale = .01f;

static CGFloat const kTYPopupViewBackgroundAnimateDuration = .3f;

const UIWindowLevel UIWindowLevelTYPopup = 1996.0;

static TYAlertBackgroundWindow *_sTYAlertBackgroundWindow;

@interface CAAnimation(TYPopupViewHandler)
@end

@implementation CAAnimation(TYPopupViewHandler)

- (void)setHander:(void(^)())handler
{
    [self setValue:handler forKey:@"handler"];
}

- (void(^)())handler
{
    return [self valueForKey:@"handler"];
}

@end

@interface TYPopupView()<CAAnimationDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, weak) UIWindow *currentKeyWindow;

@end

@implementation TYPopupView

+ (void)initialize
{
    if (self != [TYPopupView class]) {
        return;
    }
    
    TYPopupView *appearance = [self appearance];
    appearance.shadowRadius = kTYPopupViewDefaultShadowRadius;
    appearance.popupViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = self.popupViewBackgroundColor;
    _containerView.clipsToBounds = YES;
    _containerView.layer.cornerRadius = kTYPopupViewContentViewCornerRadius;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = self.shadowRadius;
    _containerView.layer.shadowOpacity = .5f;
    [self addSubview:_containerView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
}

- (void)show
{
    self.currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    [TYPopupView showBackgroundWithStyle:self.backgroundStyle];
    
    TYPopupViewController *alertViewController = [[TYPopupViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.popupView = self;
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelTYPopup;
        window.rootViewController = alertViewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    [self transitionIn:nil];
}

- (void)dismissAnimated:(BOOL)animated
{
    [TYPopupView hideBackgroundAnimated:animated];
    [self translationOut:^{
        [self removeFromSuperview];
        self.alertWindow.hidden = YES;
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
    }];
    
    UIWindow *window = self.currentKeyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

#pragma mark - Setter

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}

- (void)setPopupViewBackgroundColor:(UIColor *)popupViewBackgroundColor
{
    if (_popupViewBackgroundColor == popupViewBackgroundColor) {
        return;
    }
    _popupViewBackgroundColor = popupViewBackgroundColor;
    self.containerView.backgroundColor = popupViewBackgroundColor;
}

#pragma mark - Transition

- (void)transitionIn:(void(^)())completion
{
    switch (self.transitionStyle) {
        case TYPopupViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:.3f
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TYPopupViewTransitionStyleSystem:
        {
            self.containerView.alpha = 0;
            self.containerView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
            [UIView animateWithDuration:.3f
                             animations:^{
                                 self.containerView.alpha = 1;
                                 self.containerView.transform = CGAffineTransformMakeScale(1, 1);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TYPopupViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [self bounceAnimation:completion];
            animation.values = @[@(.8), @(1.2), @(.9), @(1)];
            animation.keyTimes = @[@(0), @(.4), @(.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
    }
    
}

- (void)translationOut:(void(^)())completion
{
    switch (self.transitionStyle) {
        case TYPopupViewTransitionStyleSystem:
        case TYPopupViewTransitionStyleFade:
        {
            [UIView animateWithDuration:.25f
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TYPopupViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [self bounceAnimation:completion];
            animation.values = @[@(1), @(1.2), @(kTYPopupViewTransitionAnimationBounceMinScale)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            self.containerView.transform = CGAffineTransformMakeScale(kTYPopupViewTransitionAnimationBounceMinScale, kTYPopupViewTransitionAnimationBounceMinScale);
        }
            break;
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim handler];
    if (completion) {
        completion();
    }
}

#pragma mark - Helper

#pragma mark Animation

- (CAKeyframeAnimation *)bounceAnimation:(void(^)())completion
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [animation setHander:completion];
    animation.duration = .3f;
    animation.delegate = self;
    return animation;
}

#pragma mark BackgroundWindow

+ (void)showBackgroundWithStyle:(TYAlertViewBackgroundStyle)style
{
    if (!_sTYAlertBackgroundWindow) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        
        _sTYAlertBackgroundWindow = [[TYAlertBackgroundWindow alloc] initWithFrame:frame style:style];
        [_sTYAlertBackgroundWindow makeKeyAndVisible];
        _sTYAlertBackgroundWindow.alpha = 0;
        [UIView animateWithDuration:kTYPopupViewBackgroundAnimateDuration
                         animations:^{
                             _sTYAlertBackgroundWindow.alpha = 1;
                         }];
        
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [_sTYAlertBackgroundWindow removeFromSuperview];
        _sTYAlertBackgroundWindow = nil;
        return;
    }
    [UIView animateWithDuration:kTYPopupViewBackgroundAnimateDuration
                     animations:^{
                         _sTYAlertBackgroundWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_sTYAlertBackgroundWindow removeFromSuperview];
                         _sTYAlertBackgroundWindow = nil;
                     }];
}


@end

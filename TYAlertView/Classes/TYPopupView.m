//
//  TYPopupView.m
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import "TYPopupView.h"
#import "TYAlertViewController.h"
#import "TYAlertBackgroundWindow.h"

/**
 *  same as UIAlertView
 *  @{
 */
static CGFloat const kTYAlertViewContentViewCornerRadius = 20.f;
/**
 *  @}
 */

static CGFloat const kTYAlertBackgroundAnimateDuration = .3f;

const UIWindowLevel UIWindowLevelTYPopup = 1996.0;

static TYAlertBackgroundWindow *_sTYAlertBackgroundWindow;

@interface TYPopupView()

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation TYPopupView

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
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = kTYAlertViewContentViewCornerRadius;
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
    
    TYAlertViewController *alertViewController = [[TYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.alertView = self;
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
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    [self translationOut:nil];
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

#pragma mark - Transition

- (void)transitionIn:(void(^)())completion
{
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.containerView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)translationOut:(void(^)())completion
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.containerView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

#pragma mark - Helper

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
        [UIView animateWithDuration:kTYAlertBackgroundAnimateDuration
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
    [UIView animateWithDuration:kTYAlertBackgroundAnimateDuration
                     animations:^{
                         _sTYAlertBackgroundWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_sTYAlertBackgroundWindow removeFromSuperview];
                         _sTYAlertBackgroundWindow = nil;
                     }];
}


@end

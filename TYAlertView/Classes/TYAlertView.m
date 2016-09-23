//
//  TYAlertView.m
//  TYAlertView
//
//  Created by luckytianyiyan on 16/9/20.
//
//

#import "TYAlertView.h"
#import "TYAlertViewController.h"
#import "TYAlertBackgroundWindow.h"

static CGFloat const kTYAlertViewContentViewWidth = 300.f;
static CGFloat const kTYAlertViewContentViewHeight = 300.f;

static CGFloat const kTYAlertBackgroundAnimateDuration = .3f;

const UIWindowLevel UIWindowLevelTYAlert = 1996.0;

static TYAlertBackgroundWindow *_sTYAlertBackgroundWindow;

@interface TYAlertView()

@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TYAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = kTYAlertViewContentViewHeight;
    CGFloat left = (CGRectGetWidth(self.bounds) - kTYAlertViewContentViewWidth) / 2.f;
    CGFloat top = (CGRectGetHeight(self.bounds) - height) / 2.f;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, kTYAlertViewContentViewWidth, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
}

- (void)show
{
    [TYAlertView showBackground];
    
    TYAlertViewController *alertViewController = [[TYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.alertView = self;
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelTYAlert;
        window.rootViewController = alertViewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
}

- (void)dismissAnimated:(BOOL)animated
{
    [TYAlertView hideBackgroundAnimated:animated];
}

#pragma mark - Setup

- (void)setup
{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 4.f;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = 2.f;
    _containerView.layer.shadowOpacity = .5f;
    [self addSubview:_containerView];
}

#pragma mark - Helper

+ (void)showBackground
{
    if (!_sTYAlertBackgroundWindow) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        
        _sTYAlertBackgroundWindow = [[TYAlertBackgroundWindow alloc] initWithFrame:frame];
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

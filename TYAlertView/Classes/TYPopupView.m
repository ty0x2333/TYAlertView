//
//  TYPopupView.m
//  Pods
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import "TYPopupView.h"
#import "TYAlertViewController.h"
#import "TYAlertBackgroundWindow.h"

static CGFloat const kTYAlertBackgroundAnimateDuration = .3f;

const UIWindowLevel UIWindowLevelTYPopup = 1996.0;

static TYAlertBackgroundWindow *_sTYAlertBackgroundWindow;

@interface TYPopupView()

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation TYPopupView

- (void)show
{
    [TYPopupView showBackground];
    
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
}

- (void)dismissAnimated:(BOOL)animated
{
    [TYPopupView hideBackgroundAnimated:animated];
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

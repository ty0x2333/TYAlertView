//
//  TYPopupView.h
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import <UIKit/UIKit.h>
#import "TYAlertBackgroundWindow.h"

typedef NS_ENUM(NSInteger, TYPopupViewTransitionStyle) {
    TYPopupViewTransitionStyleSystem = 0,
    TYPopupViewTransitionStyleBounce,
    TYPopupViewTransitionStyleFade
};

extern const UIWindowLevel UIWindowLevelTYPopup;

@interface TYPopupView : UIView

@property (nonatomic, assign) TYPopupViewTransitionStyle transitionStyle;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) TYAlertViewBackgroundStyle backgroundStyle;

@property (nonatomic, assign) CGFloat shadowRadius;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@property (nonatomic, weak) UIWindow *currentKeyWindow;

@end

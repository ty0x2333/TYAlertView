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
@property (nonatomic, assign) TYAlertViewBackgroundStyle backgroundStyle;

@property (nonatomic, strong) UIView *containerView;

/**
 default is 4.0f
 */
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

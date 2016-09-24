//
//  TYPopupView.h
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import <UIKit/UIKit.h>
#import "TYAlertBackgroundWindow.h"

extern const UIWindowLevel UIWindowLevelTYPopup;

@interface TYPopupView : UIView

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) TYAlertViewBackgroundStyle backgroundStyle;

@property (nonatomic, assign) CGFloat shadowRadius;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@property (nonatomic, weak) UIWindow *currentKeyWindow;

@end

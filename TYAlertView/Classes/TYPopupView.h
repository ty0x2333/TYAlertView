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

@property (nonatomic, assign) TYAlertViewBackgroundStyle backgroundStyle;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

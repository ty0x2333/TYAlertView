//
//  TYAlertBackgroundWindow.h
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/23.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYAlertViewBackgroundStyle) {
    TYAlertViewBackgroundStyleSolid = 0,
    TYAlertViewBackgroundStyleGradient,
};

extern const UIWindowLevel UIWindowLevelTYAlertBackground;

@interface TYAlertBackgroundWindow : UIWindow

@property (nonatomic, assign) TYAlertViewBackgroundStyle style;

@end

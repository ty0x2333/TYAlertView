//
//  TYAlertView.h
//  TYAlertView
//
//  Created by luckytianyiyan on 16/9/20.
//
//

#import <UIKit/UIKit.h>

extern const UIWindowLevel UIWindowLevelTYAlert;

NS_ASSUME_NONNULL_BEGIN

@interface TYAlertView : UIView

- (void)setup;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

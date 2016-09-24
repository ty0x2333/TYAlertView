//
//  TYPopupView.h
//  Pods
//
//  Created by luckytianyiyan on 2016/9/24.
//
//

#import <UIKit/UIKit.h>

extern const UIWindowLevel UIWindowLevelTYPopup;

@interface TYPopupView : UIView

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

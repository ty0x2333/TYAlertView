//
//  TYAlertView.h
//  TYAlertView
//
//  Created by luckytianyiyan on 16/9/20.
//
//

#import <UIKit/UIKit.h>
#import "TYPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAlertView : TYPopupView

@property (nonatomic, copy) NSString *title;

- (void)setup;

@end

NS_ASSUME_NONNULL_END

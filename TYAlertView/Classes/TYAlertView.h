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

typedef NS_ENUM(NSInteger, TYAlertActionStyle) {
    TYAlertActionStyleDefault = 0,
    TYAlertActionStyleCancel,
    TYAlertActionStyleDestructive
};

@interface TYAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(TYAlertActionStyle)style handler:(void (^ __nullable)(TYAlertAction *action))handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TYAlertActionStyle style;
@property (nonatomic, copy) void(^handler)(TYAlertAction *alertView);

@end

@interface TYAlertView : TYPopupView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/**
 default is 4.0f
 */
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;;

- (void)addAction:(TYAlertAction *)action;

@end

NS_ASSUME_NONNULL_END

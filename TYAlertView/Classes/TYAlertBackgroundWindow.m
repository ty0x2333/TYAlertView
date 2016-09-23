//
//  TYAlertBackgroundWindow.m
//  TYAlertView
//
//  Created by luckytianyiyan on 2016/9/23.
//
//

#import "TYAlertBackgroundWindow.h"

const UIWindowLevel UIWindowLevelTYAlertBackground = 1985.0;

@interface TYAlertBackgroundWindow()

@property (nonatomic, strong) CALayer *layer;

@end

@implementation TYAlertBackgroundWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelTYAlertBackground;
    }
    return self;
}

@end

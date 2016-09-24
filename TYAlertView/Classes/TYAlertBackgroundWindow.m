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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case TYAlertViewBackgroundStyleGradient:
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGFloat width = CGRectGetWidth(self.bounds);
            CGFloat height = CGRectGetHeight(self.bounds);
            
            CGPoint center = CGPointMake(width / 2, height / 2);
            CGFloat radius = MIN(width, height);
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
        case TYAlertViewBackgroundStyleSolid:
        {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}

#pragma mark - Setter / Getter

- (void)setStyle:(TYAlertViewBackgroundStyle)style
{
    if (_style == style) {
        return;
    }
    _style = style;
    
    [self setNeedsDisplay];
}

@end

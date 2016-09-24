//
//  TYAlertView.m
//  TYAlertView
//
//  Created by luckytianyiyan on 16/9/20.
//
//

#import "TYAlertView.h"
#import "TYAlertViewController.h"

static CGFloat const kTYAlertViewContentViewWidth = 300.f;
static CGFloat const kTYAlertViewContentViewHeight = 300.f;

static CGFloat const kTYAlertViewContentViewPaddingHorizontal = 10.f;
static CGFloat const kTYAlertViewContentViewPaddingVertical = 10.f;
static CGFloat const kTYAlertViewTitleLabelHeight = 50.f;

static CGFloat const kTYAlertViewButtonHeight = 44.f;

static CGFloat const kTYAlertViewDefaultShadowRadius = 4.f;

@interface TYAlertView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@end

@implementation TYAlertView

+ (void)initialize
{
    if (self != [TYAlertView class]) {
        return;
    }
    
    TYAlertView *appearance = [self appearance];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor blackColor];
    appearance.shadowRadius = kTYAlertViewDefaultShadowRadius;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = kTYAlertViewContentViewHeight;
    CGFloat left = (CGRectGetWidth(self.bounds) - kTYAlertViewContentViewWidth) / 2.f;
    CGFloat top = (CGRectGetHeight(self.bounds) - height) / 2.f;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, kTYAlertViewContentViewWidth, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat contentWidth = kTYAlertViewContentViewWidth - 2 * kTYAlertViewContentViewPaddingHorizontal;
    
    self.titleLabel.frame = CGRectMake(kTYAlertViewContentViewPaddingHorizontal, kTYAlertViewContentViewPaddingVertical, contentWidth, kTYAlertViewTitleLabelHeight);
    
    if (self.buttons.count == 2) {
        CGFloat buttonWidth = contentWidth / 2;
        UIButton *leftButton = [self.buttons firstObject];
        leftButton.frame = CGRectMake(kTYAlertViewContentViewPaddingHorizontal, height - kTYAlertViewContentViewPaddingVertical - kTYAlertViewButtonHeight, buttonWidth, kTYAlertViewButtonHeight);
        UIButton *rightButton = [self.buttons lastObject];
        rightButton.frame = CGRectMake(kTYAlertViewContentViewPaddingHorizontal + buttonWidth, height - kTYAlertViewContentViewPaddingVertical - kTYAlertViewButtonHeight, buttonWidth, kTYAlertViewButtonHeight);
    } else {
        for (NSInteger i = 0; i < self.buttons.count; ++i) {
            UIButton *button = self.buttons[i];
            button.frame = CGRectMake(kTYAlertViewContentViewPaddingHorizontal, height - kTYAlertViewContentViewPaddingVertical - (i + 1) * kTYAlertViewButtonHeight, contentWidth, kTYAlertViewButtonHeight);
        }
    }
    
    self.messageLabel.frame = CGRectMake(kTYAlertViewContentViewPaddingHorizontal, kTYAlertViewTitleLabelHeight + kTYAlertViewContentViewPaddingVertical, contentWidth, height - kTYAlertViewTitleLabelHeight - 2 * kTYAlertViewContentViewPaddingVertical - self.buttons.count * kTYAlertViewButtonHeight);
}

- (void)addButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [self.containerView addSubview:button];
    [self.buttons addObject:button];
}

#pragma mark - Setup

- (void)setup
{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 4.f;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = self.shadowRadius;
    _containerView.layer.shadowOpacity = .5f;
    [self addSubview:_containerView];
    
    // lazy
    [_containerView addSubview:self.titleLabel];
    
    // lazy
    [_containerView addSubview:self.messageLabel];
    
    _buttons = [NSMutableArray array];
}

#pragma mark - Setter / Getter

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setMessage:(NSString *)message
{
    self.messageLabel.text = message;
}

- (NSString *)message
{
    return self.messageLabel.text;
}

#pragma mark Lazy

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = self.messageColor;
        _messageLabel.backgroundColor = [UIColor clearColor];
    }
    return _messageLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

#pragma mark Appearance Setter

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) {
        return;
    }
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}

@end

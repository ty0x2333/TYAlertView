//
//  TYAlertView.m
//  TYAlertView
//
//  Created by luckytianyiyan on 16/9/20.
//
//

#import "TYAlertView.h"
#import "TYAlertViewController.h"

/**
 *  same as UIAlertView
 *  @{
 */
static CGFloat const kTYAlertViewContentViewCornerRadius = 20.f;
static CGFloat const kTYAlertViewTitleLabelFontSize = 17.f;
static CGFloat const kTYAlertViewMessageLabelFontSize = 13.f;
/**
 *  @}
 */

static CGFloat const kTYAlertViewContentViewWidth = 300.f;
static CGFloat const kTYAlertViewContentViewHeight = 300.f;

static CGFloat const kTYAlertViewContentViewPaddingHorizontal = 10.f;
static CGFloat const kTYAlertViewContentViewPaddingVertical = 10.f;
static CGFloat const kTYAlertViewTitleLabelHeight = 50.f;

static CGFloat const kTYAlertViewButtonHeight = 44.f;

static CGFloat const kTYAlertViewDefaultShadowRadius = 4.f;

@interface TYAlertViewButtonItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^handler)(TYAlertView *alertView, NSInteger index);

- (UIButton *)button;

@end

@implementation TYAlertViewButtonItem

- (UIButton *)button
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:self.text forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

@end

@interface TYAlertView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<TYAlertViewButtonItem *> *items;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *buttonConstraints;
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
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
}

- (void)show
{
    [super show];
    [self transitionIn:nil];
}

- (NSUInteger)addButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    NSUInteger index = self.items.count;
    TYAlertViewButtonItem *item = [[TYAlertViewButtonItem alloc] init];
    item.text = title;
    item.handler = handler;
    [self.items addObject:item];
    
    UIButton *button = [item button];
    [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [self.containerView addSubview:button];
    [self.buttons addObject:button];
    
    [self.containerView removeConstraints:_buttonConstraints];
    NSMutableArray *buttonConstraints;
    if (self.buttons.count == 2) {
        UIButton *leftButton = [self.buttons firstObject];
        UIButton *rightButton = [self.buttons lastObject];
        UIView *contentView = self.contentView;
        buttonConstraints = [NSMutableArray arrayWithCapacity:5];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]-[leftButton]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, leftButton)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]-[rightButton]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, rightButton)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[leftButton]-[rightButton(==leftButton)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton, rightButton)]];
    } else {
        NSMutableString *visualFormat = [NSMutableString stringWithString:@"V:[contentView]"];
        buttonConstraints = [NSMutableArray arrayWithCapacity:self.buttons.count * 2];
        NSMutableDictionary *views = [NSMutableDictionary dictionaryWithCapacity:self.buttons.count + 1];
        [views setObject:self.contentView forKey:@"contentView"];
        for (NSInteger i = 0; i < self.buttons.count; ++i) {
            UIButton *button = self.buttons[i];
            NSString *name = [NSString stringWithFormat:@"button%zd", i];
            [visualFormat appendFormat:@"-[%@(>=44)]", name];
            [views setObject:button forKey:name];
            [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        }
        [visualFormat appendString:@"-|"];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views]];
    }
    _buttonConstraints = buttonConstraints;
    [self.containerView addConstraints:_buttonConstraints];
    
    return index;
}

- (void)dismissAnimated:(BOOL)animated
{
    [super dismissAnimated:animated];
    [self translationOut:^{
        
    }];
    UIWindow *window = self.currentKeyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

#pragma mark - Setup

- (void)setup
{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = kTYAlertViewContentViewCornerRadius;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = self.shadowRadius;
    _containerView.layer.shadowOpacity = .5f;
    [self addSubview:_containerView];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.f constant:270.f]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:nil multiplier:1.f constant:44.f]];
    
    // Content View
    _contentView = [[UIView alloc] init];
    [_containerView addSubview:_contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    NSLayoutConstraint *contentViewFullHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    contentViewFullHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    [_containerView addConstraint:contentViewFullHeightConstraint];
    
    // Title Label
    UILabel *titleLabel = self.titleLabel;
    [_contentView addSubview:titleLabel];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    
    // Message Label
    UILabel *messageLabel = self.messageLabel;
    [_contentView addSubview:messageLabel];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[titleLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[messageLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleLabel]-4-[messageLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, messageLabel)]];
    
    
    _buttons = [NSMutableArray array];
    _items = [NSMutableArray array];
    
#warning test
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.translatesAutoresizingMaskIntoConstraints = NO;
//    [button setTitle:@"OK" forState:UIControlStateNormal];
//    [_containerView addSubview:button];
//    NSLayoutConstraint *t = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
//    [_containerView addConstraint:t];
//    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentView]-[button]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView, button)]];
}

#pragma mark - Transition

- (void)transitionIn:(void(^)())completion
{
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.containerView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)translationOut:(void(^)())completion
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.containerView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

#pragma mark - Event Response

- (void)onButtonClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag;
    TYAlertViewButtonItem *item = self.items[index];
    if (item.handler) {
        item.handler(self, index);
    }
    [self dismissAnimated:YES];
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
        _messageLabel.font = [UIFont systemFontOfSize:kTYAlertViewMessageLabelFontSize];
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:kTYAlertViewTitleLabelFontSize];
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

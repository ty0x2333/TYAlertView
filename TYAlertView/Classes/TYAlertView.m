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

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<TYAlertViewButtonItem *> *items;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *buttonConstraints;
@property (nonatomic, strong) NSArray<UIView *> *separators;
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
    for (UIView *view in _separators) {
        [view removeFromSuperview];
    }
    _separators = nil;
    NSMutableArray *buttonConstraints;
    NSMutableArray *separators;
    if (self.buttons.count == 2) {
        buttonConstraints = [NSMutableArray arrayWithCapacity:19];
        separators = [NSMutableArray arrayWithCapacity:2];
        
        UIView *separatorHorizontal = [self addSeparator];
        [separators addObject:separatorHorizontal];
        UIView *separatorVertical = [self addSeparator];
        [separators addObject:separatorVertical];
        
        UIButton *leftButton = [self.buttons firstObject];
        UIButton *rightButton = [self.buttons lastObject];
        UIView *contentView = self.contentView;
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]-0-[separatorHorizontal(==0.5)]-0-[leftButton(>=44)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, separatorHorizontal, leftButton)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separatorHorizontal]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorHorizontal)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorHorizontal]-0-[separatorVertical]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorHorizontal, separatorVertical)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]-0-[separatorHorizontal]-0-[rightButton(>=44)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, separatorHorizontal, rightButton)]];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftButton]-[separatorVertical(==0.5)]-[rightButton(==leftButton)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton, separatorVertical, rightButton)]];
    } else {
        buttonConstraints = [NSMutableArray arrayWithCapacity:self.buttons.count * 6 + 1];
        separators = [NSMutableArray arrayWithCapacity:self.buttons.count];
        
        NSMutableString *visualFormat = [NSMutableString stringWithString:@"V:[contentView]"];
        NSMutableDictionary *views = [NSMutableDictionary dictionaryWithCapacity:self.buttons.count + 1];
        [views setObject:self.contentView forKey:@"contentView"];
        for (NSInteger i = 0; i < self.buttons.count; ++i) {
            UIButton *button = self.buttons[i];
            
            UIView *separatorVertical = [self addSeparator];
            [separators addObject:separatorVertical];
            
            NSString *name = [NSString stringWithFormat:@"button%zd", i];
            NSString *separatorName = [NSString stringWithFormat:@"separatorVertical%zd", i];
            [visualFormat appendFormat:@"-0-[%@(==0.5)]-0-[%@(>=44)]", separatorName, name];
            [views setObject:button forKey:name];
            [views setObject:separatorVertical forKey:separatorName];
            [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[button]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button, separatorVertical)]];
            [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separatorVertical]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorVertical)]];
        }
        [visualFormat appendString:@"-0-|"];
        [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views]];
    }
    _separators = [separators copy];
    _buttonConstraints = [buttonConstraints copy];
    [self.containerView addConstraints:_buttonConstraints];
    
    return index;
}

- (void)dismissAnimated:(BOOL)animated
{
    [super dismissAnimated:animated];
}

#pragma mark - Setup

- (void)setup
{
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.f constant:270.f]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:nil multiplier:1.f constant:44.f]];
    
    // Content View
    _contentView = [[UIView alloc] init];
    [self.containerView addSubview:_contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    NSLayoutConstraint *contentViewFullHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    contentViewFullHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.containerView addConstraint:contentViewFullHeightConstraint];
    
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

#pragma mark - Helper

- (UIView *)addSeparator
{
    UIView *separatorView = [[UIView alloc] init];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:80 / 255.f alpha:.05f];
    [self.containerView addSubview:separatorView];
    return separatorView;
}

@end

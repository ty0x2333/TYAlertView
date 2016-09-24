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

@interface TYAlertView()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TYAlertView

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = kTYAlertViewContentViewHeight;
    CGFloat left = (CGRectGetWidth(self.bounds) - kTYAlertViewContentViewWidth) / 2.f;
    CGFloat top = (CGRectGetHeight(self.bounds) - height) / 2.f;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, kTYAlertViewContentViewWidth, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
}


#pragma mark - Setup

- (void)setup
{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 4.f;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = 2.f;
    _containerView.layer.shadowOpacity = .5f;
    [self addSubview:_containerView];
}

@end

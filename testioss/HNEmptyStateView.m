//
//  HNEmptyStateView.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNEmptyStateView.h"
#import "HNThemeManager.h"

@implementation HNEmptyStateView {
    HNEmptyStateActionBlock _actionBlock;
}

- (instancetype)initWithFrame:(CGRect)frame type:(HNEmptyStateType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self configureForType:type withAction:^{}];
    }
    return self;
}

- (void)setupUI {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Image View
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.tintColor = themeManager.accentColor;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:22];
    self.titleLabel.textColor = themeManager.primaryTextColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    
    // Subtitle Label
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont fontWithName:@"Courier" size:16];
    self.subtitleLabel.textColor = themeManager.secondaryTextColor;
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.subtitleLabel];
    
    // Action Button
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16];
    [self.actionButton setTitleColor:themeManager.primaryBackgroundColor forState:UIControlStateNormal];
    self.actionButton.backgroundColor = themeManager.accentColor;
    self.actionButton.layer.cornerRadius = 8;
    self.actionButton.layer.shadowColor = themeManager.shadowColor.CGColor;
    self.actionButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.actionButton.layer.shadowRadius = 10;
    self.actionButton.layer.shadowOpacity = 0.6;
    [self.actionButton addTarget:self action:@selector(actionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionButton];
    
    // Apply hacker effects
    [themeManager createHackerEffectsForView:self.imageView];
    [themeManager createHackerEffectsForView:self.actionButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Image View
        [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:40],
        [self.imageView.widthAnchor constraintEqualToConstant:80],
        [self.imageView.heightAnchor constraintEqualToConstant:80],
        
        // Title Label
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:24],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:32],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-32],
        
        // Subtitle Label
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:32],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-32],
        
        // Action Button
        [self.actionButton.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:32],
        [self.actionButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.actionButton.widthAnchor constraintEqualToConstant:140],
        [self.actionButton.heightAnchor constraintEqualToConstant:44],
        [self.actionButton.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor constant:-20]
    ]];
}

- (void)configureForType:(HNEmptyStateType)type withAction:(HNEmptyStateActionBlock)action {
    _actionBlock = action;
    
    switch (type) {
        case HNEmptyStateTypeLoading:
            self.imageView.image = [UIImage systemImageNamed:@"arrow.triangle.2.circlepath"];
            [self addRotationAnimation];
            self.titleLabel.text = @"[SYSTEM_PROCESSING]";
            self.subtitleLabel.text = @"Connecting to HACKER_NEWS feed...";
            self.actionButton.hidden = YES;
            break;
            
        case HNEmptyStateTypeNoData:
            self.imageView.image = [UIImage systemImageNamed:@"text.alignleft"];
            [self removeRotationAnimation];
            self.titleLabel.text = @"[NULL_DATA_STREAM]";
            self.subtitleLabel.text = @"No incoming packets detected. Stand by.";
            self.actionButton.hidden = YES;
            break;
            
        case HNEmptyStateTypeError:
            self.imageView.image = [UIImage systemImageNamed:@"exclamationmark.triangle"];
            [self removeRotationAnimation];
            self.titleLabel.text = @"[CONNECTION_FAILED]";
            self.subtitleLabel.text = @"Unable to establish secure connection. Check network integrity.";
            [self.actionButton setTitle:@"[RECONNECT]" forState:UIControlStateNormal];
            self.actionButton.hidden = NO;
            break;
    }
}

- (void)actionButtonTapped {
    if (_actionBlock) {
        _actionBlock();
    }
}

- (void)addRotationAnimation {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @(0);
    rotation.toValue = @(2 * M_PI);
    rotation.duration = 1.5;
    rotation.repeatCount = INFINITY;
    [self.imageView.layer addAnimation:rotation forKey:@"rotation"];
    
    // Add hacker glow effect
    [self.imageView.layer addAnimation:[themeManager hackerGlowAnimation] forKey:@"hackerGlow"];
    
    // Add title glitch effect
    [self addTitleGlitch];
}

- (void)addTitleGlitch {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Repeating glitch effect for title
    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.titleLabel.textColor = [themeManager randomHackerColor];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.titleLabel.textColor = themeManager.primaryTextColor;
        });
    }];
}

- (void)removeRotationAnimation {
    [self.imageView.layer removeAnimationForKey:@"rotation"];
    [self.imageView.layer removeAnimationForKey:@"hackerGlow"];
}

@end
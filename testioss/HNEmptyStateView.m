//
//  HNEmptyStateView.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNEmptyStateView.h"

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
    // Image View
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.tintColor = [UIColor systemOrangeColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    
    // Subtitle Label
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.subtitleLabel];
    
    // Action Button
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemOrangeColor];
    self.actionButton.layer.cornerRadius = 12;
    self.actionButton.layer.shadowColor = [UIColor systemOrangeColor].CGColor;
    self.actionButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.actionButton.layer.shadowRadius = 4;
    self.actionButton.layer.shadowOpacity = 0.3;
    [self.actionButton addTarget:self action:@selector(actionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionButton];
    
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
            self.titleLabel.text = @"Loading Stories...";
            self.subtitleLabel.text = @"Fetching the latest from Hacker News";
            self.actionButton.hidden = YES;
            break;
            
        case HNEmptyStateTypeNoData:
            self.imageView.image = [UIImage systemImageNamed:@"text.alignleft"];
            [self removeRotationAnimation];
            self.titleLabel.text = @"No Stories Available";
            self.subtitleLabel.text = @"Check back later for fresh content";
            self.actionButton.hidden = YES;
            break;
            
        case HNEmptyStateTypeError:
            self.imageView.image = [UIImage systemImageNamed:@"exclamationmark.triangle"];
            [self removeRotationAnimation];
            self.titleLabel.text = @"Something Went Wrong";
            self.subtitleLabel.text = @"Unable to load stories. Please check your connection.";
            [self.actionButton setTitle:@"🔄 Retry" forState:UIControlStateNormal];
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
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @(0);
    rotation.toValue = @(2 * M_PI);
    rotation.duration = 1.5;
    rotation.repeatCount = INFINITY;
    [self.imageView.layer addAnimation:rotation forKey:@"rotation"];
}

- (void)removeRotationAnimation {
    [self.imageView.layer removeAnimationForKey:@"rotation"];
}

@end
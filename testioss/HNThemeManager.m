//
//  HNThemeManager.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNThemeManager.h"

@implementation HNThemeManager

static HNThemeManager *_sharedManager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupHackerColors];
    }
    return self;
}

- (void)setupHackerColors {
    _primaryBackgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.08 alpha:1.0];    // Deep dark blue
    _secondaryBackgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.12 alpha:1.0];  // Darker blue
    _cardBackgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.18 alpha:0.9];        // Card dark
    _primaryTextColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];              // Matrix green
    _secondaryTextColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.6 alpha:1.0];           // Light green
    _accentColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0];                   // Cyber blue
    _highlightColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.4 alpha:1.0];                // Neon red
    _borderColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:0.3];                  // Green border
    _shadowColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.2 alpha:0.4];                  // Green shadow
    _glowColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:0.8];                    // Green glow
}

#pragma mark - Theme Application

- (void)applyHackerTheme {
    // Apply to navigation bar
    [[UINavigationBar appearance] setBarTintColor:self.primaryBackgroundColor];
    [[UINavigationBar appearance] setTintColor:self.accentColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName: self.primaryTextColor,
        NSFontAttributeName: [UIFont fontWithName:@"Courier" size:18]
    }];
    [[UINavigationBar appearance] setLargeTitleTextAttributes:@{
        NSForegroundColorAttributeName: self.primaryTextColor,
        NSFontAttributeName: [UIFont fontWithName:@"Courier-Bold" size:34]
    }];
    
    // Set status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Apply to refresh control
    [[UIRefreshControl appearance] setTintColor:self.accentColor];
}

- (void)createHackerEffectsForView:(UIView *)view {
    // Add hacker-style border
    view.layer.borderColor = self.borderColor.CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 8.0;
    
    // Add hacker shadow
    view.layer.shadowColor = self.shadowColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 10.0;
    view.layer.shadowOpacity = 0.6;
    view.layer.masksToBounds = NO;
    
    // Add subtle glow effect
    view.layer.shadowColor = self.glowColor.CGColor;
    view.layer.shadowRadius = 5.0;
    view.layer.shadowOpacity = 0.3;
}

#pragma mark - Hacker Animations

- (CABasicAnimation *)hackerGlowAnimation {
    CABasicAnimation *glowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    glowAnimation.fromValue = @(0.3);
    glowAnimation.toValue = @(0.8);
    glowAnimation.autoreverses = YES;
    glowAnimation.duration = 2.0;
    glowAnimation.repeatCount = INFINITY;
    return glowAnimation;
}

- (CABasicAnimation *)hackerPulseAnimation {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.fromValue = @(1.0);
    pulseAnimation.toValue = @(1.02);
    pulseAnimation.autoreverses = YES;
    pulseAnimation.duration = 1.5;
    pulseAnimation.repeatCount = INFINITY;
    return pulseAnimation;
}

- (UIColor *)randomHackerColor {
    NSArray *hackerColors = @[
        self.primaryTextColor,
        self.accentColor,
        self.highlightColor,
        [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0], // Yellow
        [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0], // Purple
    ];
    return hackerColors[arc4random_uniform((uint32_t)hackerColors.count)];
}

@end
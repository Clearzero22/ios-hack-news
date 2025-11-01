//
//  HNThemeManager.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNThemeManager : NSObject

@property (class, nonatomic, readonly) HNThemeManager *sharedManager;

// Hacker Theme Colors
@property (nonatomic, readonly) UIColor *primaryBackgroundColor;
@property (nonatomic, readonly) UIColor *secondaryBackgroundColor;
@property (nonatomic, readonly) UIColor *cardBackgroundColor;
@property (nonatomic, readonly) UIColor *primaryTextColor;
@property (nonatomic, readonly) UIColor *secondaryTextColor;
@property (nonatomic, readonly) UIColor *accentColor;
@property (nonatomic, readonly) UIColor *highlightColor;
@property (nonatomic, readonly) UIColor *borderColor;
@property (nonatomic, readonly) UIColor *shadowColor;
@property (nonatomic, readonly) UIColor *glowColor;

// Theme Methods
- (void)applyHackerTheme;
- (void)createHackerEffectsForView:(UIView *)view;
- (UIColor *)randomHackerColor;
- (CABasicAnimation *)hackerGlowAnimation;
- (CABasicAnimation *)hackerPulseAnimation;

@end

NS_ASSUME_NONNULL_END
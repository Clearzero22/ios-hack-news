//
//  HNEmptyStateView.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HNEmptyStateType) {
    HNEmptyStateTypeLoading,
    HNEmptyStateTypeNoData,
    HNEmptyStateTypeError
};

typedef void(^HNEmptyStateActionBlock)(void);

@interface HNEmptyStateView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *actionButton;

- (instancetype)initWithFrame:(CGRect)frame type:(HNEmptyStateType)type;
- (void)configureForType:(HNEmptyStateType)type withAction:(HNEmptyStateActionBlock)action;

@end

NS_ASSUME_NONNULL_END
//
//  HNStoryTableViewCell.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <UIKit/UIKit.h>

@class HNStory;

NS_ASSUME_NONNULL_BEGIN

@interface HNStoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *metaLabel;
@property (nonatomic, strong) UIView *cardView;

- (void)configureWithStory:(HNStory *)story;

@end

NS_ASSUME_NONNULL_END
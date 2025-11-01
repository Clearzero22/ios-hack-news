//
//  HNNewsDetailViewController.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <UIKit/UIKit.h>
#import "HNStory.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNNewsDetailViewController : UIViewController

- (instancetype)initWithStory:(HNStory *)story;

@end

NS_ASSUME_NONNULL_END
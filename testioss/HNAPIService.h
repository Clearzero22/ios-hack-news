//
//  HNAPIService.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <Foundation/Foundation.h>
#import "HNStory.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HNStoriesCompletionBlock)(NSArray<HNStory *> * _Nullable stories, NSError * _Nullable error);
typedef void(^HNStoryDetailCompletionBlock)(HNStory * _Nullable story, NSError * _Nullable error);

@interface HNAPIService : NSObject

+ (instancetype)sharedService;

- (void)fetchTopStorysWithCompletion:(HNStoriesCompletionBlock)completion;
- (void)fetchStoryDetailWithID:(NSNumber *)storyID completion:(HNStoryDetailCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
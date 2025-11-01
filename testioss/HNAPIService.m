//
//  HNAPIService.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNAPIService.h"

static NSString * const HNBaseURL = @"https://hacker-news.firebaseio.com/v0";

@implementation HNAPIService

+ (instancetype)sharedService {
    static HNAPIService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)fetchTopStorysWithCompletion:(HNStoriesCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/topstories.json", HNBaseURL]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        NSError *jsonError = nil;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![jsonResponse isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, jsonError ?: [NSError errorWithDomain:@"HNAPIError" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"Invalid response format"}]);
            });
            return;
        }
        
        NSArray *storyIDs = (NSArray *)jsonResponse;
        NSArray *topStoryIDs = [storyIDs subarrayWithRange:NSMakeRange(0, MIN(30, storyIDs.count))];
        
        [self fetchStoriesWithIDs:topStoryIDs completion:completion];
    }];
    
    [task resume];
}

- (void)fetchStoriesWithIDs:(NSArray<NSNumber *> *)storyIDs completion:(HNStoriesCompletionBlock)completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray<HNStory *> *stories = [NSMutableArray array];
    NSMutableArray<NSError *> *errors = [NSMutableArray array];
    
    for (NSNumber *storyID in storyIDs) {
        dispatch_group_enter(group);
        
        [self fetchStoryDetailWithID:storyID completion:^(HNStory * _Nullable story, NSError * _Nullable error) {
            if (story) {
                @synchronized(stories) {
                    [stories addObject:story];
                }
            } else if (error) {
                @synchronized(errors) {
                    [errors addObject:error];
                }
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [stories sortUsingComparator:^NSComparisonResult(HNStory *obj1, HNStory *obj2) {
            NSUInteger index1 = [storyIDs indexOfObject:obj1.storyID];
            NSUInteger index2 = [storyIDs indexOfObject:obj2.storyID];
            return [@(index1) compare:@(index2)];
        }];
        
        completion(stories, errors.count > 0 ? errors.firstObject : nil);
    });
}

- (void)fetchStoryDetailWithID:(NSNumber *)storyID completion:(HNStoryDetailCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/item/%@.json", HNBaseURL, storyID]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        NSError *jsonError = nil;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || ![jsonResponse isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, jsonError ?: [NSError errorWithDomain:@"HNAPIError" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Invalid story format"}]);
            });
            return;
        }
        
        HNStory *story = [[HNStory alloc] initWithDictionary:(NSDictionary *)jsonResponse];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(story, nil);
        });
    }];
    
    [task resume];
}

@end
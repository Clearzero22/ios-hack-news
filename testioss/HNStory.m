//
//  HNStory.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNStory.h"

@implementation HNStory

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _storyID = dict[@"id"];
        _title = dict[@"title"];
        _author = dict[@"by"];
        _url = dict[@"url"];
        _score = dict[@"score"];
        _commentCount = dict[@"descendants"];
        
        if (dict[@"time"]) {
            _createdAt = [NSDate dateWithTimeIntervalSince1970:[dict[@"time"] doubleValue]];
        }
    }
    return self;
}

@end
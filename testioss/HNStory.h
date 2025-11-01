//
//  HNStory.h
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import <Foundation/Foundation.h>

@interface HNStory : NSObject

@property (nonatomic, strong) NSNumber *storyID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
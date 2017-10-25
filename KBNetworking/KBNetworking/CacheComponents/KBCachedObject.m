//
//  KBCachedObject.m
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 kuaibao. All rights reserved.
//

#import "KBCachedObject.h"

@interface KBCachedObject ()

@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end

@implementation KBCachedObject

- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > KBCacheOutdateTimeSeconds;
}

- (void)setContent:(id)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark - life cycle
- (instancetype)initWithContent:(id)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(id)content
{
    self.content = content;
}


@end

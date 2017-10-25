//
//  KBCache.m
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 kuaibao. All rights reserved.
//

#import "KBCache.h"
#import "NSString+Methods.h"

@interface KBCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation KBCache

#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = KBCacheCountLimit;
    }
    return _cache;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static KBCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public method

- (BOOL)hasContentWithIdentifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    id content = [self fetchCachedIdentifier:identifier methodName:methodName requestParams:requestParams];
    return content == nil ? NO : YES;
}

- (BOOL)hasContentWithKey:(NSString *)key
{
    id content = [self fetchCachedDataWithKey:key];
    return content == nil ? NO : YES;
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)saveCacheWithData:(id)cachedData key:(NSString *)key
{
    KBCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[KBCachedObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (id)fetchCachedDataWithKey:(NSString *)key
{
    KBCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)deleteCacheWithIdentifier:(NSString *)identifier methodName:(NSString *)methodName
                     requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:identifier methodName:methodName requestParams:requestParams]];
}


- (void)saveCacheWithData:(id)cachedData identifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:identifier methodName:methodName requestParams:requestParams]];
}

- (id)fetchCachedIdentifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:identifier methodName:methodName requestParams:requestParams]];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
      return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [NSString stringSignatureWithParams:requestParams]];
}


@end

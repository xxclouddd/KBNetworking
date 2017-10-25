//
//  KBCache.h
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 kuaibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBNetworkingConfiguration.h"
#import "KBCachedObject.h"

@interface KBCache : NSObject

+ (instancetype)sharedInstance;

- (BOOL)hasContentWithKey:(NSString *)key;
- (BOOL)hasContentWithIdentifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(id)cachedData key:(NSString *)key;
- (void)saveCacheWithData:(id)cachedData identifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;

- (void)deleteCacheWithKey:(NSString *)key;
- (void)deleteCacheWithIdentifier:(NSString *)identifier methodName:(NSString *)methodName
                    requestParams:(NSDictionary *)requestParams;

- (id)fetchCachedDataWithKey:(NSString *)key;
- (id)fetchCachedIdentifier:(NSString *)identifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;

- (void)clean;

@end

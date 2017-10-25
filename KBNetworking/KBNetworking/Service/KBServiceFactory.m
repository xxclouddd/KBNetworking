
//
//  KBServiceFactory.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBServiceFactory.h"
#import "KBServiceV1.h"
#import "KBServiceV2.h"
#import "KBServiceV3.h"

NSString * const kKBServiceV1 = @"KBServiceV1";
NSString * const kKBServiceV2 = @"KBServiceV2";
NSString * const kKBServiceV3 = @"KBServiceV3";

@interface KBServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation KBServiceFactory

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static KBServiceFactory *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[KBServiceFactory alloc] init];
    });
    return shareInstance;
}

#pragma mark - public methods
- (KBService<KBServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (KBService<KBServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kKBServiceV1]) {
        return [[KBServiceV1 alloc] init];
    }
    else if ([identifier isEqualToString:kKBServiceV2]) {
        return [[KBServiceV2 alloc] init];
    }
    else if ([identifier isEqualToString:kKBServiceV3]) {
        return [[KBServiceV3 alloc] init];
    }

    return nil;
}

#pragma mark - setter and getter
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    return _serviceStorage;
}

@end










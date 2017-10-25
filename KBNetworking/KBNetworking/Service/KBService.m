
//
//  KBService.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBService.h"

@implementation KBService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(KBServiceProtocal)]) {
            self.child = (id<KBServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - public methods
- (NSString *)generaterApiUrlStringWithMethodName:(NSString *)methodName
{
    return self.apiBaseUrl;
}

- (NSDictionary *)generaterParamsWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params
{
    return @{};
}

#pragma mark - getter and setter
- (NSString *)apiBaseUrl
{
    return [self.child isOnline] ? [self.child onlineApiBaseUrl] : [self.child offlineApiBaseUrl];
}

- (NSString *)privateKey
{
    return [self.child isOnline] ? [self.child onlinePrivateKey] : [self.child offlinePrivateKey];
}

@end





























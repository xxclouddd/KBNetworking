//
//  KBServiceMethodFactory.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/26.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBServiceMethodFactory.h"
#import "KBNetworkingConfiguration.h"

@interface KBServiceMethodFactory ()

@end

@implementation KBServiceMethodFactory

#pragma mark - KBBrandProtocal
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static KBServiceMethodFactory *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[KBServiceMethodFactory alloc] init];
    });
    return shareInstance;
}

- (NSString *)userLogin
{
    return @"/v1/xxx/login";
}

- (NSString *)interface1
{
    return @"/v1/interface1";
}

- (NSString *)interface2
{
    return @"/v1/interface2";
}

- (NSString *)informBroadcast
{
    return @"/v1/informBroadcast";
}

@end

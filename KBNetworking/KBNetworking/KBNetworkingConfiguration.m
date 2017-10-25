//
//  KBNetworkingConfiguration.m
//  KBNetworking
//
//  Created by 肖雄 on 17/3/6.
//  Copyright © 2017年 kuaibao. All rights reserved.
//

#import "KBNetworkingConfiguration.h"

@implementation KBNetworkingConfiguration

+ (instancetype)shareInstance
{
    static KBNetworkingConfiguration *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBNetworkingConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)session
{
    return [NSString stringWithFormat:@"session_id=%@%@", @"s", _session ?: @""];
}

@end

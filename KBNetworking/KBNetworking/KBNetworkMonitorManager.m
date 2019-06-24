//
//  KBNetworkMonitorManager.m
//  KBNetworking
//
//  Created by 肖雄 on 17/3/6.
//  Copyright © 2017年 xiaoxiong. All rights reserved.
//

#import "KBNetworkMonitorManager.h"
#import "AFNetworkReachabilityManager.h"

@implementation KBNetworkMonitorManager

#pragma mark - life circle
+ (instancetype)sharedInstance
{
    static KBNetworkMonitorManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBNetworkMonitorManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

#pragma mark - public methods
- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}


@end

//
//  KBNetworkMonitorManager.h
//  KBNetworking
//
//  Created by 肖雄 on 17/3/6.
//  Copyright © 2017年 kuaibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBNetworkMonitorManager : NSObject

@property (nonatomic, readonly) BOOL isReachable;

+ (instancetype)sharedInstance;

@end

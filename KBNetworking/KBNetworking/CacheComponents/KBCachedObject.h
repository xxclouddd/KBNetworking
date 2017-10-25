//
//  KBCachedObject.h
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 kuaibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBNetworkingConfiguration.h"

@interface KBCachedObject : NSObject

@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(id)content;
- (void)updateContent:(id)content;

@end

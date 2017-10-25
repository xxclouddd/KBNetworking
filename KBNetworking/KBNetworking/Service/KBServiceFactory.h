//
//  KBServiceFactory.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBService.h"

@interface KBServiceFactory : NSObject

+ (instancetype)shareInstance;
- (KBService<KBServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;

@end

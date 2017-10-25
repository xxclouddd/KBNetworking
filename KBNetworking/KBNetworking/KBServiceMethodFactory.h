//
//  KBServiceMethodFactory.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/26.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBServiceMethodFactory : NSObject

+ (instancetype)shareInstance;

- (NSString *)userLogin;
- (NSString *)interface1;
- (NSString *)interface2;
- (NSString *)informBroadcast;

-@end

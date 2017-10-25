//
//  KBRequestParamsGenerator.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBRequestParamsGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary *)generatePostRequestParamsWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSString *)generatePostRequestURLWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName;

@end

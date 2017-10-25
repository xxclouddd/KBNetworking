//
//  KBService.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlinePrivateKey;
@property (nonatomic, readonly) NSString *onlinePrivateKey;

@end

@interface KBService : NSObject

@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

@property (nonatomic, weak) id<KBServiceProtocal>child;

- (NSString *)generaterApiUrlStringWithMethodName:(NSString *)methodName;
- (NSDictionary *)generaterParamsWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params;

@end

//
//  KBServiceV1.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBServiceV1.h"
#import "NSString+Methods.h"

@implementation KBServiceV1

#pragma mark - override
- (NSDictionary *)generaterParamsWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params
{
    NSString *timestamp = [NSString timestampStringSince1970];
    NSString *tokenStr= [NSString serializationParams:params];
    tokenStr = [tokenStr stringByAppendingString:self.privateKey];
    tokenStr = [NSString md5:tokenStr];
    
    NSDictionary *header = @{@"service_name": methodName,
                             @"partner_name": @"ioss",
                             @"time_stamp": timestamp,
                             @"version": @"v1",
                             @"format": @"json",
                             @"token": tokenStr};
    
    NSDictionary *sendDic = @{@"header": header,
                              @"body": params};
    
    NSString *sendStr = [NSString jsonStringWithObject:@{@"request": sendDic}];
    NSDictionary *requestParams = @{@"request": sendStr};
    
    
    return requestParams;
}

#pragma mark - KBServiceProtocal
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)offlineApiBaseUrl
{
    return @"";
}

- (NSString *)onlineApiBaseUrl
{
    return @"http://xxx/xxx";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"private key";
}


@end

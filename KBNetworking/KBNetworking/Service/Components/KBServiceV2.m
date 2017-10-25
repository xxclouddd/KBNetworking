//
//  KBServiceV2.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBServiceV2.h"
#import "NSString+Methods.h"

@implementation KBServiceV2

#pragma mark - override
- (NSDictionary *)generaterParamsWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *content = [NSString jsonStringWithObject:dic];
    NSString *tokenString = [NSString stringWithFormat:@"%@%@", content, self.privateKey];
    NSString *token = [NSString md5:tokenString];
    
    NSDictionary *requestParams = @{@"content": content,
                                    @"token": token};

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
    return @"http://xxx/xxxx";
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

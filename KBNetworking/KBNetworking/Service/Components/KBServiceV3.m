

//
//  KBServiceV3.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBServiceV3.h"
#import "NSString+Methods.h"

@interface KBServiceV3 ()

@end

@implementation KBServiceV3

#pragma mark - override
- (NSString *)generaterApiUrlStringWithMethodName:(NSString *)methodName
{
    return [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, methodName];
}

- (NSDictionary *)generaterParamsWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params
{
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%0.f", ts*1000];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@", timeStr, self.privateKey, methodName, self.appId];
    NSString *sign = [NSString md5:str];
    NSString *sendStr = [NSString jsonStringWithObject:params];
    sendStr = [sendStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    //http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string
    
    NSDictionary *requestParams = @{@"app_id": self.appId,
                                    @"ts": timeStr,
                                    @"sign": sign,
                                    @"data": sendStr};
    
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
    return @"http://xxxx/xxx.com";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"private key";
}

#pragma mark - setter and getter
- (NSString *)appId
{
    return [self isOnline] ? @"abc123" : @"123";
}

@end

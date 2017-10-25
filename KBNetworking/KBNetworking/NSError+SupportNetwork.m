//
//  NSError+SupportNetwork.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "NSError+SupportNetwork.h"

@implementation NSError (SupportNetwork)

+ (instancetype)errorDesc:(nullable NSString *)desc
{
    NSDictionary *userInfo;
    if (![desc isKindOfClass:[NSString class]]) {
        desc = @"";
    }
    userInfo = @{NSLocalizedDescriptionKey: desc};

    return [self errorWithDomain:@"" code:KBInstantErrorDefaultValue userInfo:userInfo];
}

+ (instancetype)errorWithCode:(NSInteger)code desc:(nullable NSString *)desc
{
    NSDictionary *userInfo;
    if (![desc isKindOfClass:[NSString class]]) {
        desc = @"";
    }
    userInfo = @{NSLocalizedDescriptionKey: desc};
    
    return [self errorWithDomain:@"" code:code userInfo:userInfo];
}

+ (instancetype)plainErrorWithError:(NSError *)error
{
    // 除了超时以外，所有错误都当成是无网络
    if (error.code == NSURLErrorTimedOut) {
        return [NSError errorWithCode:KBInstantErrorTimeout desc:@"连接超时，请稍候重试"];
    } else {
        return [NSError errorWithCode:KBInstantErrorNoNetwork desc:@"连接失败，请稍候重试"];
    }
}

@end

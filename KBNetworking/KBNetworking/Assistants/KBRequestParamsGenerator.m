



//
//  KBRequestParamsGenerator.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBRequestParamsGenerator.h"
#import "KBService.h"
#import "KBServiceFactory.h"

@implementation KBRequestParamsGenerator
#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static KBRequestParamsGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBRequestParamsGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)generatePostRequestParamsWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    KBService *service = [[KBServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    return [service generaterParamsWithMethodName:methodName requestParams:requestParams];
}

- (NSString *)generatePostRequestURLWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName
{
    KBService *service = [[KBServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    return [service generaterApiUrlStringWithMethodName:methodName];
}


@end

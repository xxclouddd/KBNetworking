//
//  KBBroadcastManager.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 16/1/25.
//  Copyright © 2016年 KuaidiHelp. All rights reserved.
//

#import "KBBroadcastManager.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const KBBroadcastTypeActionGet = @"get";
NSString * const KBBroadcastTypeScan = @"scan";

@implementation KBBroadcastManager

- (void)getInformBroadcastWithAction:(NSString *)action type:(NSString *)type completionHandle:(void (^)(NSString * _Nullable, NSError * _Nullable))completionHandle
{
    NSParameterAssert(action);
    NSParameterAssert(type);

    NSDictionary *params = @{@"action" : action,
                             @"type": type};
    [self loadDataWithParams:params success:^(KBAPIManagerTask *task, NSDictionary *responseObject) {
        NSDictionary *data = [responseObject[@"data"] safeCastForClass:[NSDictionary class]];
        NSDictionary *result = [data[@"result"] safeCastForClass:[NSDictionary class]];
        NSDictionary *retArr = [result[@"retArr"] safeCastForClass:[NSDictionary class]];
        NSString *content = [retArr[@"content"] safeCastForClass:[NSString class]];
        
        completionHandle ? completionHandle(content, nil) : nil;
        
    } failure:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
        completionHandle ? completionHandle(nil, error) : nil;
    }];
}

#pragma mark - KBAPIManager

- (NSString *)methodName
{
    return [[KBServiceMethodFactory shareInstance] informBroadcast];
}

- (NSString *)serviceType
{
    return kKBServiceV2;
}

- (KBAPIManagerRequestType)requestType
{
    return KBAPIManagerRequestTypePost;
}

- (BOOL)shouldCache
{
    return YES;
}

#pragma mark - KBAPIManagerValidator
- (KBValidatorType)validatorType
{
    return KBValidatorTypeValue2;
}

- (KBValidator * _Nullable)manager:(KBAPIBaseManager *)manager task:(KBAPIManagerTask *)task callBackData:(id)data
{
    NSDictionary *aData = [data[@"data"] safeCastForClass:[NSDictionary class]];
    NSString *status = aData[@"status"];
    if (![status isEqualToString:@"success"]) {
        NSString *desc = [aData[@"desc"] safeCastForClass:[NSString class]];
        NSError *error = [NSError errorDesc:desc];
        return [[KBValidator alloc] initWithContent:data error:error];
    }
    return nil;
}

@end

NS_ASSUME_NONNULL_END

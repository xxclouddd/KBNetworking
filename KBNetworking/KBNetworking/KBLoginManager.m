//
//  KBLoginManager.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBLoginManager.h"

@implementation KBLoginManager

- (void)loginWithAccout:(NSString *)account password:(NSString *)password completion:(void (^)(NSDictionary *, NSError *))completion
{    
    NSDictionary *params = @{@"username": account ?: @"",
                             @"password": password ?: @""};
    
    [self loadDataWithParams:params success:^(KBAPIManagerTask *task, NSDictionary *responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        completion ? completion(data, nil) : nil;
        
    } failure:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
        
        completion ? completion(nil, error) : nil;
    }];
}

#pragma mark - KBAPIManager

- (NSString *)methodName
{
    return [[KBServiceMethodFactory shareInstance] userLogin];
}

- (NSString *)serviceType
{
    return kKBServiceV3;
}

- (KBAPIManagerRequestType)requestType
{
    return KBAPIManagerRequestTypePost;
}

#pragma mark - KBAPIManagerValidator
- (KBValidatorType)validatorType
{
    return KBValidatorTypeValue2;
}

@end


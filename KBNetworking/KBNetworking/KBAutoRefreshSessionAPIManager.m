


//
//  KBAutoRefreshSessionAPIManager.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBAutoRefreshSessionAPIManager.h"
#import "KBLoginManager.h"
#import "KBApiProxy.h"

static NSInteger loginManagerTryCountMax = 1;

@interface KBAutoRefreshSessionAPIManager ()

@property (nonatomic, strong) KBLoginManager *loginManager;
@property (nonatomic, assign) NSInteger loginManagerTryCount;

@end

@implementation KBAutoRefreshSessionAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginManagerTryCount = 0;
    }
    return self;
}

- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
                                 success:(void (^)(KBAPIManagerTask *, id))success
                                 failure:(void (^)(KBAPIManagerTask *, id, NSError *))failure
{
   KBAPIManagerTask *requestTask = [super loadDataWithParams:params success:success failure:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
       if (error.code != KBInstantErrorSessionInvalid || self.loginManagerTryCount >= loginManagerTryCountMax) {
           failure ? failure(task, responseObject, error) : nil;
           return;
       }

       self.loginManagerTryCount ++;
       
       NSString *account = [KBNetworkingConfiguration shareInstance].phone;
       NSString *password = [KBNetworkingConfiguration shareInstance].password;
       
       if (account.length > 0 && password.length > 0) {
           [[[KBLoginManager alloc] init] loginWithAccout:account password:password completion:^(NSDictionary *JSON, NSError *error) {
               NSString *sessionID = nil;
               if (error == nil && JSON) {
                   sessionID = [NSString stringWithFormat:@"%@", JSON[@"session_id"]];
               }
               
               if (sessionID.length > 0) {
                   [[KBNetworkingConfiguration shareInstance] setSession:sessionID];
                   [[KBApiProxy sharedInstance].manager.requestSerializer setValue:[KBNetworkingConfiguration shareInstance].session forHTTPHeaderField:@"Cookie"];
                   [self resumeTask:task];
               } else {
                   failure ? failure(task, responseObject, error) : nil;
               }
           }];
       } else {
           failure ? failure(task, responseObject, error) : nil;
       }
    }];
    
    return requestTask;
}

- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
               constructingBodyWithBlock:(void (^)(id<KBMultipartFormData>))block
                                 success:(void (^)(KBAPIManagerTask *, id))success
                                 failure:(void (^)(KBAPIManagerTask *, id, NSError *))failure
{
    KBAPIManagerTask *requestTask = [super loadDataWithParams:params constructingBodyWithBlock:block success:success failure:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
        if (error.code != KBInstantErrorSessionInvalid || self.loginManagerTryCount >= loginManagerTryCountMax) {
            failure ? failure(task, responseObject, error) : nil;
            return;
        }
        
        self.loginManagerTryCount ++;
        
        NSString *account = [KBNetworkingConfiguration shareInstance].phone;
        NSString *password = [KBNetworkingConfiguration shareInstance].password;
        
        if (account.length > 0 && password.length > 0) {
            [[[KBLoginManager alloc] init] loginWithAccout:account password:password completion:^(NSDictionary *JSON, NSError *error) {
                NSString *sessionID = nil;
                if (error == nil && JSON) {
                    sessionID = [NSString stringWithFormat:@"%@", JSON[@"session_id"]];
                }
                
                if (sessionID.length > 0) {
                    [[KBNetworkingConfiguration shareInstance] setSession:sessionID];
                    [[KBApiProxy sharedInstance].manager.requestSerializer setValue:[KBNetworkingConfiguration shareInstance].session forHTTPHeaderField:@"Cookie"];
                    [self resumeTask:task];
                } else {
                    failure ? failure(task, responseObject, error) : nil;
                }
            }];
        } else {
            failure ? failure(task, responseObject, error) : nil;
        }
    }];
    
    return requestTask;
}

#pragma mark - setter and getter 
- (KBLoginManager *)loginManager
{
    if (_loginManager == nil) {
        _loginManager = [[KBLoginManager alloc] init];
    }
    return _loginManager;
}

@end

//
//  KBAPIBaseManager1.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/13.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBAPIBaseManager.h"
#import "KBValidator.h"
#import "NSError+SupportNetwork.h"
#import "KBNetworkingConfiguration.h"
#import "KBServiceMethodFactory.h"
#import "KBApiProxy.h"
@class KBAPIBaseManager;
@class KBAPIManagerTask;


@protocol KBAPIManager <NSObject>
@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (KBAPIManagerRequestType)requestType;

@optional
- (BOOL)shouldCache;

@end

@protocol KBAPIManagerValidator <NSObject>
@optional
- (KBValidatorType)validatorType;
- (KBValidator *)manager:(KBAPIBaseManager *)manager task:(KBAPIManagerTask *)task callBackData:(id)data;

@end


@interface KBAPIBaseManager : NSObject

@property (nonatomic, weak) NSObject<KBAPIManager> *child;
@property (nonatomic, weak) id<KBAPIManagerValidator> validator;

- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
                                 success:(void (^)(KBAPIManagerTask *task ,id responseObject))success
                                 failure:(void (^)(KBAPIManagerTask *task ,id responseObject ,NSError *error))failure;

- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
               constructingBodyWithBlock:(void (^)(id <KBMultipartFormData> formData))block
                                 success:(void (^)(KBAPIManagerTask *task ,id responseObject))success
                                 failure:(void (^)(KBAPIManagerTask *task ,id responseObject ,NSError *error))failure;

- (void)resumeTask:(KBAPIManagerTask *)task;

- (void)cancelRequestWithTask:(KBAPIManagerTask *)task;
- (void)cancelAllRequests;

@end

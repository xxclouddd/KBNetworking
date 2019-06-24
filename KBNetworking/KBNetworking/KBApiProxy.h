//
//  KBApiProxy.h
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@protocol KBMultipartFormData;

@interface KBApiProxy : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

+ (instancetype)sharedInstance;

- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;

- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
       constructingBodyWithBlock:(void (^)(id <KBMultipartFormData> formData))block
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end


@protocol KBMultipartFormData <NSObject>

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

@end

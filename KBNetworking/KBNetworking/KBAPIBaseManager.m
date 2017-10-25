
//
//  KBAPIBaseManager1.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/13.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBAPIBaseManager.h"
#import "KBNetworkingConfiguration.h"
#import "KBCache.h"
#import "KBCachedObject.h"
#import "KBNetworkMonitorManager.h"
#import "KBRequestParamsGenerator.h"

#pragma mark -----  KBAPIManagerTask

typedef void (^KBAPITaskCompletionHandler)(KBAPIManagerTask *task ,id responseObject, NSError *error);
typedef void (^KBAPITaskConstructingBody)(id<KBMultipartFormData>formData);

@interface KBAPIManagerTask : NSObject

@property (nonatomic, strong) NSString *serviceIdentifier;
@property (nonatomic, assign) KBAPIManagerRequestType requestType;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) KBAPITaskConstructingBody constructingBody;
@property (nonatomic, copy) KBAPITaskCompletionHandler completionHandler;

@property (nonatomic, strong) NSNumber *requestId;
@property (nonatomic, strong) id responseObject;

@end

@implementation KBAPIManagerTask

- (instancetype)initWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                   requestType:(KBAPIManagerRequestType)requestType
             serviceIdentifier:(NSString *)serviceIdentifier
              completionHandle:(KBAPITaskCompletionHandler)completion
{
    self = [super init];
    if (self) {
        self.serviceIdentifier = serviceIdentifier;
        self.params = params;
        self.methodName = methodName;
        self.requestType = requestType;
        self.completionHandler = completion;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                   requestType:(KBAPIManagerRequestType)requestType
             serviceIdentifier:(NSString *)serviceIdentifier
              constructingBody:(KBAPITaskConstructingBody)constructingBody
              completionHandle:(KBAPITaskCompletionHandler)completion
{
    self = [self initWithParams:params methodName:methodName requestType:requestType serviceIdentifier:serviceIdentifier completionHandle:completion];
    if (self) {
        self.constructingBody = constructingBody;
    }
    return self;
}

- (instancetype)initWithResponseObject:(id)responseObject completionHandle:(KBAPITaskCompletionHandler)completion
{
    self = [super init];
    if (self) {
        self.responseObject = responseObject;
        self.completionHandler = completion;
    }
    return self;
}

- (void)start
{
    if (self.responseObject) {
        self.completionHandler ? self.completionHandler(self, self.responseObject, nil) : nil;
        return;
    }
    
    if (self.requestType == KBAPIManagerRequestTypePost) {
        self.requestId = [[KBApiProxy sharedInstance] callPostWithParams:self.params methodName:self.methodName serviceIdentifier:self.serviceIdentifier success:^(id responseObject) {
            self.completionHandler ? self.completionHandler(self, responseObject, nil) : nil;
        } failure:^(NSError *error) {
            self.completionHandler ? self.completionHandler(self, nil, error) : nil;
        }];
    } else if (self.requestType == KBAPIManagerRequestTypePostByForm) {
        self.requestId = [[KBApiProxy sharedInstance] callPostWithParams:self.params methodName:self.methodName serviceIdentifier:self.serviceIdentifier constructingBodyWithBlock:self.constructingBody success:^(id responseObject) {
            self.completionHandler ? self.completionHandler(self, responseObject, nil) : nil;
        } failure:^(NSError *error) {
            self.completionHandler ? self.completionHandler(self, nil, error) : nil;
        }];
    } else {
        NSAssert(NO, @"unsupport this type");
    }
}

- (void)stop
{
    [[KBApiProxy sharedInstance] cancelRequestWithRequestID:self.requestId];
}

@end

#pragma mark -----  KBAPIBaseManager

static dispatch_queue_t kb_manager_request_creation_queue() {
    static dispatch_queue_t kb_api_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kb_api_manager_creation_queue = dispatch_queue_create("com.kuaibao.networking.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return kb_api_manager_creation_queue;
}

@interface KBAPIBaseManager ()

@property (nonatomic, strong) NSMutableArray *requestTaskList;
@property (nonatomic, strong) KBCache *cache;

@end

@implementation KBAPIBaseManager

#pragma mark - life circle
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(KBAPIManager)]) {
            self.child = (NSObject <KBAPIManager> *)self;
        }
        
        if ([self conformsToProtocol:@protocol(KBAPIManagerValidator)]) {
            self.validator = (id<KBAPIManagerValidator>)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestTaskList = nil;
}

#pragma mark - public methods
- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
                                 success:(void (^)(KBAPIManagerTask *task ,id responseObject))success
                                 failure:(void (^)(KBAPIManagerTask *task ,id responseObject ,NSError *error))failure
{
    id result = [self cacheResultWithParams:params];
    if ([self shouldCache] && result != nil) {
        
        KBAPIManagerTask * requestTask = [[KBAPIManagerTask alloc] initWithResponseObject:result completionHandle:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeTask:task];
                
                [self.cache saveCacheWithData:responseObject
                                   identifier:self.child.serviceType
                                   methodName:self.child.methodName
                                requestParams:params];

                success ? success(task, responseObject) : nil;
            });
        }];
        
        [self addTask:requestTask];
        [requestTask start];
        
        return requestTask;
    }

    
    if (![self isReachable]) {
        NSError *error = [NSError errorWithCode:KBInstantErrorNoNetwork desc:@"无网络连接"];
        failure ? failure(nil, nil, error) : nil;
        return nil;
    }
    
    
    KBAPIManagerTask *requestTask = [[KBAPIManagerTask alloc] initWithParams:params methodName:self.child.methodName requestType:self.child.requestType serviceIdentifier:self.child.serviceType completionHandle:^(KBAPIManagerTask *task ,id responseObject, NSError *error) {
        
        [self removeTask:task];
        
        if (error || responseObject == nil) {
#if !DEBUG
            error = [NSError plainErrorWithError:error];
#endif
            failure ? failure(task ,nil, error) : nil;
            return;
        }
        
        
        KBValidator *response = [[KBValidator alloc] initWithContent:responseObject type:[self.validator validatorType]];
        if (response.error == nil) {
            if ([self.validator respondsToSelector:@selector(manager:task:callBackData:)] &&
                [self.validator manager:self task:task callBackData:response.content]) {
                response = [self.validator manager:self task:task callBackData:response.content];
            }
        }
        
        if (response.error == nil) {
            if ([self shouldCache]) {
                [self.cache saveCacheWithData:responseObject
                                   identifier:self.child.serviceType
                                   methodName:self.child.methodName
                                requestParams:params];
            }
            
            success ? success(task, responseObject) : nil;
        } else {
            failure ? failure(task, responseObject, response.error) : nil;
        }
    }];
    [self addTask:requestTask];
    [requestTask start];
    
    return requestTask;
}

- (KBAPIManagerTask *)loadDataWithParams:(NSDictionary *)params
               constructingBodyWithBlock:(void (^)(id <KBMultipartFormData> formData))block
                                 success:(void (^)(KBAPIManagerTask *task ,id responseObject))success
                                 failure:(void (^)(KBAPIManagerTask *task ,id responseObject ,NSError *error))failure
{
    id result = [self cacheResultWithParams:params];
    if ([self shouldCache] && result != nil) {
        
        KBAPIManagerTask * requestTask = [[KBAPIManagerTask alloc] initWithResponseObject:result completionHandle:^(KBAPIManagerTask *task, id responseObject, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeTask:task];
                
                [self.cache saveCacheWithData:responseObject
                                   identifier:self.child.serviceType
                                   methodName:self.child.methodName
                                requestParams:params];
                
                success ? success(task, responseObject) : nil;
            });
        }];
        
        [self addTask:requestTask];
        [requestTask start];
        
        return requestTask;
    }
    
    
    if (![self isReachable]) {
        NSError *error = [NSError errorWithCode:KBInstantErrorNoNetwork desc:@"无网络连接"];
        failure ? failure(nil, nil, error) : nil;
        return nil;
    }
    
    
    KBAPIManagerTask *requestTask = [[KBAPIManagerTask alloc] initWithParams:params methodName:self.child.methodName requestType:self.child.requestType serviceIdentifier:self.child.serviceType constructingBody:block completionHandle:^(KBAPIManagerTask *task ,id responseObject, NSError *error) {
        
        [self removeTask:task];
        
        if (error || responseObject == nil) {
#if !DEBUG
            error = [NSError plainErrorWithError:error];
#endif
            failure ? failure(task ,nil, error) : nil;
            return;
        }
        
        
        KBValidator *response = [[KBValidator alloc] initWithContent:responseObject type:[self.validator validatorType]];
        if (response.error == nil) {
            if ([self.validator respondsToSelector:@selector(manager:task:callBackData:)] &&
                [self.validator manager:self task:task callBackData:response.content]) {
                response = [self.validator manager:self task:task callBackData:response.content];
            }
        }
        
        if (response.error == nil) {
            if ([self shouldCache]) {
                [self.cache saveCacheWithData:responseObject
                                   identifier:self.child.serviceType
                                   methodName:self.child.methodName
                                requestParams:params];
            }
            
            success ? success(task, responseObject) : nil;
        } else {
            failure ? failure(task, responseObject, response.error) : nil;
        }
    }];
    [self addTask:requestTask];
    [requestTask start];
    
    return requestTask;
}


- (void)resumeTask:(KBAPIManagerTask *)task
{
    [self addTask:task];
    [task start];
}

- (void)cancelRequestWithTask:(KBAPIManagerTask *)task
{
    [task stop];
    [self removeTask:task];
}

- (void)cancelAllRequests
{
    for (KBAPIManagerTask *task in self.requestTaskList) {
        [task stop];
    }
    [self.requestTaskList removeAllObjects];
}

#pragma mark - private methods

- (void)addTask:(KBAPIManagerTask *)task
{
    if ([task isKindOfClass:[KBAPIManagerTask class]]) {
        dispatch_sync(kb_manager_request_creation_queue(), ^{
            [self.requestTaskList addObject:task];
        });
    }
}

- (void)removeTask:(KBAPIManagerTask *)task
{
    if ([self.requestTaskList containsObject:task]) {
        dispatch_sync(kb_manager_request_creation_queue(), ^{
            [self.requestTaskList removeObject:task];
        });
    }
}

- (id)cacheResultWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    id result = [self.cache fetchCachedIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    return result;
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    id result = [self.cache fetchCachedIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    if (result == nil) {
        return NO;
    }
    return YES;
}

- (BOOL)isReachable
{
    return [KBNetworkMonitorManager sharedInstance].isReachable;
}

#pragma mark - method for child
- (BOOL)shouldCache
{
    return kKBShouldCache;
}

- (KBAPIManagerRequestType)requestType
{
    NSAssert(NO, @"child must implementation protocol KBAPIManager!");
    return KBAPIManagerRequestTypePost;
}

- (NSString *)methodName
{
    NSAssert(NO, @"child must implementation protocol KBAPIManager!");
    return @"";
}

- (NSString *)serviceType
{
    NSAssert(NO, @"child must implementation protocol KBAPIManager!");
    return @"";
}

#pragma mark - method for validator
- (KBValidatorType)validatorType
{
    return KBValidatorTypeDefault;
}

#pragma mark - setter and getter
- (NSMutableArray *)requestTaskList
{
    if (_requestTaskList == nil) {
        _requestTaskList = [NSMutableArray array];
    }
    return _requestTaskList;
}

- (KBCache *)cache
{
    if (_cache == nil) {
        _cache = [KBCache sharedInstance];
    }
    return _cache;
}

@end











//
//  KBApiProxy.m
//  WeiKuaiDi
//
//  Created by 肖雄 on 15/10/19.
//  Copyright (c) 2015年 xiaoxiong. All rights reserved.
//

#import "KBApiProxy.h"
#import "KBNetworkingConfiguration.h"
#import "KBRequestParamsGenerator.h"
#import "KBService.h"
#import "KBNetworkMonitorManager.h"

@interface KBAFStreamingMultipartFormData : NSObject<KBMultipartFormData>

@property (nonatomic, strong) id<AFMultipartFormData> formData;

- (instancetype)initWithAFMultipartFormData:(id<AFMultipartFormData>)data;

@end

@implementation KBAFStreamingMultipartFormData

- (instancetype)initWithAFMultipartFormData:(id<AFMultipartFormData>)data
{
    self = [super init];
    if (self) {
        self.formData = data;
    }
    return self;
}

- (void)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    [self.formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
}

@end


@interface KBApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *manager;
@property (nonatomic, strong) KBRequestParamsGenerator *paramsGenerator;

@end

@implementation KBApiProxy

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static KBApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure
{
    NSDictionary *requestParams = [self.paramsGenerator generatePostRequestParamsWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSString *requestURL = [self.paramsGenerator generatePostRequestURLWithServiceIdentifier:serviceIdentifier methodName:methodName];
    return [self postWithParams:requestParams requestURLString:requestURL success:success failure:failure];
}

- (NSNumber *)callPostWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceIdentifier:(NSString *)serviceIdentifier constructingBodyWithBlock:(void (^)(id<KBMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestParams = [self.paramsGenerator generatePostRequestParamsWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSString *requestURL = [self.paramsGenerator generatePostRequestURLWithServiceIdentifier:serviceIdentifier methodName:methodName];
    return [self postWithParams:requestParams requestURLString:requestURL constructingBodyWithBlock:block success:success failure:failure];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *task = self.dispatchTable[requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}


#pragma mark - private methods
- (NSNumber *)postWithParams:(NSDictionary *)params
            requestURLString:(NSString *)requestURLString
                     success:(void(^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure
{
    NSNumber *requestId = [self generateRequestId];
    
    /*
    NSString *session = [NSString stringWithFormat:@"session_id=%@%@", @"s",[User currentUser].sessionID];
    [self.manager.requestSerializer setValue:session forHTTPHeaderField:@"Cookie"];
    [self.manager.requestSerializer setValue:[KBAppContext sharedInstance].appVersion forHTTPHeaderField:@"appVersion"];
    [self.manager.requestSerializer setValue:[KBAppContext sharedInstance].version forHTTPHeaderField:@"version"];
    */
    
    [_manager.requestSerializer setValue:[KBNetworkingConfiguration shareInstance].session forHTTPHeaderField:@"Cookie"];

    NSURLSessionDataTask *requestTask = [self.manager POST:requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
#if 0
        // sometimes the service return the codes of html, which can't be decoded to json.
        // turn #if 1 to check what they gived to us. 
        NSData *errorData = [[error.userInfo[@"NSUnderlyingError"] userInfo] objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *tmp = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Failure error serialised - %@",serializedData);
#endif
        
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        failure ? failure(error) : nil;
    }];
    
    [self.dispatchTable setObject:requestTask forKey:requestId];
    
    return requestId;
}

- (NSNumber *)postWithParams:(NSDictionary *)params
            requestURLString:(NSString *)requestURLString
   constructingBodyWithBlock:(void (^)(id <KBMultipartFormData> formData))block
                     success:(void(^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure
{
    NSNumber *requestId = [self generateRequestId];
    
    [_manager.requestSerializer setValue:[KBNetworkingConfiguration shareInstance].session forHTTPHeaderField:@"Cookie"];
    
    NSURLSessionDataTask *requestTask = [self.manager POST:requestURLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        KBAFStreamingMultipartFormData *_formData = [[KBAFStreamingMultipartFormData alloc] initWithAFMultipartFormData:formData];
        block(_formData);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        failure ? failure(error) : nil;
    }];
    
    
    [self.dispatchTable setObject:requestTask forKey:requestId];
    
    return requestId;
}


- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

#pragma mark - getter and setter
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/javascript", @"application/xml", @"application/json", @"image/jpeg", @"image/png", nil];
        _manager.requestSerializer.timeoutInterval = KBNetworkingTimeoutSeconds;
        KBNetworkingConfiguration *configuration = [KBNetworkingConfiguration shareInstance];
        [_manager.requestSerializer setValue:configuration.session forHTTPHeaderField:@"Cookie"];
        NSAssert(configuration.appVersion && configuration.version, @"Please configure appVersion and version");
        [_manager.requestSerializer setValue:configuration.appVersion forHTTPHeaderField:@"appVersion"];
        [_manager.requestSerializer setValue:configuration.version forHTTPHeaderField:@"version"];
    }
    return _manager;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (KBRequestParamsGenerator *)paramsGenerator
{
    if (_paramsGenerator == nil) {
        _paramsGenerator = [KBRequestParamsGenerator sharedInstance];
    }
    return _paramsGenerator;
}


@end

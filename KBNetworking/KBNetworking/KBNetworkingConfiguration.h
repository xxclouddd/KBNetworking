
//
//  KBNetworkingConfiguration.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, KBAPIManagerRequestType){
    KBAPIManagerRequestTypeGet,
    KBAPIManagerRequestTypePost,
    KBAPIManagerRequestTypePostByForm
};

static BOOL kKBShouldCache = NO;
static NSTimeInterval KBNetworkingTimeoutSeconds = 20.0f;
static NSUInteger KBCacheCountLimit = 1000;            // 最多1000条cache
static NSTimeInterval KBCacheOutdateTimeSeconds = 180; // 3分钟的cache过期时间

extern NSString * const kKBServiceV1;
extern NSString * const kKBServiceV2;
extern NSString * const kKBServiceV3;


@interface KBNetworkingConfiguration : NSObject

// env
@property (nullable, nonatomic, copy) NSString *appVersion;
@property (nullable, nonatomic, copy) NSString *version;
@property (nullable, nonatomic, copy) NSString *deviceNo;
@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *uuid;

@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *session;
@property (nullable, nonatomic, copy) NSString *brand;
@property (nullable, nonatomic, copy) NSString *cmCode;
@property (nullable, nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;
@property (nullable, nonatomic, copy) NSDictionary *mainInfoDictionary;
@property (nullable, nonatomic, copy) NSString *vendorID;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

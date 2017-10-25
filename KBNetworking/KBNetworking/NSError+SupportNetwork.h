//
//  NSError+SupportNetwork.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const KBKuaiDiYuanDomain = @"kuaidiyuan";

typedef NS_ENUM(NSInteger, KBInstantError) {
    KBInstantErrorDefaultValue = -1000000,
    
    // network status
    KBInstantErrorNoNetwork,
    KBInstantErrorTimeout,
    
    // response
    KBInstantErrorUnexpectedResponse,
    KBInstantErrorSessionInvalid,
    
    // scan to e3
    KBInstantErrorWithWrongOrder,
    KBInstantErrorWithInterceptOrder,
    KBInstantErrorNotAllSuccessedUpload,
    KBInstantErrorIntercept,

    // modify timing send
    KBInstantErrorRecharge,
    
    // e3 upload or save
    KBInstantErrorE3UploadOrSaveHaveRepeatOrder,
    KBInstantErrorE3UploadOrSaveHaveSignedOrder,
    KBInstantErrorE3UploadOrSaveHaveNoOrder,
    KBInstantErrorE3UploadOrSaveHaveCOD,
    
    // inform_bydh send2
    KBInstantErrorInformBYDHSend2InsufficientCost,
    
    // scan sign
    KBInstantErrorScanSignQRInvalidate,
    
    // bar gun
    KBInstantErrorGunVerifyNeedLogin,
    KBInstantErrorGunVerifyDepleteParameter,
    KBInstantErrorGunVerifyFailed,
};


@interface NSError (SupportNetwork)

+ (instancetype)errorDesc:(nullable NSString *)desc;
+ (instancetype)errorWithCode:(NSInteger)code desc:(nullable NSString *)desc;
+ (instancetype)plainErrorWithError:(NSError *)error;

@end
NS_ASSUME_NONNULL_END

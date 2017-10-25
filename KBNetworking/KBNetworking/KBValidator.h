//
//  KBValidator.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SessionInvalidSituation(code) \
    (code == 1103 || code == 5 || code == 6 || code == 401 || code == 1011)

#define GeneralValidator(DATA, BOOLVALUE) \
    if (![DATA isKindOfClass:[NSDictionary class]]) { \
        return [[KBValidator alloc] initWithContent:DATA    \
               error:[NSError errorWithCode:KBInstantErrorUnexpectedResponse desc:@"未知错误"]];\
    } \
  \
    NSInteger code = [[NSString stringWithFormat:@"%@", [DATA objectForKey:@"code"]] integerValue];  \
    if (code == 0 && BOOLVALUE) {   \
       return [[KBValidator alloc] initWithContent:DATA error:nil];\
    }   \
  \
    NSString *errMsg = [data objectForKey:@"msg"];  \
    if (SessionInvalidSituation(code)) {              \
      return [[KBValidator alloc] initWithContent:DATA     \
             error:[NSError errorWithCode:KBInstantErrorSessionInvalid desc:errMsg]]; \
    }


static inline BOOL KBRspSuccess(NSObject *obj)
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj isEqualToString:@"1"] || [(NSString *)obj isEqualToString:@"true"];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj integerValue] == 1;
    } else {
        return NO;
    }
}

typedef NS_ENUM(NSInteger, KBValidatorType) {
    KBValidatorTypeDefault,
    KBValidatorTypeValue1,
    KBValidatorTypeValue2
};

@interface KBValidator : NSObject

@property (nonatomic, copy, readonly) NSError *error;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) KBValidatorType validatorType;

- (instancetype)initWithContent:(id)content type:(KBValidatorType)type;
- (instancetype)initWithContent:(id)content error:(NSError *)error;

@end

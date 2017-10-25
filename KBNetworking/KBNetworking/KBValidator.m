

//
//  KBValidator.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/11/16.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "KBValidator.h"
#import "KBNetworkingConfiguration.h"
#import "NSError+SupportNetwork.h"

@interface KBValidator ()

@property (nonatomic, copy, readwrite) NSError *error;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, assign, readwrite) KBValidatorType validatorType;

@end


#pragma mark - Private Class pValidateResponseV1

@interface pValidateValue1 : KBValidator

@end
@implementation pValidateValue1
- (instancetype)initWithContent:(id)content
{
    self = [super init];
    if (self) {
        self.content = content;
        self.validatorType = KBValidatorTypeValue1;
    }
    return self;
}

#pragma mark - setter and getter
- (void)setContent:(id)content
{
    super.content = content;
    
    if (![content isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithCode:KBInstantErrorUnexpectedResponse desc:@"未知错误"];
        return;
    }
    
    NSDictionary *response = [content objectForKey:@"response"];
    if (![response isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithCode:KBInstantErrorUnexpectedResponse desc:@"未知错误"];
        return;
    }

    NSDictionary *header = [response objectForKey:@"header"];
    if (![header isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithCode:KBInstantErrorUnexpectedResponse desc:@"未知错误"];
        return;
    }
    
    NSString *status = [header objectForKey:@"status"];
    if (![status isEqualToString:@"success"]) {
        NSString *desc = [header objectForKey:@"desc"];
        self.error = [NSError errorDesc:desc];
        return;
    }
}

@end


#pragma mark - Private Class pValidateResponseV2

@interface pValidateValue2 : KBValidator

@end
@implementation pValidateValue2
- (instancetype)initWithContent:(id)content
{
    self = [super init];
    if (self) {
        self.content = content;
        self.validatorType = KBValidatorTypeValue2;
    }
    return self;
}

#pragma mark - setter and getter
- (void)setContent:(id)content
{
    super.content = content;
    
    if (![content isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithCode:KBInstantErrorUnexpectedResponse desc:@"未知错误"];
        return;
    }
    
    NSString *code = [NSString stringWithFormat:@"%@", [content objectForKey:@"code"]];
    if ([code isEqualToString:@"0"]) {
        return;
    }
    
    NSString *desc = [content objectForKey:@"msg"];
    if (![desc isKindOfClass:[NSString class]]) {
        desc = @"";
    }
    
    if (SessionInvalidSituation([code integerValue])) {
        self.error = [NSError errorWithCode:KBInstantErrorSessionInvalid desc:desc];
    } else {
        self.error = [NSError errorDesc:desc];
    }
}

@end


#pragma mark - Public Class KBValidatorValue1
@interface pValidateDefault : KBValidator

@end

@implementation pValidateDefault
- (instancetype)initWithContent:(id)content
{
    self = [super init];
    if (self) {
        self.content = content;
        self.error = nil;
    }
    return self;
}

@end


#pragma mark - Public Class KBValidator

@implementation KBValidator

- (instancetype)initWithContent:(id)content type:(KBValidatorType)type
{
    if (type == KBValidatorTypeValue1) {
        return [[pValidateValue1 alloc] initWithContent:content];
    } else if (type == KBValidatorTypeValue2) {
        return [[pValidateValue2 alloc] initWithContent:content];
    } else if (type == KBValidatorTypeDefault) {
        return [[pValidateDefault alloc] initWithContent:content];
    } else {
        NSAssert(NO, @"Unknow validator type!");
        return nil;
    }
}

- (instancetype)initWithContent:(id)content error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.content = content;
        self.error = error;
    }
    return self;
}


@end

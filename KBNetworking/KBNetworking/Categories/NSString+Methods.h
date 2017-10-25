//
//  NSString+Methods.h
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kInitVector;
extern NSString *const kAESKey;

@interface NSString (Methods)

+ (instancetype)md5:(NSString *)input;

+ (instancetype)jsonStringWithObject:(id)obj;

+ (instancetype)timestampStringSince1970;

+ (instancetype)stringSignatureWithParams:(NSDictionary *)params;

+ (instancetype)serializationParams:(NSDictionary *)params;

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key; // AES加密

@end

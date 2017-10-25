

//
//  NSString+Methods.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 15/10/19.
//  Copyright © 2015年 KuaidiHelp. All rights reserved.
//

#import "NSString+Methods.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NSString *const kInitVector = @"";
NSString *const kAESKey = @"";

size_t const kKeySize = kCCKeySizeAES128;

@implementation NSString (Methods)

+ (instancetype)jsonStringWithObject:(id)obj
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (instancetype) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (instancetype)timestampStringSince1970
{
    double recordTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",recordTime];
}

+ (instancetype)stringSignatureWithParams:(NSDictionary *)params
{
    NSMutableArray *tranformedParams = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if ([obj length] > 0) {
            [tranformedParams addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    
    NSArray *sortedParams = [tranformedParams sortedArrayUsingSelector:@selector(compare:)];
    
    //字母排序之后形成的参数字符串
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}

+ (instancetype)serializationParams:(NSDictionary *)params
{
    //sort
    NSArray *arr = [params allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSString *str = @"";
    for (NSString * tempStr in arr) {
        id value = [params objectForKey:tempStr];
        if ([value isKindOfClass:[NSArray class]]){
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,", @""]];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,", @""]];
        }else{
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",value]];
        }
    }
    
    return str;
}
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}


@end

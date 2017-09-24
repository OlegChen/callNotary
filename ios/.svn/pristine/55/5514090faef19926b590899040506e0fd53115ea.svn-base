//
//  NSData+Encryption.h
//  AESTest
//
//  Created by 肖 喆 on 13-4-23.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString *)base64encode:(NSString*)str;           //同上64编码

- (NSData *)AES128EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSData *)key;   //解密
//NSString 转成16进制NSData
+ (NSData *)stringToByte:(NSString*)string;
@end


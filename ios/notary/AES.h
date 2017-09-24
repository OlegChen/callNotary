//
//  AES.h
//  notary
//
//  Created by 肖 喆 on 13-4-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@protocol AESDelegate;

@interface AES : NSObject
{
    id <AESDelegate> _delegate;
    NSString * _uid;         //用户id
    NSString * _secretKey;
    NSString * _fid;         //文件id  即服务器id
    NSString * _extendName;  //文件扩展名
    NSString * _fPath;
}

@property id <AESDelegate> delegate;

- (id)initWithId:(NSString *)uid secretKey:(NSString *)secretKey fid:(NSString *)fid extendName:(NSString *)extendName fPath:(NSString *)fPath;

//解密
- (void)decrypt;

//是否已经存在解密后的文件
- (BOOL)isDecrypted;

@end


@protocol AESDelegate <NSObject>

//解密成功
- (void)notificationDecryptSuccess:(AES *)aes;

//解密失败
- (void)notificationDecryptError:(AES *)aes;

@end
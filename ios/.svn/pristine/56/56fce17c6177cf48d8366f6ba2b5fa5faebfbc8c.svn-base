//
//  AES.m
//  notary
//
//  Created by 肖 喆 on 13-4-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "AES.h"
#import "NSData+Encryption.h"
#import "NSData+Extension.h"

@implementation AES
- (id)initWithId:(NSString *)uid secretKey:(NSString *)secretKey fid:(NSString *)fid extendName:(NSString *)extendName fPath:(NSString *)fPath
{
    if (self = [super init]) {
        
        _uid = uid;
        _secretKey = secretKey;
        _fid = fid;
        _extendName = extendName;
        _fPath = fPath;
    }
    return self;
}
- (void)decrypt
{
    NSString * key = [NSString stringWithFormat:@"%@%@%@%@",_secretKey,_uid,_fid,_extendName];
    NSString * logstr = [NSString stringWithFormat:@"解密key %@",key];
    debugLog(logstr);
    
    NSData * keyData = [[key dataUsingEncoding:NSUTF8StringEncoding]MD5];
    NSString * tagertPath = [NSString stringWithFormat:@"%@.enr",_fPath];
    
    NSData * cryptData = [[NSData alloc] initWithContentsOfFile:tagertPath];
    NSData * tmp = [cryptData AES128DecryptWithKey:keyData];
    
    if (tmp == nil) {
        
        NSString * logerror = [NSString stringWithFormat:@"解密失败 %@",tagertPath];
        debugLog(logerror);
        
        if (_delegate){
            [_delegate notificationDecryptError:self];
        }
        
    }else {
        
        [tmp writeToFile:_fPath atomically:YES];
        
        if (_delegate){
            [_delegate notificationDecryptSuccess:self];
        }
        
        //删除加密文件
        [self removeFile];
        /*
        //更新数据库状态 是否解密成功  现在不加
        [self updateEncryptStatus:_fid];
        */
    }
}
- (BOOL)isDecrypted
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:_fPath]){
        return YES;
    }
    return NO;
}
- (void)removeFile
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * tagerFilePath = [NSString stringWithFormat:@"%@.enr",_fPath];
    NSError * error = nil;
    
    if ([manager fileExistsAtPath:tagerFilePath]) {
        
        [manager removeItemAtPath:tagerFilePath error:&error];
        
    }
    
    if (error) {
        
        NSString * logstr = [NSString stringWithFormat:@"删除加密文件错误 %@\r\n %@",error,tagerFilePath];
        debugLog(logstr);
    }
    
}

- (void)updateEncryptStatus:(NSString *)serverId
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    
    //isEncrypt  0 为解密失败  1为解密成功
    NSString * sql = @"update FileModel set isEncrypt = ? where serverFIleId = ? and uid = ?";
    
    NSArray * pars = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],serverId,user.uid,nil];
    
    NSString * logstr = [NSString stringWithFormat:@"update FileModel set isEncrypt = 1 where serverFIleId = %@ and uid = %@",serverId,user.uid];
    debugLog(logstr);
    
    [db update:sql parameter:pars];
    
    [db close];
    
}
@end

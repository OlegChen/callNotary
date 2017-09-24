//
//  Config.h
//  notary
//
//  Created by 肖 喆 on 13-3-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

//是否已经登录
@property BOOL isLogin;
//是否具备网络连接
@property BOOL isNetworkRunning;

//保存登录用户名以及密码
-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
-(NSString *)getUserName;
-(NSString *)getPwd;
-(void)saveUID:(int)uid;
-(int)getUID;

+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;

//配置默认选项
+(void)setDefaultHandler;

@end

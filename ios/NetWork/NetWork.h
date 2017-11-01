//
//  NetWork.h
//  notary
//
//  Created by Chen on 2017/10/30.
//  Copyright © 2017年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"


//宏定义成功block 回调成功后得到的信息
typedef void (^HttpSuccess)(id data);
//宏定义失败block 回调失败信息
typedef void (^HttpFailure)(NSError *error);

@interface NetWork : NSObject

//get请求
+(void)getWithUrlString:(NSString *)urlString success:(HttpSuccess)success failure:(HttpFailure)failure;


//post请求
+(void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end


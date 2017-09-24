//
//  Tool.h
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

//获得系统通知
+ (OSCNotice *)getOSCNotice:(ASIHTTPRequest *)request;

+ (OSCNotice *)getOSCNotice2:(NSString *)response;

@end

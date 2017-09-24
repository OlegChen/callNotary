//
//  Tool.m
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Tool.h"

@implementation Tool


+ (OSCNotice *)getOSCNotice:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    return [Tool getOSCNotice2:response];
}

+ (OSCNotice *)getOSCNotice2:(NSString *)response
{
    OSCNotice * oc = nil;
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeUpdate object:oc];
    
    return oc;
}

@end

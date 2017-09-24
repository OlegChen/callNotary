//
//  NetWorkListener.m
//  fengyz
//
//  Created by 刘天源 on 12-11-30.
//  Copyright (c) 2012年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "NetWorkListener.h"
#import "Reachability.h"

@implementation NetWorkListener
@synthesize delegate = _delegate,reachability = _reachability;

- (void)dealloc {
    [self stopListener];
    [_reachability release],_reachability = nil;
    [super dealloc];
}

- (id)init {
    
    if (self = [super init]) {
        //开启网络状况的监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        self.reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
        [_reachability startNotifier];  //启动网络变动监听
    }
    return self;
}
//判断是否有网络链接
+(BOOL)isNetWork
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    if ([reach currentReachabilityStatus] == NotReachable) {
        return NO;
    }else{
        return YES;
    }
}
//判断并返回网络类型
+(NSString *)NetWorkType
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.goole.com"];
    switch ([reachability currentReachabilityStatus]) {
            
        case NotReachable:       //无网络连接
            return @"没有网络";
            break;
        case ReachableViaWWAN:   //使用3G网络
            return @"3G网络可用";
            break;
        case ReachableViaWiFi:   //使用WIFI
            return @"WIFI可用";
            break;
        default:
            break;
    }
}
//通知中心监听到网络变动时调用 而且每次变动会被调用多次
- (void) reachabilityChanged:(NSNotification* )notification {
    Reachability* reach = [notification object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);  //判断notification 类型是否是Reachability
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {           //网络状态为断开
        
        [_delegate netConnectionInterrupt];
        
    }else if(status == ReachableViaWWAN) {  //网络联通恢复
        
        [_delegate netConnectionRecover];
        
    }else if (status == ReachableViaWiFi) {
        
        [_delegate netConnectionRecover];
    }
}
- (void)stopListener {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [_reachability stopNotifier];
}
@end

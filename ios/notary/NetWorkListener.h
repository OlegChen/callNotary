//
//  NetWorkListener.h
//  fengyz
//
//  Created by 刘天源 on 12-11-30.
//  Copyright (c) 2012年 风雨者科技（北京）有限公司. All rights reserved.
//  这个类是用来判断网络的

#import <Foundation/Foundation.h>
//#import <SystemConfiguration/SystemConfiguration.h>
@protocol NetWorkListenerDelegate;
@class Reachability;

@interface NetWorkListener : NSObject {
    
    id <NetWorkListenerDelegate> _delegate;
    Reachability* _reachability;
}

@property(nonatomic,assign) id <NetWorkListenerDelegate> delegate;
@property(nonatomic,retain) Reachability* reachability;

//如果网络连接不可用 返回NO
+ (BOOL)isNetWork;
//如果网络可连接，获取网络连接类型，返回字符串
+ (NSString *)NetWorkType;

//停止监听
- (void)stopListener;

@end

@protocol NetWorkListenerDelegate <NSObject>

//网络中断通知
- (void)netConnectionInterrupt;
//网络连接恢复
- (void)netConnectionRecover;

@end
//
//  Sandbox.h
//  notary
//
//  Created by 肖 喆 on 13-4-9.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sandbox : NSObject

+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)resourcePath; //

+ (NSString *)videoPath;     //存储视频路径
+ (NSString *)imagePath;     //存储图片路径
+ (NSString *)voicePath;     //音频存储路径
+ (NSString *)otherFilePath; //ios原生不支持打开的文件路径
+ (NSString *)storePath;     //数据库路径
+ (NSString *)crashLog;      //log存储路径
+ (NSString *)thumbnail;     //缩略图路径

+ (NSString *)uploadTempPath;  //上传使用临时文件目录

+ (NSString *)touch:(NSString *)path;

@end

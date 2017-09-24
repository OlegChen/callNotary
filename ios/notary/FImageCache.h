//
//  FImageCache.h
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FImageCache : NSObject

{
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}

+ (FImageCache *)sharedImageCache;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image imageData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (UIImage *)imageFromKey:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;
//- (void)queryDiskCacheForKey:(NSString *)key delegate:(id <SDImageCacheDelegate>)delegate userInfo:(NSDictionary *)info;

- (void)removeImageForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;

@end

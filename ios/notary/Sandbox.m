//
//  Sandbox.m
//  notary
//
//  Created by 肖 喆 on 13-4-9.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Sandbox.h"

@implementation Sandbox

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)touch:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:path
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
	return path;
}
+ (NSString *)resourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}
+(NSString *)videoPath
{
    return [[self libCachePath] stringByAppendingPathComponent:@"Videos"];
}
+(NSString *)imagePath
{
    return [[self libCachePath] stringByAppendingPathComponent:@"Images"];
}
+ (NSString *)voicePath
{
    return [[self libCachePath] stringByAppendingPathComponent:@"Voices"];
}
+ (NSString *)otherFilePath
{
    return [[self libCachePath] stringByAppendingPathComponent:@"Other"];
}
+ (NSString *)thumbnail
{
    return [[self libCachePath] stringByAppendingPathComponent:@"Thumbnails"];
}
+ (NSString *)crashLog
{
    return [[self libCachePath]
            stringByAppendingPathComponent:@"crashlog.txt"];
}
+(NSString *)storePath
{
    return [[self libCachePath] stringByAppendingPathComponent:DATABASE];
}
+ (NSString *)uploadTempPath
{
        return [[self libCachePath] stringByAppendingPathComponent:@"uploadtemp"];
}
@end

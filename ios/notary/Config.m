//
//  Config.m
//  notary
//
//  Created by 肖 喆 on 13-3-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config * instance = nil;
+(Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
+(void)setDefaultHandler
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * videoPath =  [Sandbox videoPath];
    if ( NO == [manager fileExistsAtPath:videoPath]) {
        [manager createDirectoryAtPath:videoPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * imagePath = [Sandbox imagePath];
    if ( NO == [manager fileExistsAtPath:imagePath]) {
        [manager createDirectoryAtPath:imagePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * voicePath = [Sandbox voicePath];
    if ( NO == [manager fileExistsAtPath:voicePath]) {
        [manager createDirectoryAtPath:voicePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * otherFilePath = [Sandbox otherFilePath];
    if ( NO == [manager fileExistsAtPath:otherFilePath]) {
        [manager createDirectoryAtPath:otherFilePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * thumbnailPath = [Sandbox thumbnail];
    if ( NO == [manager fileExistsAtPath:thumbnailPath]) {
        [manager createDirectoryAtPath:thumbnailPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * uploadtempPath = [Sandbox uploadTempPath];
    if ( NO == [manager fileExistsAtPath:uploadtempPath]) {
        [manager createDirectoryAtPath:uploadtempPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSString * databasePath = [Sandbox storePath];
    if ( NO == [manager fileExistsAtPath:databasePath]) {
        
        NSString * appPath = [[Sandbox resourcePath]stringByAppendingPathComponent:DATABASE];
        NSData * mainBundleFile = [NSData dataWithContentsOfFile:appPath];
        [manager createFileAtPath:databasePath contents:mainBundleFile attributes:nil];

    }
    
   

    
}
-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings setObject:userName forKey:@"UserName"];
    
    [settings setObject:pwd forKey:@"Password"];
    [settings synchronize];

}

-(NSString *)getUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UserName"];
}
-(NSString *)getPwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * temp = [settings objectForKey:@"Password"];
    return temp;
}
@end

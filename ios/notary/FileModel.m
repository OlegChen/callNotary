//
//  FileModel.m
//  notary
//
//  Created by 肖 喆 on 13-3-27.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (NSString *)description {
    
    if (_type == kVideoFile) {
        
        return [NSString stringWithFormat:@"video,%@",[_path absoluteString]];
        
    }else {
        return [NSString stringWithFormat:@"photo,%@",_name];
    }
    
}
+(FileType)getFileType:(NSString *)name
{
    FileType type = kOtherFile; //默认是ios 原生不能打开的文件类型
    
    //转换成小写
    NSString * lowercaseName = [name lowercaseString];
    
    //判断图片类型
    if([lowercaseName hasSuffix:@".png"]) {
        return kPhotoFile;
    }
    else if ([lowercaseName hasSuffix:@".jpeg"])
    {
        return kPhotoFile;
    }
    else if ([lowercaseName hasSuffix:@".jpg"])
    {
        return kPhotoFile;
    }
    //判断音频类型
    else if ([lowercaseName hasSuffix:@".wav"])
    {
        return kVoiceFile;
    }
    else if ([lowercaseName hasSuffix:@".mp3"])
    {
        return kVoiceFile;
    }
    //判断视频格式
    else if ([lowercaseName hasSuffix:@".mov"])
    {
       return  kVideoFile;
    }
    else if ([lowercaseName hasSuffix:@".mp4"])
    {
        return  kVideoFile;
    }
    else if ([lowercaseName hasSuffix:@".3gp"])
    {
        return  kVideoFile;
    }
    
    return type;
}
+ (NSString *)getExtendName:(NSString *)name
{
    NSString * lowercaseName = [name lowercaseString];
    NSString * extendName = nil;
       
    NSRange range =  [lowercaseName rangeOfString:@"." options:NSBackwardsSearch];
    
    if (range.length > 0) {
        
        extendName = [lowercaseName substringFromIndex:NSMaxRange(range)];
        
    }else {
        NSLog(@"文件没有扩展名称,解密会失败");
    }

    
    NSString * log = [NSString stringWithFormat:@"文件扩展名为:%@",extendName];
    debugLog(log);
    
    return extendName;
}
@end

//
//  NSString+Extension.m
//  notary
//
//  Created by 肖 喆 on 13-4-9.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSData+Extension.h"

@implementation NSString (Extension)

- (NSString *)MD5
{
	NSData * value;
	
	value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
	value = [value MD5];
    
	if ( value )
	{
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i )
		{
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return [result lowercaseString];
	}
	else
	{
		return nil;
	}
}

+ (NSMutableArray *)splite:(NSString *)str separator:(NSString *)separator
{
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    NSString * temp = str;
    
    
    while (true) {
        
        NSInteger index = [temp rangeOfString:separator].location;
        
        if (index < temp.length) {
            
            NSString * s = [temp substringToIndex:index];
            [array addObject:s];
            temp = [temp substringFromIndex:index + 1];
            
            
        }else {
            
            [array addObject:temp];
            
            break;
            
        }
    }
    
    return array;
}

+ (NSString *)getFileKBNumber:(NSString *)value
{
    double tmp = [value doubleValue];
    
    tmp = tmp/1024;
    
    return [NSString stringWithFormat:@"%0.2f",tmp];
}
+ (NSString *)getFileMBNumber:(NSString *)value
{
    double tmp = [value doubleValue];
    
    tmp = tmp/(1024*1024);
    
    return [NSString stringWithFormat:@"%0.2f",tmp];
}
+ (NSString *)getAutoKBorMBNumber:(NSString *)value
{
    NSString * tmp = [NSString getFileKBNumber:value];
    
    if (1024 < [tmp intValue]) {
        
        return [NSString stringWithFormat:@"%@M",[NSString getFileMBNumber:value]];
    }
    
    return [NSString stringWithFormat:@"%@kb",[NSString getFileKBNumber:value]];
}
+ (BOOL)isIncludeSpecialCharact: (NSString *)str
{
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€%,.?。，！!:：😄"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
+ (NSString *)trimeExtendName:(NSString *)name;
{
    
    NSString * result = nil;
    
    if ([name hasSuffix:@".mov"]){
        
        result = [name stringByReplacingOccurrencesOfString:@".mov" withString:@""];
    }
    else if ([name hasSuffix:@".png"]){
        result = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    }
    else if ([name hasSuffix:@".wav"]){
        result = [name stringByReplacingOccurrencesOfString:@".wav" withString:@""];
    }
    else if ([name hasSuffix:@".jpeg"]){
        result = [name stringByReplacingOccurrencesOfString:@".jpeg" withString:@""];
    }
    else if ([name hasSuffix:@".jpg"]){
        result = [name stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    }
    else if ([name hasSuffix:@".doc"]){
        result = [name stringByReplacingOccurrencesOfString:@".doc" withString:@""];
    }

    return result;
    
    
}
+ (NSString *)trimeExtendName:(NSString *)name unique:(NSString *)unique
{
    NSString * result = nil;
    
    //视频
    if ([name hasSuffix:@".mov"]){
        
        result = [name stringByReplacingOccurrencesOfString:@".mov" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.mov",result,unique];
    }
    else if ([name hasSuffix:@".mp4"])
    {
        result = [name stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.mp4",result,unique];
    }
    else if ([name hasSuffix:@".3gp"])
    {
        result = [name stringByReplacingOccurrencesOfString:@".3gp" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.3gp",result,unique];
    }
    //图片
    else if ([name hasSuffix:@".png"]){
        result = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.png",result,unique];
    }
    else if ([name hasSuffix:@".jpeg"]){
        result = [name stringByReplacingOccurrencesOfString:@".jpeg" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.jpeg",result,unique];
    }
    else if ([name hasSuffix:@".jpg"]){
        result = [name stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.jpg",result,unique];
    }
    //音频
    else if ([name hasSuffix:@".wav"]){
        result = [name stringByReplacingOccurrencesOfString:@".wav" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.wav",result,unique];
    }
    else if ([name hasSuffix:@".mp3"]){
        result = [name stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.mp3",result,unique];
    }
    //文件
    else if ([name hasSuffix:@".doc"]){
        result = [name stringByReplacingOccurrencesOfString:@".doc" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.doc",result,unique];
    }
    else if ([name hasSuffix:@".pdf"]){
        result = [name stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.pdf",result,unique];
    }
    else if ([name hasSuffix:@".txt"]){
        result = [name stringByReplacingOccurrencesOfString:@".txt" withString:@""];
        result = [NSString stringWithFormat:@"%@%@.txt",result,unique];
    }

    return result;
}
@end

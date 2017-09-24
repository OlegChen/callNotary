//
//  MD5Util.m
//  fengyz
//
//  Created by 肖 喆 on 13-1-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "URLUtil.h"
#import "CommonCrypto/CommonDigest.h" 

@implementation URLUtil

+ (NSString *)md5:(NSString *)str
{
    const char *cStr=[str cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+(NSString *)generateNormalizedString:(NSDictionary *)params
{
    NSArray * allKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * s1 = (NSString *)obj1;
        NSString * s2 = (NSString *)obj2;
        NSComparisonResult result = [s1 compare:s2];
        
        return result == NSOrderedDescending; // 升序
        //        return result == NSOrderedAscending;  // 降序

    }];
    NSMutableString * sb = [[NSMutableString alloc] init];
    for (NSString * key in allKeys) {
        
        if (![URLUtil needEncryptedForSig:key]) {
            continue;
        }
        NSString * value = [params objectForKey:key];
        [sb appendFormat:@"%@%@%@",key,@"=",value];
    }
    return sb;
}
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (BOOL)needEncryptedForSig:(NSString *)key
{
    NSArray * keys = [NSArray arrayWithObjects:@"sig", nil];
    
    for (NSString * value in keys) {
        
        if ([value isEqualToString:key]) {
            return false;
        }
    }
    return true;
}
+(NSMutableDictionary *)publicDataDictionary
{
    NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
    [temp setObject:APP_ID forKey:@"app_id"];
    [temp setObject:VERSIONS forKey:@"v"];
    [temp setObject:@"1" forKey:@"src"];
    return temp;
}

/*
 NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
 [dic setObject:VERSIONS forKey:@"v"];
 [dic setObject:APP_ID forKey:@"app_id"];
 [dic setObject:@"byscenic_id" forKey:@"method"];
 [dic setObject:_scene.sid forKey:@"scenic_id"];
 
 
 NSString * result =  [URLUtil generateNormalizedString:dic];
 NSLog(@"result gen is %@",result);
 NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
 NSLog(@"return sig was  %@",sig);
 
 NSString * value = [NSString stringWithFormat:@"%@%@?method=%@&%@&app_id=%@&v=%@&scenic_id=%@",ROOT_URL,SCENCE_DETAIL_URL,@"byscenic_id",[NSString stringWithFormat:@"sig=%@",sig ],APP_ID,VERSIONS,_scene.sid];
 
 NSLog(@"Get request url is %@",value);
 
 NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:value]];
 
 _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
 [_connection start];
*/

@end

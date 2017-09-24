//
//  PublicStatistics.m
//  notary
//
//  Created by 肖 喆 on 13-8-21.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "PublicStatistics.h"
#import "OpenUDID.h"
//appchina\appsino\gfan\hiapk\mumayi\nduoa

//#define Appsino @"appsino"

#define Appchina @"appchina"


@implementation PublicStatistics

//初次启动
- (void)firstStartApplication
{
    NSString * udid = [OpenUDID value];//[UIDevice currentDevice].uniqueIdentifier;
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:udid forKey:@"deviceId"];
    [dic setObject:Appsino forKey:@"qudao"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:APP_ID forKey:@"app_id"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"初次启动:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"初次启动:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",TONGJI_ROOT_URL,FIRSTAPPLICATION];
    NSURL * url = [NSURL URLWithString:urls];
    
    self.request4FirstStartApplication = [[ASIFormDataRequest alloc]initWithURL:url];
#if 1
    [self.request4FirstStartApplication setPostValue:udid forKey:@"deviceId"];
    [self.request4FirstStartApplication setPostValue:Appsino forKey:@"qudao"];
#else
    [self.request4FirstStartApplication setPostValue:APP_ID forKey:@"app_id"];
    [self.request4FirstStartApplication setPostValue:VERSIONS forKey:@"v"];
    [self.request4FirstStartApplication setPostValue:@"1" forKey:@"src"];
#endif
    [self.request4FirstStartApplication setPostValue:sig forKey:@"sig"];
    
    [self.request4FirstStartApplication setDelegate:self];
    [self.request4FirstStartApplication setDidStartSelector:@selector(requestStarted:)];
    [self.request4FirstStartApplication setDidFailSelector:@selector(requestFailed:)];
    [self.request4FirstStartApplication setDidFinishSelector:@selector(requestFinished:)];
    [self.request4FirstStartApplication setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [self.request4FirstStartApplication startAsynchronous];
}

//启动次数
- (void)startNumber
{
    
    NSString * udid = [OpenUDID value];//[UIDevice currentDevice].uniqueIdentifier;
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:udid forKey:@"deviceId"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:Appsino forKey:@"qudao"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:APP_ID forKey:@"app_id"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"启动次数:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"启动次数:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",TONGJI_ROOT_URL,STARTNUMBER];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"%@%@?deviceId=%@&mobileNo=%@&qudao=%@&v=%@&src=%@&app_id=%@&sig=%@",TONGJI_ROOT_URL,STARTNUMBER,udid,user.phoneNumber,Appsino,VERSIONS,@"1",APP_ID,sig];
    
    
    self.request4StartNumber = [[ASIFormDataRequest alloc]initWithURL:url];

    [self.request4StartNumber setPostValue:udid forKey:@"deviceId"];
    [self.request4StartNumber setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [self.request4StartNumber setPostValue:Appsino forKey:@"qudao"];
    [self.request4StartNumber setPostValue:APP_ID forKey:@"app_id"];
    [self.request4StartNumber setPostValue:VERSIONS forKey:@"v"];
    [self.request4StartNumber setPostValue:@"1" forKey:@"src"];
    [self.request4StartNumber setPostValue:sig forKey:@"sig"];
    
    [self.request4StartNumber setDelegate:self];
    [self.request4StartNumber setDidStartSelector:@selector(requestStarted:)];
    [self.request4StartNumber setDidFailSelector:@selector(requestFailed:)];
    [self.request4StartNumber setDidFinishSelector:@selector(requestFinished:)];
    [self.request4StartNumber setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [self.request4StartNumber startAsynchronous];
    
}

//单次使用时长
- (void)useTime:(double)time
{
    int sec = (int)time;
    
    NSString * udid = [OpenUDID value];//[UIDevice currentDevice].uniqueIdentifier;
    
    UserModel * user = [UserModel sharedInstance];
    
    NSString * phone = @"";
    if (nil != user.phoneNumber) {
        phone = user.phoneNumber;
    }
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:udid forKey:@"deviceId"];
    [dic setObject:phone forKey:@"mobileNo"];
    [dic setObject:Appsino forKey:@"qudao"];
    [dic setObject:[NSString stringWithFormat:@"%d",sec] forKey:@"time"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:APP_ID forKey:@"app_id"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"单次使用时间:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"单次使用时间:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",TONGJI_ROOT_URL,USETIME];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"%@%@?deviceId=%@&mobileNo=%@&qudao=%@&v=%@&src=%@&app_id=%@&sig=%@&time=%@",TONGJI_ROOT_URL,USETIME,udid,user.phoneNumber,Appsino,VERSIONS,@"1",APP_ID,sig,[NSString stringWithFormat:@"%d",sec]];
    
    debugLog(@"单次使用时长url %@",logurl);
    
    self.request4UseTime = [[ASIFormDataRequest alloc]initWithURL:url];
    
    [self.request4UseTime setPostValue:udid forKey:@"deviceId"];
    [self.request4UseTime setPostValue:phone forKey:@"mobileNo"];
    [self.request4UseTime setPostValue:Appsino forKey:@"qudao"];
    [self.request4UseTime setPostValue:[NSString stringWithFormat:@"%d",sec] forKey:@"time"];
    [self.request4UseTime setPostValue:APP_ID forKey:@"app_id"];
    [self.request4UseTime setPostValue:VERSIONS forKey:@"v"];
    [self.request4UseTime setPostValue:@"1" forKey:@"src"];
    [self.request4UseTime setPostValue:sig forKey:@"sig"];
    
    [self.request4UseTime setDelegate:self];
    [self.request4UseTime setDidStartSelector:@selector(requestStarted:)];
    [self.request4UseTime setDidFailSelector:@selector(requestFailed:)];
    [self.request4UseTime setDidFinishSelector:@selector(requestFinished:)];
    [self.request4UseTime setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [self.request4UseTime startAsynchronous];

}

- (void)cancel
{
    if (self.request4FirstStartApplication != nil){
        [self.request4FirstStartApplication cancel];
        self.request4FirstStartApplication = nil;
    }
    
    if (self.request4StartNumber != nil){
        [self.request4StartNumber cancel];
        self.request4StartNumber = nil;
    }
    if (self.request4UseTime != nil){
        [self.request4UseTime cancel];
        self.request4UseTime = nil;
    }
}

#pragma ASIHTTPRequest
- (void)requestStarted:(ASIHTTPRequest *)request
{
        logmessage;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
        logmessage;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
        logmessage;
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    logmessage;
    
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
    
    NSString * message = [NSString stringWithFormat:@"%@,文件夹名称不能包含特殊符号",codeInfo];
    
    if ([code intValue] != 0) {
        
        
    }
    
    NSLog(@"jsonDic %@",jsonDic);
}
@end

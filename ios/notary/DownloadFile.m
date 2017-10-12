//
//  DownloadFile.m
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "DownloadFile.h"
#import "AppDelegate.h"
#import "FileModel.h"
#import "NSData+Encryption.h"
#import "NSData+Extension.h"

@implementation DownloadFile


+ (DownloadFile *)launchRequest:(FileModel *)file immediately:(BOOL)immediately
{
    
    if([file.receivedSize floatValue]>0){
        file.isFirstDownload = NO;
    } else {
        file.isFirstDownload = YES;

    }
  
    //目的地
    NSString * destinationPath = nil;
    
    //在文件名称中加入唯一id标示
    NSString * name = [NSString trimeExtendName:file.name unique:file.serverFileId];

    
    if (file.type == kVideoFile) {
        
        NSString * cryptName = [NSString stringWithFormat:@"%@.enr",name];
        
        destinationPath = [[Sandbox videoPath] stringByAppendingPathComponent:cryptName];

    }else if (file.type == kPhotoFile) {
        
        NSString * cryptName = [NSString stringWithFormat:@"%@.enr",name];
        
        destinationPath = [[Sandbox imagePath] stringByAppendingPathComponent:cryptName];
        
    }else if  (file.type == kVoiceFile){
        
        NSString * cryptName = [NSString stringWithFormat:@"%@",name];
        destinationPath = [[Sandbox voicePath] stringByAppendingPathComponent:cryptName];
        
    }
    else {
        
        NSString * cryptName = [NSString stringWithFormat:@"%@.enr",name];
        destinationPath = [[Sandbox otherFilePath] stringByAppendingPathComponent:cryptName];
        
    }

    //临时文件路径
    NSString * tempPath = [[Sandbox libCachePath] stringByAppendingPathComponent:file.name];

    DownloadFile * down = [[DownloadFile alloc] init];
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.downloadRequest setObject:down forKey:file.serverFileId];
    
    //这个必须加，要保留全局的FileModel
    if (![app.fileModels containsObject:file]) {
        [app.fileModels addObject:file];
    }
    

    UserModel * user = [UserModel sharedInstance];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.serverFileId forKey:@"fileID"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"请求下载:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];

    NSString * logstr2 = [NSString stringWithFormat:@"请求下载:sig 加密后 %@",sig];
    debugLog(logstr2);

    
    NSString * urls = [NSString stringWithFormat:@"%@%@?userID=%@&mobileNo=%@&fileID=%@&app_id=%@&v=%@&src=%@&sig=%@",ROOT_URL,FILE_DOWN_URL,user.userID,user.phoneNumber,file.serverFileId,APP_ID,VERSIONS,@"1",sig];
    NSLog(@"请求下载 url :%@",urls);
    
    
    down.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urls]];
    down.request.delegate = down;
   
    [down.request setDownloadDestinationPath:destinationPath];  //目的地路径
    [down.request setTemporaryFileDownloadPath:tempPath]; //临时文件路径
    [down.request setDownloadProgressDelegate:down];
    [down.request setAllowResumeForFileDownloads:YES];  //支持断点续传
    [down.request setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    [down.request setDidFinishSelector:@selector(requestFinished:)];
    //[down.request setCompletionBlock:^{
        
        // Use when fetching textdata
        
    
  //  }];
   
    [down.request setTimeOutSeconds:60.0f];
    
    if (immediately) {
        
        [down.request startAsynchronous];   //开始异步下载
        file.isDownLoading = YES;
        
    }else {
        file.isDownLoading = NO;
    }

    
    return down;
    
}
- (void)cancel
{
    if (nil != _request) {
        
     //  [_request cancel];
//        _request.delegate = nil;
 
       [_request clearDelegatesAndCancel];
        _request = nil;
    }
}

#pragma mark ASIHTTPRequestDelegate methods

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSError * error = request.error;
    //modify by liwzh 错误处理修改 being
//    if (error) {
//        NSLog(@"download file error :\r\n %@",error);
//
//        FileModel * file = [request.userInfo objectForKey:@"File"];
//        file.downStatus = ZIPFILE_DOWNLOADED;
//        [self update:file];
//        
//
//           if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationFinish:)])
//           {
//               [_myDelegate notificationFinish:request];
//           }
//         
//        return;
//        
//    }
    FileModel * file = [request.userInfo objectForKey:@"File"];
    
      if (error) {
          if (error.code == 2 ) { //请求超时
              
              file.message = @"请求超时(已停止点击重试)";
              if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationError:message:)])
              {
                  [_myDelegate notificationError:request message:file.message];
              }
              
          }
          else if (error.code == 1) {
              
              file.message = @"连接服务器错误(已停止点击重试)";
              if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationError:message:)])
              {
                  [_myDelegate notificationError:request message:file.message];
              }
          } else {
              file.message = @"下载失败(已停止点击重试)";
              if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationError:message:)])
              {
                  [_myDelegate notificationError:request message:file.message];
              }
          }
      }
    //end
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
   
    
    FileModel * file = [request.userInfo objectForKey:@"File"];
    file.downStatus = ZIPFILE_DOWNLOADING;
    file.actionType = kDownLoadFile;
    
    FileModel * result = [self queryById:file.serverFileId];
    
    if (nil == result.serverFileId) {
        [self insert:file];
    }
        
}


- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"----%@",responseHeaders);
//    NSString *Content=[responseHeaders objectForKey:@"Content-Type"];
//    NSLog(@"-----%@",Content);
    //是否是断点后重新接受的数据 add by liwzh
     FileModel * file = [request.userInfo objectForKey:@"File"];
     if ([[request responseHeaders] objectForKey:@"Content-Range"]) {
         //此处设置为是，主要是为了断点续传，断点续传的bytes是总的byte会造成重复累加receivedSize，造成progress超过1
         file.isFirstDownload =YES;
     }
    
}
-(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}
-(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}
-(void)getDownloadedSize:(FileModel *)fileInfo
{
    //暂停下载
    NSFileManager * manager = [NSFileManager defaultManager];
    //删除ASI 缓存文件
    NSString * tempPath = [[Sandbox libCachePath]
                           stringByAppendingPathComponent:fileInfo.name];
    
    if ([manager fileExistsAtPath:tempPath]) {
        NSFileManager *fm;
        fm = [NSFileManager defaultManager];
        NSDictionary *attr =[fm fileAttributesAtPath: tempPath traverseLink: NO] ; //文件属性
        fileInfo.receivedSize =[attr objectForKey:NSFileSize];
        NSLog(@"file size is：%i bytes ",[[attr objectForKey:NSFileSize] intValue]);
    }
}
#pragma mark ASIProgressDelegate methods
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
   NSLog(@"%@, didReceiveBytes %lld",NSStringFromSelector(_cmd),bytes);
   NSLog(@"----bytes:%lld",bytes);
//   Notification_Filecomplete
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Filecomplete object:nil];
    
    FileModel * file = [request.userInfo objectForKey:@"File"];
    //comment by liwzh
    //注意此处的bytes在断点续传时，代表的是总的已接受的大小，这样会造成receivedSize超过文件实际大小
    //故在didReceiveResponseHeaders里要做判断是否是断点下载，如果是断点下载要把isFirstDownload设置yes
    //这样初始的receivedSize就是会是对的
    if (!file.isFirstDownload) {
        NSLog(@"receiving %@,%lld",file.receivedSize,bytes);
        file.receivedSize = [NSString stringWithFormat:@"%lld",[file.receivedSize longLongValue] + bytes];
        
    }else {
        
        file.receivedSize = [NSString stringWithFormat:@"%lld",bytes];
        NSLog(@"receiving first %@,%lld",file.receivedSize,bytes);
    }
    
    
    float currentProgress = [self getProgress:[self getFileSizeNumber:file.size]
                                         currentSize:[file.receivedSize floatValue]];
    //comment by liwzh没有必要
//    if (currentProgress > 1) {
//    
//        [NSTimer scheduledTimerWithTimeInterval:3.0f
//                                         target:self
//                                       selector:@selector(handleMaxShowTimer)
//                                       userInfo:nil
//                                        repeats:NO];
//     
//     }
    

        if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationUpdateCellProgress:)])
    {
        [_myDelegate notificationUpdateCellProgress:request];
    }
    file.isFirstDownload = NO;
    
}
-(void)handleMaxShowTimer{
    
  //[self.request cancel];


}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    
    
    FileModel * file = [request.userInfo objectForKey:@"File"];
    file.downStatus = ZIPFILE_DOWNLOADED;
    [self update:file];
    
    /*
    UserModel * user = [UserModel sharedInstance];
    //secretKey+userid +文件id+文件类型
    NSString * key = nil;
    
    if (file.type == kVideoFile) {
        
        key = [NSString stringWithFormat:@"%@%@%@%@",user.secretKey,user.userID,file.serverFileId,@"mov"] ;
        debugLog([NSString stringWithFormat:@"key原始值 %@",key]);
        
        
    }else if (file.type == kPhotoFile) {
        key = [NSString stringWithFormat:@"%@%@%@%@",user.secretKey,user.userID,file.serverFileId,@"png"] ;
        
        debugLog([NSString stringWithFormat:@"key原始值 %@",key]);
        
    }else if (file.type == kVoiceFile) { //音频的后缀目前还不能确定
        key = nil;
    }
    

    NSData * keyData = [[key dataUsingEncoding:NSUTF8StringEncoding]MD5];
    
    //加密文件路径
    NSString * taget = [NSString stringWithFormat:@"%@.enr",file.targetName];
    NSData * cryptData = [[NSData alloc] initWithContentsOfFile:taget];
    NSData * tmp = [cryptData AES128DecryptWithKey:keyData];
    if (tmp == nil) {
        NSString * logerror = [NSString stringWithFormat:@"解密失败 %@",taget];
        debugLog(logerror);
    }else {
        [tmp writeToFile:file.targetName atomically:YES];
    }
    */
    logmessage;
    debugLog([NSString stringWithFormat:@"%@ :receivedSize(%@),size(%@)",file.name,file.receivedSize,file.size]);
    
    
    if(_myDelegate && [_myDelegate respondsToSelector:@selector(notificationFinish:)])
    {
        [_myDelegate notificationFinish:request];
    }
    [_jsonData setLength:0];
}

#pragma make private methods
- (FileModel *)queryById:(NSString *)srcid
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where serverFIleId = %@ and uid = %@",srcid,user.uid];
    
    debugLog(sql);
    
    FMResultSet * result =  [db query:sql];
    FileModel * file = [[FileModel alloc]init];
    
    while (result.next) {
        
        file.fid = [NSString stringWithFormat:@"%d",[result intForColumn:@"id"]];
        file.name = [result stringForColumn:@"name"];
        file.targetName = [result stringForColumn:@"targetname"];
        file.size = [result stringForColumn:@"size"];
        file.downStatus = [result intForColumn:@"status"];
        file.type = [result intForColumn:@"type"];
        file.srcid = [result stringForColumn:@"srcid"];
        file.actionType = [result intForColumn:@"actiontype"];
        file.datatime = [result stringForColumn:@"datatime"];
        file.serverFileId = [result stringForColumn:@"serverFIleId"];
        file.folderId = [result stringForColumn:@"forderId"];
    }
    [db close];
    
    return file;
    
}
- (void)insert:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"INSERT INTO FileModel(name,targetname,size,status,type,actiontype,datatime,serverFIleId,uid) VALUES (?,?,?,?,?,?,?,?,?);";
  
    
    NSArray * pars = [NSArray arrayWithObjects:
                      file.name,
                      file.targetName,
                      file.size,
                      [NSNumber numberWithInt:file.downStatus],
                      [NSNumber numberWithInt:file.type],
                      [NSNumber numberWithInt:file.actionType],
                      file.datatime,
                      file.serverFileId,
                      user.uid,
                      nil];
    
    NSString *logsql = [NSString stringWithFormat:@"INSERT INTO FileModel(name,targetname,size,status,type,actiontype,datatime,serverFIleId,uid) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@);",
                        file.name,
                        file.targetName,
                        file.size,
                        [NSNumber numberWithInt:file.downStatus],
                        [NSNumber numberWithInt:file.type],
                        [NSNumber numberWithInt:file.actionType],
                        file.datatime,
                        file.serverFileId,user.uid];
    debugLog(logsql);
    
    [db insert:sql parameter:pars];

    [db close];

}
- (void)update:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"update FileModel set status = ? where serverFIleId = ? and actiontype = 1 and uid = ?";
    
    NSArray * pars = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],file.serverFileId,user.uid,nil];
    
    NSString * logstr = [NSString stringWithFormat:@"update FileModel set status = 2 where serverFIleId = %@ and actiontype = 1 and uid = %@",file.serverFileId,user.uid];
    debugLog(logstr);
    
    [db update:sql parameter:pars];
    
    [db close];

}


@end

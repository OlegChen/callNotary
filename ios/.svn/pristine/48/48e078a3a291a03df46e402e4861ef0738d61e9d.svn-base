//
//  UpLoadContinue.m
//  notary
//
//  Created by 肖 喆 on 13-5-14.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UpLoadContinue.h"
#import "AppDelegate.h"
#import "BWStatusBarOverlay.h"

@implementation UpLoadContinue

+ (UpLoadContinue *)lauchSocket:(FileModel *)file immediately:(BOOL)immediately
{
    
    
    file.isFirstDownload = YES;  //这里表示是否是第一次上传
    
    UpLoadContinue * upload = [[UpLoadContinue alloc] init];
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UpLoadContinue * temp = [app.uploadSocket objectForKey:file.md5];
    if (nil != temp) {
        
        temp.socket.delegate = nil;
        temp.socket = nil;
        [app.uploadSocket removeObjectForKey:file.md5];
        [app.uploadSocket setObject:upload forKey:file.md5];
    }else {
        [app.uploadSocket setObject:upload forKey:file.md5];
    }

    if (![app.uploadArray containsObject:file]){
//        [app.uploadArray addObject:file];
        [app.uploadArray insertObject:file atIndex:0];
    }
    
    upload.file = file;
    
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    
    if (nil == file.srcid) {
        [dic setObject:@"" forKey:@"srcid"];
    }
    else {
       [dic setObject:file.srcid forKey:@"srcid"];
    }
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.folderId forKey:@"targetFolderId"];
    [dic setObject:file.size forKey:@"content-length"];
    [dic setObject:file.name forKey:@"filename"];
    [dic setObject:file.md5 forKey:@"md5"];
    
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    debugLog([NSString stringWithFormat:@"sig: %@",result]);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    debugLog([NSString stringWithFormat:@"upload sig MD5 : %@",sig]);
    
    NSMutableString * strs = [[NSMutableString alloc]initWithCapacity:0];
    //必须严格按照这个格式
    [strs appendString:@"{"];
    [strs appendString:[NSString stringWithFormat:@"userID=%@;",user.userID]];
    
    if (nil == file.srcid) {
        [strs appendString:[NSString stringWithFormat:@"srcid=%@;",@""]];
    }else {
        [strs appendString:[NSString stringWithFormat:@"srcid=%@;",file.srcid]];
    }

    [strs appendString:[NSString stringWithFormat:@"targetFolderId=%@;",file.folderId]];
    [strs appendString:[NSString stringWithFormat:@"content-length=%@;",file.size]];
    [strs appendString:[NSString stringWithFormat:@"filename=%@;",file.name]];
    [strs appendString:[NSString stringWithFormat:@"src=%@;",@"1"]];
    [strs appendString:[NSString stringWithFormat:@"mobileNo=%@;",user.phoneNumber]];
    [strs appendString:[NSString stringWithFormat:@"app_id=%@;",APP_ID]];
    [strs appendString:[NSString stringWithFormat:@"v=%@;",VERSIONS]];
    [strs appendString:[NSString stringWithFormat:@"sig=%@;",sig]];
    [strs appendString:[NSString stringWithFormat:@"md5=%@",file.md5]];
    [strs appendString:[NSString stringWithFormat:@"\r\n"]];
    [strs appendString:@"}"];
    
    
    NSString * logstr = [NSString stringWithFormat:@"socket json %@",strs];
    debugLog(logstr);
    
    NSData * data = [strs dataUsingEncoding:NSUTF8StringEncoding];
    
    upload.socket = [[AsyncSocket alloc] initWithDelegate:upload];
    
    BOOL connectstatus = NO;
    NSError * error = nil;
    connectstatus = [upload.socket connectToHost:UPLOAD_SERVER_IP
                                          onPort:UPLOAD_SERVER_PORT
                                           error:&error];
    
    if (!connectstatus) {
        NSString * errorstring = [NSString stringWithFormat:@"socket connect error:%@",error];
        debugLog(errorstring);
    }
    [upload.socket setRunLoopModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    
    if (connectstatus) {
        [upload.socket writeData:data withTimeout:-1 tag: 0];
    }
    return upload;
    
}
- (void)cancel
{
    if (nil != _socket) {
        
        if (_file != nil) {
            _file.downStatus = ZIPFILE_DOWNLOAD_NO; //更改为上传完成的状态
            _file.isFirstDownload = YES;  //解决bug添加
            _file.isDownLoading = NO;
//            if (_file.srcid != nil) {
//                [self update:_file];
//            }
        }
        
        [_socket disconnect];
        [_socket setDelegate:nil];
        _socket = nil;

    }
    
    NSString * logrstr = [NSString stringWithFormat:@"%@ upload cancel",_file.name];
    debugLog(logrstr);
}

#pragma mark - tcp AsyncSocketDelegate


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{    logmessage;
    [_socket readDataWithTimeout: -1 tag: 0];
}
//这里判断发送完成 暂停不会调用这个函数
//这个方法默认会被调用两侧 开始上传的时候调用一次 完成上传调用一次
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    

    if (!_file.isFirstDownload){ //上传完成时会调用这个if中的语句
        
        _file.downStatus = ZIPFILE_DOWNLOADED; //更改为上传完成的状态
        [self update:_file];
        
        //通知更新列表
        FolderModel * folder = [[FolderModel alloc] init];
        folder.folderID = _file.folderId;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeUploadFileSuccess object:folder];
        
    
        
    }
    
    /*
    //在结束以上操作之后在去调用代理通知
    if(!_file.isFirstDownload && _delegate != nil) {

        
        [_delegate notificationUploadFinished:_file];
        
    }
    else if (!_file.isFirstDownload && _delegate == nil){

        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [app.uploadSocket removeObjectForKey:_file.md5];
        
        if ([app.uploadArray containsObject:_file]){
            [app.uploadArray removeObject:_file];
        }
        
        
        _file = nil;
    }
    */
    
//    [_socket readDataWithTimeout: -1 tag: 0];

}
// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * socketResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString * logstr = [NSString stringWithFormat:@"socket result :%@",socketResult];
    debugLog(logstr);
    
    if (nil == socketResult) {
        
        [_socket readDataWithTimeout: -1 tag: 0];
        return;
    }
    
    NSDictionary * dic = [self getSocketMessage:socketResult];
    
    NSString * status = [dic objectForKey:@"status"];
    NSString * message = [dic objectForKey:@"errMsg"];
    NSString * srcid = [dic objectForKey:@"srcid"];
    NSString * position = [dic objectForKey:@"position"];
    
    NSData * dataTemp = nil;
    //状态为0 上传正常
    if ([status intValue] == 0 )
    {
        _file.srcid = srcid;
        _file.datatime = [self handleGetCurrentTime];
        _file.downStatus = ZIPFILE_DOWNLOAD_NO; //还没有开始上传的状态
        _file.isFirstDownload = NO; //标记已经不是第一次上传
        
        if ([position intValue] != 0)
        {
            
            _file.receivedSize = position;   //文件上次传送到的位置
            
            /*
            if (_file.type == kVideoFile) {
                
                NSError * error = nil;
                NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:_file.path
                                                                            error:&error];
                if (error) {
                    NSString * logerrorstr = [NSString stringWithFormat:@"read kVideoFile error %@",error];
                    debugLog(logerrorstr);
                }
                
                [handle seekToFileOffset:[position intValue]];
                
                NSLog(@"position intvalue %d",[position intValue]);
                
                dataTemp  = [handle readDataToEndOfFile];
                
            }else {
                
                dataTemp = UIImageJPEGRepresentation(_file.image,DEFAULT_IMAGE_COMPRESS);
            }
            */
            if (_file.type == kVideoFile) {
                
                NSError * error = nil;
                NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:_file.path
                                                                            error:&error];
                if (error) {
                    NSString * logerrorstr = [NSString stringWithFormat:@"read kVideoFile error %@",error];
                    debugLog(logerrorstr);
                }
                
                [handle seekToFileOffset:[position intValue]];
                
                NSLog(@"position intvalue %d",[position intValue]);
                
                dataTemp  = [handle readDataToEndOfFile];
                
            }else if (_file.type == kPhotoFile){
                
                NSError * error = nil;
//                NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:_file.path
//                                                                            error:&error];
                
                NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:_file.targetName];
                if (error) {
                    NSString * logerrorstr = [NSString stringWithFormat:@"read kVideoFile error %@",error];
                    debugLog(logerrorstr);
                }
                
                [handle seekToFileOffset:[position intValue]];
                
                NSLog(@"position intvalue %d",[position intValue]);
                
                dataTemp  = [handle readDataToEndOfFile];

                
            } else if (_file.type == kVoiceFile){
                NSError * error = nil;
                NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:_file.path
                                                                            error:&error];
                if (error) {
                    NSString * logerrorstr = [NSString stringWithFormat:@"read kVoiceFile error %@",error];
                    debugLog(logerrorstr);
                }
                
                [handle seekToFileOffset:[position intValue]];
                
                NSLog(@"position intvalue %d",[position intValue]);
                
                dataTemp  = [handle readDataToEndOfFile];
            }

        }
        else
        {
            
            if (_file.type == kVideoFile) {
                
                dataTemp  = [NSData dataWithContentsOfURL:_file.path];
                
            }else if(_file.type == kPhotoFile) {
                
                dataTemp = UIImageJPEGRepresentation(_file.image,DEFAULT_IMAGE_COMPRESS);
                
                //保存image原图断点上传用 并且要修噶model的tagetname
                [self saveOriginalImage:dataTemp file:_file];
                
            } else if (_file.type == kVoiceFile){
                dataTemp  = [NSData dataWithContentsOfURL:_file.path];
//                NSLog(@"%@----%@",dataTemp,_file.path);
            }
            
            //保存缩略图
            [self saveThumbnail:_file];
            
            //增加一条新数据
            [self insert:_file];
        }
        
        _file.downStatus = ZIPFILE_DOWNLOADING; //更改为开始上传的状态
        _file.isDownLoading = YES;
        
        [self update:_file];
        
        [_socket writeData: dataTemp withTimeout: -1 tag: 0];
        
        dataTemp = nil;
    }
    else
    {
        
        debugLog(message);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        [alert show];
        
        //提示之后立即关闭连接
        [_socket disconnect];
        [_socket setDelegate:nil];
        
        
        if (nil != _delegate) {
            [_delegate notificationUploadFailed:nil FileModel:_file];
        }
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([app.uploadArray containsObject:_file]){
            [app.uploadArray removeObject:_file];
        }
        
        return;
    }
    
//    [BWStatusBarOverlay showWithMessage:@"文件上传中" loading:NO animated:YES];
    
    [_socket disconnectAfterWriting];
    
    [_socket readDataWithTimeout: -1 tag: 0];
}
//连接断开时调用
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString * logstr = [NSString stringWithFormat:@"file size(%@),uploded size(%@)",_file.size,_file.receivedSize];
    debugLog(logstr);
    
    //在结束以上操作之后在去调用代理通知
    if(_file.downStatus == ZIPFILE_DOWNLOADED && _delegate != nil) {
        
        [_delegate notificationUploadFinished:_file];
        
    }
    else if (_file.downStatus == ZIPFILE_DOWNLOADED){
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        

        
        if ([app.uploadArray containsObject:_file]){
            [app.uploadArray removeObject:_file];
        }
        [app.uploadSocket removeObjectForKey:_file.md5];
        
        _file = nil;
    }
    
//    [self cancel];
}
//连接错误时调用
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    logmessage;
    
    [_socket disconnect];
    

    if (_file != nil && _file.srcid != nil){
        _file.downStatus = ZIPFILE_DOWNLOAD_NO; //更改为开始上传的状态
        _file.isDownLoading = NO;
        [self update:_file];
    }
    if (nil != _delegate) {
        [_delegate notificationUploadFailed:err FileModel:_file];
    }
   
    
//    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([app.uploadArray containsObject:_file]){
//        [app.uploadArray removeObject:_file];
//    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"服务器错误" message:@"服务器连接错误,请稍后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

    
}
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{

    _file.receivedSize = [NSString stringWithFormat:@"%d",[_file.receivedSize intValue] + partialLength];
    float progress = [_file.receivedSize floatValue] / [_file.size floatValue];
    
    if (nil != _delegate) {
        [_delegate notificationUploadProgress:progress FileModel:_file];
    }
    
    /*
    //计算总显示条进度
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString * allSzie = @"";
    NSString * allReceivedSize = @"0";
    BOOL isHadUploadingFile = NO;
    for (int i = 0; i < app.uploadArray.count;i++){
        
        FileModel * file = [app.uploadArray objectAtIndex:i];
        
        if ( file.downStatus == ZIPFILE_DOWNLOADING){
            
            isHadUploadingFile = YES;
            allSzie = [NSString stringWithFormat:@"%d",[allSzie intValue] + [file.size intValue]];
            allReceivedSize = [NSString stringWithFormat:@"%d",[allReceivedSize intValue] + [file.receivedSize intValue]];
        }
    
    }
    if (isHadUploadingFile) {
        float showProgress = [allReceivedSize floatValue] / [allSzie floatValue];
        [BWStatusBarOverlay setProgress:showProgress animated:YES];
    }
    else {
        [BWStatusBarOverlay showSuccessWithMessage:@"当前没有文件上传中" duration:4 animated:YES];
    }
     */
}
#pragma db
- (void)insert:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    //@"select * from UFile where srcid = ?";
    NSString * sql = @"INSERT INTO FileModel(name,targetName,type,srcid,size,status,actiontype,datatime,md5,uid,targetFolderId) VALUES (?,?,?,?,?,?,?,?,?,?,?);";
    NSArray * pars = [NSArray arrayWithObjects:
                      file.name,
                      file.targetName,
                      [NSNumber numberWithInt:file.type],
                      file.srcid,
                      file.size,
                      [NSNumber numberWithInt:file.downStatus],
                      [NSNumber numberWithInt:0],
                      file.datatime,
                      file.md5,
                      user.uid,
                      file.folderId,
                      nil];
    
    NSString * logstr = [NSString stringWithFormat:@"INSERT INTO FileModel(name,targetName,type,srcid,size,status,actiontype,datatime,md5,uid,targetFolderId) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",file.name,file.targetName,[NSNumber numberWithInt:file.type],file.srcid,file.size,[NSNumber numberWithInt:file.downStatus],[NSNumber numberWithInt:0],file.datatime,file.md5,user.uid,file.folderId];
    debugLog(logstr);
    
    [db insert:sql parameter:pars];
    [db close];
    db = nil;
}
- (void)update:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"update FileModel set status = ? where srcid = ? and actiontype = 0 and uid = ?";
    
    NSArray * pars = [NSArray arrayWithObjects:[NSNumber numberWithInt:file.downStatus],file.srcid,user.uid,nil];
    
    NSString * logstr = [NSString stringWithFormat:@"update FileModel set status = %d where srcid = %@ and actiontype = 0 and uid = %@",file.downStatus, file.srcid,user.uid];
    debugLog(logstr);
    
    [db update:sql parameter:pars];
    
    [db close];
    db =nil;
}
- (void)delete:(FileModel *)file
{
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"delete from FileModel where srcid = ?";
    NSArray * pars = [NSArray arrayWithObject:file.srcid];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
    db = nil;
}
- (FileModel *)query:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where srcid = %@ and uid = %@",file.srcid,user.uid];
    
    debugLog(sql);
    
    FMResultSet * result = [db query:sql];
    
    FileModel * temp = nil;
    while (result.next) {
        
        temp = [[FileModel alloc]init];
        temp.fid = [result stringForColumn:@"id"];
        temp.targetName = [result stringForColumn:@"targetName"];
        temp.type = [result intForColumn:@"type"];
        temp.srcid = [result stringForColumn:@"srcid"];
        temp.size = [result stringForColumn:@"size"];
        temp.actionType = [result intForColumn:@"actiontype"];
        temp.datatime = [result stringForColumn:@"datatime"];
        temp.md5 = [result stringForColumn:@"md5"];
    }
    [db close];
    db = nil;
    return temp;
}

#pragma util method
- (NSMutableDictionary *)getSocketMessage:(NSString *)message
{
    NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * array = [NSString splite:message separator:@";"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString * temp = [array objectAtIndex:i];
        
        NSArray * result = [NSString splite:temp separator:@"="];
        [info setObject:[result objectAtIndex:1] forKey:[result objectAtIndex:0]];
    }
    
    NSLog(@"info %@",info);
    
    return info;
}
- (NSString *)handleGetCurrentTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [df stringFromDate:nowDate];
    
    NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
}
- (void)saveThumbnail:(FileModel *)file
{   
    //保存缩略图
    UIImage * thumbnail  = [UIImage imageWithImageSimple:file.image scaledToSize:CGSizeMake(70, 70)];
    NSString * thumbnailName = [NSString stringWithFormat:@"%@_%@",file.name,file.srcid];
    NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:thumbnailName];
    NSData * imageData = UIImagePNGRepresentation(thumbnail);
    [imageData writeToFile:path atomically:YES];
    
    thumbnail = nil;
    imageData = nil;
     
}
- (void)saveOriginalImage:(NSData *)image file:(FileModel *)file
{
    NSString * uniqueName = [NSString stringWithFormat:@"%@%@",file.md5,file.name];
    NSString * path = [[Sandbox uploadTempPath]stringByAppendingPathComponent:uniqueName];
    [image writeToFile:path atomically:YES];
    
    file.targetName = path;
    file.path = [NSURL URLWithString:file.targetName];
    
    image = nil;
}
@end

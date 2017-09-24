//
//  UploadFile.m
//  notary
//
//  Created by 肖 喆 on 13-4-1.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UploadFile.h"
#import "BWStatusBarOverlay.h"

static UploadFile * instance;

@implementation UploadFile

+ (id)sharedInstance
{
    if (nil == instance) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}
+ (UploadFile *)initWithFileModel:(FileModel *)file andDelegate:(id <UploadFileDelegate>)delegate
{
    UploadFile * upload = [[UploadFile alloc] init];//[UploadFile sharedInstance];
    upload.model = file;
    upload.delegate = delegate;
    
    
    upload.socket = [[AsyncSocket alloc] initWithDelegate:upload];
    
    
    return upload;
}
- (void)viewWillDisappear
{
    if (nil != _socket) {
        [BWStatusBarOverlay showWithMessage:@"上传文件" loading:NO animated:YES];
    }
}
- (void)cancel
{
   [self delete:_model.srcid];
    _model.receivedSize = @"0";
   [self stop];

}
- (void)stop
{
    //如果调用了 stop函数 那么设置为NO
    if (_socket != nil) {
        
        [_socket disconnect];
        _socket = nil;
    }
    _isStart = NO;
    
    _model.downStatus = ZIPFILE_DOWNLOAD_NO;
    [self update:_model];
}
- (void)startWith:(NSData *)data
{
    _isStart = YES;
    
    [_socket writeData:data withTimeout:-1 tag:0];
   
}
- (void)start
{
    NSMutableString * sendString =  [self handleGetJsonString];
    
    NSData * data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    static BOOL connectOK = NO;
    
//    if (!_socket)
//    {
//        self.socket = [[AsyncSocket alloc] initWithDelegate:self] ;
    
        NSError *error;
        connectOK = [_socket connectToHost:UPLOAD_SERVER_IP onPort:UPLOAD_SERVER_PORT error: &error];
        if (!connectOK)
        {
            NSLog(@"connect error: %@", error);
        }
        
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
//    }
    
    if (connectOK)
    {
        _isFirstUpload = YES;
        [_socket writeData: data withTimeout: -1 tag: 0];
    }
}
#pragma mark - tcp AsyncSocketDelegate


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
    [_socket readDataWithTimeout: -1 tag: 0];
}
//这里判断发送完成 暂停不会调用这个函数
//这个方法默认会被调用两侧 开始上传的时候调用一次 完成上传调用一次
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
    if (!_isFirstUpload){
        
        if (nil != _delegate) {
            [_delegate notificationUploadFinished];
            
        }
        [BWStatusBarOverlay showSuccessWithMessage:@"上传完成" duration:2 animated:YES];
        
        
        //更新数据库
        [self update:_model];
        
        //通知更新列表
        FolderModel * folder = [[FolderModel alloc] init];
        folder.folderID = _model.folderId;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeUploadFileSuccess object:folder];
        
        //保存缩略图
        UIImage * thumbnail  = [UIImage imageWithImageSimple:_model.image scaledToSize:CGSizeMake(70, 70)];
        NSString * thumbnailName = [NSString stringWithFormat:@"%@_%@",_model.name,_model.srcid];
        NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:thumbnailName];
        NSData * imageData = UIImagePNGRepresentation(thumbnail);
        [imageData writeToFile:path atomically:YES];
        
        
    }else {
        _isFirstUpload = NO;
    }
    logmessage;
    
    [_socket readDataWithTimeout: -1 tag: 0];

}

// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    debugLog(result);
    
    if (result == nil) {
        
        [_socket readDataWithTimeout: -1 tag: 0];
        return;
    }
    
    NSDictionary * dic = [self getSocketMessage:result];
    
    NSString * status = [dic objectForKey:@"status"];
    NSString * message = [dic objectForKey:@"errMsg"];
    NSString * srcid = [dic objectForKey:@"srcid"];
    NSString * position = [dic objectForKey:@"position"];
    
    if ([status intValue] == 0) { //状态为0 说明没有消息
        
        FileModel * uploadFile = [self query:srcid];
        
        NSData * dataTmp = nil;
        
        if (nil == uploadFile) {
            
            _model.srcid = srcid;
            _model.datatime = [self handleGetCurrentTime];
            _model.downStatus = ZIPFILE_DOWNLOAD_NO;  //没有上传过
            [self insertUFile:_model];
            
            //写入物理文件 断点续传用
            
            
            if (_model.type == kVideoFile) {
                
                dataTmp  = [NSData dataWithContentsOfURL:_model.path];
                
            }else {
                
                dataTmp = UIImageJPEGRepresentation(_model.image,DEFAULT_IMAGE_COMPRESS);
                
            }
            
        }else {
            
            //防止出现bug
            _model.srcid = uploadFile.srcid;
            
            if (_model.type == kVideoFile) {
                
                NSError * error = nil;
                NSFileHandle * handle = [NSFileHandle fileHandleForReadingFromURL:_model.path error:&error];
                if (error) {
                    NSLog(@"readfile error : %@",error);
                }
                
                [handle seekToFileOffset:[position intValue]];
                
                NSLog(@"position intvalue %d",[position intValue]);
                
                dataTmp  = [handle readDataToEndOfFile];
                
            }else {
                
                dataTmp = UIImagePNGRepresentation(_model.image);
                
            }
            
        }
        
        
        //开始上传了
        _model.downStatus = ZIPFILE_DOWNLOADING;
        [self update:_model];
        
        [_socket writeData: dataTmp withTimeout: -1 tag: 0];
        
    }else {
        
        debugLog(message);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }
    
    [_socket disconnectAfterWriting];
    
    [_socket readDataWithTimeout: -1 tag: 0];

    
}
//连接断开时调用
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    NSString * logstr = [NSString stringWithFormat:@"upload file size(%@),uplodedsize(%@)",_model.size,_model.receivedSize];
    debugLog(logstr);
    
    if (_socket.isConnected) {
        [BWStatusBarOverlay showSuccessWithMessage:@"上传完成" duration:2 animated:YES];
    }
    _socket = nil;
    
    //收到的数据要大于 文件本身数据
    if ([_model.receivedSize intValue] > [_model.size intValue]) {
         [_delegate notificationUploadFinished];
    }
     
}
//连接错误时调用
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    if (err) {
        
        NSString * errorMessage = [NSString stringWithFormat:@"%@",err];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"服务器错误" message:@"服务器连接错误,请稍后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        debugLog(errorMessage);
        
        [BWStatusBarOverlay showSuccessWithMessage:@"上传文件失败" duration:4 animated:YES];
    }
    
}
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
        _model.receivedSize = [NSString stringWithFormat:@"%d",[_model.receivedSize intValue] + partialLength];
        float progress = [_model.receivedSize floatValue] / [_model.size floatValue];
        
    [_delegate notificationUploadProgress:progress];
        
    [BWStatusBarOverlay setProgress:progress animated:YES];
}



#pragma mark db 
- (void)insertUFile:(FileModel *)file
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
                      [NSNumber numberWithInt:file.actionType],
                      file.datatime,
                      file.md5,
                      user.uid,
                      file.folderId,
                      nil];
    
    NSString * logstr = [NSString stringWithFormat:@"INSERT INTO FileModel(name,targetName,type,srcid,size,status,actiontype,datatime,md5,uid,targetFolderId) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",file.name,file.targetName,[NSNumber numberWithInt:file.type],file.srcid,file.size,[NSNumber numberWithInt:file.downStatus],[NSNumber numberWithInt:file.actionType],file.datatime,file.md5,user.uid,file.folderId];
    debugLog(logstr);
    
    [db insert:sql parameter:pars];
    [db close];
}
- (void)update:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"update FileModel set status = ? where srcid = ? and actiontype = 0 and uid = ?";
    
    NSArray * pars = [NSArray arrayWithObjects:[NSNumber numberWithInt:_model.downStatus],file.srcid,user.uid,nil];
    
    NSString * logstr = [NSString stringWithFormat:@"update FileModel set status = %d where srcid = %@ and actiontype = 0 and uid = %@",file.downStatus, file.srcid,user.uid];
    debugLog(logstr);
    
    [db update:sql parameter:pars];
    
    [db close];
    
}
- (NSString *)handleGetSrcId:(NSString *)md5
{
    NSString * srcid = @"";
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    //@"select * from UFile where srcid = ?";
    NSString * sql = @"select * from FileModel where md5 = ? and uid = ?";//[NSString stringWithFormat:@"select * from FileModel where targetName = %@",targetName];
    
    
    NSArray * par = [NSArray arrayWithObjects:md5,user.uid,nil];
    FMResultSet * result = [db query:sql parameter:par];
    
    NSString * logstr = [NSString stringWithFormat:@"select * from FileModel where md5 = %@ and uid = %@",md5,user.uid];
    debugLog(logstr);
    
    while (result.next) {
        NSString * temp = [result stringForColumn:@"srcid"];
        if (nil != temp) {
            srcid = temp;
        }
    }
    [db close];
    return srcid;
}

- (FileModel *)query:(NSString *)srcid
{
    //@"INSERT INTO FileModel(targetName,type,srcid,size,actiontype,datatime) VALUES (?,?,?,?,?,?);";
    
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where srcid = %@ and uid = %@",srcid,user.uid];
    debugLog(sql);
    FMResultSet * result = [db query:sql];
    
    FileModel * file = nil;
    while (result.next) {
        
        file = [[FileModel alloc]init];
        file.fid = [result stringForColumn:@"id"];
        file.targetName = [result stringForColumn:@"targetName"];
        file.type = [result intForColumn:@"type"];
        file.srcid = [result stringForColumn:@"srcid"];
        file.size = [result stringForColumn:@"size"];
        file.actionType = [result intForColumn:@"actiontype"];
        file.datatime = [result stringForColumn:@"datatime"];
        file.md5 = [result stringForColumn:@"md5"];
    }
    [db close];
    return file;
}

- (NSMutableString *)handleGetJsonString
{
    UserModel * user = [UserModel sharedInstance];
    NSString * srcid = nil;
    if (_model.srcid == nil) {
        
        srcid = [self handleGetSrcId:_model.md5];
        
    }else {
        srcid = _model.srcid;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
   
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:srcid forKey:@"srcid"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:_model.folderId forKey:@"targetFolderId"];
    [dic setObject:_model.size forKey:@"content-length"];
    [dic setObject:_model.name forKey:@"filename"];
    [dic setObject:_model.md5 forKey:@"md5"];

    
    NSString * result = [URLUtil generateNormalizedString:dic];
    debugLog([NSString stringWithFormat:@"sig: %@",result]);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    debugLog([NSString stringWithFormat:@"upload sig MD5 : %@",sig]);
    
    NSMutableString * strs = [[NSMutableString alloc]initWithCapacity:0];
    //必须严格按照这个格式
    [strs appendString:@"{"];
    [strs appendString:[NSString stringWithFormat:@"userID=%@;",user.userID]];
    [strs appendString:[NSString stringWithFormat:@"srcid=%@;",srcid]];
    [strs appendString:[NSString stringWithFormat:@"targetFolderId=%@;",_model.folderId]];
    [strs appendString:[NSString stringWithFormat:@"content-length=%@;",_model.size]];
    [strs appendString:[NSString stringWithFormat:@"filename=%@;",_model.name]];
    [strs appendString:[NSString stringWithFormat:@"src=%@;",@"1"]];
    [strs appendString:[NSString stringWithFormat:@"mobileNo=%@;",user.phoneNumber]];
    [strs appendString:[NSString stringWithFormat:@"app_id=%@;",APP_ID]];
    [strs appendString:[NSString stringWithFormat:@"v=%@;",VERSIONS]];
    [strs appendString:[NSString stringWithFormat:@"sig=%@;",sig]];
    [strs appendString:[NSString stringWithFormat:@"md5=%@",_model.md5]];
    [strs appendString:[NSString stringWithFormat:@"\r\n"]];
    [strs appendString:@"}"];
    
    NSLog(@"send json %@",strs);
    
    return strs;
}

- (NSString *)handleGetCurrentTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];//中文表示 周二，4月
    //    [df setDateFormat:@"yyyyMMddHHMMss"];//获得数字时间
    NSString *locationString = [df stringFromDate:nowDate];
    
    NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
}

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
- (void)delete:(NSString *)srcid
{
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"delete from FileModel where srcid = ?";
    NSArray * pars = [NSArray arrayWithObject:srcid];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
}
@end

//
//  DownLoadHistory.m
//  notary
//a
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "DownLoadHistory.h"
#import "UpLoadHistoryCell.h"
#import "AppDelegate.h"
#import "DownloadCell.h"
#import "PreviewView.h"
#import "Preview.h"
#define HEIGHT_FOR_LOADHISTORY_TABLEVIEW_CELL 85
static FileModel * tmpFileModel = nil;
@interface DownLoadHistory ()<AESDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIVideoEditorControllerDelegate>
- (void)handleUpdateCellOnMainThread:(FileModel *)fileInfo;

@end

@implementation DownLoadHistory

- (void)back 
{ 
    if (_isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //先查询数据库中下载的文件列表
     _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self queryAllModels];
    
    _downloadeRequest = _app.downloadRequest;
    _files = _app.fileModels;
    
    [self makeView];
    
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_bg_one"]];
    _innerView.backgroundView = imageView;
}

- (void)makeView
{
    self.title = @"下载记录";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10.0f, 0.0f, 30.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton * Right = [UIButton buttonWithType:UIButtonTypeCustom];
    Right.frame = CGRectMake(0, 0, 60, 40);
    Right.titleLabel.font = [UIFont systemFontOfSize:13];
    [Right addTarget:self action:@selector(handleEditItemClick:) forControlEvents:UIControlEventTouchUpInside];
     [Right setTitle:@"清除全部" forState:UIControlStateNormal];
    [Right setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:Right];
    self.navigationItem.rightBarButtonItem = rightButton;
 }
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //防止推出时候闪退bug
    NSArray * allkeys = [_app.downloadRequest allKeys];
    
    for (int i = 0; i < allkeys.count;i++) {
        
        DownloadFile * down = [_app.downloadRequest objectForKey:[allkeys objectAtIndex:i]];
        [down setMyDelegate:nil];
    }
    
    [MobClick endLogPageView:@"下载记录"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"下载记录"];
}
- (void)handleEditItemClick:(UIButton *)but
{
    _alertRecoverAll = [[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:@"确定要清空全部"
                        delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertRecoverAll.delegate = self;
     [_alertRecoverAll show];

    
}
- (void)notificationBack:(FileModel *)fileModel{
    NSLog(@"-----fileModel:%@",fileModel.serverFileId);
    tmpFileModel=fileModel;
    
    UIAlertView* _alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                          message:@"该文件下载数据不完整,是否重新下载该文件"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                
                                                otherButtonTitles:@"确定",nil];
    _alertError.tag=234;
    
    [_alertError show];



}
//add by liwzh 获取已经下载的文件大小
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

- (void)handleMessageCellOnMainThread:(FileModel *)fileInfo
{
    @try {
        
       
    if (IOS7_OR_LATER) {
        
        for (id obj in _myTableView.subviews) {
            
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                UIView*objView=(UIView*)obj;
                for (id view in objView.subviews) {
            
            if ([view isKindOfClass:[DownloadCell class]])
            {
                DownloadCell * cell = (DownloadCell *)view;
               
                if (cell.file == nil) {
                    
                }else{
               
                if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
                {
                    
                    [cell showErrorMessage:fileInfo.message];
                }
                }
                
            }
        }
            }
        
        }
        
    }else{
        
 
    for (id obj in _myTableView.subviews) {
        
        if ([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell * cell = (DownloadCell *)obj;
            if (cell.file == nil) {
                
            }else{
            if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
            {
                
                [cell showErrorMessage:fileInfo.message];
            }
            }
        }
    }
        
        
    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}
- (void)handleUpdateCellOnMainThread:(FileModel *)fileInfo
{
    @try {
        
       if (IOS7_OR_LATER) {
        for (id obj in _myTableView.subviews) {
            
            
        if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                UIView*objView=(UIView*)obj;
                for (id view in objView.subviews) {
              
            if ([view isKindOfClass:[DownloadCell class]])
            {
                DownloadCell * cell = (DownloadCell *)view;
                if (cell.file == nil) {
                    
                }else{
                if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
                {
                    
                    float currentProgress = [self getProgress:[self getFileSizeNumber:fileInfo.size]
                                                  currentSize:[fileInfo.receivedSize floatValue]];

                    NSLog(@"------currentProgress:%f",currentProgress);
                    [cell.progressView setProgress:currentProgress];
                    cell.labErrorMessage.text = @"下载中(点击暂停)";
                }
                }
            }
                    
                }
                
            }
        }

    }else{
        for (id obj in _myTableView.subviews) {
            
            
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                UIView*objView=(UIView*)obj;
                for (id view in objView.subviews) {
                    
                }
                
            }
            if ([obj isKindOfClass:[DownloadCell class]])
            {
                DownloadCell * cell = (DownloadCell *)obj;
                if (cell.file == nil) {
                    
                }else{
                if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
                {
                    
                    float currentProgress = [self getProgress:[self getFileSizeNumber:fileInfo.size]
                                                  currentSize:[fileInfo.receivedSize floatValue]];
                    NSLog(@"------currentProgress:%f",currentProgress);
                    NSLog(@"-----fileInfo.size:%@,fileInfo.receivedSize:%@",fileInfo.size,fileInfo.receivedSize );
                    [cell.progressView setProgress:currentProgress];
                    cell.labErrorMessage.text = @"下载中(点击暂停)";
                }}
            }
        }

    }
    }
    @catch (NSException *exception) {
        
        NSLog(@"------exception:%@",exception);
    }
    @finally {
        
    }

    }
- (void)handleUpdateCellFinished:(FileModel *)fileInfo
{
    
    if (IOS7_OR_LATER) {
        
        for (id obj in _myTableView.subviews) {
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                UIView*objView=(UIView*)obj;
                for (id view in objView.subviews) {
            if ([view isKindOfClass:[DownloadCell class]])
            {
               
                DownloadCell * cell = (DownloadCell *)view;
                if (cell.file == nil) {
                    
                }else{
                if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
                {
                    
                    [cell.progressView setProgress:1.0];
                    cell.labErrorMessage.text = @"已完成";
                    //                [self updateDownStatusFinish:cell.file.serverFileId];
                }}
            }
        }
        
            }
        
        }

        
    }else{
    for (id obj in _myTableView.subviews) {
        
        if ([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell * cell = (DownloadCell *)obj;
            if (cell.file == nil) {
                
            }else{
            if ([fileInfo.serverFileId isEqualToString:cell.file.serverFileId])
            {
                
                [cell.progressView setProgress:1.0];
                cell.labErrorMessage.text = @"已完成";
//                [self updateDownStatusFinish:cell.file.serverFileId];
            }
            }
        }
    }


    }


    
}
#pragma mark -
#pragma mark 编辑删除清空
- (void)noneBtnClick
{
//    NSLog(@"清空");
    [_dataSourceArr removeAllObjects];
    [self.myTableView reloadData];
}

- (void)doneBtnClick
{
    [self.myTableView setEditing:NO animated:YES];
    [self.navigationItem setRightBarButtonItems:_barBtnItemEditArr animated:YES];
}

- (void)editBtnClick
{
    [self.myTableView setEditing:YES animated:YES];
    [self.navigationItem setRightBarButtonItems:_barBtnItemDoneArr animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"UITableViewCellEditingStyle");
    return UITableViewCellEditingStyleDelete;
}
#pragma mark- deleteFileModel
//删除下载记录的文件的方法
-(void)deleteFileModel:(FileModel*)file{
    //删除下载
    DownloadFile * down = [_app.downloadRequest objectForKey:file.serverFileId];
    [down cancel];
    
    //删除数据库
    [self delete:file.serverFileId];
    
    NSLog(@"-----file.serverFileId-%@",file.serverFileId);
    NSLog(@"-----file.name-%@",file.name);
     NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    //删除完整的下载文件
    //目的地
      if ([manager fileExistsAtPath:file.targetName]) {
        
        [manager removeItemAtPath:file.targetName error:&error];
        
        if (error) {
            debugLog([error description]);
        }
    }

    
    //删除ASI 缓存文件
    NSString * tempPath = [[Sandbox libCachePath]
                           stringByAppendingPathComponent:file.name];
   
    
    if ([manager fileExistsAtPath:tempPath]) {
        
        [manager removeItemAtPath:tempPath error:&error];
        
        if (error) {
            debugLog([error description]);
        }
    }
    
    
    //删除全局文件缓存
    [_app.downloadRequest removeObjectForKey:file.serverFileId];
    [_app.fileModels removeObject:file];
    
    //modify by liwzh ios8闪退,先这么处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.myTableView reloadData];
        
    });
    
//    [self.myTableView reloadData];


}
//这个方法根据参数editingStyle是UITableViewCellEditingStyleDelete
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)     {
        
        int descIndex = _files.count - indexPath.row - 1;
        
        FileModel * file = [_files objectAtIndex:descIndex];
        [self deleteFileModel:file];
        
           }
}

//表视图委托
#pragma mark -
#pragma mark table view data source methods
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _innerView) {
        return 1;
    }
    if (_files.count == 0) {
        return 1;
    }
    return _files.count;
}

//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tableView == _innerView){
        
        UITableViewCell * incell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"incell"];
        incell.textLabel.font = [UIFont systemFontOfSize:10];
        incell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        
        if (indexPath.row == 0){
            incell.textLabel.text = @"清除全部";
        }
        
        return incell;
    }

    
    DownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    
    cell.tag = indexPath.row + 1000;
    
    if (_files.count == 0) {
        
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"当前没有下载文件";
        
        cell.labDate.hidden = YES;
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.progressView.hidden = YES;
        cell.imageTitle.hidden = YES;
        cell.labErrorMessage.hidden = YES;
        tableView.userInteractionEnabled = NO;
        
    }else {
        
        
        NSFileManager * manager = [NSFileManager defaultManager];
        
        int descIndex = _files.count - indexPath.row - 1;
        
        FileModel * file = [_files objectAtIndex:descIndex];
        DownloadFile * down = [_downloadeRequest objectForKey:file.serverFileId];
        if (nil != down) {
            down.myDelegate = self;
        }
        
        cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
        /*
        NSRange  range =  [file.name rangeOfString:@"**"];
        if(range.length > 0) {
            cell.labName.text = [file.name substringToIndex:range.location];
            
        }else {
            cell.labName.text = file.name;
        }
         */

        cell.labDate.text = file.datatime;
        cell.labSize.text = [NSString getAutoKBorMBNumber:file.size];
        cell.file = file;
        
        if (file.type == kVideoFile) {
            
            
            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_video"]];
                
            }
            
            
        }else if (file.type == kPhotoFile) {
            
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_picture"]];
                
            }

            
        }else if (file.type == kVoiceFile) {
            
            /*
            NSRange  range =  [file.name rangeOfString:@"("];
            if(range.length > 0) {
                cell.labName.text = [file.name substringToIndex:range.location];
                
            }else {
                cell.labName.text = file.name;
            }
            */
            [cell.imageTitle setImage:[UIImage imageNamed:@"111"]];
        }
        else {
            
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_other"]];
        }
        
        if (file.downStatus == ZIPFILE_DOWNLOADED ) {

            cell.labErrorMessage.text = @"已完成";
            cell.progressView.progress = 1.0;
            
        }
        else if (file.downStatus == ZIPFILE_DOWNLOADING){
            
            cell.labErrorMessage.text = @"下载中(点击暂停)";
            cell.progressView.progress = [file.receivedSize floatValue] / [file.size floatValue];
            
        }else {
            cell.labErrorMessage.text = @"暂停中(点击继续下载)";
            cell.progressView.progress = [file.receivedSize floatValue] / [file.size floatValue];
        }
        
       tableView.userInteractionEnabled = YES; 
    }
    
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
     
}

//数据源委托
#pragma mark -
#pragma mark table delegate methods

//在某行被选中前调用，返回nil表示该行不能被选中；另外也可返回重定向的indexPath，使选择某行时会跳到另一行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //实现的效果是：每行点中以后变蓝色，并且马上蓝色消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//在弹出警告后自动取消选中表视图单元
    
    if (_files.count == 0) {
        
    }else {
        
        int  descIndex = _files.count - indexPath.row - 1;
        
        FileModel * file = [_files objectAtIndex:descIndex];
        fileStr = file;
//        DownloadFile * down = [_downloadeRequest objectForKey:file.serverFileId];
        
        if (file.downStatus == ZIPFILE_DOWNLOADED) {
            if (file.type == kVoiceFile ||file.type == kVideoFile || file.type == kPhotoFile){
                UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开",@"发送到...", nil];
                [actionsheet showInView:self.view];
                actionsheet.tag =10;
                actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            }
//            else {
//                UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开",@"发送到...", nil];
//                [actionsheet showInView:self.view];
//                actionsheet.tag = 20;
//                actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//            }
            
        }
        else if (file.downStatus != ZIPFILE_DOWNLOADED)
        {
            //暂停下载
           [self getDownloadedSize:file];
           DownloadCell * cell = (DownloadCell *)[tableView viewWithTag:indexPath.row + 1000];
           DownloadFile * down = [_downloadeRequest objectForKey:file.serverFileId];
           [cell changeDownLoadStatus:tableView andDownLoadFile:down delegate:self];
        }
    }
}
-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}

-(void)sendToAppWithFileModel:(FileModel *)file
{
    NSString * tempPath = file.targetName;
    NSURL *URL = [NSURL fileURLWithPath:tempPath];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Present Open In Menu
        [self.documentInteractionController presentOpenInMenuFromRect:[self.view frame] inView:self.view animated:YES];
}
    
    
}
 
-(void)saveDatotoPhotosAlbumWithFile:(FileModel *)file
{
    if (file.type == kPhotoFile){
        UIImage *image = [UIImage imageWithContentsOfFile:file.targetName];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

    }else if(file.type == kVideoFile|| file.type == kVoiceFile){
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:file.targetName]){
//            NSString *str = [file.targetName substringWithRange:NSMakeRange(0, file.targetName.length-4)];
//            NSString *newName = [NSString stringWithFormat:@"%@.mp3",str];
//            [manager copyItemAtPath:file.targetName toPath:newName error:nil];
//            NSLog(@"%@----%@",file.targetName,newName);
        UISaveVideoAtPathToSavedPhotosAlbum(file.targetName,self, @selector(video:didFinishSavingWithError:contextInfo:), nil);

        }
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
     NSString *msg = nil ;
     if(error != NULL){
         msg = @"保存图片失败，请稍候重试" ;
     }else{
         msg = @"图片已成功保存到手机相册中，您可以在相册中查看该图片" ;
     }
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
     [alert show];
 }
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"文件保存失败，请稍候重试";
    }else{
        msg = @"文件已成功保存至手机相册中，您可以在相册中查看该文件" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10){
    if (buttonIndex == 0){
        Preview * preview = [[Preview alloc] initWithControler:self andFileModel:fileStr];
        preview.delegate = self;
        [preview initialize];
    }else if(buttonIndex == 1){
        [self sendToAppWithFileModel:fileStr];
    }else if(buttonIndex == 2){
        [self saveDatotoPhotosAlbumWithFile:fileStr];
    }else if (buttonIndex == 3){
        
    }
    }else if (actionSheet.tag == 20){
        if (buttonIndex == 0){
            Preview * preview = [[Preview alloc] initWithControler:self andFileModel:fileStr];
            preview.delegate = self;
            [preview initialize];
        }else if(buttonIndex == 1){
            [self sendToAppWithFileModel:fileStr];
        }else {
            
        }
    }
}
//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _innerView) {
        return 45.0f;
    }
    return HEIGHT_FOR_LOADHISTORY_TABLEVIEW_CELL;
//    NSLog(@"HEIGHT_FOR_LOADHISTORY_TABLEVIEW_CELL %d",HEIGHT_FOR_LOADHISTORY_TABLEVIEW_CELL);
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

#pragma DownloadDelegate methods
- (void)notificationError:(ASIHTTPRequest *)request message:(NSString *)message
{
    FileModel * file = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(handleMessageCellOnMainThread:) withObject:file waitUntilDone:YES];
}
- (void)notificationUpdateCellProgress:(ASIHTTPRequest *)request
{
    FileModel * file = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(handleUpdateCellOnMainThread:) withObject:file waitUntilDone:YES];
}
- (void)notificationFinish:(ASIHTTPRequest *)request
{
    FileModel * file = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(handleUpdateCellFinished:) withObject:file waitUntilDone:YES];
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

#pragma mark db methods 
- (NSMutableArray *)queryAllModels
{
    
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where actiontype = 1 and uid = %@",user.uid];
    debugLog(sql);
    
    FMResultSet * result =  [db query:sql];
    while (result.next) {
        
        
        BOOL isExist = NO;
        FileModel * file = [[FileModel alloc]init];
        file.fid = [NSString stringWithFormat:@"%d",[result intForColumn:@"id"]];
        file.name = [result stringForColumn:@"name"];
        file.targetName = [result stringForColumn:@"targetname"];
        NSLog(@"-----%@",[result stringForColumn:@"targetname"]);
        file.size = [result stringForColumn:@"size"];
        file.downStatus = [result intForColumn:@"status"];
        file.type = [result intForColumn:@"type"];
        file.srcid = [result stringForColumn:@"srcid"];
        file.actionType = [result intForColumn:@"actiontype"];
        file.datatime = [result stringForColumn:@"datatime"];
        file.serverFileId = [result stringForColumn:@"serverFIleId"];
        file.isEncrypt    = [result intForColumn:@"isEncrypt"];
        
        if (file.downStatus != ZIPFILE_DOWNLOADED) {
            
            file.isDownLoading = NO;
            file.downStatus = ZIPFILE_DOWNLOAD_NO;
        }
        
        //判断全局Model中知否已经存在一个相同serverFileId
        if (_app.fileModels.count > 0) {
        
            for (FileModel * tmpModel in _app.fileModels){
                
                if ([tmpModel.serverFileId isEqualToString:file.serverFileId]) {
                    isExist = YES;
                    
                    //修改全局类中的isEncrypt状态
                    tmpModel.isEncrypt = file.isEncrypt;
                }
            }
            
            if (!isExist) {
                
                [_app.fileModels addObject:file];
            }
            
        }else {
            
            [_app.fileModels addObject:file];
        }
        
    }
    
    [db close];
    
    
    //心插入排序算法
    
    
    [_app.fileModels sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        FileModel * model1 = (FileModel *)obj1;
        FileModel * model2 = (FileModel *)obj2;
        
        if ([model1.fid integerValue] < [model2.fid integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([model1.fid integerValue]> [model2.fid integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
        
    }];
    
    return _app.fileModels;
}
- (void)delete:(NSString *)serverId
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"Delete from FileModel where serverFIleId = ?";
    NSArray * pars = [NSArray arrayWithObject:serverId];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
}
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 234) {
        if (buttonIndex == 1) {
            [self deleteFileModel:tmpFileModel];
            //add by liwzh 初始化下载model
            tmpFileModel.downStatus = ZIPFILE_DOWNLOADING;
            tmpFileModel.receivedSize = nil;

            [DownloadFile launchRequest:tmpFileModel immediately:YES];
            
            _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [self queryAllModels];
            
            _downloadeRequest = _app.downloadRequest;
            _files = _app.fileModels;
            
            [self.myTableView reloadData];
            
          

        }
        
    }else{
//    CATransition * animation = [CATransition  animation];
//    animation.delegate = self;
//    animation.duration = 0.3f;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromTop;
//    [_viewDrop setAlpha:0.0f];
//    [_viewDrop.layer addAnimation:animation forKey:@"pushOut"];
//    [_viewDrop performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];

    if(alertView == _alertRecoverAll) {
        int index = alertView.tag;
        
        if (index == 0) {
            
            //清空全部
            if (buttonIndex == alertView.firstOtherButtonIndex)
            {
                if (_files.count == 0){
                    
                }else {
                   [self deleteAll]; 
                }
                
            }
            
        }
        return;
    }
    }
}
- (void)deleteAll
{   
    
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"Delete from FileModel where actiontype = 1 and uid = %@",user.uid];
    
    
    NSArray * pars = [NSArray arrayWithObject:user.uid];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
    
    //先取消掉说有的下载
    NSArray * allkey = [_app.downloadRequest allKeys];
    for (int i = 0; i < allkey.count; i++) {
        
        int indexPath = allkey.count - i - 1;
        
        DownloadFile * down = [_app.downloadRequest objectForKey:[allkey objectAtIndex:indexPath]];
        [down cancel];

        //删除ASI 缓存文件
        
        FileModel * file = [_files objectAtIndex:indexPath];
        NSString * tempPath = [[Sandbox libCachePath]
                               stringByAppendingPathComponent:file.name];
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        if ([manager fileExistsAtPath:tempPath]) {
            
            [manager removeItemAtPath:tempPath error:&error];
            
            if (error) {
                debugLog([error description]);
            }
        }

    }
    

    [_app.fileModels removeAllObjects];
    [_app.downloadRequest removeAllObjects];
    
    [_myTableView reloadData];
}
- (void)updateDownStatusFinish:(NSString *)serverId
{
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"update FileModel set status = ? where serverFIleId = ? and actiontype = 1 and uid = ?";
    
    NSArray * pars = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],serverId,user.uid,nil];
    
    NSString * logstr = [NSString stringWithFormat:@"update FileModel set status = 2 where serverFIleId = %@ and actiontype = 1 and uid = %@",serverId,user.uid];
    debugLog(logstr);
    
    [db update:sql parameter:pars];
    
    [db close];
    
}

- (void)playingDone:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    switch ([[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue]) {
        case MPMovieFinishReasonUserExited:
            NSLog(@"用户点击完成");
            
            [self dismissMoviePlayerViewControllerAnimated];
            break;
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"自动播放完成");
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"播放出错");
            //            [self  alertWithMessage:@"播放失败,文件出错"];
            break;
        default:
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
            break;
    }
}

#pragma UIDocumentInteractionControllerDelegate methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}
- (void)handleOtherFile:(FileModel *)file
{
    NSString * urlName = file.targetName;
    [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL fileURLWithPath:urlName];
    
    NSLog(@"urlstring %@",file.targetName);
    
    
    if (_docInteractionController == nil)
    {
        _docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        
        _docInteractionController.delegate = self;
    }
    else
    {
        _docInteractionController.URL = url;
    }
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    //    [_docInteractionController presentOptionsMenuFromRect:navRect inView:_controler.view  animated:YES];
    [_docInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
}

@end

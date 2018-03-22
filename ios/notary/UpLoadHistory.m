//
//  UpLoadHistory.m
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UpLoadHistory.h"
#import "UpLoadHistoryCell.h"

#define HEIGHT_FOR_LOADHISTORY_TABLEVIEW_CELL 80

@interface UpLoadHistory ()
{
    int tag;
}

@end

@implementation UpLoadHistory

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self queryAllModels];//会将数据库中的上传信息加入全局集合中
    
    _uploadeRequest = _app.uploadSocket;
    _files = _app.uploadArray;
    
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_bg_one"]];
    _innerView.backgroundView = imageView;
    
    [self makeView];
}

- (void)makeView
{
    self.title = @"上传记录";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
    customRight.frame = CGRectMake(0, 0, 60, 40);
    customRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [customRight addTarget:self action:@selector(handleEditItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    [customRight setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [customRight setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [customRight setTitle:@"清除全部" forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
    self.navigationItem.rightBarButtonItem = rightButton;
    [_viewDrop setCenter:CGPointMake(282, 25)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)handleEditItemClick:(UIButton *)but
{
    _alertRecoverAll = [[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:@"确定要清空全部？"
                        delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertRecoverAll.delegate = self;
    _alertRecoverAll.tag = 0;
    [_alertRecoverAll show];
}
#pragma mark -
#pragma mark 编辑删除清空
- (void)noneBtnClick
{
//    NSLog(@"清空");
//    [_dataSourceArr removeAllObjects];
//    [self.myTableView reloadData];
}

- (void)doneBtnClick
{
//    [self.myTableView setEditing:NO animated:YES];
    [self.navigationItem setRightBarButtonItems:_barBtnItemEditArr animated:YES];
}

- (void)editBtnClick
{
 [self.navigationItem setRightBarButtonItems:_barBtnItemDoneArr animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _innerView) {
        return 50.0f;
    }
    
    return 65.0f;

}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//这个方法用来告诉表格 这一行是否可以移动换行
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"BOOL");
    
    return YES;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSLog(@"void");
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [_dataSourceArr objectAtIndex:fromRow];
    [_dataSourceArr removeObjectAtIndex:fromRow];
    [_dataSourceArr insertObject:object atIndex:toRow];
}

//这个方法根据参数editingStyle是UITableViewCellEditingStyleDelete
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)     {
    
        
        FileModel * file = [_files objectAtIndex:indexPath.row];
        
        //停止上传
        UpLoadContinue * upload = [_app.uploadSocket objectForKey:file.md5];
        [upload cancel];
        
        //删除数据库
        [self delete:file.fid];
        
        [_app.uploadSocket removeObjectForKey:file.md5];
        [_app.uploadArray removeObject:file];
        
        [tableView reloadData];
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
        incell.textLabel.font = [UIFont systemFontOfSize:11];
        incell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        if (indexPath.row == 0){
            incell.textLabel.text = @"清除全部";
        }        
        return incell;
    }

    
    static NSString *CellIdentifier = @"default";
    
    UpLoadHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"UpLoadHistoryCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    
    cell.tag = indexPath.row + 10000;
    
    
    if (_files.count == 0) {
        
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"当前没有上传记录";
        
        cell.labFinishMessage.hidden = YES;
        cell.labDate.hidden = YES;
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.progressView.hidden = YES;
        cell.imageTitle.hidden = YES;
        tableView.userInteractionEnabled = NO;
        
    }else {
        
        tableView.userInteractionEnabled = YES;
        
        NSFileManager * manager = [NSFileManager defaultManager];
        
        FileModel * file = [_files objectAtIndex:indexPath.row];
        
        UpLoadContinue * upload = [_uploadeRequest objectForKey:file.md5];
        if (nil != upload) {
            upload.delegate = self;
        }
        
        
        cell.file = file;
        cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
        cell.labDate.text = file.datatime;
        cell.labSize.text = [NSString getAutoKBorMBNumber:file.size];        

        
        if (file.type == kVideoFile) {
            
            
            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.srcid]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_video"]];
                
            }
    
            
        }else if (file.type == kPhotoFile) {
            
            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.srcid]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_picture"]];
                
            }

            
        }else if (file.type == kVoiceFile) {
            
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_call"]];
        }

        if (file.downStatus == ZIPFILE_DOWNLOAD_NO) {
            
//            cell.progressView.progress = 1.0f;
            cell.progressView.progressTintColor = [UIColor grayColor];
            cell.labFinishMessage.text = @"等待上传";
        }
        else if (file.downStatus == ZIPFILE_DOWNLOADING) {
            
            cell.progressView.progress = [file.receivedSize floatValue] / [file.size floatValue];
            cell.labFinishMessage.text = @"文件上传中";
        }
        else if (file.downStatus == ZIPFILE_DOWNLOADED) {
            
//            cell.progressView.hidden = YES;

            cell.progressView.progress = 1.0;
            cell.labFinishMessage.text = @"上传完成";
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    if (tableView == _innerView) {
        
        if (indexPath.row == 0){
            
            _alertRecoverAll = [[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"确定要清空全部"
                                delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _alertRecoverAll.delegate = self;
            _alertRecoverAll.tag = indexPath.row;
            [_alertRecoverAll show];
            
        }
        
        return;
    }
    if (_files.count == 0)
    {
        
    }
    else
    {
        FileModel * file = [_files objectAtIndex:indexPath.row];
        UpLoadContinue * upload = [_uploadeRequest objectForKey:file.md5];
        
        if (file.downStatus == ZIPFILE_DOWNLOADED)
        {
            
        }
        else if (file.downStatus != ZIPFILE_DOWNLOADED)
        {
            UpLoadHistoryCell * cell = (UpLoadHistoryCell *)[tableView viewWithTag:indexPath.row + 10000];
            [cell changeUploadStatus:tableView andUploadFile:upload delegate:self];
            tag = cell.tag;

        }
    }
    
}
//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}


- (void)viewDidUnload {
//    [self setMyTableView:nil];
    [super viewDidUnload];
}


#pragma mark db methods
- (NSMutableArray *)queryAllModels
{
    
    UserModel * user = [UserModel sharedInstance];
    NSMutableArray * models = [[NSMutableArray alloc]init];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where actiontype = 0 and uid = %@ order by id DESC",user.uid] ;
    debugLog(sql);
    
    FMResultSet * result =  [db query:sql];
    while (result.next) {
        
        BOOL isExist = NO;
        FileModel * file = [[FileModel alloc]init];
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
        file.isEncrypt    = [result intForColumn:@"isEncrypt"];
        file.folderId = [result stringForColumn:@"targetFolderId"];
        file.md5 = [result stringForColumn:@"md5"];
        
        //需要path这个
        NSURL * url = [NSURL URLWithString:file.targetName];
        file.path = url;
        
        if (file.downStatus != ZIPFILE_DOWNLOADED) {
            
            file.isDownLoading = NO;
            file.downStatus = ZIPFILE_DOWNLOAD_NO;
        }
        
        if (_app.uploadArray.count > 0) {
            
            for (FileModel * tmpModel in _app.uploadArray)
            {
                if ([tmpModel.md5 isEqualToString:file.md5]) {
                    
                    isExist = YES;
                    //修改全局类中的isEncrypt状态
                    tmpModel.isEncrypt = file.isEncrypt;
                    tmpModel.fid = file.fid;
                }
            }
            
            if (!isExist) {
                
                [_app.uploadArray addObject:file];
            }
            
        }
        else
        {
            [_app.uploadArray addObject:file];

        }
        
        [models addObject:file];
    }
            
    [db close];
    
    return _app.uploadArray;
}
- (void)delete:(NSString *)fid
{
    //进入上传记录中都存在id 所以删除用id 就可以
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"Delete from FileModel where id = ?";
    NSArray * pars = [NSArray arrayWithObject:fid];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
    
    [self flush];
}
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CATransition * animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [_viewDrop setAlpha:0.0f];
    [_viewDrop.layer addAnimation:animation forKey:@"pushOut"];
    [_viewDrop performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];

    if(_alertRecoverAll == alertView) {
        
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

- (void)deleteAll{
    
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"Delete from FileModel where actiontype = 0 and uid = %@",user.uid];
    
    
    NSArray * pars = [NSArray arrayWithObject:user.uid];
    debugLog(sql);
    [db update:sql parameter:pars];
    
    [db close];
    
    
    NSArray * allkey = [_app.uploadSocket allKeys];
    for (int i = 0; i < allkey.count; i++)
    {
        UpLoadContinue * upload = [_app.uploadSocket objectForKey:[allkey objectAtIndex:i]];
        [upload cancel];
        
        //删除图片临时文件 待完成
        
    }
    
    [_app.uploadArray removeAllObjects];
    [_app.uploadSocket removeAllObjects];
    
    [_contentView reloadData];
//    [self flush];
}

- (void)flush
{
    _files = [self queryAllModels];
    [_contentView reloadData];
}


#pragma UploadContinueDelegate methods
- (void)notificationUploadStart:(FileModel *)file
{
    
}
- (void)notificationUploadPause:(FileModel *)file
{
    
}
- (void)notificationUploadFinished:(FileModel *)file
{
    [self performSelectorOnMainThread:@selector(handleUpdateCellFinished:) withObject:file waitUntilDone:YES];
}
- (void)notificationUploadFailed:(NSError *)error FileModel:(FileModel *)file
{
    [self performSelectorOnMainThread:@selector(handleUpdateCellOnError:) withObject:file waitUntilDone:YES];
}
- (void)notificationUploadProgress:(float)progress FileModel:(FileModel *)file
{
    [self performSelectorOnMainThread:@selector(handleUpdateCellOnMainThread:) withObject:file waitUntilDone:YES];
}
#pragma handl methods
- (void)handleUpdateCellOnError:(FileModel *)fileInfo
{
    for (id obj in _contentView.subviews)
    {
        if ([obj isKindOfClass:[UpLoadHistoryCell class]])
        {
            UpLoadHistoryCell * cell = (UpLoadHistoryCell *)obj;
            if (cell.file == nil) {
                
            }else{
            if ([fileInfo.md5 isEqualToString:cell.file.md5])
            {

                cell.labFinishMessage.text = @"等待上传";
                [cell changeUploadStatus:_contentView andUploadFile:nil delegate:self];

            }
            }
        }
    }
    [self flush];
 }
- (void)handleUpdateCellOnMainThread:(FileModel *)fileInfo
{
        for (id obj in _contentView.subviews)
        {
            if ([obj isKindOfClass:[UpLoadHistoryCell class]])
            {
                
                UpLoadHistoryCell * cell = (UpLoadHistoryCell *)obj;
                if (cell.tag == tag){
                if (cell.file == nil) {
                    
                }else{
                 
                     cell.progressView.progress = [fileInfo.receivedSize floatValue]/ [fileInfo.size floatValue];
                }
                }
            }
        }
    [_contentView reloadData];
}
- (void)handleUpdateCellFinished:(FileModel *)fileInfo
{
    for (id obj in _contentView.subviews)
    {
        if ([obj isKindOfClass:[UpLoadHistoryCell class]])
        {
            UpLoadHistoryCell * cell = (UpLoadHistoryCell *)obj;
            if (cell.tag == tag){
                if (cell.file == nil){
                    
                }else{
                cell.progressView.progress = 1.0;
                cell.labFinishMessage.text = @"上传完成";
            }
          }
       }
    }

    [_app.uploadSocket removeObjectForKey:fileInfo.md5];
    if ([_app.uploadArray containsObject:fileInfo]){
        [_app.uploadArray removeObject:fileInfo];
    }
    [self flush];
    
    //保存上传状态信息
    UserModel *user = [UserModel sharedInstance];
    NSString *plistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmx.plist",user.userID]];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
    NSMutableDictionary *doc = [dic objectForKey:fileInfo.name];
    NSLog(@"%@",doc);
    [doc setValue:fileInfo.folderName forKey:@"uploadState"];
    [dic setValue:doc forKey:fileInfo.name];
    [dic writeToFile:plistPath atomically:YES];
    //    NSLog(@"%@-----%@",dic,doc);

}
-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:fileName];
}
@end

//
//  SearchView.m
//  notary
//
//  Created by 肖 喆 on 13-4-9.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "SearchView.h"
#import "AppDelegate.h"
#import "ListProofCell.h"
#import "FileModel.h"
#import "PreviewView.h"
#import "Preview.h"
#import "ListProofView.h"
#import "NSString+Extension.h"

@interface SearchView ()

@end

@implementation SearchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    startIndex = 0;
    
    _fileArray = [[NSMutableArray alloc]init];
    _jsonData = [[NSMutableData alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索结果";
    
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }

    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
    if (_keyWord == nil || [_keyWord isEqualToString:@""]) {
        
        [_contentView reloadData];
        _contentView.hidden = NO;
        
    }else {
        
        [self requestFileList];
        
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
    [MobClick beginLogPageView:@"搜索"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"搜索"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleBackButtonClick:(UIButton *)but {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma UITableViewDelegate and UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_fileArray.count == 0 ) return;
    
    
    //加载更多
    if (_fileArray.count == indexPath.row) {
        
        
        if (isLoadFileList) return;
        
        startIndex += 10;
        
        [self requestFileList];
        
        return;
    }
    
    FileModel * file = [_fileArray objectAtIndex:indexPath.row];
    
    
    if (file.type == kFolderFile){
        
        ListProofView * listProof = [[ListProofView alloc] initWithNibName:@"ListProofView" bundle:nil];
        
        listProof.isSearchFrom = YES;
        
        FolderModel * folder = [[FolderModel alloc] init];
        folder.folderID = file.fid;
        folder.folderName = file.name;
        
        listProof.parentFolder = folder;
        [self.navigationController pushViewController:listProof animated:YES];
        
        return;
    }
    
    FileModel * tmp =  [self queryById:file.serverFileId];
    
    if (tmp.serverFileId != nil ) {
        
        if (tmp.downStatus != ZIPFILE_DOWNLOADED){
            
            UIAlertView * alert = [[UIAlertView alloc]
                                   initWithTitle:@"提示"
                                   message:@"文件下载中"
                                   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }else { //已经下载完成了
            
            /*
            PreviewView * preview = [[PreviewView alloc]init];
            preview.file = file;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:preview];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            */
            Preview *preview = [[Preview alloc] initWithControler:self andFileModel:tmp];
            preview.delegate = self;
            [preview initialize];
        }
        
        return;
    }
    else {  //提示开启新的下载
        
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"提示"
                               message:@"是否下载该文件"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               otherButtonTitles:@"确定", nil];
        alert.tag = indexPath.row;
        
        [alert show];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fileArray.count == 0 ){
        return 1;
    }
    if (_fileArray.count >= 10)
    {
        return _fileArray.count + 1;
    }
    return _fileArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListProofCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"ListProofCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    
    if (_fileArray.count == 0) {
        
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"您查找的数据不存在";
        
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.labTime.hidden = YES;
        cell.imageTitle.hidden = YES;
        tableView.userInteractionEnabled = NO;
        
    }
    
    else if (_fileArray.count == indexPath.row){
        //cont - 1  == row 所以这里不需要再count + 1
        
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"加载更多";
        
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.labTime.hidden = YES;
        cell.imageTitle.hidden = YES;
        //        tableView.userInteractionEnabled = NO;
        
    }
    
    else {
        
        tableView.userInteractionEnabled = YES;
        NSFileManager * manager =[ NSFileManager defaultManager];
        FileModel * file = [_fileArray objectAtIndex:indexPath.row];

        cell.labSize.text = [NSString getAutoKBorMBNumber:file.size];
        cell.labTime.text = file.datatime;


        
        if (file.type == kFolderFile) {
            
            //文件夹没有后缀名称 
            cell.labName.text = file.name;
            [cell.imageTitle setImage:[UIImage imageNamed:@"file_other"]];
            
        }
        
        else if (file.type == kVideoFile) {
            
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];

            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_video"]];
                
            }
             
        }
        else if (file.type == kPhotoFile) {
            
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];

            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_picture"]];
                
            }

            
        }
        else if (file.type == kVoiceFile) {
            
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_call"]];
        }
        else {
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_other"]];
        }
        
    }

    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  75.0f;
}

- (void)requestFileList
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:_keyWord forKey:@"searchStr"];
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"搜索:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"搜索:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SEARCH_URL];
    NSURL * url = [NSURL URLWithString:urls];
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [request setPostValue:_keyWord forKey:@"searchStr"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    [request setPostValue:sig forKey:@"sig"];
    
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestFolderListStart:)];
    [request setDidFailSelector:@selector(requestFolderListFail:)];
    [request setDidFinishSelector:@selector(requestFolderListFinish:)];
    [request setDidReceiveDataSelector:@selector(requestFolderListReceiveData:didReceiveData:)];
    
    [request startAsynchronous];
}

- (void)requestFolderListStart:(ASIHTTPRequest *)request
{
    logmessage;
    isLoadFileList = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
}
- (void)requestFolderListFail:(ASIHTTPRequest *)request
{
    [DejalBezelActivityView removeView];
}
- (void)requestFolderListFinish:(ASIHTTPRequest *)request
{
    [DejalBezelActivityView removeView];
    
    
//    [_fileArray removeAllObjects];
    
    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    NSLog(@"jsonDic %@",jsonDic);
    
    NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
    
    NSArray * folder = [dataDic objectForKey:@"folder"];
    if (folder.count > 0) {
        
        for (int i = 0; i <folder.count; i++){
            
            NSDictionary * tmp = [folder objectAtIndex:i];
            
            NSString * fileid = [tmp objectForKey:@"folderid"];
            NSString * filename = [tmp objectForKey:@"foldername"];
            NSString * time = [tmp objectForKey:@"createTime"];
            
            
            FileModel * file = [[FileModel alloc] init];
            file.fid = fileid;
            file.serverFileId = fileid;
            file.name = filename;
            file.datatime = time;
            file.type = kFolderFile;
            [_fileArray addObject:file];
        }
        
    }
    
    NSArray * files = [dataDic objectForKey:@"file"];
    
    for (int i = 0; i < files.count;i++) {
        
        NSDictionary * tmp = [files objectAtIndex:i];
        
        NSString * fileid = [tmp objectForKey:@"fileid"];
        NSString * filename = [[tmp objectForKey:@"filename"] lowercaseString];;
        NSString * size = [tmp objectForKey:@"size"];
        NSString * time = [tmp objectForKey:@"createTime"];

        FileModel * file = [[FileModel alloc] init];
        file.fid = fileid;
        file.serverFileId = fileid;
        file.name = filename;
        file.size = size;
        file.datatime = time;
        
        file.type = [FileModel getFileType:file.name];
        
        if (file.type == kVideoFile) {
            
            NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
            
            file.targetName = [[Sandbox videoPath] stringByAppendingPathComponent:cryptName];

            
        }else if (file.type == kPhotoFile) {
            
            NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
            
            file.targetName = [[Sandbox imagePath] stringByAppendingPathComponent:cryptName];

            
        }
        else if (file.type == kVoiceFile){
            
            NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
            
            file.targetName = [[Sandbox voicePath] stringByAppendingPathComponent:cryptName];
            file.type = kVoiceFile;
        }
        

        else {
          
            NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
            
            file.targetName = [[Sandbox otherFilePath] stringByAppendingPathComponent:cryptName];

        }

        
        [_fileArray addObject:file];
    }
//    self.photoURL != nil||![self.photoURL isEqualToString:@""]
//    if (files.count == 0 || folder.count == 0) {
//        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//        HomepageCell *cell=(HomepageCell *)[self.classTabelView cellForRowAtIndexPath:index];
//        cell.labMessage.hidden = NO;
//
//    }
    _contentView.hidden = NO;
    [_contentView reloadData];
    [_jsonData setLength:0];
    isLoadFileList = NO;
}
- (void)requestFolderListReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
    
}

#pragma mark db methods
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
    }
    [db close];
    
    return file;
    
}

#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    int index = alertView.tag;
    FileModel * file = [_fileArray objectAtIndex:index];
    
  
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            
            [DownloadFile launchRequest:file immediately:YES];
            
        }
    
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

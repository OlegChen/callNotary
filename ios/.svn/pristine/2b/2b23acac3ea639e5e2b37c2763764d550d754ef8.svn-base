//
//  NotaryView.m
//  notary
//
//  Created by 肖 喆 on 13-5-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "NotaryView.h"
#import "AppDelegate.h"

@interface NotaryView ()

//网络请求回调函数
- (void)requestStart:(ASIHTTPRequest *)request;
- (void)requestFail:(ASIHTTPRequest *)request;
- (void)requestFinish:(ASIHTTPRequest *)request;
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;

@end

@implementation NotaryView


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请公证";
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
    
    
    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
    customRight.frame = CGRectMake(0, 0, 51, 40);
    [customRight addTarget:self action:@selector(requestApply4Notary) forControlEvents:UIControlEventTouchUpInside];
    [customRight setImage:[UIImage imageNamed:@"btn_queding"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _jsonFolderList = [[NSMutableData alloc] init];
    _folderArray = [[NSMutableArray alloc]init];
    _subCells = [[NSMutableDictionary alloc] init];
    _jsonSubCells = [[NSMutableData alloc] init];
    _fileIds = [[NSMutableArray alloc] init];
    
    [self requestList];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self cancelAllRequest];
    
    _jsonFolderList = nil;
    _folderArray = nil;
    _subCells = nil;
    _jsonSubCells = nil;
    _fileIds = nil;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleBackButtonClick:(UIButton *)but {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Nested Tables methods

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    return _folderArray.count;
}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    
    NSMutableArray * temp = [_subCells objectForKey:folder.folderID];
    
    return temp.count;
}

//滑动tableview的时候会调用这个方法
- (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    item.groupCelldelegate = self;
    item.itemText.font = [UIFont fontWithName:DEFAULT_FONT size:15];
    item.itemText.text = folder.folderName;
    item.tag = indexPath.row;
    item.uniqueid = folder.folderID;
    
    NSString * folderImage = [self getFolderImageName:[folder.type integerValue]];
    [item.folderImage setImage:[UIImage imageNamed:folderImage]];
    
    return item;
}

- (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    subItem.itemText.text = [NSString stringWithFormat:@"My Sub Item %u", indexPath.row +1];
    
    NSMutableArray * temp = [_subCells objectForKey:item.uniqueid];
    FileModel * file = [temp objectAtIndex:indexPath.row];
    subItem.itemText.text = file.name;
    
    return subItem;
}

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
{
    SelectableCellState state = item.selectableCellState;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:item];
    switch (state) {
        case Checked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Checked\"", indexPath);
            break;
        case Unchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            break;
        case Halfchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Halfchecked\"", indexPath);
            break;
        default:
            break;
    }
}

- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
{
    

    
    SelectableCellState state = subItem.selectableCellState;
    NSIndexPath *indexPath = [item.subTable indexPathForCell:subItem];
    
    NSMutableArray * temp = [_subCells objectForKey:item.uniqueid];
    FileModel * file = [temp objectAtIndex:indexPath.row];
    
    switch (state) {
        case Checked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Checked\"", indexPath);
            
            if (![_fileIds containsObject:file.serverFileId]){
                [_fileIds addObject:file.serverFileId];
            }
            
            break;
        case Unchecked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            if ([_fileIds containsObject:file.serverFileId]){
                [_fileIds removeObject:file.serverFileId];
            }
            
            break;
        default:
            break;
    }
}
//经过改动之后 下面两个方法已经不调用
//展开
- (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Expanded Item at indexPath: %@", indexPath);
    
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    [self requestSubCells:folder];
}

//收回
- (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Collapsed Item at indexPath: %@", indexPath);
}
/*
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
	_reloading = YES;
    
    [self requestList];
	
}
- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}
*/
#pragma ASIHttpRequest handle method
- (void)requestList
{
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件夹列表:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件夹列表:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FOLDER_LIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    if (nil != _requestRefresh) {
        
        [_requestRefresh cancel];
        _requestRefresh.delegate = nil;
        _requestRefresh = nil;
    }
    
    _requestRefresh = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRefresh setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRefresh setPostValue:user.userID forKey:@"userID"];
    [_requestRefresh setPostValue:APP_ID forKey:@"app_id"];
    [_requestRefresh setPostValue:VERSIONS forKey:@"v"];
    [_requestRefresh setPostValue:@"1" forKey:@"src"];
    [_requestRefresh setPostValue:sig forKey:@"sig"];
    
    [_requestRefresh setDelegate:self];
    [_requestRefresh setDidStartSelector:@selector(requestStart:)];
    [_requestRefresh setDidFailSelector:@selector(requestFail:)];
    [_requestRefresh setDidFinishSelector:@selector(requestFinish:)];
    [_requestRefresh setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestRefresh startAsynchronous];
    
}
- (void)requestSubCells:(FolderModel *)folder
{
    UserModel * user = [UserModel sharedInstance];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:folder.folderID forKey:@"folderID"];

    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件夹下文件列表:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件夹下文件列表:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,GET_FOLDERLIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    //发送新请求之前取消之前的请求
    if (nil != _requestSubCells){
        
        [_requestSubCells clearDelegatesAndCancel];
        _requestSubCells = nil;
    }
    
    [_jsonSubCells setLength:0];
    
    _requestSubCells = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestSubCells setPostValue:user.userID forKey:@"userID"];
    [_requestSubCells setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestSubCells setPostValue:folder.folderID forKey:@"folderID"];
    [_requestSubCells setPostValue:@"1" forKey:@"src"];
    [_requestSubCells setPostValue:APP_ID forKey:@"app_id"];
    [_requestSubCells setPostValue:VERSIONS forKey:@"v"];
    [_requestSubCells setPostValue:sig forKey:@"sig"];
    [_requestSubCells setUserInfo:[NSDictionary dictionaryWithObject:folder forKey:@"Folder"]];

    NSString * logurl = [NSString stringWithFormat:@"列表: %@?userID=%@&folderID=%@",urls,user.userID,folder.folderID];
    debugLog(logurl);
    
    
    [_requestSubCells setDelegate:self];
    [_requestSubCells setDidStartSelector:@selector(requestStart:)];
    [_requestSubCells setDidFailSelector:@selector(requestFail:)];
    [_requestSubCells setDidFinishSelector:@selector(requestFinish:)];
    [_requestSubCells setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestSubCells startAsynchronous];

}
- (void)requestApply4Notary
{
    if (_fileIds.count == 0){
       
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择需要申请公证的文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }

    NSMutableString * ids = [[NSMutableString alloc]init];

    for (int i = 0; i < _fileIds.count; i++){
        
        NSString * fileid = [_fileIds objectAtIndex:i];
        
        if (i == _fileIds.count - 1 ) {
            
            [ids appendFormat:@"%@",fileid];
            
        }else {
            
          [ids appendFormat:@"%@,",fileid];  
        }
        
    }
    
    NSString * idslog = [NSString stringWithFormat:@"申请公证ids:%@",ids];
    debugLog(idslog);
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:ids forKey:@"fileIDs"];
    
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"立即公正:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"立即公正:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,APPLYGZ_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"立即公正:%@%@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&fileIDs=%@&sig=%@",ROOT_URL,APPLYGZ_URL,user.userID,user.phoneNumber,APP_ID,VERSIONS,ids,sig];
    debugLog(logurl);
    
    _requestApplygz = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestApplygz setPostValue:user.userID forKey:@"userID"];
    [_requestApplygz setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestApplygz setPostValue:@"1" forKey:@"src"];
    [_requestApplygz setPostValue:APP_ID forKey:@"app_id"];
    [_requestApplygz setPostValue:VERSIONS forKey:@"v"];
    [_requestApplygz setPostValue:ids forKey:@"fileIDs"];
    [_requestApplygz setPostValue:sig forKey:@"sig"];
    
    [_requestApplygz setDelegate:self];
    [_requestApplygz setDidStartSelector:@selector(requestStart:)];
    [_requestApplygz setDidFailSelector:@selector(requestFail:)];
    [_requestApplygz setDidFinishSelector:@selector(requestFinish:)];
    [_requestApplygz setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestApplygz startAsynchronous];
}
- (void)cancelAllRequest
{
    if (_requestRefresh != nil) {
        
        [_requestRefresh clearDelegatesAndCancel];
        _requestRefresh = nil;
    }
    if (_requestSubCells != nil){
        
        [_requestSubCells clearDelegatesAndCancel];
        _requestSubCells = nil;
        
    }
    if (_requestApplygz != nil) {
        
        [_requestApplygz clearDelegatesAndCancel];
        _requestApplygz = nil;
    }

}
- (void)autoExpendCell:(NSString *)fid
{

    
    for (id obj in self.tableView.subviews) {
        
        if ([obj isKindOfClass:[SDGroupCell class]])
        {
            SDGroupCell * cell = (SDGroupCell *)obj;
            
            if ([cell.uniqueid isEqualToString:fid]) {
                
                NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
                if (nil != indexPath) {
                [super autoExpanded:indexPath];
                [cell autoExpandCells];
                }
            }
        }
    }

}
- (NSString *)getFolderImageName:(NSInteger)type
{
    
    NSString * name = nil;
    if (type == 0) {
        name = @"file_other";
    }else if (type == 1) {
        name = @"file_call";
    }else if (type == 2) {
        name = @"file_recording";
    }else if (type == 3) {
        name = @"file_picture";
    }else if (type == 4) {
        name = @"file_video";
    }else if (type == 5) {
        name = @"file_other";
    }else {
        name = @"file_other";
    }
    
    return name;
}
#pragma ASIHttpRequest Delegate methods
- (void)requestStart:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    }
    else if (request == _requestSubCells)
    {
        
    }
    else if (request == _requestApplygz)
    {
        
    }

    
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        [DejalBezelActivityView removeView];
        
    }
    else if (request == _requestSubCells)
    {
        
    }
    else if (request == _requestApplygz)
    {
        
    }
}
- (void)requestFinish:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        [_folderArray removeAllObjects];
        
        NSDictionary * jsonDic = [_jsonFolderList objectFromJSONData];
        
        NSArray * array = [jsonDic objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i ++) {
            
            NSDictionary * tmp = [array objectAtIndex:i];
            NSString * dataNum = [tmp objectForKey:@"dataNum"];
            NSString * folderID = [tmp objectForKey:@"folderID"];
            NSString * folderName = [tmp objectForKey:@"folderName"];
            NSString * type = [tmp objectForKey:@"type"];
            
            FolderModel * folder = [[FolderModel alloc] init];
            folder.dataNum = dataNum;
            folder.folderID = folderID;
            folder.folderName = folderName;
            folder.type = type;
            
            
            if ([@"回收站" isEqualToString:folderName]){
                
                
            }
            else {
                
                [_folderArray addObject:folder];
                
            }
            
//            NSString * logstr = [NSString stringWithFormat:@"ListFloder: folderID(%@),folderName(%@),folderType(%@),dataNum(%@)",folder.folderID,folder.folderName,folder.type,folder.dataNum];
//            
//            debugLog(logstr);
        }
        
        
        [DejalBezelActivityView removeView];
        [self.tableView reloadData];
        [_jsonFolderList setLength:0];
        
//        [self doneLoadingTableViewData];
        
    }
    else if (request == _requestSubCells)
    {
        FolderModel * folder = [request.userInfo objectForKey:@"Folder"];
        
        NSDictionary * jsonDic = [_jsonSubCells objectFromJSONData];
        
        debugLog([jsonDic description]);
        
        NSArray * array = [jsonDic objectForKey:@"data"];
        NSMutableArray * files = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary * temp = [array objectAtIndex:i];
            NSString * type =     [temp objectForKey:@"type"];
            //folderID这个变量有歧义，服务器返回的是文件的id，或者文件夹的id
            //根据返回的信息不能判断出 文件属于那个文件夹下,所以还原的时候，也就无法本地更新
            //ProofView列表中的数量图标
            NSString * folderID = [temp objectForKey:@"folderID"];
            NSString * fName    = [temp objectForKey:@"fName"];
            NSString * size     = [temp objectForKey:@"size"];
            NSString * time =     [temp objectForKey:@"createTime"];
            
            
            if ([type intValue] == 1) {  //1文件 0文件夹
                
                FileModel * file = [[FileModel alloc] init];
                file.name = fName;
                file.size = size;
                file.datatime = time;
                file.folderId = folder.folderID;
                file.serverFileId = [NSString stringWithFormat:@"%d",[folderID intValue]];     //证据列表返回的folderID 就是 serverFileId
                
                
                if ([file.name hasSuffix:@"mov"]) {
                    
                    NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                    
                    file.targetName = [[Sandbox videoPath] stringByAppendingPathComponent:cryptName];
                    file.type = kVideoFile;
                    
                }else if ([file.name hasSuffix:@"png"]) {
                    
                    NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                    
                    file.targetName = [[Sandbox imagePath] stringByAppendingPathComponent:cryptName];
                    file.type = kPhotoFile;
                    
                }else {
                    
                    NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                    
                    file.targetName = [[Sandbox voicePath] stringByAppendingPathComponent:cryptName];
                    file.type = kVoiceFile;
                }
                
                [files addObject:file];
                
            }
            
        }//end for
        
        [_subCells setObject:files forKey:folder.folderID];
        
        [_jsonSubCells setLength:0];

        [self.tableView reloadData];
        [self autoExpendCell:folder.folderID];

    }
    else if (request == _requestApplygz)
    {
        
    }

}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (request == _requestRefresh) {
        
        [_jsonFolderList appendData:data];
        
    }
    else if (request == _requestSubCells)
    {
        FolderModel * folder = [request.userInfo objectForKey:@"Folder"];
        [_jsonSubCells appendData:data];
    }
    else if (request == _requestApplygz)
    {
        NSDictionary * jsonDic = [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
        NSDictionary  * data = [jsonDic objectForKey:@"data"];
        NSLog(@"%@",jsonDic);
        
        if ([code intValue] == 0) {
            
            NSString * message = [data objectForKey:@"tipText"];

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        }else {
            [self alertMessage:codeInfo];
        }

        
    }
}
- (void)alertMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //清空全部
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        
 
    }

}

#pragma SDGroupCellDelegate method
-(void)notificationExpendButtonClick:(NSInteger)index isExpend:(BOOL)isExpend
{
    
    NSString * log = [NSString stringWithFormat:@"选中行index %d",index];
    debugLog(log);
    
    FolderModel * folder = [_folderArray objectAtIndex:index];
    
    NSArray * cells = [_subCells objectForKey:folder.folderID];
    if (cells && cells.count != 0) {
        [self autoExpendCell:folder.folderID];
    }
    else
    {
        [self requestSubCells:folder];
    }
    
}
@end

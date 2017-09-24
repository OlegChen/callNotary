//
//  ChecProofListView.m
//  notary
//
//  Created by 肖 喆 on 13-9-23.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ChecProofListView.h"
#import "ChecProofListCell.h"
#import "ZSYPopoverListView.h"
#import "AppDelegate.h"
@interface ChecProofListView ()
@property(nonatomic,retain) NSIndexPath *selectedIndexPath;

@end

@implementation ChecProofListView
@synthesize selectedIndexPath=_selectedIndexPath;
@synthesize listView;
@synthesize allDataArr;

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
    
    
    //点击确定按钮所触发的事件
     UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
     customRight.frame = CGRectMake(0, 0, 51, 40);
     [customRight addTarget:self action:@selector(requestApply4Notary) forControlEvents:UIControlEventTouchUpInside];
     [customRight setImage:[UIImage imageNamed:@"btn_queding"] forState:UIControlStateNormal];
     
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
     self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    [self requestFileList];
    
}

- (void)handleBackButtonClick:(UIButton *)but {
    
    [self cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancel
{
    if (self.request != nil){
        [self.request cancel];
        [self.request setDelegate:nil];
        self.request = nil;
    }
    if (self.requestApplygz != nil){
        [self.requestApplygz cancel];
        [self.requestApplygz setDelegate:nil];
        self.requestApplygz = nil;
    }
}
#pragma UITableViewDelegate and UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileModel * file = [self.contentArray objectAtIndex:indexPath.row];
    
    
    if (file.isFolder){
        
        
        FolderModel * parentFolder = [[FolderModel alloc]init];
        parentFolder.folderID = file.serverFileId;
        
        ChecProofListView * checkview = [[ChecProofListView alloc] init];
        
        checkview.rootFolder = self.rootFolder;
        checkview.parentFolder = parentFolder;
        
        
        [self.navigationController pushViewController:checkview animated:YES];
        
        
    }else {
        
        if (file.isAlreadySubmit){
            
            return;
            
        }
        
        else if ([self.fileIds containsObject:file])
        {
            [self.fileIds removeObject:file];
            
        }else {
            
            [self.fileIds addObject:file];
        }
        
    [self.contentView reloadData];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FileModel * file = [self.contentArray objectAtIndex:indexPath.row];
    
    ChecProofListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"ChecProofListCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    
    if (file.isFolder){
        
        cell.labFileName.hidden = YES;
        cell.imageCheck.hidden = YES;
        
        cell.labFolderName.text = file.name;
        
    }else {
        
        cell.labFolderName.hidden = YES;
        cell.imageIcon.hidden = YES;
        cell.labFileName.text = file.name;
        
        if (file.isAlreadySubmit){
            
            [cell.imageCheck setImage:[UIImage imageNamed:@"checked_gray"]];
        }
        
        else if ([self.fileIds containsObject:file]){
            [cell.imageCheck setImage:[UIImage imageNamed:@"check"]];
        }
        
    }

    return cell;
}

- (void)requestFileList
{
    self.jsonData = [[NSMutableData alloc]init];
    self.contentArray = [[NSMutableArray alloc]init];
    self.fileIds = [[NSMutableArray alloc]init];
    startIndex = 0;

    
    
    
    UserModel * user = [UserModel sharedInstance];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:_parentFolder.folderID forKey:@"folderID"];
    if([_parentFolder.folderName isEqualToString:@"回收站"]) {
        [dic setObject:@"0" forKey:@"folderType"];
    }
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件夹下文件列表:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件夹下文件列表:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,GET_FOLDERLIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_request setPostValue:user.userID forKey:@"userID"];
    [_request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_request setPostValue:_parentFolder.folderID forKey:@"folderID"];
    [_request setPostValue:@"1" forKey:@"src"];
    [_request setPostValue:APP_ID forKey:@"app_id"];
    [_request setPostValue:VERSIONS forKey:@"v"];
    [_request setPostValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    [_request setPostValue:sig forKey:@"sig"];
    
    //如果是回收站
    if([_parentFolder.folderName isEqualToString:@"回收站"]) {
        
        [_request setPostValue:@"0" forKey:@"folderType"];
        
        NSString * logstr = [NSString stringWithFormat:@"回收站列表: %@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&folderID=%@&folderType=%@&startIndex=%d&sig=%@",urls,user.userID,user.phoneNumber,APP_ID,VERSIONS,_parentFolder.folderID,@"0",startIndex,sig];
        debugLog(logstr);
    }else {
        
        NSString * logstr = [NSString stringWithFormat:@"列表: %@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&folderID=%@&startIndex=%d&sig=%@",urls,user.userID,user.phoneNumber,APP_ID,VERSIONS,_parentFolder.folderID,startIndex,sig];
        debugLog(logstr);
    }
    
    [_request setDelegate:self];
    [_request setDidStartSelector:@selector(requestFolderListStart:)];
    [_request setDidFailSelector:@selector(requestFolderListFail:)];
    [_request setDidFinishSelector:@selector(requestFolderListFinish:)];
    [_request setDidReceiveDataSelector:@selector(requestFolderListReceiveData:didReceiveData:)];
    
    [_request startAsynchronous];
}

- (void)requestFolderListStart:(ASIHTTPRequest *)request
{
    logmessage;
//    isLoadFileList = YES;
    [DejalActivityView activityViewForView:self.view withLabel:@"加载数据中..."];
}
- (void)requestFolderListFail:(ASIHTTPRequest *)request
{
    
    [DejalActivityView removeView];
}
- (void)requestFolderListFinish:(ASIHTTPRequest *)request
{
    
    
    //    [_fileArray removeAllObjects];
    
    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    
    
    NSArray * array = [jsonDic objectForKey:@"data"];
    
    
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary * temp = [array objectAtIndex:i];
        NSString * type =     [temp objectForKey:@"type"];
        //folderID这个变量有歧义，服务器返回的是文件的id，或者文件夹的id
        //根据返回的信息不能判断出 文件属于那个文件夹下,所以还原的时候，也就无法本地更新
        //ProofView列表中的数量图标
        NSString * folderID = [temp objectForKey:@"folderID"];
        NSString * fName    = [[temp objectForKey:@"fName"] lowercaseString];
        NSString * size     = [temp objectForKey:@"size"];
        NSString * time =     [temp objectForKey:@"createTime"];
        NSString * isAlreadySubmit = [temp objectForKey:@"isAlreadySubmit"];
        
        if ([type intValue] == 1) {  //1文件 0文件夹
            
            FileModel * file = [[FileModel alloc] init];
            file.name = fName;
            file.size = size;
            file.datatime = time;
            file.folderId = _parentFolder.folderID;//[NSString stringWithFormat:@"%d",[folderID intValue]];
            file.serverFileId = [NSString stringWithFormat:@"%d",[folderID intValue]];     //证据列表返回的folderID 就是 serverFileId
            
            file.type = [FileModel getFileType:file.name];
            if ([isAlreadySubmit isEqualToString:@"true"]){
                file.isAlreadySubmit = YES;
            }
            
            if (file.type == kVideoFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox videoPath] stringByAppendingPathComponent:cryptName];
                //                file.type = kVideoFile;
                
            }
            else if (file.type == kPhotoFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox imagePath] stringByAppendingPathComponent:cryptName];
                //                file.type = kPhotoFile;
                
            }
            else if (file.type == kVoiceFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox voicePath] stringByAppendingPathComponent:cryptName];
                
            }
            //ios 不支持的文件类型
            else {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox otherFilePath] stringByAppendingPathComponent:cryptName];
                
            }
            
//            [_fileArray addObject:file];
            [_contentArray addObject:file];
            
        }else { //文件夹
            
            FileModel * file = [[FileModel alloc] init];
            
            file.isFolder = YES;
            file.type = kFolderFile;   //解决bug新增加的变量
            file.name = fName;
            file.size = size;
            file.datatime = time;
            file.folderId = _parentFolder.folderID;//[NSString stringWithFormat:@"%d",[folderID intValue]];
            file.serverFileId = [NSString stringWithFormat:@"%d",[folderID intValue]];     //证据列表返回的folderID 就是 serverFileId
            
//            [_fileArray addObject:file];
            [_contentArray addObject:file];
            
        }
        
        
    }//end for
    
    [DejalActivityView removeView];
    _contentView.hidden = NO;
    [_contentView reloadData];
    
    //清空
    [_jsonData setLength:0];
//    isLoadFileList = NO;
    
}
- (void)requestFolderListReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];    
    
}

- (void)requestApply4Notary
{
    if (_fileIds.count == 0){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择需要申请公证的文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
#if 0
   
#else
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(callBack)
                                                 name: @"back"
                                               object: nil];
     [self popView];
#endif
}
-(void)callBack{
   //self.selectedIndexPath = nil;
     self.selectedIndexPath= [NSIndexPath indexPathForRow:10000 inSection:4];
    NSLog(@"11111111");
}
//弹出视图
-(void)popView{

   listtView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
   listtView.titleName.text = @"请选择或输入公证事由";
   listtView.datasource = self;
   listtView.delegate = self;
   listtView.myDelegate = self;
   listtView.textviewdatasource=self;
    
    self.listView=listtView;
    [listView show];
   
    [self asiRequest];

}
-(BOOL)yangtextView:(ZSYPopoverListView *)textView1 yangshouldChangeTextInRange:(NSRange)range yangreplacementText:(NSString *)text{

   // NSLog(@"-------%@",text);
    //self.selectedIndexPath = nil;
     self.selectedIndexPath= [NSIndexPath indexPathForRow:10000 inSection:4];
    [self.listView.mainPopoverListView reloadData];
        return YES;

}
-(void)asiRequest{

    //查询可用公证申请包，供申请公证时选择接口
    UserModel * user = [UserModel sharedInstance];
    //request.shouldAttemptPersistentConnection   = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    
    NSString *resultMd5 = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",resultMd5,@"wqerf*6205"]];
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"qryGzRecords4Option.action"];
    NSURL * url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    ASIFormDataRequest*request =  [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag=111;
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [request setPostValue:sig forKey:@"sig"];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    

    
    
}
#pragma ASIHttpRequest Delegate methods
#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];
    
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    
    NSDictionary *jsonDic = [_jsonData objectFromJSONData];
    NSArray*sendStrArr = [jsonDic objectForKey:@"data"];
    self.allDataArr=sendStrArr;
    
    //获得数据以后进行表刷新
    [self.listView.mainPopoverListView reloadData];
    //清空
    [_jsonData setLength:0];
     
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    
}

#pragma mark - ZSYPopoverListView

- (void)returnTheContent:(NSString *)content {
    
    
        //allDataArr
  //  BOOL isPickName = NO;
    if (content.length == 0) {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
    
    NSLog(@"-------content:%@",content);
  
    NSMutableArray*array=[[NSMutableArray alloc] init];
    for (int i = 0; i<[self.allDataArr count]; i++) {
        
      NSString*string=[[self.allDataArr objectAtIndex:i]  objectForKey:@"packName"];
        
      
          NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"-------encodedString:%@",string);
        [array addObject:trimmedString];
        }
    
    
    if ([array containsObject:content]) {
        
        if (self.selectedIndexPath.row == 10000) {
        
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"公证事由已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];

            return;
        }
        
    }
        
    

        
         
       
    
    
    

    //申请公证接口
    NSMutableString * ids = [[NSMutableString alloc]init];
    
    for (int i = 0; i < _fileIds.count; i++){
        
        FileModel * file = [_fileIds objectAtIndex:i];
        
        if (i == _fileIds.count - 1 ) {
            
            [ids appendFormat:@"%@",file.serverFileId];
            
        }else {
            
            [ids appendFormat:@"%@,",file.serverFileId];
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
       
        if (self.selectedIndexPath.row == 10000) {
            [dic setObject:@"-1" forKey:@"packId"];
            NSLog(@"----------yes");
        }else{
            NSString*packId=[NSString stringWithFormat:@"%@",[[self.allDataArr objectAtIndex:self.selectedIndexPath.row]  objectForKey:@"packId"]];
            [dic setObject:packId forKey:@"packId"];
            NSLog(@"----------no");
        }

  
    
    [dic setObject:content forKey:@"packName"];
    [dic setObject:ids forKey:@"fileIDs"];
    
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"立即公正:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"立即公正:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"applygz.action"];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"立即公正:%@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&fileIDs=%@&sig=%@",urls,user.userID,user.phoneNumber,APP_ID,VERSIONS,ids,sig];
    debugLog(logurl);
    
    _requestApplygz = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestApplygz setPostValue:user.userID forKey:@"userID"];
    //NSLog(@"------user.userID:-%@",user.userID);
    [_requestApplygz setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestApplygz setPostValue:@"1" forKey:@"src"];
    [_requestApplygz setPostValue:APP_ID forKey:@"app_id"];
    [_requestApplygz setPostValue:VERSIONS forKey:@"v"];
    [_requestApplygz setPostValue:ids forKey:@"fileIDs"];
    
   
        
        if (self.selectedIndexPath.row == 10000) {
            [_requestApplygz setPostValue:@"-1" forKey:@"packId"];
            NSLog(@"----------yes");
        }else{
            NSString*packId=[NSString stringWithFormat:@"%@",[[self.allDataArr objectAtIndex:self.selectedIndexPath.row]  objectForKey:@"packId"]];
            [_requestApplygz setPostValue:packId forKey:@"packId"];
            NSLog(@"----------no");
        }
        
   

     [_requestApplygz setPostValue:content forKey:@"packName"];
    [_requestApplygz setPostValue:sig forKey:@"sig"];
    [_requestApplygz setDelegate:self];
    [_requestApplygz setRequestMethod:@"POST"];
    [_requestApplygz setDidFailSelector:@selector(requestFail:)];
    [_requestApplygz setDidFinishSelector:@selector(requestFinish:)];
    [_requestApplygz setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestApplygz startAsynchronous];
            
        }
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_NoticeUploadFileSuccess object:nil];

    
       
}
#pragma ASIHttpRequest Delegate methods
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
     NSLog(@"----_jsonData1:%@",_jsonData);
}

- (void)requestFinish:(ASIHTTPRequest *)request
{
    
  
    
    NSDictionary *jsonDic = [_jsonData objectFromJSONData];
    NSLog(@"----jsonDic1:%@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
    NSDictionary  * data = [jsonDic objectForKey:@"data"];
    NSLog(@"%@",jsonDic);
    
    if ([code intValue] == 0) {

    self.selectedIndexPath= [NSIndexPath indexPathForRow:10000 inSection:4];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissview" object:nil];
     message = [data objectForKey:@"tipText"];
    
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag=5;
        [alert show];
  
//
       [self requestFileList];
        //[self.contentView  reloadData];
  
    
    }else {
            [self alertMessage:codeInfo];
    }

  //清空_jsonData
     [_jsonData setLength:0];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 5) {
        NSLog(@"申请公证已经成功");
    
        
       
    }



}




- (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)requestFail:(ASIHTTPRequest *)request
{
   
}



#pragma mark -ZSYPopoverListViewdelegate
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allDataArr count];
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"check.png"];
   }
    else
   {
        cell.imageView.image = [UIImage imageNamed:@"check1.png"];
    }
    //NSLog(@"------%@",self.allDataArr);
    cell.textLabel.textColor=[UIColor colorWithRed:40./255.
                              green:90./255.
                              blue:131./255.
                              alpha:1.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"%d.%@", indexPath.row+1,[[self.allDataArr objectAtIndex:indexPath.row]  objectForKey:@"packName"]];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"check1.png"];
    NSLog(@"deselect:%d", indexPath.row);
    
    
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*selectedString=[NSString stringWithFormat:@"%d",self.selectedIndexPath.row+1];
   
    NSString*indexPathString=[NSString stringWithFormat:@"%d",indexPath.row+1];
    NSLog(@"-----selectedString:%@",selectedString);
    NSLog(@"-----indexPathString:%@",indexPathString);
    if ([selectedString isEqualToString:indexPathString]) {
        UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"check1.png"];
        NSLog(@"select:%d", indexPath.row);
        
        self.listView.textView.text = @"";
        self.selectedIndexPath= [NSIndexPath indexPathForRow:10000 inSection:4];
      
    }else{
    
    
        self.selectedIndexPath = indexPath;
        UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"check.png"];
        NSLog(@"select:%d", indexPath.row);
        
        self.listView.textView.text = [NSString stringWithFormat:@"%@",[[self.allDataArr objectAtIndex:indexPath.row]  objectForKey:@"packName"]];
    
    }
   
}

//#pragma ASIHttpRequest Delegate methods
//- (void)requestStart:(ASIHTTPRequest *)request
//{
//  
//    
//    
//}
//- (void)requestFail:(ASIHTTPRequest *)request
//{
//
//}
//- (void)requestFinish:(ASIHTTPRequest *)request
//{
//    
//    
//}
//- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//     if (request == _requestApplygz)
//    {
//        NSDictionary * jsonDic = [data objectFromJSONData];
//        NSString * code = [jsonDic objectForKey:@"code"];
//        NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
//        NSDictionary  * data = [jsonDic objectForKey:@"data"];
//        NSLog(@"%@",jsonDic);
//        
//        if ([code intValue] == 0) {
//            
//            NSString * message = [data objectForKey:@"tipText"];
//            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            
//            [alert show];
//            
//        }else {
//            [self alertMessage:codeInfo];
//        }
//        
//        
//    }
//}
- (void)alertMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


@end

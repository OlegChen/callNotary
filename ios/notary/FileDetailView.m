//
//  FileDetailView.m
//  notary
//
//  Created by 肖 喆 on 13-9-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "FileDetailView.h"
#import "Preview.h"
#import "DownLoadHistory.h"
#import "FolderListView.h"

@interface FileDetailView ()<UIActionSheetDelegate,ASIHTTPRequestDelegate>
{
    ASIFormDataRequest * _fenXiangRequest;
    ASIFormDataRequest *_shareRequest;
    NSString *_shareText;
    NSString* _shareImageUrl;
    NSMutableData *mesData;
    UIView *backView;
    UIView *midView;
    NSMutableData *_jsonData;
}
@end

@implementation FileDetailView
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
    if (IS_IPHONE_5){
    self.bottomView.frame = CGRectMake(0, 348+88, 320, 68);
    }else{
        self.bottomView.frame = CGRectMake(0, 348, 320, 68);
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"文件详情";
    self.jsonData = [[NSMutableData alloc]init];
    self.filename.numberOfLines=0;
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(-10, 0, 30, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"左上角通用返回"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self requestDetail];
    if (IS_IPHONE_5){
        self.bottomView.frame = CGRectMake(0, 341+88, 320, 75);
    }
    
    //添加图层
    backView = [[UIView alloc] init];
    CGFloat high =[UIScreen mainScreen].bounds.size.height - 49.5;
    backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, high);
    backView.alpha = 0.7;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
    backView.backgroundColor = [URLUtil colorWithHexString:@"#000000"];
    [self.view addSubview:backView];
    backView.hidden = YES;
    
    midView = [[UIView alloc] init];
    CGFloat highY =  ([UIScreen mainScreen].bounds.size.height - 150  ) / 2.0 - 64;
    midView.frame = CGRectMake(50,highY, [UIScreen mainScreen].bounds.size.width - 100,150);
    midView.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    [self.view addSubview:midView];
    midView.hidden = YES;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"";
    lab.frame = CGRectMake(18, 14, 150, 14);
    lab.textColor = [URLUtil colorWithHexString:@"#555555"];
    lab.font = [UIFont boldSystemFontOfSize:14];
    [midView addSubview:lab];
    
    NSArray *arr = [NSArray arrayWithObjects:@"删 除",@"取 消",nil];
    for (int i = 0;i<2;i++){
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(20,37+ i*44, [UIScreen mainScreen].bounds.size.width - 40 - 100, 35);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(VouClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setContentHorizontalAlignment:UIControlContentVerticalAlignmentCenter];
        if (btn.tag == 0){
            [btn setBackgroundColor:[URLUtil colorWithHexString:@"#eeeeee"]];
            [btn setTitleColor:[URLUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];

        } else {
            if (btn.tag == 1){
                [btn setBackgroundColor:[URLUtil colorWithHexString:@"#e9b230"]];
            } else if (btn.tag == 2){
                [btn setBackgroundColor:[URLUtil colorWithHexString:@"#38a7da"]];
            }
            [btn setTitleColor:[URLUtil colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];

        }
        [midView addSubview:btn];
    }

    
    [self.btnDownLoad setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btnRename setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btnMove setBackgroundImage:[UIImage resizableImageWithName:@"红色按钮"] forState:UIControlStateNormal];


    
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
    if (self.requestRename != nil){
        [self.requestRename cancel];
        [self.requestRename setDelegate:nil];
        self.requestRename = nil;
    }
}
- (void)handleBackButtonClick:(UIButton *)but
{
    [self cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestDetail
{
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:self.file.serverFileId forKey:@"fileID"];
   
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件详细信息:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件详细信息:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FILE_INFO];
    
    
    NSString * log = [NSString stringWithFormat:@"%@%@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&fileID=%@&sig=%@",ROOT_URL,FILE_INFO,user.userID,user.phoneNumber,APP_ID,VERSIONS,self.file.serverFileId,sig];
    
    
    NSURL * url = [NSURL URLWithString:urls];
    _request = [[ASIFormDataRequest alloc] initWithURL:url];
    [_request setPostValue:user.userID forKey:@"userID"];
    [_request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_request setPostValue:@"1" forKey:@"src"];
    [_request setPostValue:APP_ID forKey:@"app_id"];
    [_request setPostValue:VERSIONS forKey:@"v"];
    [_request setPostValue:sig forKey:@"sig"];
    [_request setPostValue:self.file.serverFileId forKey:@"fileID"];
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

}
- (void)requestFolderListFail:(ASIHTTPRequest *)request
{
    
    [DejalActivityView removeView];
}
- (NSString *)getImageName:(NSInteger )num
{
    if (1 == num) {
        return @"icon_f_image.png";
    }else{
        return @"icon_f_other.png";
    }
}
- (void)requestFolderListFinish:(ASIHTTPRequest *)request
{
    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    
    NSLog(@"json %@",jsonDic);
    
    NSDictionary * dic = [jsonDic objectForKey:@"data"];
    NSString *fileName = [dic objectForKey:@"fileName"];
    NSString *srcType = [dic objectForKey:@"srcType"];
    self.filename.text = fileName;
    self.saveTime.text = [dic objectForKey:@"createTime"];
    self.fileNumber.text = [NSString getAutoKBorMBNumber:[dic objectForKey:@"fileSize"]];
    self.desc.text = [self getFileDescName:srcType];
    
    if ([srcType isEqualToString:@"0"]||[srcType isEqualToString:@"2"]) {
        self.manLabel.hidden = self.outLabel.hidden = self.timeLabel.hidden = self.manNumber.hidden = self.outNumber.hidden = self.labTime.hidden = YES;
        NSLog(@"文件的名字%@",self.file.name);
        NSInteger i = [FileModel getFileType:fileName];
        self.fileTypeImage.image = [UIImage imageNamed:[self getImageName:i]];
    }else{
        self.manLabel.hidden = self.outLabel.hidden = self.timeLabel.hidden = self.manNumber.hidden = self.outNumber.hidden = self.labTime.hidden = NO;
        self.fileTypeImage.image = [UIImage imageNamed:@"关于电话录音.png"];
        self.manNumber.text = [dic objectForKey:@"srcTel"];
        self.outNumber.text = [dic objectForKey:@"descTel"];
        self.labTime.text = [NSString stringWithFormat:@"%@秒",[dic objectForKey:@"duration"]];
    }
    
    
    [_jsonData setLength:0];
        
}
- (void)requestFolderListReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];    
    
}
-(void)requestHeader{
    
    UserModel *user=[UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:self.file.serverFileId forKey:@"fileID"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"请求下载:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];

    NSString * urls = [NSString stringWithFormat:@"%@%@?userID=%@&mobileNo=%@&fileID=%@&app_id=%@&v=%@&src=%@&sig=%@",ROOT_URL,FILE_DOWN_URL,user.userID,user.phoneNumber,self.file.serverFileId,APP_ID,VERSIONS,@"1",sig];
    NSLog(@"请求下载 url :%@",urls);

   _requestHeader = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urls]];
    
    
    [_requestHeader setDelegate:self];
    [_requestHeader setDidStartSelector:@selector(requesttetStart:)];
    [_requestHeader setDidFailSelector:@selector(requesttetFail:)];
    [_requestHeader setDidFinishSelector:@selector(requesttetFinish:)];
    [_requestHeader setDidReceiveResponseHeadersSelector:@selector(tetrequest:tetdidReceiveResponseHeaders:)];
    [_requestHeader setDidReceiveDataSelector:@selector(requesttetReceiveData:didReceiveData:)];
    
    [_requestHeader startAsynchronous];

}
- (void)tetrequest:(ASIHTTPRequest *)request tetdidReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"---%@",[responseHeaders objectForKey:@"Content-Type"]);
    if (![[responseHeaders objectForKey:@"Content-Type"] isEqualToString:@"application/json;charset=utf-8"]) {
        [_requestHeader cancel];
        [DejalBezelActivityView removeView];
        [self enterDownload];
    }

}
- (void)requesttetStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requesttetFail:(ASIHTTPRequest *)request
{
    
}
- (void)requesttetFinish:(ASIHTTPRequest *)request
{
    NSLog(@"---responseString:%@",request.responseString);
    
    
}
- (void)requesttetReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    
    
    [DejalBezelActivityView removeView];
    NSDictionary * dic = [data objectFromJSONData];
    NSString *string =[dic objectForKey:@"codeInfo"];
    
    NSLog(@"+++++++++++++%@",dic);
    
    if (!string) {
        
    }else{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
      NSLog(@"---responseString:%@",dic);
    }
}
-(void)enterDownload{

    FileModel * tmp =  [self queryById:self.file.serverFileId];
    
    if (tmp.fid == nil){
        
        self.file.downStatus = ZIPFILE_DOWNLOADING;
        //modify by liwzh 初始化
        self.file.receivedSize  = nil;
        [DownloadFile launchRequest:self.file immediately:YES];
        
        DownLoadHistory *downLoadHisVC = [[DownLoadHistory alloc] init];
        downLoadHisVC.isPresent = YES;
        
        UINavigationController * navDown = [[UINavigationController alloc]initWithRootViewController:downLoadHisVC];
        if (IOS7_OR_LATER) {
            
            
            [navDown.navigationBar setBarStyle:UIBarStyleBlack];
            
            
            [navDown.navigationBar setTranslucent:NO];
            
            [navDown.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
            
        }else{
            
            [navDown.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
        }
        
        
        [self.navigationController presentViewController:navDown animated:YES completion:nil];
    }
    
    else if (tmp.downStatus != ZIPFILE_DOWNLOADED){
        
        DownLoadHistory *downLoadHisVC = [[DownLoadHistory alloc] init];
        downLoadHisVC.isPresent = YES;
        
        UINavigationController * navDown = [[UINavigationController alloc]initWithRootViewController:downLoadHisVC];
        
        if (IOS7_OR_LATER) {
            
            
            [navDown.navigationBar setBarStyle:UIBarStyleBlack];
            
            
            [navDown.navigationBar setTranslucent:NO];
            
            [navDown.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
            
        }else{
            
            [navDown.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
            
            
            
        }
        
        
        [self.navigationController presentViewController:navDown animated:YES completion:nil];
        
        
    }else { //已经下载完成了
        
        Preview *preview = [[Preview alloc] initWithControler:self andFileModel:tmp];
        preview.delegate = self;
        [preview initialize];
    }


}
- (IBAction)download:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在加载" width:0];

    [self requestHeader];
}
- (void)notificationBack:(FileModel *)fileModel{
    NSLog(@"解密失败啦");
    //[self alertErrorMessage:@"该文件下载数据不完整,请在“下载记录”中删除该文件后重新下载"];
   UIAlertView* _alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                             message:@"该文件下载数据不完整,是否重新下载"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
               
                                               otherButtonTitles:@"确定",nil];
    _alertError.tag=234;
    
    [_alertError show];


}
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
#pragma mark -ZSYPopdelegate
-(void)popoView:(ZSYTextPopView *)popview content:(NSString *)content clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"popview---%ld",(long)popview.tag);
//    NSLog(@"content---content:-%@",content);
//    NSLog(@"content---clickedButtonAtIndex:%ld",(long)buttonIndex);
    if (popview.tag == 1 && buttonIndex == 1) {
        [self requestRename:content];
    }
    
    
    
    
}

- (IBAction)rename:(id)sender
{
//    if (IOS7_OR_LATER) {
        ZSYTextPopView*RenameView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
        RenameView.titleName.text = @"输入文件名";
        RenameView.maxLength=60;
        RenameView.tag=1;
        RenameView.myDelegate=self;
        [RenameView show];
//    }else{
//
//        _alert4Rename = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件名"];
//        _alert4Rename.delegate = self;
//        _alert4Rename.maxLength = 60;
//        [_alert4Rename show];
//    }
   
}
//////////////yang//////
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
//////////////yang////

- (void)requestRename:(NSString *)name
{
    
    NSLog(@"------%@",[NSString stringWithFormat:@"%@.%@",name,[self.filename.text pathExtension]]);
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:self.file.serverFileId forKey:@"fileID"];
    [dic setObject:[NSString stringWithFormat:@"%@.%@",name,[self.filename.text pathExtension]] forKey:@"name"];

    NSString * result = [URLUtil generateNormalizedString:dic];
    
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];; 
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RE_NAME];
    NSURL * url = [NSURL URLWithString:urls];
    
    
//    debugLog(@"%@%@?app_id=%@&v=%@&src=1&userID=%@&mobileNo=%@&fileID=%@&name=%@&sig=%@",ROOT_URL,RE_NAME,APP_ID,VERSIONS,user.userID,user.phoneNumber,self.file.folderId,name,sig);
    
    _requestRename = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRename setPostValue:user.userID forKey:@"userID"];
    [_requestRename setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRename setPostValue:@"1" forKey:@"src"];
    [_requestRename setPostValue:APP_ID forKey:@"app_id"];
    [_requestRename setPostValue:VERSIONS forKey:@"v"];
    [_requestRename setPostValue:self.file.serverFileId forKey:@"fileID"];
    [_requestRename setPostValue:[NSString stringWithFormat:@"%@.%@",name,[self.filename.text pathExtension]] forKey:@"name"];
    [_requestRename setPostValue:sig forKey:@"sig"];
    
    [_requestRename setUserInfo:[NSDictionary dictionaryWithObject:self.file forKey:@"File"]];
    
  
    
    [_requestRename setDelegate:self];
    [_requestRename setDidStartSelector:@selector(requestRenameStart:)];
    [_requestRename setDidFailSelector:@selector(requestRenameFail:)];
    [_requestRename setDidFinishSelector:@selector(requestRenameFinish:)];
    [_requestRename setDidReceiveDataSelector:@selector(requestRenameReceiveData:didReceiveData:)];
    
    [_requestRename startAsynchronous];
    
    
}
- (void)requestRenameStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestRenameFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestRenameFinish:(ASIHTTPRequest *)request
{

    [self requestDetail];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeName:)]) {
        [_delegate changeName:@"好的"];
    }
    
}
- (void)requestRenameReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    
    
    NSLog(@"清空全部文件 dic %@",dic);
}
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 234) {
        if (buttonIndex == 1) {
            DataBaseManager * db = [[DataBaseManager alloc]init];
            NSString * sql = @"Delete from FileModel where serverFIleId = ?";
//            serverId
            NSArray * pars = [NSArray arrayWithObject:self.file.serverFileId];
//            self.file
            debugLog(sql);
            [db update:sql parameter:pars];
            
            [db close];
      
        
        //删除ASI 缓存文件
        NSString * tempPath = [[Sandbox libCachePath]
                               stringByAppendingPathComponent:self.file.name];
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        if ([manager fileExistsAtPath:tempPath]) {
            
            [manager removeItemAtPath:tempPath error:&error];
            
            if (error) {
                debugLog([error description]);
            }
        }
         AppDelegate*_app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //删除全局文件缓存
        [_app.downloadRequest removeObjectForKey:self.file.serverFileId];
        [_app.fileModels removeObject:self.file];
        
        [self download:nil];
        
      }
    }else{
    if (buttonIndex == 0){
        
    }
    else {
        CustomAlertView * alert = (CustomAlertView *)alertView;
        NSString * keyword = [alert getKeyWord];
        
        [self requestRename:keyword];
    }
    }
}

//删除除了回收站以外的列表用函数
- (void)requestDeleteFile:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.serverFileId forKey:@"fileIDs"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"删除文件:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"删除文件:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,DELETE_FOLDER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [request setPostValue:file.serverFileId forKey:@"fileIDs"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:sig forKey:@"sig"];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    NSString * logstrurl = [NSString stringWithFormat:@"%@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
    debugLog(logstrurl);
    
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestDeleteFileStart:)];
    [request setDidFailSelector:@selector(requestDeleteFileFail:)];
    [request setDidFinishSelector:@selector(requestDeleteFileFinish:)];
    [request setDidReceiveDataSelector:@selector(requestDeleteFileReceiveData:didReceiveData:)];
    
    [request startAsynchronous];
}
- (void)requestDeleteFileStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    
}
- (void)requestDeleteFileFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestDeleteFileFinish:(ASIHTTPRequest *)request
{
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:Notification_MoveFolder object:nil];
    
    [self handleBackButtonClick:nil];
    
}
- (void)requestDeleteFileReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"删除文件 dic %@",dic);
}

- (IBAction)deleteFile:(id)sender {
    if (_shareText == nil){
        [self httpGetShareMessage];
    }else {
        [self shareFile];
    }
}
- (IBAction)move:(id)sender {
    
//       [UIView animateWithDuration:0.5 animations:^{
//        self.bottomView.frame = CGRectMake(0, 341+88+75, 320, 75);
//    } completion:^(BOOL finished) {
//        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"移动",@"分享", nil];
//        action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [action showInView:self.view];
//    }];
    backView.hidden = NO;
    midView.hidden = NO;
 }

//删除、移动
-(void)VouClick:(UIButton *)btn
{
    if (btn.tag == 0){
//        FolderListView * fList = [[FolderListView alloc]init];
//        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:fList];
//        fList.myFileModel = self.file;
//        
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
//        [self touch];
     } else if(btn.tag == 1) {
         [self requestDeleteFile:self.file];
         [self touch];
    } else if (btn.tag == 2){
        [self touch];
    }
}
-(void)touch
{
    backView.hidden = YES;
    midView.hidden = YES;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            FolderListView * fList = [[FolderListView alloc]init];
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:fList];
            fList.myFileModel = self.file;
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];

        }
            break;
        case 1:{
            [self shareFile];
          }
            break;
        case 2:{
            [UIView animateWithDuration:0.5 animations:^{
                if (IS_IPHONE_5){
                    self.bottomView.frame = CGRectMake(0, 348+88, 320, 68);
                } else {
                self.bottomView.frame = CGRectMake(0, 348, 320, 68);
                }
            }completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)httpGetShareMessage
{
    _jsonData = [[NSMutableData alloc] init];
     if (nil == _shareText) {
        UserModel * user = [UserModel sharedInstance];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
        [dic setObject:@"gfs" forKey:@"action"];
        [dic setObject:self.file.serverFileId forKey:@"profileId"];
        [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:@"" forKey:@"shareType"];
         NSLog(@"dic---->%@", dic);
        NSString *result = [URLUtil generateNormalizedString:dic];
        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
        
        NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SHARE_FILE];
        NSURL *url = [NSURL URLWithString:urls];
        NSLog(@"request URL is: %@",url);
        
        _shareRequest = [ASIFormDataRequest requestWithURL:url];
         [_shareRequest setPostValue:APP_ID forKey:@"app_id"];
         [_shareRequest setPostValue:VERSIONS forKey:@"v"];
         [_shareRequest setPostValue:@"1" forKey:@"src"];
         [_shareRequest setPostValue:user.phoneNumber forKey:@"mobileNo"];
        [_shareRequest setPostValue:@"gfs" forKey:@"action"];
        [_shareRequest setPostValue:self.file.serverFileId forKey:@"profileId"];
        [_shareRequest setPostValue:user.userID forKey:@"userID"];
        [_shareRequest setPostValue:@"" forKey:@"shareType"];
        [_shareRequest setPostValue:sig forKey:@"sig"];
        [_shareRequest setTimeOutSeconds:30.0f];
        _shareRequest.delegate = self;
        _shareRequest.tag= 7777;
        [_shareRequest setRequestMethod:@"POST"];
        [_shareRequest startAsynchronous];
    }
}
-(void)shareFile
{
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    id<ISSContent> publishContent = nil;
    publishContent = [ShareSDK content: _shareText
                        defaultContent:@""
                                 image:nil
                                 title: @"afda"
                                   url:nil
                           description:nil
                             mediaType:SSPublishContentMediaTypeText];
    
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeQQ,
//                          ShareTypeQQSpace,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSMS,
                            nil];
    
    [ShareSDK ssoEnabled:NO];
    [ShareSDK showShareActionSheet:nil shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil
        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                    if (state == SSPublishContentStateSuccess){
                                    if ((int)type == 1) {
                                        [self httpRequestFenXiang:@"0"];
                                    }else if ((int)type == 22) {
                                        [self httpRequestFenXiang:@"1"];
                                    }else if ((int)type == 23) {
                                        [self httpRequestFenXiang:@"2"];
                                    }else  {
                                        [self httpRequestFenXiang:@"3"];
                                    }
                                    
                        }else if (state == SSPublishContentStateFail){
                                    
                                    if ([error errorCode] == -22003){
                                        if (IS_IPHONE_5){
                                            self.bottomView.frame = CGRectMake(0, 348+88, 320, 68);
                                        } else {
                                            self.bottomView.frame = CGRectMake(0, 348, 320, 68);
                                        }
                                    }
                            
                                }else if (state==SSPublishContentStateCancel){
                                    if (IS_IPHONE_5){
                                        self.bottomView.frame = CGRectMake(0, 348+88, 320,68);
                                    } else {
                                        self.bottomView.frame = CGRectMake(0, 348, 320,68);
                                    }
                                }
                            }];
}

-(void)httpRequestFenXiang:(NSString*)type{
    UserModel * user = [UserModel sharedInstance];
    // NSString *phoneNum = user.phoneNumber;
    NSLog(@"userID---->%@", user.userID);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:type forKey:@"shareType"];
    [dic setObject:user.userID forKey:@"userID"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FENXIANGURL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    
    _fenXiangRequest = [ASIFormDataRequest requestWithURL:url];
    
    [_fenXiangRequest setPostValue:user.userID forKey:@"userID"];
    [_fenXiangRequest setPostValue:APP_ID forKey:@"app_id"];
    [_fenXiangRequest setPostValue:VERSIONS forKey:@"v"];
    [_fenXiangRequest setPostValue:type forKey:@"shareType"];
    [_fenXiangRequest setPostValue:@"1" forKey:@"src"];
    [_fenXiangRequest setPostValue:sig forKey:@"sig"];
    [_fenXiangRequest setTimeOutSeconds:30.0f];
    _fenXiangRequest.delegate = self;
    _fenXiangRequest.tag= 6666;
    [_fenXiangRequest setRequestMethod:@"POST"];
    [_fenXiangRequest startAsynchronous];

}
- (void)handleActivityStart
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    
    
}
- (void)handleActivityStop
{
    [DejalBezelActivityView removeView];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    [self handleActivityStart];
}
- (void)request:(ASIHTTPRequest *)request1 didReceiveData:(NSData *)data
{
     if(7777 == request1.tag){
//         NSDictionary * Dic = [data objectFromJSONData];
//        NSString * code = [Dic objectForKey:@"code"];
//        if (0 == [code intValue]) {
//            NSDictionary *tmpDic= [Dic objectForKey:@"data"];
//            _shareText = [tmpDic objectForKey:@"text"];
//            NSLog(@"分享内容  %@",_shareText);
//            NSString *tmpStr = [tmpDic objectForKey:@"picUrl"];
//            _shareImageUrl = [ROOT_URL stringByAppendingString:tmpStr];
//            
//        }else{
////                        [self alertWithMessage:codeInfo];
//        }
         [_jsonData appendData:data];
    }
    else if (6666 == request1.tag) {
        NSDictionary * jsonDic =  [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
         if (0 == [code intValue]) {
//            [self alertWithMessage:codeInfo];
            NSDictionary *dic = [jsonDic objectForKey:@"data"];
            NSString * newLeftMoney =[dic objectForKey:@"newLeftMoney"];
//            self.binNumberLabel.text=newLeftMoney;
            NSLog(@"---------newLeftMoney%@",newLeftMoney);
        }
        NSLog(@"---------code%@",code);
        
        
    }
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 6666){
        [DejalActivityView removeView];

    }else if (request.tag == 7777){
    NSDictionary *dic = [_jsonData objectFromJSONData];
    NSDictionary *doc = [dic objectForKey:@"data"];
    NSString *code = [dic objectForKey:@"code"];
    NSString * codeInfo = [dic objectForKey:@"codeInfo"];

        if ([code intValue] == 0){
    _shareText = [NSString stringWithFormat:@"我通过录音存证存证，并分享了文件“%@”,地址：%@%@",self.filename.text,ROOT_URL, [doc objectForKey:@"url"]];
    [DejalActivityView removeView];
    [self shareFile];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:codeInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
        }
    NSLog(@"%@",dic);
    }
    [self handleActivityStop];
}
    
- (NSString *)getFileDescName:(NSString *)type
{
    if ([type isEqualToString:@"1"]) {
        return @"通话录音";
    }else if([type isEqualToString:@"2"]){
        return @"现场录音";
    }else if([type isEqualToString:@"0"]){
        return @"文件上传";
    }
    return nil;
}
- (void)viewDidUnload {
    [self setManLabel:nil];
    [self setOutLabel:nil];
    [self setTimeLabel:nil];
    [self setFileTypeImage:nil];
    [super viewDidUnload];
}
@end

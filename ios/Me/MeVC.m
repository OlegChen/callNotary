//
//  MeVC.m
//  notary
//
//  Created by he on 15/4/24.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "MeVC.h"
#import "SettingCell.h"
#import "MessageCenter.h"
#import "MessageCenterViewController.h"

#import "ContactUs.h"
#import "AppDelegate.h"
#import "LoginView.h"
//
#import "DemoTableViewController.h"
#import <AGCommon/UIDevice+Common.h>
//#import <AGCommon/UIView+Common.h>
//#import "RecommendationView.h"

#import "SettingView.h"
#import "UserCenter.h"
#import "ListProofView.h"


#define HEIGHT_FOR_SETTING_TABLEVIEW_CELL 49


@interface MeVC ()

//网络请求
- (void)requestFolderList;
- (void)requestCreateFolder:(NSString *)name;
- (void)requestDeleteFolder:(FolderModel *)model;

//网络请求回调函数
- (void)requestStart:(ASIHTTPRequest *)request;
- (void)requestFail:(ASIHTTPRequest *)request;
- (void)requestFinish:(ASIHTTPRequest *)request;
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
- (void)alertMessage:(NSString *)message;


@end

@implementation MeVC




//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"request Finish");
//    if (8888 == request.tag) {
//        [self.myTableView reloadData];
//    }else if(9999 == request.tag){
//        //退出接口
//    }else if(7777 == request.tag){
//        [self getShareImage];
//    }
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"request Failed");
//    //    [self alertWithMessage:@"更新数据失败，请检查网络后刷新"];
//    if (8888 == request.tag) {
//        //
//    }else if(9999 == request.tag){
//        //退出接口
//    }
//}

//- (void)getShareImage
//{
//    //下载分享用的图片
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_shareImageUrl]];
//    NSOperationQueue*operationQueue=[[NSOperationQueue alloc]init];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:operationQueue
//                           completionHandler:^(NSURLResponse*urlResponce,NSData*data,NSError*error)
//     {
//         if(error)
//         {
//             NSLog(@"download image error:\n%@",error);
//             return ;
//         }
//         _shareImage = [UIImage imageWithData:data];
//     }
//     ];
//    if (request != nil) {
//        request = nil;
//    }
//    if (operationQueue != nil) {
//        operationQueue = nil;
//    }
//}

//- (void) alertWithMessage:(NSString *)msg
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//- (void)cancel
//{
//    if (_shareRequest != nil) {
//        [_shareRequest clearDelegatesAndCancel];
//        _shareRequest = nil;
//    }
//    if (_tipsRequest != nil) {
//        [_tipsRequest clearDelegatesAndCancel];
//        _tipsRequest = nil;
//    }
//    if (_outRequest != nil) {
//        [_outRequest clearDelegatesAndCancel];
//        _tipsRequest = nil;
//    }
//}

//- (void)back
//{
//    [self cancel];
//    [self.navigationController popViewControllerAnimated:YES];
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:NO];
//}

- (void)makeView
{
    //self.title = @"设置";
   
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
//    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
     self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItem:@"我的选中" higImageNmae:@"我的选中" tager:nil action:nil frame:CGRectMake(0.0f, 0.0f, 60.0f, 40.0f) title:@"我的"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"我的页面"];
    //[self cancel];
    [DejalBezelActivityView removeView];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"我的页面"];
    //查询数据库，找下载和上传的总数显示
    //[self openSqite];
    //[self postHttpGetTipsNum];
    
    [super viewWillAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (IOS7_OR_LATER) {
            self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        }
    }
    
    _contentTextArr = [NSArray arrayWithObjects:
                       @"我的录音",
                       @"我的设置",
                       @"用户中心",
                  nil];
    _contentImageArr = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"我的录音"],
                        [UIImage imageNamed:@"我的设置"],
                        [UIImage imageNamed:@"用户中心"],nil];
    
    _msgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaWeiboClick) name:@"sinaWeibo" object:nil];
    
    return self;
}

//- (void)sinaWeiboClick
//{
//    logmessage;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestFolderList];
    
    [self makeView];
    
    
    
    //[self httpGetShareMessage];
    
}

//- (void)openSqite
//{
//    UserModel * user = [UserModel sharedInstance];
//    _upLoadCount = 0;
//    _downLoadCount = 0;
//    DataBaseManager * db = [[DataBaseManager alloc]init];
//    NSString * sqlUp = [NSString stringWithFormat:@"select * from FileModel where actiontype = 0 and uid = %@",user.uid];
//    
//    FMResultSet * resultUp =  [db query:sqlUp];
//    while (resultUp.next) {
//        _upLoadCount ++;
//    }
//    NSString * sqlDown = [NSString stringWithFormat:@"select * from FileModel where actiontype = 1 and uid = %@",user.uid];
//    FMResultSet * resultDown =  [db query:sqlDown];
//    while (resultDown.next) {
//        _downLoadCount ++;
//    }
//    NSLog(@"_upLoadCount--->%d---->%d",_upLoadCount,_downLoadCount);
//    
//    [db close];
//    [_myTableView reloadData];
//}

//表视图委托
#pragma mark -
#pragma mark table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}

//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
            return 3;
}

//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tableView.backgroundView = nil;
    static NSString *CellIdentifier = @"default";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    else{
        //cell中本来就有一个subview，如果是重用cell，则把cell中自己添加的subview清除掉，避免出现重叠问题
        [[cell.subviews objectAtIndex:1] removeFromSuperview];
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    
    
       if(0 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.myContentLabel.text = [_contentTextArr objectAtIndex: 0];
                cell.myLeftImage.image = [_contentImageArr objectAtIndex:0];
                break;
            case 1:
                cell.myContentLabel.text = [_contentTextArr objectAtIndex: 1];
                cell.myLeftImage.image = [_contentImageArr objectAtIndex:1];
                break;
            case 2:
                cell.myContentLabel.text = [_contentTextArr objectAtIndex:2];
                cell.myLeftImage.image = [_contentImageArr objectAtIndex:2];
                break;
                           default:
                break;
        }
    }
    
    return cell;
}

//数据源委托
#pragma mark -
#pragma mark table delegate methods

//在某行被选中前调用，返回nil表示该行不能被选中；另外也可返回重定向的indexPath，使选择某行时会跳到另一行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                ProofView * proof = nil;
                    if(IS_IPHONE_5) {
                        proof = [[ProofView alloc] initWithNibName:@"ProofView-ip5" bundle:nil];
                    }else{
                        proof = [[ProofView alloc] initWithNibName:@"ProofView" bundle:nil];
                    }
                
                [self.navigationController pushViewController:proof animated:YES];
                
            }
                break;
            case 1:
            {
                SettingView *set = [[SettingView alloc]init];
                [self.navigationController pushViewController:set animated:YES];
                
                
            }
                break;
            case 2:
            {
                UserCenter *user = [[UserCenter alloc]init];
                [self.navigationController pushViewController:user animated:YES];
            
            
            }
                break;
                                      default:
                break;
        }
    }
    
}

//网络请求
- (void)requestFolderList
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

    //http://m.4009991000.com/evidenceRootList.action
    
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


#pragma ASIHttpRequest Delegate method
- (void)requestStart:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        [self handleActivityStart];
        
    }
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        //_customLeft.enabled = YES;
        [self handleActivityStop];
        
    }

    
}
- (void)requestFinish:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.folderArray removeAllObjects];
        
        //清空
        [_folderArray removeAllObjects];
        
        NSDictionary * jsonDic = [_jsonFolderList objectFromJSONData];
        
        NSArray * array = [jsonDic objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i ++) {
            
            NSDictionary * tmp = [array objectAtIndex:i];
            NSString * dataNum = [tmp objectForKey:@"dataNum"];
            NSString * folderID = [tmp objectForKey:@"folderID"];
            NSString * folderName = [tmp objectForKey:@"folderName"];
            NSString * type = [tmp objectForKey:@"type"];
            NSString * haschild = [tmp objectForKey:@"haschild"];
            
            FolderModel * folder = [[FolderModel alloc] init];
            folder.dataNum = dataNum;
            folder.folderID = folderID;
            folder.folderName = folderName;
            folder.type = type;
            folder.haschild = haschild;
            
            
            if ([@"回收站" isEqualToString:folderName]){
                
//                _recover = folder;
//                [_btnRecoverNum setTitle:_recover.dataNum forState:UIControlStateNormal];
                
                
            }else if ([@"音频视频" isEqualToString:folderName]
                      || [@"照片图片" isEqualToString:folderName] ||
                      [@"现场录音" isEqualToString:folderName]){
                
                [_folderArray addObject:folder];
                
                //添加到全局目录结构
                [app.folderArray addObject:folder];
                
            }
            else {
                
                [_folderArray addObject:folder];
                
            }
            
            NSString * logstr = [NSString stringWithFormat:@"ListFloder: folderID(%@),folderName(%@),folderType(%@),dataNum(%@),haschild(%@)",folder.folderID,folder.folderName,folder.type,folder.dataNum,folder.haschild];
            
            debugLog(logstr);
        }
        
        
        [self handleActivityStop];
        
//        [_jsonFolderList setLength:0];
        
//        [self doneLoadingTableViewData];
        
    }

    
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (request == _requestRefresh) {
        
//        [_jsonFolderList appendData:data];
        
    }
}

- (void)handleActivityStart
{
   // [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
}
- (void)handleActivityStop
{
    [DejalBezelActivityView removeView];
}


//-(void)updateVersions{
//    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=640969531"]];
//    
//    NSString  *content = [[NSString alloc] initWithBytes:[data1 bytes] length:[data1 length] encoding:NSISOLatin1StringEncoding];
//    
//    NSString *jsonStr = [[NSString alloc] initWithFormat:@"%@",content];
//    
//    NSDictionary *postResult = [jsonStr objectFromJSONString];
//    NSLog(@"--------postResult:%@",postResult);
//    NSArray *latestArr = [postResult objectForKey:@"results"];
//    NSDictionary * dic =[latestArr objectAtIndex:0];
//    //                        version
//    NSLog(@"------latestVersion:%@",[dic objectForKey:@"version"]);
//    [self checkUpdate:[dic objectForKey:@"version"]];
//    
//    
//}
//- (void)checkUpdate:(NSString *)versionFromAppStroe {
//    
//    
//    
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    
//    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
//    
//    
//    NSLog(@"nowVersion == %@",versionFromAppStroe);
//    NSLog(@"nowVersion == %@",nowVersion);
//    
//    //    [processView stopAnimating];
//    
//    //检查当前版本与appstore的版本是否一致
//    
//    
//    if ([versionFromAppStroe intValue] > [nowVersion intValue])
//        
//    {
//        
//        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message: @"有新的版本可供下载" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles: @"去下载", nil];
//        createUserResponseAlert.tag = 123;
//        
//        [createUserResponseAlert show];
//        
//    } else {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前已是最新版本" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        //        [CTCommonUtils showAlertViewOnView:self.viewwithText:@"暂无新版本"];
//        
//    }
//    [DejalBezelActivityView removeView];
//    //     [self.indicatorView stopAnimating];
//}
//
//- (void)httpGetShareMessage
//{
//    if (nil == _shareText) {
//        UserModel * user = [UserModel sharedInstance];
//        NSString *phoneNum = user.phoneNumber;
//        NSLog(@"userID---->%@", user.userID);
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:APP_ID forKey:@"app_id"];
//        [dic setObject:VERSIONS forKey:@"v"];
//        [dic setObject:@"1" forKey:@"src"];
//        [dic setObject:phoneNum forKey:@"mobileNo"];
//        [dic setObject:user.userID forKey:@"userID"];
//        NSString *result = [URLUtil generateNormalizedString:dic];
//        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
//        
//        NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SHARE_INFO];
//        NSURL *url = [NSURL URLWithString:urls];
//        NSLog(@"request URL is: %@",url);
//        
//        _shareRequest = [ASIFormDataRequest requestWithURL:url];
//        
//        [_shareRequest setPostValue:user.userID forKey:@"userID"];
//        [_shareRequest setPostValue:APP_ID forKey:@"app_id"];
//        [_shareRequest setPostValue:VERSIONS forKey:@"v"];
//        [_shareRequest setPostValue:phoneNum forKey:@"mobileNo"];
//        [_shareRequest setPostValue:@"1" forKey:@"src"];
//        [_shareRequest setPostValue:sig forKey:@"sig"];
//        
//        _shareRequest.delegate = self;
//        _shareRequest.tag= 7777;
//        [_shareRequest setRequestMethod:@"POST"];
//        [_shareRequest startAsynchronous];
//    }
//}
//
//
//#if 1
//-(void)displaySMSComposerSheet
//{
//    logmessage;
//    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//    
//    picker.messageComposeDelegate = self;
//    
//    NSString *smsBody = _shareText;
//    
//    picker.body=smsBody;
//    
//    [self presentModalViewController:picker animated:YES];
//    
//}
//
//- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
//                 didFinishWithResult:(MessageComposeResult)result {
//    logmessage;
//    [controller dismissModalViewControllerAnimated:NO];
//    switch(result)
//    
//    {
//            
//        case MessageComposeResultCancelled:
//            
//            NSLog(@"Result: SMS sending canceled");
//            
//            
//            break;
//            
//        case MessageComposeResultSent:
//            
//        {NSLog(@"Result: SMS sent");
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"短信分享成功"  message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles: nil];
//            
//            [alert show];
//            
//        }
//            break;
//            
//        case MessageComposeResultFailed:
//        {
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"短信发送失败"  message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles: nil];
//            
//            [alert show];
//        }
//            
//            break;
//            
//        default:
//            
//            NSLog(@"Result: SMS not sent");
//            
//            break;
//            
//    }
//}
//#endif
////退出弹出框的代理
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 123) {
//        if (buttonIndex == 1) {
//            
//            //        　　　//去appstore中更新
//            
//            //方法一：根据应用的id打开appstore，并跳转到应用下载页面
//            
//            //NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",app_id];
//            
//            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
//            
//            
//            
//            //方法二：直接通过获取到的url打开应用在appstore，并跳转到应用下载页面
//            
//            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/zheng-ju-guan-jia-tong-hua/id640969531?mt=8"]];
//            
//            
//        } else if (buttonIndex == 2) {
//            
//            //去itunes中更新
//            
//            
//            
//        }
//        
//        
//    }else {
//        switch (buttonIndex) {
//            case 0:
//                NSLog(@"取消");
//                break;
//            case 1:
//            {
//                [self logOutPost];
//                NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//                NSLog(@"密码的干活%@   %@",[userdefault objectForKey:DEFAULT_ISRMBPWD],[userdefault objectForKey:DEFAULT_ISAUTOLOGIN]);
//                //                [userdefault removeObjectForKey:DEFAULT_ISRMBPWD];
//                [userdefault removeObjectForKey:DEFAULT_ISAUTOLOGIN];
//                //                DEFAULT_PWD
//                [userdefault removeObjectForKey:DEFAULT_PWD];
//                //退出
//                AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                
//                //当用户切换用户时需要清除全局变量，没有下载的时候没问题
//                [app.fileModels removeAllObjects];
//                
//                NSArray * allkey = [app.downloadRequest allKeys];
//                for (int i = 0; i < allkey.count;i++) {
//                    
//                    DownloadFile * down = [app.downloadRequest objectForKey:[allkey objectAtIndex:i]];
//                    [down cancel];
//                    [down setMyDelegate:nil];
//                    
//                }
//                //结束清空全局变量
//                
//                
//                LoginView * log = nil;
//                
//                if(IS_IPHONE_5) {
//                    log = [[LoginView alloc] initWithNibName:@"LoginView-ip5" bundle:nil];
//                }else {
//                    log = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
//                }
//                
//                UINavigationController * logNav = [[UINavigationController alloc] initWithRootViewController:log];
//                app.window.rootViewController = logNav;
//                
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}
///*退出接口*/
//- (void)logOutPost
//{
//    UserModel * user = [UserModel sharedInstance];
//    NSString *phoneNum = user.phoneNumber;
//    NSLog(@"userID---->%@", user.userID);
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:APP_ID forKey:@"app_id"];
//    [dic setObject:VERSIONS forKey:@"v"];
//    [dic setObject:@"1" forKey:@"src"];
//    [dic setObject:phoneNum forKey:@"mobileNo"];
//    [dic setObject:user.userID forKey:@"userID"];
//    NSString *result = [URLUtil generateNormalizedString:dic];
//    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
//    
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,LOG_OUT_URL];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    
//    _outRequest = [ASIFormDataRequest requestWithURL:url];
//    
//    /*此处userID是写死的，38，用来测试的*/
//    
//    [_outRequest setPostValue:user.userID forKey:@"userID"];
//    [_outRequest setPostValue:APP_ID forKey:@"app_id"];
//    [_outRequest setPostValue:VERSIONS forKey:@"v"];
//    [_outRequest setPostValue:phoneNum forKey:@"mobileNo"];
//    [_outRequest setPostValue:@"1" forKey:@"src"];
//    [_outRequest setPostValue:sig forKey:@"sig"];
//    
//    _outRequest.delegate = self;
//    _outRequest.tag = 9999;
//    [_outRequest setRequestMethod:@"POST"];
//    [_outRequest startAsynchronous];
//}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_FOR_SETTING_TABLEVIEW_CELL;
    NSLog(@"HEIGHT_FOR_SETTING_TABLEVIEW_CELL %d",HEIGHT_FOR_SETTING_TABLEVIEW_CELL);
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

@end

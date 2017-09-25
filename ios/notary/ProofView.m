//
//  ProofView.m
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import "ProofView.h"
#import "ListProofView.h"
#import "SearchView.h"
#import "AppDelegate.h"
#import "NotaryView.h"
#import "UserInfoView.h"
#import "NewProofapplyView.h"
#import "NoticeView.h"
#import "ZSYTextPopView.h"

#import "SettingCell.h"
#import "SettingView.h"
#import "UserCenter.h"

#import "MeTableViewCell.h"

#import "MessageCenter.h"

@interface ProofView ()

@property (nonatomic ,weak) UIButton *badgeBtn;


- (void)handleAlertTextField;


- (void)handleActivityStart;
- (void)handleActivityStop;

- (NSString *)getFolderImageName:(NSInteger)type;

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

@implementation ProofView


//LogInAgain
-(void)addMessageNum{
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.window.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
     UserModel * user = [UserModel sharedInstance];
    _noReadMsgCount = user.unReadMsgNum;
    
    if (_noReadMsgCount > 0) {
        
    btnNumMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNumMessage.userInteractionEnabled = NO;
    btnNumMessage.tag = 1001;
    btnNumMessage.titleLabel.font = [UIFont systemFontOfSize:12];
    btnNumMessage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 15, 3, 15, 15);
    [btnNumMessage setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [btnNumMessage setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
    //[self.navigationController.navigationBar addSubview:btnNum];
    
    [delgate.tabBar.bottomView addSubview:btnNumMessage];
    
  }
    
}
-(void)removeMessageNum{
    
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.tabBar.bottomView.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
    
    //[btnNumMessage removeFromSuperview];
}
//
//- (void)postHttpGetTipsNum
//{
//    
//    _msgArr = [[NSMutableArray alloc] initWithCapacity:10];
//    
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
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_MESSAGE_URL];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    
//    _tipsRequest = [ASIFormDataRequest requestWithURL:url];
//    
//    /*此处userID是写死的，38，用来测试的*/
//    
//    [_tipsRequest setPostValue:user.userID forKey:@"userID"];
//    [_tipsRequest setPostValue:APP_ID forKey:@"app_id"];
//    [_tipsRequest setPostValue:VERSIONS forKey:@"v"];
//    [_tipsRequest setPostValue:phoneNum forKey:@"mobileNo"];
//    [_tipsRequest setPostValue:@"1" forKey:@"src"];
//    [_tipsRequest setPostValue:sig forKey:@"sig"];
//    
//    [_tipsRequest setDidStartSelector:@selector(requestStartJiaobiao:)];
//    [_tipsRequest setDidFailSelector:@selector(requestFailJiaobiao:)];
//    [_tipsRequest setDidFinishSelector:@selector(requestFinishJiaobiao:)];
//    [_tipsRequest setDidReceiveDataSelector:@selector(requestReceiveDataJiaobiao:didReceiveData:)];
//
//    
//    
//    _tipsRequest.delegate = self;
//    _tipsRequest.tag= 8888;
//    [_tipsRequest setRequestMethod:@"POST"];
//    [_tipsRequest startAsynchronous];
//}
//#pragma ASIHttpRequestJiaobiao Delegate method
//- (void)requestStartJiaobiao:(ASIHTTPRequest *)request
//{
//  
//}
//- (void)requestFailJiaobiao:(ASIHTTPRequest *)request
//{
//  
//    
//}
//- (void)requestFinishJiaobiao:(ASIHTTPRequest *)request
//{
//    
//        
//        //__block self;
//        NSDictionary * jsonDic = [_jsonData1 objectFromJSONData];
//        NSString * code = [jsonDic objectForKey:@"code"];
//        //   NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
//        //  NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
//        if ([code intValue] == 0) {
//            
//            [_msgArr removeAllObjects];
//            [_msgArr addObjectsFromArray:[jsonDic objectForKey:@"data"]];
//            NSLog(@"_msgArr-->%@",_msgArr);
//            _noReadMsgCount = 0;
//            
//            for (int i = 0; i < [_msgArr count]; i++) {
//                if ([[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"N"] || [[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"n"]) {
//                    _noReadMsgCount++;
//                }
//            }
//        }else {
//            //[self alertWithMessage:codeInfo];
//        }
//        [self addMessageNum];
//        
//        
//    
//    [_jsonData1 setLength:0];
//    
//}
//- (void)requestReceiveDataJiaobiao:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    
//        
//        [_jsonData1 appendData:data];
//        
//    
//}


- (void)initNavigationBar {
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tit_logo"]];
//    self.navigationItem.titleView = imageView;
    
    
    //_customLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    /*
     _customLeft.frame = CGRectMake(0, 0, 40, 40);
    [_customLeft setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
     */
    //申请公证的点击按钮
   
    
    //[_customLeft addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];

    
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItem:@"我的选中" higImageNmae:@"我的选中" tager:nil action:nil frame:CGRectMake(0.0f, 0.0f, 70.0f, 40.0f) title:@"我的"];
    //self.navigationItem.leftBarButtonItem.enabled = NO;
  
    
//    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    customRight.frame = CGRectMake(0, 0, 40, 40);
//    [customRight addTarget:self action:@selector(handleAlertTextField) forControlEvents:UIControlEventTouchUpInside];
//    [customRight setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.logpress = [[UILongPressGestureRecognizer alloc] init];
    [self.logpress addTarget:self action:@selector(handleLongPress:)];
    self.logpress.minimumPressDuration = 1.0;
    self.logpress.delegate = self;
    [_contentView addGestureRecognizer:self.logpress];
    
}

- (void)handleAlertTextField
{
    if (IOS7_OR_LATER) {
        ZSYTextPopView*SearchView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
        SearchView.titleName.text = @"搜索";
        SearchView.maxLength=60;
        SearchView.tag=2;
        SearchView.myDelegate=self;
        [SearchView show];

    }else{
        
        _alert4Search = [[CustomAlertView alloc] initWithAlertTitle:@"搜索"];
        _alert4Search.delegate = self;
        _alert4Search.maxLength = 40;
        [_alert4Search show];
        
        [MobClick event:@"收索事件"];
    
    }
    
}
- (void)handleRefresh:(UIButton *)btn
{
    /*
    NotaryView * notary = [[NotaryView alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    */
    
    NSUserDefaults * defauls =  [NSUserDefaults standardUserDefaults];
    NSString * notice =  [defauls objectForKey:@"Notice"];
    
    if (notice == nil){
    
        NoticeView * notView = [[NoticeView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        @try {
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
       
        return;
    }
   
    UserModel * user = [UserModel sharedInstance];
    if (user.isExist){
        
        NewProofapplyView * notary = [[NewProofapplyView alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }

        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        
        UserInfoView * infoView = [[UserInfoView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:infoView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
       
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }

    
    /*
    _customLeft.enabled = NO;
    [self requestFolderList];
    */
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] , NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    
    UserModel * user = [UserModel sharedInstance];
    _noReadMsgCount = user.unReadMsgNum;
    
    if (_noReadMsgCount > 0) {
        
        self.badgeBtn.hidden =  NO;
        
        
        self.badgeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        NSString *num = [NSString stringWithFormat:@"%d",user.unReadMsgNum];
        [self.badgeBtn setTitle:num forState:UIControlStateNormal];
    }

    
    
    //用与及时更新文件数量显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList:) name:Notification_NoticeUploadFileSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList:) name:@"locNubAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListDelete:) name:Notification_NoticeDeleteFile object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListDeleteALL:) name:Notification_NoticeDeleteAllFile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListRestoreALL:) name:Notification_NoticeRestoreAllFile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListForder:) name:Notification_NoticeLogInAgain object:nil];

    
    
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];
    [self initNavigationBar];
    
    _uploadCount = [self queryUploadFileCount];

    
    _folderArray = [[NSMutableArray alloc] init];
    _jsonData = [[NSMutableData alloc]init];
    _jsonFolderList = [[NSMutableData alloc] init];
    
    [self requestFolderList];
    
    _btnRecoverNum = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRecoverNum setBackgroundImage:[UIImage imageNamed:@"btn_new"] forState:UIControlStateNormal];
    _btnRecoverNum.hidden = YES;
    _btnRecoverNum.userInteractionEnabled = NO;
    _btnRecoverNum.titleLabel.font = [UIFont systemFontOfSize:8];
    if (IS_IPHONE_5) {
        
        _btnRecoverNum.frame = CGRectMake(288, 400, 18, 18);

    }else {

        _btnRecoverNum.frame = CGRectMake(288, 319, 18, 18);

    }
    
    [self.view addSubview:_btnRecoverNum];
    
    
#pragma - mark  刷新
//    if (nil == _refreshHeaderView) {
//        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.contentView.bounds.size.height, self.view.frame.size.width, self.contentView.bounds.size.height)];
//        _refreshHeaderView.delegate = self;
//        [_contentView addSubview:_refreshHeaderView];
//    }
//    [_refreshHeaderView refreshLastUpdatedDate];
    
    //告知的通知方法
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(noticeInform) name:@"Notification_NoticeInform" object:nil];
    
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedProof"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedProof"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchProof"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchProof"]) {
        
        
    }else {
        leadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leadBtn.frame =CGRectMake(0, 0, 320, 480+(IS_IPHONE_5?88:0));
        [leadBtn setBackgroundImage:[UIImage imageNamed:(IS_IPHONE_5?@"walkthroughs-2.png":@"saveimage14.png")] forState:UIControlStateNormal];
        
        [leadBtn addTarget:self action:@selector(userDidTap) forControlEvents:UIControlEventTouchUpInside];
        AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delgate.window addSubview:leadBtn];
        
       
        
    }
    
    
    //个人信息
    self.contentView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc]init];
        
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160);
        
         UserCenter *user = [[UserCenter alloc]init];
        [self addChildViewController:user];
        [view addSubview:user.view];
        view.frame = CGRectMake(0, 10, view.bounds.size.width,view.bounds.size.height - 20 );
        view.clipsToBounds = YES;
        
        view;
    });
    

 
    
}
-(void)userDidTap{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunchProof"];
    [leadBtn removeFromSuperview];
 
}
-(void)noticeInform{
    
  
    UserModel * user = [UserModel sharedInstance];
    if (user.isExist){
        
        NewProofapplyView * notary = [[NewProofapplyView alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        
        UserInfoView * infoView = [[UserInfoView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:infoView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_contentView reloadData];
    
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
#pragma - mark satusBar 颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _contentView.scrollEnabled = NO;
   
    _jsonData1=[[NSMutableData alloc] init];
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:NO];
    [MobClick beginLogPageView:@"证据管理"];
    /////yang---/////
     //[self requestFolderList];
    //modify by liwzh消息获取方式修改  beigin
   //[self postHttpGetTipsNum];
    [self addMessageNum];
    //end

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"证据管理"];
    [self removeMessageNum];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    
}
#pragma mark - ZSYTextPopView

-(void)popoView:(ZSYTextPopView *)popview content:(NSString *)content clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"popview---%ld",(long)popview.tag);
    NSLog(@"content---content:-%@",content);
    NSLog(@"content---clickedButtonAtIndex:%ld",(long)buttonIndex);
    if (![content isEqualToString:@""]) {
        
   
    if (popview.tag == 1 && buttonIndex == 1)
        {
            
            BOOL isExist = NO;
            
            for (int i =0; i <_folderArray.count;i++) {
                
                FolderModel * folder = [_folderArray objectAtIndex:i];
                
                //去除前后空格
                NSString * newkeword = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([folder.folderName  isEqualToString:newkeword]) {
                    isExist = YES;
                }
            }
            
            if (isExist) {
                
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"文件夹已存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [errorAlert show];
                
            }else {
                
                [self requestCreateFolder:content];
                
            }
            
        }else if(popview.tag == 2 && buttonIndex == 1){
            
            
                
                SearchView * search = [[SearchView alloc] initWithNibName:@"SearchView" bundle:nil];
                search.keyWord = content;
                
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:search];
            
            if (IOS7_OR_LATER) {
               
                [nav.navigationBar setBarStyle:UIBarStyleBlack];
                
                [nav.navigationBar setTranslucent:NO];
               
            }
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else if (popview.tag == 3 && buttonIndex == 1){
            
            FolderModel * folder = [_folderArray objectAtIndex:_indexPath4Sheet.row];
            
            [self requestRenameFolder:content];
        }

       }
        
        
        
    
    
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                         message:@"hhfhfshfhsfhhfhsfhsfhshhjfhhdjhshjh"
//                                                        delegate:nil
//                                               cancelButtonTitle:@"确定"
//                                               otherButtonTitles:nil];
//    [alertView show];
    
}

- (IBAction)btnAddClick:(UIButton *)but
{
    if (IOS7_OR_LATER) {
        
        if (IS_IPHONE_5) {
            ZSYTextPopView*folderView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            folderView.titleName.text = @"输入文件夹名称";
            folderView.maxLength=60;
            folderView.tag=1;
            folderView.myDelegate=self;
            [folderView show];

        }else{
        
            ZSYTextPopView*folderView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            folderView.titleName.text = @"输入文件夹名称";
            folderView.maxLength=60;
            folderView.tag=1;
            folderView.myDelegate=self;
            [folderView show];

        
        }
       
    }else{
        
    _alert4Folder = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件夹名"];
    _alert4Folder.delegate = self;
    _alert4Folder.maxLength = 60;
    [_alert4Folder show];
    
    [MobClick event:@"创建文件夹"];
    }
}
- (IBAction)btnRecoverClick:(UIButton *)but
{
    ListProofView * listProof = [[ListProofView alloc] initWithNibName:@"ListProofView" bundle:nil];
    listProof.parentFolder = _recover;
    [self.navigationController pushViewController:listProof animated:YES];
}
- (void)handleActivityStart
{
      [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
}
- (void)handleActivityStop
{
    [DejalBezelActivityView removeView];
}
#pragma UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundView = nil;
    static NSString *CellIdentifier = @"default";
    
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:self options:nil];
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
                cell.title.text = @"我的录音";
                cell.image.image = [UIImage imageNamed:@"我的录音"];
                cell.badge.hidden =  YES;
                break;
            case 1:
                cell.title.text = @"我的设置";
                cell.image.image = [UIImage imageNamed:@"我的设置"];
                cell.badge.hidden =  YES;

                break;
            case 2:
                cell.title.text = @"消息中心";
                cell.image.image = [UIImage imageNamed:@"用户中心"];
                
                self.badgeBtn = cell.badge;
                self.badgeBtn.hidden =  YES;
                
                
                if (_noReadMsgCount > 0) {
                    
                    self.badgeBtn.hidden =  NO;
                    
                    
                    self.badgeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                    
                    
                    NSString *num = [NSString stringWithFormat:@"%d",_noReadMsgCount];
                    [self.badgeBtn setTitle:num forState:UIControlStateNormal];
                }
              
                break;
                
            default:
                break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:fileName];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                ListProofView * listProof = [[ListProofView alloc] initWithNibName:@"ListProofView" bundle:nil];
                
                FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
                listProof.isRootFloder = YES;
                
                listProof.parentFolder = folder;
                
                //rootfolder 是为了向下传递root值
                listProof.rootFolder = folder;
                
                listProof.rootFolderID = folder.folderID;
                
                [self.navigationController pushViewController:listProof animated:YES];
                
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
//                UserCenter *user = [[UserCenter alloc]init];
//                [self.navigationController pushViewController:user animated:YES];
                
                MessageCenter *messageCenterVC = [[MessageCenter alloc] init];
                [self.navigationController pushViewController:messageCenterVC animated:YES];
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:YES];
                
                
            }
                break;
            default:
                break;
        }
    }
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    NSString * message = [NSString stringWithFormat:@"确定删除%@文件夹及其子项",folder.folderName];
    self.alert4Delete = [[UIAlertView alloc] initWithTitle:nil
                                               message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert4Delete.tag = indexPath.row;
    [self.alert4Delete show];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 5)
    {
        return YES;
    }
    else {
        
        return NO;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{

    return 18;
    

}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == _alert4Delete) {
        
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            
            int index = alertView.tag;
            FolderModel * folder = [_folderArray objectAtIndex:index];
            
            [self requestDeleteFolder:folder];
            
        }
        
        return;
    }

    
    CustomAlertView * alert = (CustomAlertView *)alertView;
    NSString * keyword = [alert getKeyWord];
    
    if (alert == _alert4Folder) {
        
        //点击确定
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            
            BOOL isExist = NO;
            
            for (int i =0; i <_folderArray.count;i++) {
                
                FolderModel * folder = [_folderArray objectAtIndex:i];
                
                //去除前后空格
                NSString * newkeword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([folder.folderName  isEqualToString:newkeword]) {
                    isExist = YES;
                }
            }
            
            if (isExist) {
                
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"文件夹已存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [errorAlert show];
                
            }else {
                
                [self requestCreateFolder:keyword];
                
            }
            
        }
        
    }else if (alert == _alert4Search) {
        
          if (buttonIndex == alertView.firstOtherButtonIndex) {
        
              SearchView * search = [[SearchView alloc] initWithNibName:@"SearchView" bundle:nil];
              search.keyWord = keyword;
              
              UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:search];
              
              [self.navigationController presentViewController:nav animated:YES completion:nil];
          }
        
        
    }else if (alert == _alert4RenameFolder){
        
        FolderModel * folder = [_folderArray objectAtIndex:_indexPath4Sheet.row];
        
        [self requestRenameFolder:keyword];
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

- (int)queryUploadFileCount
{
    int count = 0;
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"select count(*) from FileModel where actiontype = 0 and uid = %@",user.uid] ;
    debugLog(sql);
    
    FMResultSet * result =  [db query:sql];
    while (result.next) {
        
        count = [result intForColumnIndex:0];
    }
    
    [db close];
    
    NSLog(@"count %d",count);
    return count;
}

//通过通知 解决viewWillAppear不调用问题
- (void)updateList:(NSNotification*)notification
{
    FolderModel * foler = [notification object];
    
    for (int i = 0; i<_folderArray.count;i++){
        
        FolderModel * tmp = [_folderArray objectAtIndex:i];
        if ([tmp.folderName isEqualToString:foler.folderName]) {
            
            int  dataNum = [tmp.dataNum intValue] + 1;
            tmp.dataNum = [NSString stringWithFormat:@"%d",dataNum];
            break;
        }
        
    }
    
    [_contentView reloadData];
}
- (void)updateListDelete:(NSNotification*)notification
{
    
    FolderModel * foler = [notification object];
    
    //对回收站的特殊处理
    if ([foler.folderID isEqualToString:_recover.folderID]){
        
//        [_btnRecoverNum setTitle:tmp.dataNum forState:UIControlStateNormal];
        
        int  dataNum = [_recover.dataNum intValue] - 1;
        
        if (dataNum >= 0){
            _recover.dataNum = [NSString stringWithFormat:@"%d",dataNum];
        }
        [_btnRecoverNum setTitle:_recover.dataNum forState:UIControlStateNormal];
        return;
    }
    
    
    for (int i = 0; i<_folderArray.count;i++){
        
        FolderModel * tmp = [_folderArray objectAtIndex:i];
        if ([tmp.folderID isEqualToString:foler.folderID]) {

            int  dataNum = [tmp.dataNum intValue] - 1;
            
            if (dataNum >= 0){
                
                tmp.dataNum = [NSString stringWithFormat:@"%d",dataNum];
                //除本地之外的删除
                if (![tmp.folderName isEqualToString:@"本地文件"]){

                //回收站要加1
                int  dataNum = [_recover.dataNum intValue] + 1;
                if (dataNum >= 0){
                    _recover.dataNum = [NSString stringWithFormat:@"%d",dataNum];
                }
                [_btnRecoverNum setTitle:_recover.dataNum forState:UIControlStateNormal];
                }

            }

            break;
        }
        [_contentView reloadData];

    }
   
    
}
- (void)updateListDeleteALL:(NSNotification*)notification{
    [_btnRecoverNum setTitle:@"0" forState:UIControlStateNormal];
}
- (void)updateListRestoreALL:(NSNotification*)notification{
    
    [_btnRecoverNum setTitle:@"0" forState:UIControlStateNormal];
    
}
- (void)updateListForder:(NSNotification*)notification{
    [self requestFolderList];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	//[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	 
	_reloading = YES;
    
    [self requestFolderList];
	 
}
- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.contentView];
	
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


#pragma ASIHttpRequest methods
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
- (void)requestCreateFolder:(NSString *)name
{
    
    NSString * temp = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([temp isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
        
    }
    
    
    BOOL charact = [NSString isIncludeSpecialCharact:name];
    
    if (charact) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能包含特殊字符" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSString * regex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:name];
    
    if (!isMatch) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能包含特殊符号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:name forKey:@"folderName"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"创建文件夹:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"创建文件夹:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,CREATE_FOLDER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _requestCreateFolder = [[ASIFormDataRequest alloc] initWithURL:url];
    [_requestCreateFolder setPostValue:user.userID forKey:@"userID"];
    [_requestCreateFolder setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestCreateFolder setPostValue:name forKey:@"folderName"];
    
    [_requestCreateFolder setPostValue:@"1" forKey:@"src"];
    [_requestCreateFolder setPostValue:APP_ID forKey:@"app_id"];
    [_requestCreateFolder setPostValue:VERSIONS forKey:@"v"];
    [_requestCreateFolder setPostValue:sig forKey:@"sig"];
    
    
    [_requestCreateFolder setDelegate:self];
    [_requestCreateFolder setDidStartSelector:@selector(requestStart:)];
    [_requestCreateFolder setDidFailSelector:@selector(requestFail:)];
    [_requestCreateFolder setDidFinishSelector:@selector(requestFinish:)];
    [_requestCreateFolder setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestCreateFolder startAsynchronous];
}
- (void)requestDeleteFolder:(FolderModel *)model
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:model.folderID forKey:@"folderIDs"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"删除文件夹:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"删除文件夹:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,DELETE_FOLDER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    _requestDeleteFolder = [[ASIFormDataRequest alloc] initWithURL:url];
    _requestDeleteFolder.userInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
    
    [_requestDeleteFolder setPostValue:user.userID forKey:@"userID"];
    [_requestDeleteFolder setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestDeleteFolder setPostValue:model.folderID forKey:@"folderIDs"];
    [_requestDeleteFolder setPostValue:@"1" forKey:@"src"];
    [_requestDeleteFolder setPostValue:APP_ID forKey:@"app_id"];
    [_requestDeleteFolder setPostValue:VERSIONS forKey:@"v"];
    [_requestDeleteFolder setPostValue:sig forKey:@"sig"];
    
    [_requestDeleteFolder setDelegate:self];
    [_requestDeleteFolder setDidStartSelector:@selector(requestStart:)];
    [_requestDeleteFolder setDidFailSelector:@selector(requestFail:)];
    [_requestDeleteFolder setDidFinishSelector:@selector(requestFinish:)];
    [_requestDeleteFolder setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    [_requestDeleteFolder startAsynchronous];
}


#pragma ASIHttpRequest Delegate method
- (void)requestStart:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        [self handleActivityStart];
        
    }
    else if (request == _requestCreateFolder){
        
    }
    else if (request == _requestDeleteFolder){
        [self handleActivityStart];
    }
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        _customLeft.enabled = YES;
        [self handleActivityStop];
        
    }
    else if (request == _requestCreateFolder){
        
    }
    else if (request == _requestDeleteFolder){
        [self handleActivityStop];
    }

}
- (void)requestFinish:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        _customLeft.enabled = YES;
        
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
                
                _recover = folder;
                [_btnRecoverNum setTitle:_recover.dataNum forState:UIControlStateNormal];
                
                
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
        [_contentView reloadData];
        [_jsonFolderList setLength:0];
        
        [self doneLoadingTableViewData];
        
    }
    else if (request == _requestCreateFolder){
        
        [self requestFolderList];
        
    }
    else if (request == _requestDeleteFolder){
        
        [self handleActivityStop];
        
        NSDictionary * dic = request.userInfo;
        FolderModel * folder = [dic objectForKey:@"model"];
        [_folderArray removeObject:folder];
        
        [_contentView reloadData];
    }

}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
     if (request == _requestRefresh) {
        
        [_jsonFolderList appendData:data];
        
    }
    else if (request == _requestCreateFolder){
        
        NSDictionary * jsonDic = [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
        
        NSString * message = [NSString stringWithFormat:@"%@,文件夹名称不能包含特殊符号",codeInfo];
        
        if ([code intValue] != 0) {
            
            [self alertMessage:message];
        }

    }
    else if (request == _requestDeleteFolder){
        
    }

}
- (void)alertMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


//次方法会被调用多次
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //通过点击的point 判断按下的是哪个cell
    
    CGPoint point = [gestureRecognizer locationInView:_contentView];
    
    NSIndexPath * indexPath = [_contentView indexPathForRowAtPoint:point];
    _indexPath4Sheet = indexPath;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        
        if (indexPath != nil) {
            
            FolderModel * folder = [_folderArray objectAtIndex:_indexPath4Sheet.row];
            
            
            if ([folder.folderName isEqualToString:@"通话录音"]){
                return;
            }
            else if ([folder.folderName isEqualToString:@"现场录音"])
            {
                return;
            }
            else if ([folder.folderName isEqualToString:@"照片图片"])
            {
                return;
            }
            else if ([folder.folderName isEqualToString:@"音频视频"])
            {
                return;
            }
            else if ([folder.folderName isEqualToString:@"其它资料"])
            {
                return;
                
            }else {
            
            
                UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重命名",@"移动", nil];
                sheet.delegate = self;
                sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [sheet showInView:self.view];
            
            }
        }
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        
    {
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
    }
    
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
        
        if (IOS7_OR_LATER) {
            
           
         [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
            
        }else{
            _alert4RenameFolder = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件夹名"];
            _alert4RenameFolder.delegate = self;
            _alert4RenameFolder.maxLength = 60;
            [_alert4RenameFolder show];
        
        
        }
       

    }else{
        
        
        
    }
    
}
-(void)startTimer{
    
    ZSYTextPopView*RenameView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    RenameView.titleName.text = @"输入文件夹名";
    RenameView.maxLength=60;
    RenameView.tag=3;
    RenameView.myDelegate=self;
    [RenameView show];


}
- (void)requestRenameFolder:(NSString *)name
{
    FolderModel * file = [_folderArray objectAtIndex:_indexPath4Sheet.row];
    
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.folderID forKey:@"folderID"];
    [dic setObject:name forKey:@"name"];
    /*
     if (file.isFolder) {
     [dic setObject:file.serverFileId forKey:@"folderIDs"];
     }else {
     [dic setObject:file.serverFileId forKey:@"fileIDs"];
     }
     */
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"修改文件夹名:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"修改文件夹名:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RE_NAME_FOLDER];
    NSURL * url = [NSURL URLWithString:urls];
    
    
    debugLog(@"%@%@?app_id=%@&v=%@&src=1&userID=%@&mobileNo=%@&folderID=%@&name=%@&sig=%@",ROOT_URL,RE_NAME_FOLDER,APP_ID,VERSIONS,user.userID,user.phoneNumber,file.folderID,name,sig);
    
    _requestRename = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRename setPostValue:user.userID forKey:@"userID"];
    [_requestRename setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRename setPostValue:@"1" forKey:@"src"];
    [_requestRename setPostValue:APP_ID forKey:@"app_id"];
    [_requestRename setPostValue:VERSIONS forKey:@"v"];
    [_requestRename setPostValue:file.folderID forKey:@"folderID"];
    [_requestRename setPostValue:name forKey:@"name"];
    [_requestRename setPostValue:sig forKey:@"sig"];
    
    [_requestRename setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
   
    
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
   
    [_folderArray removeAllObjects];
    [self requestFolderList];
    
}
- (void)requestRenameReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    
    NSLog(@"清空全部文件 dic %@",dic);
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}


@end
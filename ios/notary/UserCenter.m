//
//  About.m
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UserCenter.h"
#import "Recharge.h"
#import "SettingView.h"
#import "AppDelegate.h"
#import "MessageCenter.h"

@interface UserCenter ()

@property (nonatomic ,weak) UIButton *bardge;


@end

@implementation UserCenter

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
    btnNumMessage.titleLabel.font = [UIFont systemFontOfSize:10];
    btnNumMessage.frame = CGRectMake(280, 3, 15, 15);
    [btnNumMessage setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [btnNumMessage setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
    //[self.navigationController.navigationBar addSubview:btnNum];
    
    [delgate.tabBar.bottomView addSubview:btnNumMessage];
    
    btnNum = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNum.userInteractionEnabled = NO;
    btnNum.tag = 1001;
    btnNum.frame = CGRectMake(55, 5, 15, 15);
    btnNum.titleLabel.font = [UIFont systemFontOfSize:10];
    if (!IOS7_OR_LATER) {
        btnNum.frame = CGRectMake(45, 5, 15, 15);
    }

    [btnNum setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [btnNum setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:btnNum];
        
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
//    [_tipsRequest setTimeOutSeconds:30.0f];
//    
//    
//    
//    _tipsRequest.delegate = self;
//    _tipsRequest.tag= 8888;
//    [_tipsRequest setRequestMethod:@"POST"];
//    [_tipsRequest startAsynchronous];
//}
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

- (void)httpGetShareMessage
{
    if (nil == _shareText) {
        UserModel * user = [UserModel sharedInstance];
        NSString *phoneNum = user.phoneNumber;
        NSLog(@"userID---->%@", user.userID);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:phoneNum forKey:@"mobileNo"];
        [dic setObject:user.userID forKey:@"userID"];
        NSString *result = [URLUtil generateNormalizedString:dic];
        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
        
        NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SHARE_INFO];
        NSURL *url = [NSURL URLWithString:urls];
        NSLog(@"request URL is: %@",url);
        
        _shareRequest = [ASIFormDataRequest requestWithURL:url];
        
        [_shareRequest setPostValue:user.userID forKey:@"userID"];
        [_shareRequest setPostValue:APP_ID forKey:@"app_id"];
        [_shareRequest setPostValue:VERSIONS forKey:@"v"];
        [_shareRequest setPostValue:phoneNum forKey:@"mobileNo"];
        [_shareRequest setPostValue:@"1" forKey:@"src"];
        [_shareRequest setPostValue:sig forKey:@"sig"];
        [_shareRequest setTimeOutSeconds:30.0f];
        _shareRequest.delegate = self;
        _shareRequest.tag= 7777;
        [_shareRequest setRequestMethod:@"POST"];
        [_shareRequest startAsynchronous];
    }
}

//- (void)postHttpGetTipsNum
//{
//    
//     _msgArr = [[NSMutableArray alloc] initWithCapacity:0];
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
//    _tipsRequest.delegate = self;
//    _tipsRequest.tag= 8888;
//    [_tipsRequest setRequestMethod:@"POST"];
//    [_tipsRequest startAsynchronous];
//}

- (void)postHttp
{
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;
    
    NSLog(@"----------%@,%@,%@,%@,%@",user.userCode,user.userID,user.userName,user.password,user.phoneNumber);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ROOT_URL,USER_PACKAGE_MARGIN_URL];
    NSURL * postServierURL = [NSURL URLWithString:url];
    request = [ASIFormDataRequest requestWithURL:postServierURL];

    //测试，先用的是38ID，后民要改成自己的ID；
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:phoneNum forKey:@"mobileNo"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:sig forKey:@"sig"];
     [request setTimeOutSeconds:30.0f];
    
    request.delegate = self;
    request.tag = 100;
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}

- (void)request:(ASIHTTPRequest *)request1 didReceiveData:(NSData *)data
{
    
    
    
   
    if (request1.tag == 8888) {
        
//         [_jsonData appendData:data];
        
    }else if(7777 == request1.tag){
        NSDictionary * jsonDic = [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
      //  NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
        //        NSLog(@"jsonDic:%@    code:%@   codeInfo:%@",jsonDic,code,codeInfo);
        if (0 == [code intValue]) {
            NSDictionary *tmpDic= [jsonDic objectForKey:@"data"];
            _shareText = [tmpDic objectForKey:@"text"];
            NSLog(@"分享内容  %@",_shareText);
            NSString *tmpStr = [tmpDic objectForKey:@"picUrl"];
            _shareImageUrl = [ROOT_URL stringByAppendingString:tmpStr];
           
        }else{
            //            [self alertWithMessage:codeInfo];
        }
    }
     else if (6666 == request1.tag) {
         NSDictionary * jsonDic =  [data objectFromJSONData];
         NSString * code = [jsonDic objectForKey:@"code"];
         NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
         if (0 == [code intValue]) {
             [self alertWithMessage:codeInfo];
             NSDictionary *dic = [jsonDic objectForKey:@"data"];
             NSString * newLeftMoney =[dic objectForKey:@"newLeftMoney"];
             self.binNumberLabel.text=newLeftMoney;
            NSLog(@"---------newLeftMoney%@",newLeftMoney);
         } else {
              [self alertWithMessage:codeInfo];
         }
         NSLog(@"---------code%@",code);
      
         
     }else  if (request1.tag == 100) {
    /*    code = 0;
     codeInfo = "";
     data =     {
     callRecordLeft = 100;
     leftMoney = 50;
     spaceAll = 140444407;
     spaceUsed = 94427338;
     };*/
    _feeMsg = [[FeeMsgModel alloc] init];
//    JSONDecoder *jd = [[JSONDecoder alloc] init];
    NSDictionary * jsonDic =  [data objectFromJSONData];
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    
    if (0 == [code intValue]) {

    NSLog(@"jsonDic--->%@",jsonDic);
    _feeMsg.callRecordLeft = [[jsonDic objectForKey:@"data"] objectForKey:@"callRecordLeft"];
    _feeMsg.leftMoney = [[jsonDic objectForKey:@"data"] objectForKey:@"leftMoney"];
    _feeMsg.spaceAll = [[jsonDic objectForKey:@"data"] objectForKey:@"spaceAll"];
    _feeMsg.spaceUsed = [[jsonDic objectForKey:@"data"] objectForKey:@"spaceUsed"];
    
    self.binNumberLabel.text = [NSString stringWithFormat:@"%d", [_feeMsg.leftMoney intValue]];
    self.timeLabel.text = [self formatTime:_feeMsg.callRecordLeft];
    self.GNumberLaber.text =  [NSString stringWithFormat:@"%@/%@",[self performSelector:@selector(formatGandMText:) withObject:_feeMsg.spaceUsed],[self performSelector:@selector(formatGandMText:) withObject:_feeMsg.spaceAll]];
        if (IOS7_OR_LATER) {
            //[self.myProgressView setProgressViewStyle:UIProgressViewStyleDefault];
            //self.myProgressView.frame=CGRectMake(0, 40, 320,40);
            float ProgressProportion= 0.0f;
            
            self.myProgressView.hidden=YES;
            UIImageView*image1=[[UIImageView alloc] initWithFrame:CGRectMake(110, 210, 60, 16)];
           // image1.image=[UIImage imageNamed:@"progressbar_bg"];
            
            if([_feeMsg.spaceAll floatValue]==0){
                ProgressProportion = 1;
            } else {
                 ProgressProportion= [_feeMsg.spaceUsed floatValue]/[_feeMsg.spaceAll floatValue];
            }
            UIImageView*image2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60*ProgressProportion, 16)];
            image2.image=[UIImage imageNamed:@"progressbar"];
            [image1 addSubview:image2];
            
            [self.BackImage addSubview:image1];
            //
            
        }

    
    [self.myProgressView setProgress:[_feeMsg.spaceUsed floatValue]/[_feeMsg.spaceAll floatValue] animated:NO];
        
    }else{
        [self alertWithMessage:codeInfo];
    }
    }else if (request1.tag == 1000){
        [DejalBezelActivityView removeView];
        NSDictionary * jsonDic =  [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
        NSLog(@",,,,%@",jsonDic);
        if (0 == [code intValue]) {
            NSString *newLeftMoney = [[jsonDic objectForKey:@"data"] objectForKey:@"newLeftMoney"];
            [self alertWithMessage:@"签到成功，增加的录音币已经存入您的账户"];
            self.binNumberLabel.text = newLeftMoney;
        }else{
            [self alertWithMessage:codeInfo];
//            [DejalBezelActivityView activityViewForView:self.view withLabel:@"qiandaochengg"];
        }
    }
}
- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)requestFinished:(ASIHTTPRequest *)request22
{
    NSLog(@"request Finish");
    [DejalBezelActivityView removeView];

    if(7777 == request22.tag){
        [self getShareImage];
    }else if (request22.tag == 8888){
        
        //__block self;
//        NSDictionary * jsonDic = [_jsonData objectFromJSONData];
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
//        [_jsonData setLength:0];

    }
    //    NSData *da = [request responseData];
//    JSONDecoder *jd = [[JSONDecoder alloc] init];
//    NSDictionary *ret = [jd objectWithData:da];
//    NSLog(@"retretretret ---- > %@",ret);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request Failed");
    [DejalBezelActivityView removeView];

//    [self alertWithMessage:@"数据加载失败,请检查网络"];
}

- (NSString *)formatGandMText:(NSString *)space
{
    NSString *str = space;
    
    float myFloat = [str floatValue];
    
    NSString *tmpUsed;
    if (myFloat >= 1024*1024) {//>=1g
        tmpUsed = [NSString stringWithFormat:@"%.1fG",myFloat/1024/1024];
    }else if(myFloat >=1024 && myFloat < 1024*1024)
    {
        tmpUsed = [NSString stringWithFormat:@"%.0fM",myFloat/1024];
    }else
    {
        tmpUsed = [NSString stringWithFormat:@"%.0fK",myFloat];
    }
    
    return tmpUsed;
}


- (void)pushSettingVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeMyView
{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tit_logo"]];
//    self.navigationItem.titleView = imageView;
    
    UIButton *brn = [UIButton buttonWithType:UIButtonTypeCustom];
    brn.frame = CGRectMake(320-60, 0, 50, 25);
    
    brn.titleLabel.textAlignment=NSTextAlignmentCenter;
    brn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
    //[brn setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [brn setTitle:@"消息" forState:UIControlStateNormal];
    //[brn setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [brn addTarget:self action:@selector(leftSetting) forControlEvents:UIControlEventTouchUpInside];
    [brn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
#pragma - mark 未读消息
    
    UserModel * user = [UserModel sharedInstance];
    _noReadMsgCount = user.unReadMsgNum;
    
    if (_noReadMsgCount > 0) {

        UIButton *badge = [[UIButton alloc]init];
        badge.frame = CGRectMake(40, 0, 15, 15);
        [badge setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        badge.titleLabel.font = [UIFont systemFontOfSize:10];
        self.bardge = badge;
        NSString *num = [NSString stringWithFormat:@"%d",user.unReadMsgNum];
        [badge setTitle:num forState:UIControlStateNormal];
        [brn addSubview:badge];
    
    }
    
   
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:brn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    UIButton *brnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    brnLeft.frame = CGRectMake(0, 0, 50, 25);
    brnLeft.titleLabel.textAlignment=NSTextAlignmentCenter;
    brnLeft.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [brnLeft setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
   
    [brnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [brnLeft setImage:[UIImage imageNamed:@"btn_msg.png"] forState:UIControlStateNormal];

     [brnLeft addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBtn = [[UIBarButtonItem alloc] initWithCustomView:brnLeft];
    self.navigationItem.leftBarButtonItem = LeftBtn;
    
    //设置进度条的图片
    
    self.myProgressView.trackImage = [UIImage imageNamed:@"progressbar_bg"];
    self.myProgressView.progressImage = [UIImage imageNamed:@"progressbar"];
    
   // UserModel * user = [UserModel sharedInstance];

    self.phoneNumberLabel.text = user.phoneNumber;
    self.nameLabel.text = user.userCode;
}
-(void)leftSetting{
    MessageCenter *messageCenterVC = [[MessageCenter alloc] init];
//                    messageCenterVC.tmpArr = _msgArr;
    [self.navigationController pushViewController:messageCenterVC animated:YES];
      [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _jsonData = [[NSMutableData alloc] init];
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
    [self postHttp];
//    [self postHttpGetTipsNum];
    [self httpGetShareMessage];
    //[self addMessageNum];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
    UIButton *titleBtn = [[UIButton alloc]init];
    [titleBtn setTitle:@"用户中心" forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0, 0, 75, 40);
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.navigationController.navigationItem.titleView = titleBtn;
    
    
    
    //隐藏
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    [delegate hiddenTab:YES];
//
   

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_tipsRequest cancel];
    for (UIButton*btn in self.navigationController.navigationBar.subviews) {
        NSLog(@"-----btn%@",btn);
        if (btn.frame.size.height == 15) {
            [btn removeFromSuperview];
        }
    }
    //[btnNum removeFromSuperview];
     [DejalBezelActivityView removeView];
    [self removeMessageNum];
    
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];


}

- (void)viewDidDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"个人中心"];
    NSLog(@"view DidDisappear");
    if (request != nil) {

        [request clearDelegatesAndCancel];
        request = nil;
    }
    if (signRequest != nil) {
        
        [signRequest clearDelegatesAndCancel];
        signRequest = nil;
    }
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用户中心";
    
    
#pragma  - mark title颜色
    UIColor *Color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:Color forKey:UITextAttributeTextColor];
        
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"UserCenter viewDidLoad");
//    [self postHttp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postHttp) name:Notification_NoticeLogInAgain object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postHttp) name:Notification_NoticeUploadFileSuccess object:nil];
    [self makeMyView];
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedUser"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedUser"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchUser"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchUser"]) {
        
        
    }else {
        
#pragma - mark 半透明提示  图片
        
//        leadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        leadBtn.frame =CGRectMake(0, 0, 320, 480+(IS_IPHONE_5?88:0));
//        [leadBtn setBackgroundImage:[UIImage imageNamed:(IS_IPHONE_5?@"walkthroughs-3.png":@"walkthroughs-3x960.png")] forState:UIControlStateNormal];
//        
//        [leadBtn addTarget:self action:@selector(userDidTap) forControlEvents:UIControlEventTouchUpInside];
//        AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [delgate.window addSubview:leadBtn];
        
    }

}
-(void)userDidTap{
    
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunchUser"];
    
    [leadBtn removeFromSuperview];

 }

- (IBAction)rechargeBtnClick:(UIButton *)sender
{
    //充值测试
    
//    TestRecharge *rechargeVC = [[TestRecharge alloc] init];
    
    //充值
//    [MobClick event:@"充值按钮"];
//    Recharge *rechargeVC = [[Recharge alloc] init];
//    [self.navigationController pushViewController:rechargeVC animated:YES];
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:YES];
}

- (IBAction)signBtnClick:(UIButton *)sender {
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;
     [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在加载" width:0];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ROOT_URL,SIGN_URL];
    NSURL * postServierURL = [NSURL URLWithString:url];
    signRequest = [ASIFormDataRequest requestWithURL:postServierURL];
    
    //测试，先用的是38ID，后民要改成自己的ID；
    [signRequest setPostValue:user.userID forKey:@"userID"];
    [signRequest setPostValue:APP_ID forKey:@"app_id"];
    [signRequest setPostValue:VERSIONS forKey:@"v"];
    [signRequest setPostValue:phoneNum forKey:@"mobileNo"];
    [signRequest setPostValue:@"1" forKey:@"src"];
    [signRequest setPostValue:sig forKey:@"sig"];
    
    signRequest.delegate = self;
    signRequest.tag = 1000;
    [signRequest setRequestMethod:@"POST"];
    [signRequest startAsynchronous];
}

//格式化剩余时长的字符串
- (NSString *)formatTime:(NSString *)callRecordLeft
{
    int cont = [callRecordLeft intValue];
    
    int ss = cont % 60;
    int mm = cont/60;
    int hh = 00;
    if (mm) {
        hh = mm/60;
        mm = (cont - ss - hh*60*60)/60;
    }
    return [NSString stringWithFormat:@"%d小时%02d分%02d秒",hh,mm,ss];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setPhoneNumberLabel:nil];
    [self setBinNumberLabel:nil];
    [self setTimeLabel:nil];
    [self setGNumberLaber:nil];
    [self setMyProgressView:nil];
    [super viewDidUnload];
}

- (IBAction)fangXiangShiJian:(id)sender {
    
    
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
   
    id<ISSContent> publishContent = nil;
    
    //                NSString *contentString = @"This is a sample";
    //                NSString *titleString   = @"title";
    //                NSString *urlString     = @"http://www.ShareSDK.cn";
    //                NSString *description   = @"Sample";
//    _shareText
    publishContent = [ShareSDK content: _shareText
                        defaultContent:@""
                                 image:nil
                                 title: _shareText
                                   url:nil
                           description:nil
                             mediaType:SSPublishContentMediaTypeText];
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeQQ,
                          ShareTypeSinaWeibo,
//                          ShareTypeQQSpace,
                          ShareTypeSMS,
                          nil];
    
    [ShareSDK ssoEnabled:NO];
    //                id<ISSShareOptions> shareOptions =
    //                [ShareSDK simpleShareOptionsWithTitle:@"分享内容"
    //                                    shareViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess){
                                    // NSLog(@"-------%d",(int)type);
                                    if ((int)type == 1) {
                                        [self httpRequestFenXiang:@"0"];
                                    }else if ((int)type == 22) {
                                        [self httpRequestFenXiang:@"1"];
                                    }else if ((int)type == 23) {
                                        [self httpRequestFenXiang:@"2"];
                                    }else  {
                                        [self httpRequestFenXiang:@"3"];
                                    }
                                   
                                    
//                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                                        message:@"分享成功"
//                                                                                       delegate:nil
//                                                                              cancelButtonTitle:@"知道了"
//                                                                              otherButtonTitles:nil];
//                                    [alertView show];
                                    
                                }else if (state == SSPublishContentStateFail){
                                    
                                    if ([error errorCode] == -22003){
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                            }];
}

- (void)getShareImage
{
    //下载分享用的图片
    NSURLRequest * request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:_shareImageUrl]];
    NSOperationQueue*operationQueue=[[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request2
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse*urlResponce,NSData*data,NSError*error)
     {
         if(error)
         {
             NSLog(@"download image error:\n%@",error);
             return ;
         }
         _shareImage = [UIImage imageWithData:data];
     }
     ];
    if (request2 != nil) {
        request2 = nil;
    }
    if (operationQueue != nil) {
        operationQueue = nil;
    }
}
@end

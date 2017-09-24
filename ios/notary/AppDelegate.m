//
//  AppDelegate.m
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import "AddressView.h"

#import "AppDelegate.h"
#import "LoginView.h"
#import "SaveView.h"
#import "ProofView.h"
#import "SettingView.h"
#import "UserCenter.h"
#import "AddressCache.h"
#import "LoadingView.h"
#import "BPush.h"
//
//#import "AlixPay.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
#import <sys/utsname.h>
#import "URLUtil.h"
#import "ASIFormDataRequest.h"
//#import "JSON.h"
#import "JSONKit.h"
#import "WXApi.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Call_NoteVC.h"

#import "MeVC.h"

#import <Contacts/Contacts.h>



@interface AppDelegate ()<BPushDelegate>

@end

static NSString *Token;
static long      token_time;
@implementation AppDelegate
@synthesize listView;

- (void)initAddressBook {
    AddressCache * addressCache = [AddressCache sharedInstance];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        
        //通讯录权限
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined: {
                // 用户尚未就应用程序是否可以访问联系人数据做出选择。
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        // 授权成功
                        [addressCache initAddressBook];

                    }else {
                        // 未授权访问通讯录！
                        return ;
                    }
                    
                }];
                
            }
                break;
            case CNAuthorizationStatusRestricted: // 用户无法更改此应用程序的状态，可能是由于主动限制（如父母控制）。
                return ;
                break;
            case CNAuthorizationStatusDenied: // 用户明确拒绝对应用程序的联系人数据的访问。
                return ;
                break;
            case CNAuthorizationStatusAuthorized: // 该应用程序被授权访问联系人数据。
                return ;
                break;
                
            default:
                break;
        }
    });
    
}

- (void)initMainView
{
    
    
//    ProofView * proof = nil;
//    if(IS_IPHONE_5) {
//        self.proof = [[ProofView alloc] initWithNibName:@"ProofView-ip5" bundle:nil];
//    }else{
//        self.proof = [[ProofView alloc] initWithNibName:@"ProofView" bundle:nil];
//    }
    
    AddressView * proof = nil;
    proof = [[AddressView alloc] initWithNibName:@"AddressView" bundle:nil];
    
    
    UINavigationController * proofNav =[[UINavigationController alloc] initWithRootViewController:proof];
    
    
   // SaveView * save = nil;
    
    Call_NoteVC *save = nil;
    
    //save = [[AddressView alloc] initWithNibName:@"AddressView" bundle:nil];
    
    save = [[Call_NoteVC alloc]init];
    
#pragma - mark 原来的首页   
    
#warning 应该改为拨号页
    
//    if(IS_IPHONE_5) {
//        save = [[SaveView alloc] initWithNibName:@"SaveView-ip5" bundle:nil];
//    }else {
//        save = [[SaveView alloc] initWithNibName:@"SaveView" bundle:nil];
//    }
    
    UINavigationController * saveNav = [[UINavigationController alloc] initWithRootViewController:save];
    
//    MeVC * setting = [[MeVC alloc] initWithNibName:@"MeVC" bundle:nil];
//    UINavigationController * userCenterNav = [[UINavigationController alloc] initWithRootViewController:setting];
//    [setting release];
    
#pragma - mrak 文件页面
        ProofView * proofs = nil;
//        if(IS_IPHONE_5) {
//            proofs = [[ProofView alloc] initWithNibName:@"ProofView-ip5" bundle:nil];
//        }else{
            proofs = [[ProofView alloc] initWithNibName:@"ProofView" bundle:nil];
//        }
    
        UINavigationController * userCenterNav = [[UINavigationController alloc] initWithRootViewController:proofs];
        [proof release];
    
    
//    if (IOS7_OR_LATER) {
    
        [proofNav.navigationBar setBarStyle:UIBarStyleBlack];
        [saveNav.navigationBar setBarStyle:UIBarStyleBlack];
        [userCenterNav.navigationBar setBarStyle:UIBarStyleBlack];
    
    
        
        [proofNav.navigationBar setTranslucent:NO];
        [saveNav.navigationBar setTranslucent:NO];
        [userCenterNav.navigationBar setTranslucent:NO];
        
        [proofNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [saveNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [userCenterNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    }else{
//
//        [proofNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
//        [saveNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
//        [userCenterNav.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
//
//    }
    
    NSArray*controllers = [NSArray arrayWithObjects:proofNav,saveNav,userCenterNav, nil];
    
    UIImageView* back1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通讯录"]];
    
    UIImageView* back2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"拨号"]];
    
    UIImageView* back3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的"]];
    NSArray* backs = [NSArray arrayWithObjects:back1,back2,back3, nil];
    
    
    UIImageView* hilight1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通讯录选中"]];
    
    UIImageView* hilight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"拨号"]];
    UIImageView* hilight3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的选中"]];
    
    NSArray* hilights = [NSArray arrayWithObjects:hilight1,hilight2,hilight3, nil];
    _tabBar = [[XZTabBarViewControler alloc]initWithTab:backs andClickImages:hilights andViewControllers:controllers];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = _tabBar;
    [self.window makeKeyAndVisible];
    self.publicStatisticsStartNumber =  [[PublicStatistics alloc] init];
    [self.publicStatisticsStartNumber startNumber];
    
}
#pragma mark 程序生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:@"2f8f5713b08"];
  //添加QQ空间应用 注册网址 http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"82485040"
                           appSecret:@"8Fcew3mcuNemAiS0"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];

     
    //添加QQ应用 注册网址 http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"82485040"

                                                       qqApiInterfaceCls:[QQApiInterface class]
                                                         tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectSinaWeiboWithAppKey:@"594655793"
                               appSecret:@"db0e008edbea8103aa52d904b5893082"
                             redirectUri:@"http://open.weibo.com/apps/594655793/privilege/oauth"];
    
    [ShareSDK connectWeChatSessionWithAppId:@"wx38d159973f1665c3" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:@"wx38d159973f1665c3" wechatCls:[WXApi class]];
    [ShareSDK connectSMS];
    
     _downloadRequest = [[NSMutableDictionary alloc]init];
    _fileModels = [[NSMutableArray alloc] init];
    _folderArray = [[NSMutableArray alloc]init];
    _uploadArray = [[NSMutableArray alloc] init];
    _uploadSocket = [[NSMutableDictionary alloc] init];
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //配置
    [Config setDefaultHandler];
    
    //友盟统计
    [self umengTrack];
    //检查更新
    [MobClick checkUpdate];
    
    
    //处理未捕获异常
    [NdUncaughtExceptionHandler setDefaultHandler];
    
    //检查异常日志txt文件
    [self checkLog];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
#pragma 判断是否首次登陆  显示 展示页
//
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        
//        ViewController *appStartController = [[ViewController alloc] init];
//        self.window.rootViewController = appStartController;
//        
//    }else {
    
#pragma 广告页
//        LoadingView * loading  = nil;
//        
//        if(IS_IPHONE_5) {
//            loading = [[LoadingView alloc] initWithNibName:@"LoadingView-ip5" bundle:nil];
//            
//        }else {
//            loading = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
//        }
    
    //初始化全局address
    AddressCache * addressCache = [AddressCache sharedInstance];
    [addressCache initAddressBook];
    
    LoginView * log = nil;
    
//    if (IS_IPHONE_5) {
//
//        log = [[LoginView alloc] initWithNibName:@"LoginView-ip5" bundle:nil];
//
//    }else {
        log = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        
//    }
    
     UINavigationController * logNav = [[UINavigationController alloc] initWithRootViewController:log];
    
    self.window.rootViewController = logNav;
    
//#pragma - mrak 去掉登陆
//    
//    MeVC *VC = [[MeVC alloc]init];
//    
//     UINavigationController * meNav = [[UINavigationController alloc] initWithRootViewController:VC];
//    
    
        //self.window.rootViewController = meNav;
        
//    }
    
    [self.window makeKeyAndVisible];
    
    
    [BPush registerChannel:launchOptions apiKey:@"ULkOIKHgVDi8IqcnDsH4Ve9D" pushMode:BPushModeProduction isDebug:NO];
    [BPush setDelegate:self];
    [application setApplicationIconBadgeNumber:0];
    
    
    [BPush setDelegate:self]; // 必须。参数对象必须实现onMethod: response:方法，本示例中为self
    
    // [BPush setAccessToken:@"3.ad0c16fa2c6aa378f450f54adb08039.2592000.1367133742.282335-602025"];  // 可选。api key绑定时不需要，也可在其它时机调用
    

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
        settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                            categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }

    
    

    NSString * firstart = [[NSUserDefaults standardUserDefaults] objectForKey:@"firststart"];
    
    if (nil == firstart) {
        
        self.publicStatisticsFirstStart = [[PublicStatistics alloc]init];
        [self.publicStatisticsFirstStart firstStartApplication];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firststart"];
    }
    
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
     if ([self isSingleTask]) {
        NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
        
        if (nil != url) {
            [self parseURL:url application:application];
        }
    }
     return YES;
    
}


// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

-(void)updateVersions{
    
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=640969531"]];
    
    NSString  *content = [[NSString alloc] initWithBytes:[data1 bytes] length:[data1 length] encoding:NSISOLatin1StringEncoding];
    
    NSString *jsonStr = [[NSString alloc] initWithFormat:@"%@",content];
    
    NSDictionary *postResult = [jsonStr objectFromJSONString];
    NSLog(@"--------postResult:%@",postResult);
    NSArray *latestArr = [postResult objectForKey:@"results"];
    NSDictionary * dic =[latestArr objectAtIndex:0];
    //                        version
    NSLog(@"------latestVersion:%@",[dic objectForKey:@"version"]);
    [self checkUpdate:[dic objectForKey:@"version"]];
    
    
}
- (void)checkUpdate:(NSString *)versionFromAppStroe {
    
    
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"nowVersion == %@",versionFromAppStroe);
    NSLog(@"nowVersion == %@",nowVersion);
    
    //    [processView stopAnimating];
    
    //检查当前版本与appstore的版本是否一致
    
    
    if ([versionFromAppStroe intValue] >[nowVersion intValue])
        
    {
        
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message: @"有新的版本可供下载" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles: @"去下载", nil];
        createUserResponseAlert.tag = 123;
        
        [createUserResponseAlert show];
        
    } else {
        
        
    }
    
 }
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/zheng-ju-guan-jia-tong-hua/id640969531?mt=8"]];
        
        
    } else if (buttonIndex == 2) {
    
    //去itunes中更新
    }
}

- (BOOL)isSingleTask{
    struct utsname name;
    uname(&name);
    float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
    if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
        return YES;
    }
    else {
        return NO;
    }
}
 
//- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
//    AlixPay *alixpay = [AlixPay shared];
//    result = [alixpay handleOpenURL:url];
//    _jsonData = [[NSMutableData alloc] init];
//    [self request];
//}
//-(void)request{
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"payResultCheck.action"];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    ASIFormDataRequest*request =  [[ASIFormDataRequest alloc] initWithURL:url];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    
//    NSString*resultPinjie=[NSString stringWithFormat:@"%@%@\"%@\"%@\"%@\"",result.resultString,@"&sign_type=",result.signType,@"&sign=",result.signString];
//    NSString *transString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(
//                                                                                                   kCFAllocatorDefault,
//                                                                                                   (CFStringRef)resultPinjie, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
//                                                                                                   CFStringConvertNSStringEncodingToEncoding([request stringEncoding])) autorelease]);
//    
//    [dic setObject:@"142" forKey:@"userID"];
//    [dic setObject:transString forKey:@"result"];
//    [dic setObject:@"1" forKey:@"src"];
//    
//    [dic setObject:@"100" forKey:@"payType"];
//    NSString *resultMd5 = [URLUtil generateNormalizedString:dic];
//    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",resultMd5,@"wqerf*6205"]];
//    [request setPostValue:@"1" forKey:@"src"];
//    [request setPostValue:@"142" forKey:@"userID"];
//    [request setPostValue:transString forKey:@"result"];
//    
//    [request setPostValue:@"100" forKey:@"payType"];
//    [request setPostValue:sig forKey:@"sig"];
//    request.delegate = self;
//    [request setRequestMethod:@"POST"];
//    [request startAsynchronous];
//    
//}
#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
    NSLog(@"-----jsonData:%@",_jsonData);
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");
    NSDictionary *jsonDic = [_jsonData objectFromJSONData];
    //NSString *sendStrDic = [jsonDic objectForKey:@"codeInfo"];
    
    // NSLog(@"-----request:%@",[sendStrDic objectForKey:@"checkInfo"]);
    NSLog(@"-----sendStrDic:%@",jsonDic);
    NSString *coodeinfo = [jsonDic objectForKey:@"codeInfo"];
    NSLog(@"codeIn=%@",coodeinfo);
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSLog(@"request Failed");
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    self.endTime = [[NSDate date] timeIntervalSince1970];
    self.publicStatisticsUseTime = [[PublicStatistics alloc]init];
    [self.publicStatisticsUseTime useTime:self.endTime - self.startTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"后台返回");
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:Notification_NoticeLogInAgain object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /*
     [PFPush storeDeviceToken:deviceToken];
     [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
     if (succeeded)
     NSLog(@"Successfully subscribed to broadcast channel!");
     else
     NSLog(@"Failed to subscribe to broadcast channel; Error: %@",error);
     }];
     */
    // 必须
    [BPush registerDeviceToken:deviceToken];
    // 必须。可以在其它时机调用,只有在该方法返回(通过 onMethod:response:回调)绑
    //定成功时,app 才能接收到 Push 消息。一个 app 绑定成功至少一次即可(如果 access token 变更请重新绑定)。
    [BPush bindChannel];
    NSLog(@"deviceToken: %@", deviceToken);
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送服务时，发生以下错误： %@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /*
     [PFPush handlePush:userInfo];
     [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
     */
    
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message: alert
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    //    [application setApplicationIconBadgeNumber:0];
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
    [BPush handleNotification:userInfo];
    
    
}
#pragma mark
// 必须,如果正确调用了 setDelegate,在 bindChannel 之后,结果在这个回调中返回。若绑 定失败,请进行重新绑定,确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    
    
    if ([BPushRequestMethodBind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
    }
    
    
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"pushDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([BPushRequestMethodBind isEqualToString:method]) {
        ///yangjinyang
        //        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        //
        //        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        //        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        //        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        // yangjinyang
        
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
//        if (returnCode == BPushErrorCode_Success) {
//            
//            
//            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
//            
//        }
    }
//    else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
//        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
//        if (returnCode == BPushErrorCode_Success) {
//            
//            [BPush bindChannel];
//        }
//    }
    
}

-(void)requestPushNotiflcation:(NSDictionary*)data{
    
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    NSString *appid = [res valueForKey:BPushRequestAppIdKey];
    NSString *userid = [res valueForKey:BPushRequestUserIdKey];
    NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
    NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
    NSLog(@"appid:%@",appid);
    NSLog(@"userid:%@",userid);
    NSLog(@"channelid:%@",channelid);
    NSLog(@"requestid:%@",requestid);
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    
    //
    [dic setObject:userid forKey:@"userId"];
    [dic setObject:channelid forKey:@"channelId"];
    [dic setObject:@"4" forKey:@"deviceType"];
    
    //    debugLog([_loginKeyWord.text MD5]);
    //    debugLog([URLUtil md5:@"123456"]);
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"login:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    //    NSString * sig = [URLUtil md5:result];
    NSString * logstr2 = [NSString stringWithFormat:@"login:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,PUSH_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setPostValue:userid forKey:@"userId"];
    [request setPostValue:channelid forKey:@"channelId"];
    [request setPostValue:@"4" forKey:@"deviceType"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:sig forKey:@"sig"];
    [request setDidFailSelector:@selector(requestFailedPush:)];
    [request setDidFinishSelector:@selector(requestFinishedPush:)];
    [request setDidReceiveDataSelector:@selector(requestPush:didReceiveData:)];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setTimeOutSeconds:60.0f];
    
    [request startAsynchronous];
    
    
    
}
#pragma mark ASIHTTPRequestDelegatePush
- (void)requestFinishedPush:(ASIHTTPRequest *)request
{
    NSLog(@"-----_jsonData-%@",_jsonData);
    NSString * logstr = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"------%@",logstr);
    [_jsonData setLength:0];
}
- (void)requestFailedPush:(ASIHTTPRequest *)request
{
    
}
- (void)requestStartedPush:(ASIHTTPRequest *)request
{
    // [self handleActivityStart];
    
}
- (void)requestPush:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    // NSLog(@"--------data:%@",data);
    
    [_jsonData appendData:data];
    
}

- (void)hiddenTab:(BOOL)isHidden
{
    [_tabBar hiddenTab:isHidden];
    
}
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)checkLog
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * crashFile = [Sandbox crashLog];
    
    if ( YES == [manager fileExistsAtPath:crashFile]) {
        //发送log 到服务器
    }
    
    //发送成功后删除crashlog.txt
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    //[self parseURL:url application:application];
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"phonerecorder"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
    
    //[self parseURL:url application:application];
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    
}
@end

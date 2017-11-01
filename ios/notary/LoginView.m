//
//  LoginView.m
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "LoginView.h"
#import "AppDelegate.h"
#import "MoreView.h"
#import "RegistView.h"
#import "BPush.h"
#import "ForgetPWDView.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdio.h>


@interface LoginView ()

- (void)handleRememberPassWord;
- (void)handleAudoLogin;


//@property (nonatomic ,strong) UITextField *loginKeyWord;
//
//@property (nonatomic ,strong) UITextField *loginNumber;


@property (weak, nonatomic) IBOutlet UIImageView *loginBG;



@end

@implementation LoginView

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
    
    

    
    
    _jsonData = [[NSMutableData alloc] init];
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    
//    if (IOS7_OR_LATER) {
//       
//        if (IS_IPHONE_5) {
//            self.loginNumber.frame = CGRectMake((320-229)/2, 210, 229, 37);
//            self.loginKeyWord.frame = CGRectMake((320-229)/2, 210+37+12, 229, 37);
//        }else{
//        
//            self.loginNumber.frame = CGRectMake((320-229)/2, 180, 229, 37);
//            self.loginKeyWord.frame = CGRectMake((320-229)/2, 180+37+12, 229, 37);
//        
//        }
//        
//    
//        
//    }else{
//        
//        self.loginNumber.frame = CGRectMake((320-229)/2, 210-48, 229, 37);
//        self.loginKeyWord.frame = CGRectMake((320-229)/2, 210+37+12-48, 229, 37);
//    
//    
//    }
    
    /*
    if (IOS7_OR_LATER) {
        
        if (IS_IPHONE_5) {
            self.loginNumber.frame = CGRectMake((320-229)/2, 260, 229, 42);
            self.loginKeyWord.frame = CGRectMake((320-229)/2, 260+37+12, 229, 42);
            
            self.btnLogin.frame = CGRectMake((320-229)/2, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
            
            self.btnRegist.frame = CGRectMake((320-229)/2 + 9 + 110, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
            
            self.btnMore.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, CGRectGetMaxY(self.btnRegist.frame), 150, 35);
            
            
            
        }else{
            
            
            self.loginNumber.frame = CGRectMake((320-229)/2, 235, 229, 42);
            self.loginKeyWord.frame = CGRectMake((320-229)/2, 235+37+12, 229, 42);
            
            self.btnLogin.frame = CGRectMake((320-229)/2, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
            
            self.btnRegist.frame = CGRectMake((320-229)/2 + 9 + 110, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
            
            self.btnMore.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, CGRectGetMaxY(self.btnRegist.frame), 150, 35);
            
            
        }
        
        
        
    }else{
        
        self.loginNumber.frame = CGRectMake((320-229)/2, 235-48, 229, 42);
        self.loginKeyWord.frame = CGRectMake((320-229)/2, 235+37+12-48, 229, 42);
        
        self.btnLogin.frame = CGRectMake((320-229)/2, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
        self.btnRegist.frame = CGRectMake((320-229)/2 + 9 + 110, CGRectGetMaxY(self.loginKeyWord.frame) + 12, 110, 35);
        
        self.btnMore.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, CGRectGetMaxY(self.btnRegist.frame), 150, 35);
        
        
    }
    */
    
    //_btnMore.hidden = YES;
    _btnRemberPwd.hidden = YES;
    _rexianNum.hidden = YES;
    
    _btnLogin.layer.cornerRadius = 19.0;
    _btnLogin.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.4]);
    _btnLogin.layer.borderWidth = 0.5f;//设置边框颜色
    
//    [_btnLogin setBackgroundImage:[UIImage resizableImageWithName:@"登录按钮"] forState:UIControlStateNormal];
//    [_btnRegist setBackgroundImage:[UIImage resizableImageWithName:@"注册按钮"] forState:UIControlStateNormal];
    
    
//    [_loginNumber setBackground:[UIImage resizableImageWithName:@"用户名密码背景" leftRatio:0.5 topRatio:0.5]];
//    [_loginKeyWord setBackground:[UIImage resizableImageWithName:@"用户名密码背景"]];

    
//    if (IS_IPHONE_4) {
//
//         _loginBG.image = [UIImage imageNamed:@"640960"];
//
//    }else if(IS_IPHONE_5){
//
//        _loginBG.image = [UIImage imageNamed:@"640.png"];
//
//    }else{
//        //6+
//
//        _loginBG.image = [UIImage imageNamed:@"640.png"];
//
//    }
    
    
    
    
    /*
    _loginNumber.text = @"15045663231";
    _loginKeyWord.text = @"123123";
    
    //测试用
    [_userDefault setObject:@"15045663231" forKey:DEFAULT_PHONENUMBER];
    [_userDefault setObject:@"123123" forKey:DEFAULT_PWD];
    */
    /*
    NSString * phonenumber = [_userDefault objectForKey:DEFAULT_PHONENUMBER];
    NSString * pwd = [_userDefault objectForKey:DEFAULT_PWD];
    NSString * isRmb = [_userDefault objectForKey:DEFAULT_ISRMBPWD];
    NSString * isAuto = [_userDefault objectForKey:DEFAULT_ISAUTOLOGIN];
    
    _loginNumber.text = phonenumber;
    
    if ([isRmb isEqualToString:@"YES"]) {
        
        _isRemberPwd = YES;
        [_btnRemberPwd setSelected:YES];
        _loginKeyWord.text = pwd;
        
    }else {
        
        _isRemberPwd = NO;
        [_btnRemberPwd setSelected:NO];
    }
    
    if ([isRmb isEqualToString:@"YES"] && [isAuto isEqualToString:@"YES"]) {
        
        _isAutoLogin = YES;
        [_btnAutoLogin setSelected:YES];
        [self login];
        
    }else {
        
        _isAutoLogin = NO;
        [_btnAutoLogin setSelected:NO];
    }
   */
    
    [self setupKeyBoard];
    
}

- (void)setupKeyBoard{
    
    // 2.监听键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    
    // 获取键盘的frame
    CGRect tempFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘的高度
    CGFloat keyboardHeight = tempFrame.size.height;
    
    // 获取键盘弹出的动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 获取键盘弹出的动画节奏
    int curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight * 0.5);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    // 获取键盘弹出的动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 获取键盘弹出的动画节奏
    int curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
    NSString * phonenumber = [_userDefault objectForKey:DEFAULT_PHONENUMBER];
    _loginNumber.text = phonenumber;
    

    NSString * pwd = [_userDefault objectForKey:DEFAULT_PWD];
    NSLog(@"密码的是多少%@",pwd);
    NSString * isRmb = [_userDefault objectForKey:DEFAULT_ISRMBPWD];
    NSString * isAuto = [_userDefault objectForKey:DEFAULT_ISAUTOLOGIN];
    
    NSLog(@"--------isRmb:%@",isRmb);
    NSLog(@"--------isAuto:%@",isAuto);
    
    if ([isRmb isEqualToString:@"YES"]) {
        
        _isRemberPwd = YES;
        [_btnRemberPwd setSelected:YES];
        _loginKeyWord.text = pwd;
        
    }else {
        
        _isRemberPwd = NO;
        [_btnRemberPwd setSelected:NO];
    }
    
    if ([isRmb isEqualToString:@"YES"] && [isAuto isEqualToString:@"YES"]) {
        
        _isAutoLogin = YES;
        [_btnAutoLogin setSelected:YES];
        [self login];
        
    }else {
        
        _isAutoLogin = NO;
        [_btnAutoLogin setSelected:NO];
    }

//    [NSThread detachNewThreadSelector:@selector(updateVersions) toTarget:self withObject:nil];
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    self.loginKeyWord = nil;
//    self.loginNumber = nil;
    
    
}
- (void)handleActivityStart
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    
   
}
- (void)handleActivityStop
{
    [DejalBezelActivityView removeView];
}
- (IBAction)btnLoginClick:(id)sender
{

    [_userDefault setObject:@"YES" forKey:DEFAULT_ISRMBPWD];
    [_userDefault setObject:@"YES" forKey:DEFAULT_ISAUTOLOGIN];
  
    [self login];
   // [self updateVersions];
    
    
}
- (NSString *)getUuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}
- (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString
{
    NSString *platform = [self getDeviceVersion];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])   return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5 (GSM/WCDMA)";
    if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    
    if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])   return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod Touch 5G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad 2 New";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])        return@"Simulator";
    
    return platform;
}
- (void)login
{
    

    NSString * regex = @"^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:_loginNumber.text];
    
    BOOL isVerify = NO;
    NSString * message = nil;
    
    if (!isMatch) {
        
        isVerify = YES;
        message = @"请正确输入手机号码";
        
    }else if (_loginKeyWord.text == nil || [_loginKeyWord.text isEqualToString:@""]){
        
        isVerify = YES;
        message = @"请输入密码";
    }
    if (isVerify) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString  *phoneModel = [self platformString];
    NSLog(@"%@",phoneModel);
    [dic setObject:phoneModel forKey:@"model"];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:Appsino forKey:@"qudao"];
    [dic setObject:@"1" forKey:@"src"];
    
    
    NSLog(@"----v----%@",[dic objectForKey:@"v"]);
    
    [dic setObject:_loginNumber.text forKey:@"mobileNo"];
    [dic setObject:[_loginKeyWord.text MD5] forKey:@"password"];
    
//    debugLog([_loginKeyWord.text MD5]);
//    debugLog([URLUtil md5:@"123456"]);
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"login:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    //    NSString * sig = [URLUtil md5:result];
    NSString * logstr2 = [NSString stringWithFormat:@"login:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,LOGIN_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setDelegate:self];
    
    
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    
    
    //debugLog(@"MD5password %@",[_loginKeyWord.text MD5]);
//    [request setPostValue:phoneModel forKey:@"model"];
//    [request setPostValue:_loginNumber.text forKey:@"mobileNo"];
//    [request setPostValue:[_loginKeyWord.text MD5] forKey:@"password"];
//    [request setPostValue:@"1" forKey:@"src"];
//    [request setPostValue:APP_ID forKey:@"app_id"];
//    [request setPostValue:VERSIONS forKey:@"v"];
//    [request setPostValue:Appsino forKey:@"qudao"];
//    [request setPostValue:sig forKey:@"sig"];
//
//    [request setTimeOutSeconds:60.0f];
//
//    [request startAsynchronous];
    
    [self handleActivityStart];
    
    NSDictionary *parameters = @{@"model":phoneModel,
                                 @"mobileNo" : _loginNumber.text ,
                                 @"password" : [_loginKeyWord.text MD5] ,
                                 @"src" : @"1" ,
                                 @"app_id" : APP_ID ,
                                 @"v" : VERSIONS,
                                 @"qudao" : Appsino,
                                 @"sig" : sig,
                                 };
    
    [NetWork postWithUrlString:urls parameters:parameters success:^(id data) {
        
        [self handleActivityStop];
        
        [_jsonData appendData:data];

        
        NSString * logstr = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
        debugLog(logstr);
        
        NSDictionary * jsonDic =  [_jsonData objectFromJSONData];
        
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
        
        if ([code intValue] == 0) {
            
            
            //[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"pushDic"];
            
            
            NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushDic"];
            _jsonData = [[NSMutableData alloc] init];
            [self  requestPushNotiflcation:dic];
            NSLog(@"-----dic:%@",dic);
            
            NSDictionary * data = [jsonDic objectForKey:@"data"];
            NSString * userCode = [data objectForKey:@"userCode"];
            NSString * userID = [data objectForKey:@"userID"];
            NSString * secretKey = [data objectForKey:@"secretKey"];
            NSString * isExist =[data objectForKey:@"isExist"];
            NSString * succRecordNum = [data objectForKey:@"succRecordNum"];
            
            UserModel * user = [UserModel sharedInstance];
            user.userCode = userCode;
            user.userID = userID;
            user.password = _loginKeyWord.text;
            user.phoneNumber = _loginNumber.text;
            user.secretKey = secretKey;
            user.isUseAlipay = [data objectForKey:@"isUseAlipay"];
            user.unReadMsgNum = [[data objectForKey:@"unReadMsgNum"] intValue];
            user.transfer_tel = [data objectForKey:@"transfer_tel"];
            user.succRecordNum = succRecordNum;
            if ([isExist isEqualToString:@"true"]){
                
                user.isExist = YES;
                
            }else {
                
                user.isExist = NO;
                
            }
            
            BOOL result = [self queryByName:user];
            if (!result) {
                [self insert:user];
            }
            
            [_userDefault setObject:_loginNumber.text forKey:DEFAULT_PHONENUMBER];
            [_userDefault setObject:_loginKeyWord.text forKey:DEFAULT_PWD];
            
            if (nil == userID || [userID isEqualToString:@""]) {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"服务器异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else {
                
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]) initMainView];
            }
            
        }else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        [_jsonData setLength:0];
        
    } failure:^(NSError *error) {
        
        [self handleActivityStop];
        debugLog([error description]);
        
        if (error != nil) {
            NSString * message = [NSString stringWithFormat:@"%@",error];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"啊哦~网络好像断开了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }];
    
    

}


- (IBAction)hiddenKedborad:(id)sender
{
    [_loginKeyWord resignFirstResponder];
    [_loginNumber resignFirstResponder];
}
- (IBAction)btnMoreClick:(id)sender
{
    ForgetPWDView * forgetpwd = [[ForgetPWDView alloc]init];
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
        [self.navigationController.navigationBar setTranslucent:NO];
    }

    [self.navigationController pushViewController:forgetpwd animated:YES];
//    MoreView * more = nil;
//    
//    if (IS_IPHONE_5) {
//             more = [[MoreView alloc] initWithNibName:@"MoreView-ip5" bundle:nil];
//    }else {
//            more = [[MoreView alloc] initWithNibName:@"MoreView" bundle:nil]; 
//    }
//    
//    [self.navigationController pushViewController:more animated:YES];
}
- (IBAction)btnRegistClick:(id)sender
{
    RegistView * regist = nil;
    
      if (IS_IPHONE_5) {
          
              regist = [[RegistView alloc] initWithNibName:@"RegistView-ip5" bundle:nil];
          
      }else {
            regist = [[RegistView alloc] initWithNibName:@"RegistView" bundle:nil];
         
      }

    regist.tmpNumber = _loginNumber.text;
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
        [self.navigationController.navigationBar setTranslucent:NO];
    }


    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)btnRemberPwdClick:(id)sender
{
    
    
    if (!_isRemberPwd) {
        
        _isRemberPwd = true;
        [_btnRemberPwd setSelected:YES];
        [_userDefault setObject:@"YES" forKey:DEFAULT_ISRMBPWD];
        
    }else {
        
        _isRemberPwd = false;
        [_btnRemberPwd setSelected:NO];
        [_userDefault setObject:@"NO" forKey:DEFAULT_ISRMBPWD];
    }
}
- (IBAction)btnAutoLoginClick:(id)sender
{
    
    if (!_isAutoLogin) {
        
        _isAutoLogin = true;
        [_btnAutoLogin setSelected:YES];
        [_userDefault setObject:@"YES" forKey:DEFAULT_ISAUTOLOGIN];
        
    }else {
        
        _isAutoLogin = false;
        [_btnAutoLogin setSelected:NO];
        //[_userDefault setObject:@"NO" forKey:DEFAULT_ISAUTOLOGIN];

    }
}

- (IBAction)rexianBtn:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-999-1000"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
//    [callWebview release];
//    [str release];
}

#pragma mark ASIHTTPRequestDelegate 
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self handleActivityStop];
    
    NSString * logstr = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    debugLog(logstr);
    
    NSDictionary * jsonDic =  [_jsonData objectFromJSONData];
    
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
   
    if ([code intValue] == 0) {
        
        
         //[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"pushDic"];
       
        
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushDic"];
         _jsonData = [[NSMutableData alloc] init];
        [self  requestPushNotiflcation:dic];
        NSLog(@"-----dic:%@",dic);
        
        NSDictionary * data = [jsonDic objectForKey:@"data"];
        NSString * userCode = [data objectForKey:@"userCode"];
        NSString * userID = [data objectForKey:@"userID"];
        NSString * secretKey = [data objectForKey:@"secretKey"];
        NSString * isExist =[data objectForKey:@"isExist"];
        NSString * succRecordNum = [data objectForKey:@"succRecordNum"];
        
        UserModel * user = [UserModel sharedInstance];
        user.userCode = userCode;
        user.userID = userID;
        user.password = _loginKeyWord.text;
        user.phoneNumber = _loginNumber.text;
        user.secretKey = secretKey;
        user.isUseAlipay = [data objectForKey:@"isUseAlipay"];
        user.unReadMsgNum = [[data objectForKey:@"unReadMsgNum"] intValue];
        user.transfer_tel = [data objectForKey:@"transfer_tel"];
        user.succRecordNum = succRecordNum;
        if ([isExist isEqualToString:@"true"]){
            
            user.isExist = YES;
            
        }else {
            
            user.isExist = NO;
            
        }
        
        BOOL result = [self queryByName:user];
        if (!result) {
            [self insert:user];
        }
        
        [_userDefault setObject:_loginNumber.text forKey:DEFAULT_PHONENUMBER];
        [_userDefault setObject:_loginKeyWord.text forKey:DEFAULT_PWD];
        
        if (nil == userID || [userID isEqualToString:@""]) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"服务器异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }else {
            
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]) initMainView];
        }
        
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    [_jsonData setLength:0];
     
}





- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self handleActivityStop];
    NSError * error = [request error];
    debugLog([error description]);
    
    if (error != nil) {
        NSString * message = [NSString stringWithFormat:@"%@",error];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"啊哦~网络好像断开了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)requestStarted:(ASIHTTPRequest *)request
{
    [self handleActivityStart];

}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];
    
    
    
}
- (void)requestPushNotiflcation:(NSDictionary*)data{
    
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
    if (userid) {
       [dic setObject:userid forKey:@"userId"];
    }
    if (channelid) {
        [dic setObject:channelid forKey:@"channelId"];
    }
    
    [dic setObject:@"4" forKey:@"deviceType"];
    [dic setObject:_loginNumber.text forKey:@"telNo"];
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
    //[request setDelegate:self];
    
    
    //debugLog(@"MD5password %@",[_loginKeyWord.text MD5]);
    
    if (userid) {
        [request setPostValue:userid forKey:@"userId"];
    }
    if (channelid) {
        [request setPostValue:channelid forKey:@"channelId"];
    }

    
    
    [request setPostValue:@"4" forKey:@"deviceType"];
    [request setPostValue:_loginNumber.text forKey:@"telNo"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:sig forKey:@"sig"];
    //[request setDidFailSelector:@selector(requestFailedPush:)];
    //[request setDidFinishSelector:@selector(requestFinishedPush:)];
    //[request setDidReceiveDataSelector:@selector(requestPush:didReceiveData:)];
    //[request setDidStartSelector:@selector(requestStarted:)];
    [request setTimeOutSeconds:60.0f];
    
    [request startAsynchronous];
    
    
    
}
#pragma mark ASIHTTPRequestDelegatePush
- (void)requestFinishedPush:(ASIHTTPRequest *)request
{
    NSLog(@"-----_jsonData-%@",_jsonData);
    NSString * logstr = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"-----11-%@",logstr);
    
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12){
        return NO;
    }
    return YES;
}
#pragma mark db

- (BOOL)queryByName:(UserModel *)user
{
    BOOL result = NO;
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = @"select * from User where phonenum = ?";
    NSArray * par = [NSArray arrayWithObject:user.phoneNumber];
    FMResultSet * rset = [db query:sql parameter:par];
    
    while (rset.next) {
        
        user.uid = [rset stringForColumn:@"id"];
        result = YES;
    }
    
    return result;
}
- (void)insert:(UserModel *)user
{
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    NSString * sql = @"INSERT INTO User(name,phonenum,serverid,usercode) VALUES (?,?,?,?);";
    //目前username 与phonenum相同
    NSArray * pars = [NSArray arrayWithObjects:user.phoneNumber,user.phoneNumber,user.userID,user.userCode,nil];
    NSString * logstr = [NSString stringWithFormat:@"增加用户: INSERT INTO User(name,phonenum,serverid,usercode) VALUES (%@,%@,%@,%@);",user.phoneNumber,user.phoneNumber,user.userID,user.userCode];
    debugLog(logstr);
    [db insert:sql parameter:pars];
    [db close];
    
    [self queryByName:user]; //再次查询 为了获得 uid
}
- (IBAction)guanwangButton:(id)sender {
    
//    http://www.4009991000.com
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.4008786688.com"]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];


}


//- (UITextField *)loginKeyWord{
//
//    if (!_loginKeyWord) {
//        
//        _loginKeyWord = [[UITextField alloc]init];
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        
//        _loginKeyWord.leftView = view;
//        
//    }
//    return _loginKeyWord;
//}

@end

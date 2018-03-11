//
//  RegistView.m
//  notary
//     
//  Created by 肖 喆 on 13-3-26.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "RegistView.h"
#import "BPush.h"
static int count = 60;

@interface RegistView ()
- (void)handleScreen;

- (void)registerFailed:(ASIHTTPRequest *)request;
- (void)registerFinished:(ASIHTTPRequest *)request;
- (void)registerStart:(ASIHTTPRequest *)request;
- (void)registerReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;

- (void)handleActivityStart;
- (void)handleActivityStop;

@end

@implementation RegistView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)handleActivityStart1
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    
    
}
- (void)handleActivityStop1
{
    [DejalBezelActivityView removeView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    count = 60;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    if (IOS7_OR_LATER) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    }
    self.btnVerify.frame =  CGRectMake(0, 0, 260, 40);
    [self.btnVerify setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮" leftRatio:0.5 topRatio:0.5] forState:UIControlStateNormal];
    [self.btnRegist setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮" leftRatio:0.5 topRatio:0.5] forState:UIControlStateNormal];

    self.title = @"注册";
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    
    UIColor *Color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:Color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 20, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"左上角通用返回"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;

    if (_tmpNumber != nil) {
        _txtNumber.text = _tmpNumber;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view endEditing:YES];
    
    if (nil != _request) {
        [_request cancel];
        _request = nil;
    }
    if (nil != _requestMessage) {
        
        [_requestMessage cancel];
        _requestMessage = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnVerifyClick:(id)sender
{
    [self requestVerifyNumber];
}
- (IBAction)btnRegist:(id)sender
{
    NSString * phone = _txtNumber.text;
    NSString * verifyNumber = _txtVerifyNumber.text;
    NSString * pwd = _txtPwd.text;
    NSString * pwdAgain = _txtAgainPwd.text;
  
    
    NSString * regex = @"^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:_txtNumber.text];
    
    NSString * regex2 = @"[a-zA-Z0-9_]{6,12}$";
    NSPredicate * pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch2 = [pred2 evaluateWithObject:pwd];
    
    BOOL isVerify = NO;
    NSString * message = nil;
    
        
    if (!isMatch) {
    
        isVerify = YES;
        message = @"请正确输入手机号码";
        
    }else if (nil == verifyNumber || [@"" isEqualToString:verifyNumber]) {
        isVerify = YES;
        message = @"请输入短信验证码";
    }
    else if (pwd.length < 6){
        isVerify = YES;
        message = @"密码必须大于6位";
    }
    else if (nil == pwd || [@""isEqualToString:pwd]) {
        isVerify = YES;
        message = @"密码不能为空";
    }
    else if (!isMatch2) {
        isVerify = YES;
        message = @"密码不能包含特殊符号";
    }
    else if (![pwdAgain isEqualToString:pwd]) {
        isVerify = YES;
        message = @"两次密码不一致";
    }
    
    if (isVerify) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
//    
//    多余注释掉 by liwzh
//    if (!isMatch) {
//        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件名不能包含特殊符号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:Appsino forKey:@"qudao"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:_txtNumber.text forKey:@"mobileNo"];
    [dic setObject:_txtVerifyNumber.text forKey:@"validNo"];
    [dic setObject:[_txtPwd.text MD5] forKey:@"password"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"注册:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"注册:sig 加密后 %@",sig];
    debugLog(logstr2);

    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,REGIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    NSLog(@"request URL: %@",[url absoluteString]);

    
    _request = [[ASIFormDataRequest alloc] initWithURL:url];
    [_request setDelegate:self];
    [_request setDidStartSelector:@selector(registerStart:)];
    [_request setDidFailSelector:@selector(registerFailed:)];
    [_request setDidFinishSelector:@selector(registerFinished:)];
    [_request setDidReceiveDataSelector:@selector(registerReceiveData:didReceiveData:)];
    
    [_request setPostValue:phone forKey:@"mobileNo"];
    [_request setPostValue:verifyNumber forKey:@"validNo"];
    [_request setPostValue:[pwd MD5] forKey:@"password"];
//    [dic setObject:Appsino forKey:@"qudao"];
    [_request setPostValue:Appsino forKey:@"qudao"];
    [_request setPostValue:@"1" forKey:@"src"];
    [_request setPostValue:APP_ID forKey:@"app_id"];
    [_request setPostValue:VERSIONS forKey:@"v"];
    [_request setPostValue:sig forKey:@"sig"];
    
//    [request startSynchronous];
    [_request startAsynchronous];
    
      [self handleActivityStart1];
    
}

- (void)handleBackButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
//    if (IS_IPHONE_5) {
//        
//        
//        
//        
//    }else{
//        if (IOS7_OR_LATER) {
//            
//            if (textField == _txtAgainPwd || textField == _txtPwd) {
//                [UIView beginAnimations:nil context:nil];
//                [UIView animateWithDuration:1 animations:nil];
//                CGRect viewFrame = self.view.frame;
//                viewFrame.origin.y = 64;
//                self.view.frame = viewFrame;
//                [UIView commitAnimations];
//            }
//
//            
//        }else{
//        if (textField == _txtAgainPwd || textField == _txtPwd) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView animateWithDuration:1 animations:nil];
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = 0;
//            self.view.frame = viewFrame;
//            [UIView commitAnimations];
//        }
//        }
//    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (IS_IPHONE_5) {
//
//    }else{
//        if (textField == _txtPwd || textField == _txtAgainPwd) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView animateWithDuration:1 animations:nil];
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = -140;
//            self.view.frame = viewFrame;
//            [UIView commitAnimations];
//        }
//    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12){
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  
    return YES;
}
- (void)handleActivityStart
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_indicatorView];
        _indicatorView.center = self.view.center;
    }

    [_indicatorView startAnimating];
}
- (void)handleActivityStop
{
    [_indicatorView stopAnimating];
}
#pragma mark ASIHTTPRequestDelegate 
- (void)registerFailed:(ASIHTTPRequest *)request
{
    [self handleActivityStop];
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)registerFinished:(ASIHTTPRequest *)request
{
    [self handleActivityStop];
    [self handleActivityStop1];
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushDic"];
    //_jsonData = [[NSMutableData alloc] init];
    [self  requestPushNotiflcation:dic];
//    NSLog(@"%@",NSStringFromSelector(_cmd));
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
    [dic setObject:_txtNumber.text forKey:@"telNo"];
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
    
    if (userid==nil&&channelid==nil) {
        NSLog(@"绑定失败");
        return;
    }
    
    [request setPostValue:@"4" forKey:@"deviceType"];
    [request setPostValue:_txtNumber.text forKey:@"telNo"];
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

- (void)registerStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self handleActivityStart];
}
- (void)registerReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    
    if ([code intValue] == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag=999;
        [alert show];
        
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)requestVerifyNumberImmediately{
    
}

- (void)requestVerifyNumber
{
        
   // NSString * regex = @"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
    NSString * regex = @"^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:_txtNumber.text];
    
    BOOL isVerify = NO;
    NSString * message = nil;
    
    if (!isMatch) {
        
        isVerify = YES;
        message = @"请正确输入手机号码";
        
    }
    
    if (isVerify) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }

    _btnVerify.enabled = NO;
    _labTimer.hidden = NO;
    _labTimer.text = @"( 60 )";
    
     timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalculate:) userInfo:nil repeats:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:_txtNumber.text forKey:@"mobileNo"];
    [dic setObject:@"0" forKey:@"validType"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"下发短信:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"下发短信:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,MESSAGE_URL];
    NSURL * url = [NSURL URLWithString:urls];
   
    NSString * logurl = [NSString stringWithFormat:@"短信下发: %@?mobileNo=%@&src=%@&app_id=%@&v=%@&sig=%@&validType=0",urls,_txtNumber.text,@"1",APP_ID,VERSIONS,sig];
    debugLog(logurl);
    
    
     _requestMessage = [[ASIFormDataRequest alloc] initWithURL:url];
    [_requestMessage setDelegate:self];
    [_requestMessage setDidStartSelector:@selector(VerifyNumberStart:)];
    [_requestMessage setDidFailSelector:@selector(VerifyNumberFailed:)];
    [_requestMessage setDidFinishSelector:@selector(VerifyNumberFinished:)];
    [_requestMessage setDidReceiveDataSelector:@selector(VerifyNumberReceiveData:didReceiveData:)];
    
    [_requestMessage setPostValue:_txtNumber.text forKey:@"mobileNo"];
    [_requestMessage setPostValue:@"1" forKey:@"src"];
    [_requestMessage setPostValue:APP_ID forKey:@"app_id"];
    [_requestMessage setPostValue:VERSIONS forKey:@"v"];
    [_requestMessage setPostValue:sig forKey:@"sig"];
    [_requestMessage setPostValue:@"0" forKey:@"validType"];
    [_requestMessage startSynchronous];
}

- (void)VerifyNumberFailed:(ASIHTTPRequest *)request
{

}
- (void)VerifyNumberFinished:(ASIHTTPRequest *)request
{


}
- (void)VerifyNumberStart:(ASIHTTPRequest *)request
{
    logmessage;
 
   
}
- (void)VerifyNumberReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSString * log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    debugLog(log);
    
    
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
   // NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
    if ([code intValue] == 1002) {
        
        [timer invalidate];
        _btnVerify.enabled = YES;
        _labTimer.hidden = YES;
        count = 60;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        
   
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:_txtNumber.text forKey:DEFAULT_PHONENUMBER];
    [userdefault setObject:@"NO" forKey:DEFAULT_ISRMBPWD];
    [userdefault setObject:@"NO" forKey:DEFAULT_ISAUTOLOGIN];
    
    [self.navigationController popViewControllerAnimated:YES];
        
         }
}


- (void)timerCalculate:(NSTimer *)timer
{
    if (count == 0) {
        
        [timer invalidate];
        _btnVerify.enabled = YES;
        _labTimer.hidden = YES;
        count = 60;
        return;
    }
    count -= 1;
    _labTimer.text = [NSString stringWithFormat:@"( %d )",count];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //键盘消失
    //[self.view endEditing:YES];
    

}
@end

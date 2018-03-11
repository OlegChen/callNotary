//
//  ForgetPWDView.m
//  notary
//
//  Created by 肖 喆 on 13-4-28.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ForgetPWDView.h"
static int count = 60;
@interface ForgetPWDView ()

@end

@implementation ForgetPWDView

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
    self.title = @"忘记密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.btnPwd setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btnConfirm setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮"] forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    UIColor *Color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:Color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
   
    
//    self.navigationController.navigationBarHidden = NO;
//    if (IOS7_OR_LATER) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    }

    // Do any additional setup after loading the view from its nib.
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 30, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"左上角通用返回"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPwdClick:(id)sender
{
    
        NSString * regex = @"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:_txtTelNumber.text];
        
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
    
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:@"1" forKey:@"validType"];
        [dic setObject:_txtTelNumber.text forKey:@"mobileNo"];
    
        NSString * result = [URLUtil generateNormalizedString:dic];
        
        NSString * logstr = [NSString stringWithFormat:@"下发短信:sig 原始 %@",result];
        debugLog(logstr);
        NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
        NSString * logstr2 = [NSString stringWithFormat:@"下发短信:sig 加密后 %@",sig];
        debugLog(logstr2);
        
        
        NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,MESSAGE_URL];
        NSURL * url = [NSURL URLWithString:urls];
        
        NSString * logurl = [NSString stringWithFormat:@"短信下发: %@?mobileNo=%@&src=%@&app_id=%@&v=%@&sig=%@&validType=1",urls,_txtTelNumber.text,@"1",APP_ID,VERSIONS,sig];
        debugLog(logurl);
        
        
        _requestMessage = [[ASIFormDataRequest alloc] initWithURL:url];
        [_requestMessage setDelegate:self];
//        [_requestMessage setDidStartSelector:@selector(VerifyNumberStart:)];
        [_requestMessage setDidFailSelector:@selector(VerifyNumberFailed:)];
        [_requestMessage setDidFinishSelector:@selector(VerifyNumberFinished:)];
        [_requestMessage setDidReceiveDataSelector:@selector(VerifyNumberReceiveData:didReceiveData:)];
        [_requestMessage setPostValue:@"1" forKey:@"src"];
        [_requestMessage setPostValue:APP_ID forKey:@"app_id"];
        [_requestMessage setPostValue:VERSIONS forKey:@"v"];
        [_requestMessage setPostValue:sig forKey:@"sig"];
        [_requestMessage setPostValue:@"1" forKey:@"validType"];
        [_requestMessage setPostValue:_txtTelNumber.text forKey:@"mobileNo"];
        [_requestMessage startAsynchronous];

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
    _btnPwd.enabled = NO;
    _labTimer.hidden = NO;
    _labTimer.text = @"( 60 )";
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalculate:) userInfo:nil repeats:YES];
    
}
- (void)VerifyNumberReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSString * log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    debugLog(log);
    NSDictionary *jsonDic = [data objectFromJSONData];
    NSString *code = [jsonDic objectForKey:@"code"];
    NSString *codeInfo = [jsonDic objectForKey:@"codeInfo"];
    if ([code intValue] !=0 ) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo
                                                     delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        [self VerifyNumberStart:request];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信验证码下发成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
    }
}
- (void)timerCalculate:(NSTimer *)timer
{
    if (count == 0) {
        
        [timer invalidate];
        _btnPwd.enabled = YES;
        _labTimer.hidden = YES;
        count = 60;
        return;
    }
    count -= 1;
    _labTimer.text = [NSString stringWithFormat:@"( %d )",count];
}

- (IBAction)btnbtnConfirm:(id)sender
{
    NSString * validNo = _txtNumber.text;
    
    BOOL isVerify = NO;
    NSString * message = nil;
    
    if (validNo == nil || [validNo isEqualToString:@""]) {
        
        isVerify = YES;
        message = @"请正确输入短信验证码";
        
    }
    
    if (isVerify) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
   
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:validNo forKey:@"validNo"];
    [dic setObject:_txtTelNumber.text forKey:@"mobileNo"];
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"下发短信:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"下发短信:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,PASSWORD_RESTORE];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"短信下发: %@?src=%@&app_id=%@&v=%@&sig=%@&validNo=%@&mobileNo=%@",urls,@"1",APP_ID,VERSIONS,sig,validNo,_txtTelNumber.text];
    debugLog(logurl);
    
    
     _requestRestore = [[ASIFormDataRequest alloc] initWithURL:url];
    [_requestRestore setDelegate:self];
    [_requestRestore setDidStartSelector:@selector(RestoreNumberStart:)];
    [_requestRestore setDidFailSelector:@selector(RestoreNumberFailed:)];
    [_requestRestore setDidFinishSelector:@selector(RestoreNumberFinished:)];
    [_requestRestore setDidReceiveDataSelector:@selector(RestoreNumberReceiveData:didReceiveData:)];
    [_requestRestore setPostValue:@"1" forKey:@"src"];
    [_requestRestore setPostValue:APP_ID forKey:@"app_id"];
    [_requestRestore setPostValue:VERSIONS forKey:@"v"];
    [_requestRestore setPostValue:sig forKey:@"sig"];
    [_requestRestore setPostValue:validNo forKey:@"validNo"];
    [_requestRestore setPostValue:_txtTelNumber.text forKey:@"mobileNo"];
    [_requestRestore startAsynchronous];

}

- (void)RestoreNumberFailed:(ASIHTTPRequest *)request
{
    
}
- (void)RestoreNumberFinished:(ASIHTTPRequest *)request
{
    
    
}
- (void)RestoreNumberStart:(ASIHTTPRequest *)request
{
        
}
- (void)RestoreNumberReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    
    if ([code intValue] == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重置密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        alert.tag=1111;
        [alert show];
//        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

    
    /*
    NSString * log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    debugLog(log);
    NSDictionary * dic = [data objectFromJSONData];
    
    NSString * result = [dic objectForKey:@"data"];
    
    if ([@"true" isEqualToString:result]) {
        _btnPwd.enabled = NO;
        _btnConfirm.enabled = NO;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重置密码成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定 ", nil];
        [alert show];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重置密码失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定 ", nil];
        [alert show];
    }
    */
}
#pragma UITextFieldDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 1111) {
        
           [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        
    }else{
//        if (textField == _txtNumber) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView animateWithDuration:1 animations:nil];
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = 64;
//            self.view.frame = viewFrame;
//            [UIView commitAnimations];
//        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_5) {
        
    }else{
//        if (textField == _txtNumber ) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView animateWithDuration:1 animations:nil];
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = -80;
//            self.view.frame = viewFrame;
//            [UIView commitAnimations];
//        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}
- (void)handleBackButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

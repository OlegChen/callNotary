//
//  ChangePassNumber.m
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ChangePassNumber.h"

@interface ChangePassNumber ()



@end

@implementation ChangePassNumber

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改密码"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"修改密码"];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"yes");
    [self.oldNum resignFirstResponder];
    [self.nowNum resignFirstResponder];
    [self.yesNowNum resignFirstResponder];
    return YES;
}

- (void)makeView
{
    self.title = @"修改密码";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10.0f, 0.0f, 30.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
}


- (void)viewDidUnload {
    [self setOldNum:nil];
    [self setNowNum:nil];
    [self setYesNowNum:nil];
    [super viewDidUnload];
}

//判断字符串为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)showAlertView:(NSString *)string
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)changeNumBtnClick:(UIButton *)sender {
    
    if ([self isBlankString:self.oldNum.text]) {
        [self showAlertView:@"请输入旧密码"];
    }
    else if([self isBlankString:self.nowNum.text] && [self isBlankString:self.yesNowNum.text]) {
        [self showAlertView:@"新密码不能为空"];
    }
    else if ([self.nowNum.text isEqualToString:self.yesNowNum.text]) {
        if((self.nowNum.text.length<6)|| (self.nowNum.text.length >12)||(self.yesNowNum.text.length < 6) || (self.yesNowNum.text.length > 12))
        {
            [self showAlertView:@"密码只允许6到12位"];
        } else{
        [DejalBezelActivityView activityViewForView:self.view withLabel:nil width:0];
        NSLog(@"nfklslm%@",    self.oldNum.text);
        [self postChangeNum];
        }
    }
    else{
        [self showAlertView:@"新密码两次输入不一样"];
    }
}

- (void)postChangeNum
{
    
    NSString * oldpwd = [self.oldNum.text MD5];
    NSString * newpwd = [self.nowNum.text MD5];
    
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:oldpwd forKey:@"oldpwd"];
    [dic setObject:newpwd forKey:@"password"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    

    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,CHANGE_PASSNUMBER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    NSLog(@"request URL: %@",[url absoluteString]);
    
    NSString * logurl = [NSString stringWithFormat:@"修改密码: %@%@?app_id=%@&v=%@&src=1&mobileNo=%@&userID=%@&oldpwd=%@&password=%@&sig=%@",ROOT_URL,CHANGE_PASSNUMBER_URL,APP_ID,VERSIONS,phoneNum,user.userID,oldpwd,newpwd,sig];
    debugLog(logurl);

    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setDidStartSelector:@selector(registerStart:)];
    [request setDidFailSelector:@selector(registerFailed:)];
    [request setDidFinishSelector:@selector(registerFinished:)];
    [request setDidReceiveDataSelector:@selector(registerReceiveData:didReceiveData:)];
    
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:phoneNum forKey:@"mobileNo"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:sig forKey:@"sig"];
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:oldpwd forKey:@"oldpwd"];
    [request setPostValue:newpwd forKey:@"password"];
    
    [request startSynchronous];
}

#pragma mark ASIHTTPRequestDelegate
- (void)registerFailed:(ASIHTTPRequest *)request
{
    [DejalBezelActivityView removeView];

    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)registerFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [DejalBezelActivityView removeView];

}
- (void)registerStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)registerReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    if ([code intValue] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:@"密码修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
//alertView代理，修改成功，pop回去原来的页面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)notChangeBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //键盘消失
    [_oldNum resignFirstResponder];
    [_nowNum resignFirstResponder];
    [_yesNowNum resignFirstResponder];
}
@end

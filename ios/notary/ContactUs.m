//
//  ContactUs.m
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ContactUs.h"

@interface ContactUs ()

@property (weak, nonatomic) IBOutlet UIButton *Btn;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIImageView *textviewBG;


@end

@implementation ContactUs

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"联系客服页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"联系客服页面"];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView
{
    self.title = @"联系客服";
    self.navigationItem.hidesBackButton = YES;
    
    [self.Btn setBackgroundImage:[UIImage resizableImageWithName:@"登录按钮"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage resizableImageWithName:@"登录按钮"] forState:UIControlStateNormal];
    self.textviewBG.image = [UIImage resizableImageWithName:@"linkus_bg"];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    self.textView
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        logmessage;
    }
    return self;
}

//设置初始的输入框缺省文字和字体颜色
- (void)setMyTextView
{
    _placeHoldText = @"在此提出您的意见，帮助我们把服务做得更好";
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = _placeHoldText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMyTextView];
    [self makeView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"NO");
                [_textView resignFirstResponder];
                [self setMyTextView];
                break;
            case 1:
                NSLog(@"确定");
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    /*{
     code = 0;
     codeInfo = "";
     data =     {
     status = 0;
     };
     }*/
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    if ([code intValue] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"感谢你的反馈" message:@"发送成功，是否返回上一级" delegate:self cancelButtonTitle:@"NO，继续反馈" otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:codeInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");
    NSData *da = [request responseData];
    JSONDecoder *jd = [[JSONDecoder alloc] init];
    NSDictionary *ret = [jd objectWithData:da];
    NSLog(@"retretretret ---- > %@",ret);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request Failed");
    [self alertWithMessage:@"发送失败，请检查网络后重新发送"];
}

//UITextView 的代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    logmessage;
    if (_placeHoldText != nil) {
        _placeHoldText = nil;
        _textView.text = nil;
        _textView.textColor = [UIColor blackColor];
    }
        return YES;
}

//UITextView输入长度限制
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@  %@",text,textView.text);
    NSLog(@"%d", textView.text.length);

//    //点击完成，键盘收回
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    if (range.location>=140)
    {
        [self alertWithMessage:@"用户反馈最多输入140字"];

        return  NO;
    }
    else
    {
        return YES;
    }
}

#pragma mak - 用户反馈
- (IBAction)sendBtnClick:(UIButton *)sender {
    
    if (_placeHoldText == nil && ![self isBlankString:_textView.text]) {
//        //正则判断
//        NSString * regex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
//        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//        BOOL isMatch = [pred evaluateWithObject:_textView.text];
//        
//        if (!isMatch) {
//            [self alertWithMessage:@"请不要输入特殊符号"];
//        }else{

        UserModel * user = [UserModel sharedInstance];
        NSString *phoneNum = user.phoneNumber;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:phoneNum forKey:@"mobileNo"];
        [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:_textView.text forKey:@"feedbackMsg"];
        NSString *result = [URLUtil generateNormalizedString:dic];
        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
        NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,MESSAGE_RECOVER_URL];
        NSURL *url = [NSURL URLWithString:urls];
        NSLog(@"request URL is: %@",url);
        ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:url];
    
        [request setPostValue:APP_ID forKey:@"app_id"];
        [request setPostValue:VERSIONS forKey:@"v"];
        [request setPostValue:phoneNum forKey:@"mobileNo"];
        [request setPostValue:@"1" forKey:@"src"];
        [request setPostValue:sig forKey:@"sig"];
        [request setPostValue:user.userID forKey:@"userID"];
        [request setPostValue:_textView.text forKey:@"feedbackMsg"];
        request.delegate = self;
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
//        }
    }else
    {
        [self alertWithMessage:@"请先输入您的意见，再提交"];
//    NSLog(@"请先输入您的意见，再提交%@",self.textView.text);
    }
}

#pragma mak - 打电话
- (IBAction)callPhoneNumBtnClick:(UIButton *)sender {
    //这种调用还能返回原应用
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel://4008786688"];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mak - 发送邮件
- (IBAction)emailUsBtnClick:(UIButton *)sender {
    [self sendMailInApp];
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

- (void)sendMailInApp
{
    Class mailClass =  (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"电话录音邮件反馈"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"service@4008786688.com"];
    [mailPicker setToRecipients: toRecipients];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
    NSString *emailBody = @"<font color='red'>eMail</font> 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        nil;
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消发送邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self alertWithMessage:msg];
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //键盘消失
    [_textView resignFirstResponder];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end

//
//  Help.m
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Help.h"

@interface Help ()

@end

@implementation Help{
    
    UIWebView *webView;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//
- (void)makeView
{
    self.title = @"常见问题";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10.0f, 0.0f, 30.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
//    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0.0f,320, 480+(IS_IPHONE_5?88:0))]; //初始化大小并自动释放
//    if (IOS7_OR_LATER) {
//         self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0.0f,320, 480+(IS_IPHONE_5?4:0))]; //初始化大小并自动释放
//    }
//    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
//    self.textView.font = [UIFont fontWithName:@"Arial" size:16.0];//设置字体名字和字体大小
//    self.textView.delegate = self;//设置它的委托方法
//    self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
//    self.textView.text=@"1、移动公证如何进行通话录音？\n\t用户注册登录以后,点击通话录音按钮,进入选择联系人或者直接拨号就可以拨打电话,拨通电话就开始进行录音,通话结束时录音自动结束并上传云端存储.\n\n2、移动公证和普通录音软件有什么区别？\n\t作为平台合作方,中国电信提供高品质400电话（即用户主叫录音时显示的号码4009992000）实时录音,从技术上保证了从通话到录音到存储的全过程真实可靠,语音清晰,内容不可篡改,录音真实性和清晰度非普通录音软件可比.\n\n3、使用移动公证录音被叫人会发现吗？\n\t用户开启通话录音后,用户电话显示4009992000开始录音，对方看到的号码仍然是用户的真实号码,被叫方的电话状态与普通通话完全相同,平台从技术上保证了录音功能丝毫不干扰正常通话。\n\n4、移动公证除了通话录音外,还有什么功能？\n\t我们还可以提供现场录音,拍照,录像,云存储等功能,欢迎使用.\n\n5、使用移动公证需要收费么？\n\t（1）、注册用户立即获得20分钟免费录音试用和500M存储空间.通话录音8币 8币/分钟,现场录音 8币/分钟,空间资源 8币/10M;（2）、用户可以通过应用内的有奖分享、签到、官网活动等功能免费获赠公证币;更多精彩活动详见官网 www.4009991000.com\n\n6、使用移动公证遇到问题怎么办？\n\t请随时拨打我们的服务热线400-999-1000,或者联系客服QQ2380213059.（周一至周五9:00-18:00）";
//    [self.textView setEditable:NO];
//    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
//    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    self.textView.scrollEnabled = YES;//是否可以拖动
//    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    

//    [self.view addSubview: self.textView];//加入到整个页面中
      CGRect cgrect=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64); //初始化大小并自动释放
//    if (IOS7_OR_LATER) {
//        cgrect=CGRectMake(0, 0.0f,320, 480+(IS_IPHONE_5?4:0)); //初始化大小并自动释放
//    }
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    webView = [[UIWebView alloc] initWithFrame:cgrect];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@help/help.html",ROOT_URL]]];
    
    
    //webView.backgroundColor = [UIColor redColor];
    [webView loadRequest:request];
    
    webView.delegate =self;
    [self.view addSubview: webView];//加入到整个页面中


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
}



- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error{
    
}
@end

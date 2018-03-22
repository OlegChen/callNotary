//
//  About.m
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "About.h"

@interface About ()

@end

@implementation About

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

- (void)makeView
{
    self.title = @"关于录音存证";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10.0f, 0.0f, 30.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
 
   //modify by liwzh  动态获取版本
    //  获取app版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *oringalTxt = @"录音存证手机客户端V";
    self.VNumberLabel.text = [oringalTxt stringByAppendingString:[NSString stringWithFormat:@"%@",app_Version]];
    self.VNumberLabel.textAlignment = UITextAlignmentCenter;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        logmessage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
}


- (void)viewDidUnload {
    [self setVNumberLabel:nil];
    [super viewDidUnload];
}
@end

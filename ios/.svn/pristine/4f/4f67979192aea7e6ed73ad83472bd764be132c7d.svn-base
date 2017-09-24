//
//  SelectFileViewController.m
//  notary
//
//  Created by 肖 喆 on 14-12-23.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "SelectFileViewController.h"
#import "AppDelegate.h"

@interface SelectFileViewController ()

@end

@implementation SelectFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择上传至";
    self.navigationController.navigationBarHidden = NO;
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app hiddenTab:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end

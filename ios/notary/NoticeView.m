//
//  NoticeView.m
//  notary
//
//  Created by 肖 喆 on 13-9-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "NoticeView.h"
#import "AppDelegate.h"
#import "UserInfoView.h"
#import "NewProofapplyView.h"
@interface NoticeView ()

@end

@implementation NoticeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isCheck = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"告知";
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }

    UITextField *qqlable = [[UITextField alloc]init];
    qqlable.font = [UIFont systemFontOfSize:15];
    qqlable.frame = CGRectMake(193, 78, 140, 20);
    qqlable.text = @"2380213059";
    [self.view addSubview:qqlable];
    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 20, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"左上角通用返回"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    

    
}

- (void)handleBackButtonClick:(UIButton *)but {
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
}
- (IBAction)sure:(id)sender {
    
    NSUserDefaults * defauls =  [NSUserDefaults standardUserDefaults];
  
    if (isCheck == NO) {
        
        [defauls setObject:@"YES" forKey:@"Notice"];
        [self.btnTrue setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        isCheck = YES;
    }else {
        [defauls removeObjectForKey:@"Notice"];
        [self.btnTrue setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        isCheck = NO;
    }
    
}
- (IBAction)makeSure:(UIButton *)sender {
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
    
    if ([d boolForKey:@"mybool"] == YES) {
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:^(void){
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_NoticeInform1" object:nil];
                                                      }];
        [d setBool:NO forKey:@"mybool"];

    }else {
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:^(void){
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_NoticeInform" object:nil];
                                                      }];

    }
    
      

}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
  //  [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setSureBgView:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}
@end

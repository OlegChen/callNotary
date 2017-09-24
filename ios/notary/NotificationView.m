//
//  NotificationView.m
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationView ()

@end

@implementation NotificationView

- (void)myInit {
  
    self.title = @"消息管理";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self myInit];
    //消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeUpdateHandler:) name:Notification_NoticeUpdate object:nil];
    
    //测试用代码
    self.navigationController.tabBarItem.badgeValue = @"18";
    
    //隐藏TabBar
//    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)noticeUpdateHandler:(NSNotification *)notification
{
    //增加tabbar上的标号
   self.navigationController.tabBarItem.badgeValue = @"18";
}
//清除通知 标号
- (void)clearOSCNotice:(int)type
{
    
}

@end

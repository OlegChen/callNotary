//
//  MoreView.m
//  notary
//
//  Created by 肖 喆 on 13-3-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "MoreView.h"
#import "About.h"
#import "Help.h"
#import "ForgetPWDView.h"

@interface MoreView ()

@end

@implementation MoreView

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
    
    _infoArray = [[NSMutableArray alloc] initWithCapacity:3];
    [_infoArray addObject:@"帮助文档"];
    [_infoArray addObject:@"关于我们"];
    [_infoArray addObject:@"忘记密码"];
    
  
    self.title = @"更多";
    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"更多"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"更多"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleBackButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        cell.textLabel.text = [_infoArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //实现的效果是：每行点中以后变蓝色，并且马上蓝色消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//在弹出警告后自动取消选中表视图单元
    
    switch (indexPath.row) {
        case 0:
        {
            Help *helpVC = [[Help alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 1:
        {

            About *aboutVC = [[About alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];

    
        }
            break;
            
        case 2:{
            /*
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"忘记密码" message:@"忘记密码算你活该！" delegate:nil cancelButtonTitle:@"不服" otherButtonTitles:@"认了", nil];
            [alert show];
             */
            ForgetPWDView * forgetpwd = [[ForgetPWDView alloc]init];
            [self.navigationController pushViewController:forgetpwd animated:YES];
        }
            break;
        
        default:
            break;
    }
}
@end

//
//  BasicViewController.m
//  notary
//
//  Created by 肖 喆 on 14-3-21.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "BasicViewController.h"
#import "AppDelegate.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//LogInAgain
-(void)addMessageNum{
    
     AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.window.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }

  
    btnNumMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNumMessage.userInteractionEnabled = NO;
    btnNumMessage.tag = 1001;
    btnNumMessage.titleLabel.font = [UIFont systemFontOfSize:12];
    btnNumMessage.frame = CGRectMake(280, 3, 15, 15);
    [btnNumMessage setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [btnNumMessage setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
    //[self.navigationController.navigationBar addSubview:btnNum];
   
    [delgate.tabBar.bottomView addSubview:btnNumMessage];
    
   }   
-(void)removeMessageNum{
    
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.tabBar.bottomView.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }

    //[btnNumMessage removeFromSuperview];
}

//- (void)request:(ASIHTTPRequest *)request1 didReceiveData:(NSData *)data
//{
//    if (8888 == request1.tag) {
//        NSDictionary * jsonDic = [data objectFromJSONData];
//        NSString * code = [jsonDic objectForKey:@"code"];
//        NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
//        NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
//        if ([code intValue] == 0) {
//            
//            [_msgArr removeAllObjects];
//            [_msgArr addObjectsFromArray:[jsonDic objectForKey:@"data"]];
//            NSLog(@"_msgArr-->%@",_msgArr);
//            _noReadMsgCount = 0;
//            
//            for (int i = 0; i < [_msgArr count]; i++) {
//                if ([[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"N"] || [[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"n"]) {
//                    _noReadMsgCount++;
//                }
//            }
//        }else {
//            //[self alertWithMessage:codeInfo];
//        }
//    }}
//
//-(void)requestFinished:(ASIHTTPRequest *)request22
//{
//    
//    //    NSData *da = [request responseData];
//    //    JSONDecoder *jd = [[JSONDecoder alloc] init];
//    //    NSDictionary *ret = [jd objectWithData:da];
//    //    NSLog(@"retretretret ---- > %@",ret);
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"request Failed");
//    //    [self alertWithMessage:@"数据加载失败,请检查网络"];
//}


@end

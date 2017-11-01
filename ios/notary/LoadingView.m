//
//  LoadingView.m
//  notary
//
//  Created by 肖 喆 on 13-4-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.

//  广告页


#import "LoadingView.h"
#import "AddressCache.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "AFNetworking.h"
#import "PosterView.h"
@interface LoadingView ()
{
    NSTimer *timer;
}

@end

@implementation LoadingView

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//     }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    if (IS_IPHONE_5) {
//        self.backimage.image = [UIImage imageNamed:@"0启动页640.jpg"];
//    }else {
//        self.backimage.image = [UIImage imageNamed:@"0启动页640960.jpg"];
//    }
//    [self.backimage setUserInteractionEnabled:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayVison) name:@"dismiss" object:nil];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:APP_ID forKey:@"app_id"];
//    [dic setObject:VERSIONS forKey:@"v"];
//    [dic setObject:@"1" forKey:@"src"];
//    
//    NSString *resultt = [URLUtil generateNormalizedString:dic];
//    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",resultt,ATTACH]];
//
//    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
//    [dic setObject:APP_ID forKey:@"app_id"];
//    [dic setObject:VERSIONS forKey:@"v"];
//    [newDic setObject:sig forKey:@"sig"];
//    
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_ACTIVITY_URL];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
//    NSURLRequest *request = [client requestWithMethod:@"post" path:nil parameters:newDic];
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.jsonDiction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",self.jsonDiction);
//        NSString *code = [self.jsonDiction objectForKey:@"code"];
//        if ([code intValue] == 0) {
//            [self guanggao];
//        }else{
//            NSLog(@"请求失败");
//            [self initAddressBook];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"网络异常");
// 
//        [self initAddressBook];
//        
//    }];
//    [operation start];
//
//    [_indicatorView startAnimating];
// }
//
//
//
//
//- (void)guanggao
//{
//    NSString *code = [self.jsonDiction objectForKey:@"code"];
//    if ([code intValue] == 0) {
//        if (self.jsonDiction !=nil) {
//            NSDictionary *jsonDic = [self.jsonDiction valueForKey:@"data"];
//            NSLog(@"arr=%@",jsonDic);
//            if (jsonDic!=nil) {
//                 self.photoURL = [NSString stringWithFormat:@"%@",[jsonDic valueForKey:@"photoUrl"]];
//                self.jumpURL = [NSString stringWithFormat:@"%@",[jsonDic valueForKey:@"url"]];
//            }
//        }
//        
//    }
////    UIImageView *imageView = [[UIImageView alloc] init];
//    //    imageView.backgroundColor = [LYUtil colorWithHexString:@"#2bbbfe"];
////    imageView.frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
////    imageView.frame = CGRectMake(0, 0, 320, 480);
//
//    NSString *urls = [NSString stringWithFormat:@"%@",self.photoURL];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    if (url) {
//        
//        logoImageView1 = [[UIImageView alloc] init];
//        logoImageView1.frame = CGRectMake(0, 0, 320, 385+(IS_IPHONE_5?88:0));
////        logoImageView1.frame = CGRectMake(0, self.view.bounds.size.height - 480, 320, 385);
//
//        [logoImageView1 setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        //    logoImageView.image = [UIImage imageNamed:@"logo"];
//        //        UIImageView *logoimage = [[UIImageView alloc]init];
//        //        logoimage.frame = CGRectMake(30, 400, 220, 80);
//        //        logoimage.image = [UIImage imageNamed:@"logo_ad"];
//        //        [self.window addSubview:logoimage];
////        [self.backimage addSubview:logoImageView1];
////        [self.backimage setImageWithURL:url];
//        [self.backimage addSubview:logoImageView1];
////        [self.backimage setImageWithURL:url];
//        //        [self performSelector:@selector(delayVison) withObject:nil afterDelay:3];
//        
//    }else{
//        [self.backimage setImage:[UIImage imageNamed:@"0启动页640960.jpg"]];
//
//    }
//    timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(delayVison) userInfo:nil repeats:NO];
//
//    //    UILabel *tishiLabel = [[UILabel alloc]init];
//    //    tishiLabel.text = @"风语者软件（北京）有限公司";
//    //    tishiLabel.font = [UIFont systemFontOfSize:10];
//    //    tishiLabel.frame = CGRectMake(60, self.window.bounds.size.height - 28, 200, 10);
//    //    tishiLabel.textAlignment = NSTextAlignmentCenter;
//    //    tishiLabel.textColor = [LYUtil colorWithHexString:@"#000000"];
//    //    tishiLabel.alpha = 0.5;
//    //    [self.window addSubview:tishiLabel];
//    
//    NSLog(@"%@",self.photoURL);
//    NSLog(@"%@",self.jumpURL);
//    //    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HTTPURL,self.photoURL]);
//    if (self.photoURL != nil||![self.photoURL isEqualToString:@""]) {
//        photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        photoButton.frame = CGRectMake(0, 0, 320, 360+(IS_IPHONE_5?88:0));
//        [photoButton addTarget:self action:@selector(jinruguanggao) forControlEvents:UIControlEventTouchUpInside];
//
////                [photoButton setImage:[LYUtil getImageFromURL:[NSString stringWithFormat:@"%@%@",HTTPURL,self.photoURL]] forState:UIControlStateNormal];
////        [self.backimage addGestureRecognizer:tapGestureRecognizer1];
//        [self.backimage addSubview:photoButton];
//    }
//    //   http://192.168.30.251:8080/sinomini/pic/activity/Chrysanthemum.jpg
//    
//    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(in) userInfo:nil repeats:NO];
//
//}
//-(void)delayVison{
//    [logoImageView1 removeFromSuperview];
//    [photoButton removeFromSuperview];
//    [self initAddressBook];
//}
//- (void)tapped:(UITapGestureRecognizer *)gesture
//{
//    if (gesture.numberOfTapsRequired == 1)
//    {
//        
//    }else {
//        
//    }
//
//}
//- (void)jinruguanggao
//{
//    [timer invalidate];
//    timer = nil;
//    PosterView *ps=[[PosterView alloc] init];
//    UINavigationController *nv =[[UINavigationController alloc]initWithRootViewController:ps];
//    ps.url = self.jumpURL;
////    [[UIApplication sharedApplication] inputViewController];
////    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [self presentViewController:nv animated:YES completion:nil];
////    [self.navigationController pushViewController:ps animated:YES];
////    [self  addSubview:weidian];
//    
////    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,self.jumpURL];
////    NSURL *url = [NSURL URLWithString:urls];
////    NSLog(@"request URL is: %@",url);
////    [[UIApplication sharedApplication] openURL:url];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
////    [_indicatorView stopAnimating];
//    
//}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//- (void)initAddressBook {
//    
//    //初始化全局address
//    AddressCache * addressCache = [AddressCache sharedInstance];
//    [addressCache initAddressBook];
//    
//    LoginView * log = nil;
//    
//    if (IS_IPHONE_5) {
//        
//        log = [[LoginView alloc] initWithNibName:@"LoginView-ip5" bundle:nil];
//        
//    }else {
//        log = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
//        
//    }
//    
//    UINavigationController * logNav = [[UINavigationController alloc] initWithRootViewController:log];
//    
//    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    app.window.rootViewController = logNav;
//    
//}
@end

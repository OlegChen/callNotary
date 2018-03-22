//
//  PosterView.m
//  notary
//
//  Created by stian on 15/1/22.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "PosterView.h"
#import "AppDelegate.h"
@interface PosterView (){
    UIWebView *webView;
}

@end

@implementation PosterView
@synthesize url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"公告";
        
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [delgate hiddenTab:YES];
        //        _selectedCount = 0;
        //        _listContent = [NSMutableArray new];
        //        _filteredListContent = [NSMutableArray new];
        //        self.searchByName = [[NSMutableArray alloc] init];
        //        self.searchByPhone = [[NSMutableArray alloc] init];
        //        self.cardDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    CGRect cgrect= CGRectMake(0, 0, 320, 480+(IS_IPHONE_5?88:0));
    
    
    webView = [[UIWebView alloc] initWithFrame:cgrect];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
    
    webView.delegate =self;
    [self.view addSubview: webView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleBackButtonClick:(UIButton *)but {
    
//    [self cancel];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismiss" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  RecommendationView.m
//  notary
//
//  Created by stian on 14/12/25.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "RecommendationView.h"
#import "AppDelegate.h"
#import "RecommendCellTableViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
@interface RecommendationView ()

@end

@implementation RecommendationView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"应用推荐";
        
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
    [MobClick beginLogPageView:@"应用推荐页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"应用推荐页面"];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.recommendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-64+(IS_IPHONE_5?88:0)) style:UITableViewStylePlain];
//    self.recommendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 100) style:UITableViewStylePlain];
    self.recommendTableView.backgroundColor = [UIColor clearColor];
    self.recommendTableView.delegate = self;
    self.recommendTableView.dataSource = self;
    [self.view addSubview:self.recommendTableView];
    //下拉刷新
    [self setupRefresh];

    self.jsonDiction = [[NSDictionary alloc]init];
    self.recommendJsonData = [[NSMutableData alloc]init];
    self.recommendArr = [[NSMutableArray alloc]init];
//    startIndex = 0;
    [self postHttpGetRecList];

    // Do any additional setup after loading the view from its nib.
}
- (void)setupRefresh{
    
    [self.recommendTableView addFooterWithTarget:self action:@selector(classRefresh)];
    [self.recommendTableView addHeaderWithTarget:self action:@selector(postHttpGetRecList)];
}

-(void)classRefresh{
    startIndex +=10;
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;
    NSLog(@"userID---->%@", user.userID);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex]  forKey:@"startIndex"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_RECOMMEND_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    
    ASIFormDataRequest *tipsRequest = [ASIFormDataRequest requestWithURL:url];
    
    [tipsRequest setPostValue:user.userID forKey:@"userID"];
    [tipsRequest setPostValue:APP_ID forKey:@"app_id"];
    [tipsRequest setPostValue:VERSIONS forKey:@"v"];
    [tipsRequest setPostValue:phoneNum forKey:@"mobileNo"];
    [tipsRequest setPostValue:@"1" forKey:@"src"];
    [tipsRequest setPostValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    [tipsRequest setPostValue:sig forKey:@"sig"];
    
    [tipsRequest setDidStartSelector:@selector(requestStart:)];
    [tipsRequest setDidFailSelector:@selector(requestFailed:)];
    [tipsRequest setDidFinishSelector:@selector(requestFinish:)];
    [tipsRequest setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    tipsRequest.delegate = self;
    tipsRequest.tag= 8686;
    [tipsRequest setRequestMethod:@"POST"];
    [tipsRequest startAsynchronous];

}
-(void)postHttpGetRecList{
    [self.recommendArr removeAllObjects];
    startIndex = 0;
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;
    NSLog(@"userID---->%@", user.userID);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex]  forKey:@"startIndex"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_RECOMMEND_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    
    ASIFormDataRequest *tipsRequest = [ASIFormDataRequest requestWithURL:url];
    
    [tipsRequest setPostValue:user.userID forKey:@"userID"];
    [tipsRequest setPostValue:APP_ID forKey:@"app_id"];
    [tipsRequest setPostValue:VERSIONS forKey:@"v"];
    [tipsRequest setPostValue:phoneNum forKey:@"mobileNo"];
    [tipsRequest setPostValue:@"1" forKey:@"src"];
    [tipsRequest setPostValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    [tipsRequest setPostValue:sig forKey:@"sig"];
    
    [tipsRequest setDidStartSelector:@selector(requestStart:)];
    [tipsRequest setDidFailSelector:@selector(requestFailed:)];
    [tipsRequest setDidFinishSelector:@selector(requestFinish:)];
    [tipsRequest setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    tipsRequest.delegate = self;
    tipsRequest.tag= 8686;
    [tipsRequest setRequestMethod:@"POST"];
    [tipsRequest startAsynchronous];
    
}
- (void)requestStart:(ASIHTTPRequest *)request{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
//    NSLog(@"request Failed");
    [self alertWithMessage:@"更新状态失败，请检查网络"];
}
- (void)requestFinish:(ASIHTTPRequest *)request{
    
    NSDictionary * jsonDic = [self.recommendJsonData objectFromJSONData];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    NSString * code = [jsonDic objectForKey:@"code"];
    //   NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    NSLog(@"--------%@",jsonDic);

    NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
    if ([code intValue] == 0) {
        
        //        [_msgArr removeAllObjects];
        [self.recommendArr addObjectsFromArray:[jsonDic objectForKey:@"data"]];
        NSLog(@"self.re=%@",self.recommendArr);
    }else {
        [self alertWithMessage:codeInfo];
    }
    [self.recommendTableView footerEndRefreshing];
    [self.recommendTableView headerEndRefreshing];
    [self.recommendJsonData setLength:0];
//    isLoadMsgList = NO;
    [self addTableViewDataSource];
    [self.recommendTableView reloadData];
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
   
    [self.recommendJsonData appendData:data];

}
-(void)addTableViewDataSource{
    for (int i = startIndex; i < [self.recommendArr count]; i++) {
//        [_messageArr addObject:[[self.recommendArr objectAtIndex:i] objectForKey:@"msgInfo"]];
//        [_systemMsgIdArr addObject:[[self.recommendArr objectAtIndex:i ] objectForKey:@"sysmsgId"]];
//        [_messageReadArr addObject:[[self.recommendArr objectAtIndex:i]objectForKey:@"IsReadAlready"]];
//        
//        [_timeArr addObject:[[self.recommendArr objectAtIndex:i] objectForKey:@"createTime"]];
    }
//    NSLog(@"_messageReadArr--->%@",_messageReadArr);
//    [self.messageTableView reloadData];
}

- (void) alertWithMessage:(NSString *)msg
{
    NSLog(@"msg=%@",msg);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)handleBackButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:NO];
    
}
#pragma mark table view data source methods
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"sel=%d",self.recommendArr.count);
    
    return self.recommendArr.count;
}
//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"default";
    RecommendCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"RecommendCellTableViewCell" owner:self options:nil];
        cell = [objs lastObject];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    else{
//            cell中本来就有一个subview，如果是重用cell，则把cell中自己添加的subview清除掉，避免出现重叠问题
        [[cell.subviews objectAtIndex:1] removeFromSuperview];
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSString *recommendDesc =[[self.recommendArr objectAtIndex:indexPath.row] objectForKey:@"description"];
    if ([recommendDesc isEqual:[NSNull null]]) {
        cell.recommendDesc.text = @"提醒神器,智能短信、电话提醒";
    }else{
            cell.recommendDesc.text = [[self.recommendArr objectAtIndex:indexPath.row] objectForKey:@"description"];
//            NSLog(@"cell.re=%@",cell.recommendDesc.text);
    }
    if ([[[self.recommendArr objectAtIndex:indexPath.row]objectForKey:@"name"] isEqual:[NSNull null]]) {
        cell.recommendName.text = @"";
    }else{
        cell.recommendName.text = [[self.recommendArr objectAtIndex:indexPath.row]objectForKey:@"name"];
//        NSLog(@"cell.re=%@",cell.recommendName.text);
    }
    if ([[[self.recommendArr objectAtIndex:indexPath.row] objectForKey:@"logo"]isEqual:[NSNull null]]) {
        cell.cellHeadImage.image = [UIImage imageNamed:@"logo"];

    }else{
        [cell.cellHeadImage setImageWithURL:[[self.recommendArr objectAtIndex:indexPath.row] objectForKey:@"logo"]];
    }
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,[[self.recommendArr objectAtIndex:indexPath.row] objectForKey:@"logo"]];
//    NSURL *url = [NSURL URLWithString:urls];
//    [cell.cellHeadImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo"]];
    
    return cell;
}
//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)recommendNumPost{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:@"statistics" forKey:@"action"];
    
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex]  forKey:@"startIndex"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_RECOMMEND_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    
    ASIFormDataRequest *tipsRequest = [ASIFormDataRequest requestWithURL:url];
    
    [tipsRequest setPostValue:APP_ID forKey:@"app_id"];
    [tipsRequest setPostValue:VERSIONS forKey:@"v"];
    [tipsRequest setPostValue:@"statistics" forKey:@"action"];
    [tipsRequest setPostValue:@"1" forKey:@"src"];
    [tipsRequest setPostValue:sig forKey:@"sig"];
    
    tipsRequest.delegate = self;
    tipsRequest.tag= 8686;
    [tipsRequest setRequestMethod:@"POST"];
    [tipsRequest startAsynchronous];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self recommendNumPost];
   NSString *ovurl =  [[self.recommendArr objectAtIndex:indexPath.row]objectForKey:@"url"];
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,self.jumpURL];
    NSURL *url = [NSURL URLWithString:ovurl];
    NSLog(@"request URL is: %@",url);
    [[UIApplication sharedApplication] openURL:url];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

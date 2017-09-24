//
//  NewProofapplyView.m
//  notary
//
//  Created by 肖 喆 on 13-9-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "NewProofapplyView.h"
#import "AppDelegate.h"
#import "ChecProofListView.h"

@interface NewProofapplyView ()

@end

@implementation NewProofapplyView

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
    // Do any additional setup after loading the view from its nib.
    self.jsonData = [[NSMutableData alloc] init];
    self.folderArray = [[NSMutableArray alloc]init];
    
    
    [self requestFolderList];
    
    self.title = @"申请公证";
    
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }

    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    /*
    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
    customRight.frame = CGRectMake(0, 0, 51, 40);
    [customRight addTarget:self action:@selector(requestApply4Notary) forControlEvents:UIControlEventTouchUpInside];
    [customRight setImage:[UIImage imageNamed:@"btn_queding"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
    self.navigationItem.rightBarButtonItem = rightButton;
    */
}
- (void)handleBackButtonClick:(UIButton *)but {
    
    [self cancel];
   
    [self dismissViewControllerAnimated:YES completion:nil];
//    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [delgate.proof.navigationController dismissViewControllerAnimated:YES completion:nil];

   //[super turnToGame];
//    [self.navigationController dismissViewControllerAnimated:YES
//                             completion:^(void){
//                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:nil];
//                             }];
    
//    UIViewController *viewController = self;
//    while (viewController.presentingViewController)
//    {
//        if ([viewController isMemberOfClass:[ProofView class]])  // 直到找到最底层为止
//        {
//            viewController = viewController.presentingViewController;
//        }
//        else
//        {
//            break;
//        }
//    }
//    
//    if([[[UIDevice currentDevice]systemVersion]floatValue] >=6)
//    {
//        if (viewController)
//        {
//            [viewController dismissViewControllerAnimated:YES completion:nil];
//        }
//    }
//    else
//    {
//        if (viewController)
//        {
//            [viewController dismissModalViewControllerAnimated:YES];
//        }
//    }
//

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    if (self.requestRefresh != nil){
        [self.requestRefresh cancel];
        [self.requestRefresh setDelegate:nil];
        self.requestRefresh = nil;
    }
}

#pragma ASIHttpRequest methods
//网络请求
- (void)requestFolderList
{
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件夹列表:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件夹列表:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FOLDER_LIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    if (nil != _requestRefresh) {
        
        [_requestRefresh cancel];
        _requestRefresh.delegate = nil;
        _requestRefresh = nil;
    }
    
    _requestRefresh = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRefresh setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRefresh setPostValue:user.userID forKey:@"userID"];
    [_requestRefresh setPostValue:APP_ID forKey:@"app_id"];
    [_requestRefresh setPostValue:VERSIONS forKey:@"v"];
    [_requestRefresh setPostValue:@"1" forKey:@"src"];
    [_requestRefresh setPostValue:sig forKey:@"sig"];
    
    [_requestRefresh setDelegate:self];
    [_requestRefresh setDidStartSelector:@selector(requestStart:)];
    [_requestRefresh setDidFailSelector:@selector(requestFail:)];
    [_requestRefresh setDidFinishSelector:@selector(requestFinish:)];
    [_requestRefresh setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestRefresh startAsynchronous];
}

#pragma ASIHttpRequest Delegate method
- (void)requestStart:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
//        [self handleActivityStart];
        
    }
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
//        [self handleActivityStop];
        
    }
    
    
}
- (void)requestFinish:(ASIHTTPRequest *)request
{
   
        
        
        NSDictionary * jsonDic = [_jsonData objectFromJSONData];
        
        NSArray * array = [jsonDic objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i ++) {
            
            NSDictionary * tmp = [array objectAtIndex:i];
            NSString * dataNum = [tmp objectForKey:@"dataNum"];
            NSString * folderID = [tmp objectForKey:@"folderID"];
            NSString * folderName = [tmp objectForKey:@"folderName"];
            NSString * type = [tmp objectForKey:@"type"];
            
            FolderModel * folder = [[FolderModel alloc] init];
            folder.dataNum = dataNum;
            folder.folderID = folderID;
            folder.folderName = folderName;
            folder.type = type;
            
            
            if ([folder.folderName isEqualToString:@"回收站"]){
                continue;
            }
            
            [_folderArray addObject:folder];
            NSString * logstr = [NSString stringWithFormat:@"ListFloder: folderID(%@),folderName(%@),folderType(%@),dataNum(%@)",folder.folderID,folder.folderName,folder.type,folder.dataNum];
            
            debugLog(logstr);
        }
        
        
//        [self handleActivityStop];
        [_contentView reloadData];
        [_jsonData setLength:0];
       
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{

    [_jsonData appendData:data];
        
}

#pragma UITableViewDelegate and UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolderModel * parent = [_folderArray objectAtIndex:indexPath.row];
    
    ChecProofListView * checkview = [[ChecProofListView alloc] init];
    
    checkview.rootFolder = parent;
    checkview.parentFolder = parent;
    
    
    [self.navigationController pushViewController:checkview animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  62.5f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _folderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        
        UIButton * btnNum = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNum.userInteractionEnabled = NO;
        btnNum.tag = 1001;
        btnNum.titleLabel.font = [UIFont systemFontOfSize:12];
        btnNum.frame = CGRectMake(260, 20, 30, 30);
        [btnNum setBackgroundImage:[UIImage imageNamed:@"btn_new"] forState:UIControlStateNormal];
        [cell addSubview:btnNum];
        
        UILabel * labText = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 170, 40)];
        labText.font = [UIFont fontWithName:DEFAULT_FONT size:18];
        labText.tag = 2001;
        [cell addSubview:labText];
    }
    
    
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    NSString * imageName = [self getFolderImageName:[folder.type integerValue]];
    
    
    UILabel * label = (UILabel *)[cell viewWithTag:2001];
    label.text = folder.folderName;
    
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    UIButton * temp = (UIButton *)[cell viewWithTag:1001];
    [temp setTitle:folder.dataNum forState:UIControlStateNormal];
    
    return cell;

}
- (NSString *)getFolderImageName:(NSInteger)type
{
    
    NSString * name = nil;
    if (type == 0) {
        name = @"file_other";
    }else if (type == 1) {
        name = @"file_call";
    }else if (type == 2) {
        name = @"file_recording";
    }else if (type == 3) {
        name = @"file_picture";
    }else if (type == 4) {
        name = @"file_video";
    }else if (type == 5) {
        name = @"file_other";
    }else {
        name = @"file_other";
    }
    
    return name;
}
@end

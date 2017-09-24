//
//  DirectoryView.m
//  notary
//
//  Created by 肖 喆 on 13-4-8.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "DirectoryView.h"
#import "AppDelegate.h"
#import "FolderListCell.h"
#import "ChooseChildFolder.h"

@interface DirectoryView ()

- (void)initDirecory;

@end

@implementation DirectoryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initDirecory];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _jsonData = [[NSMutableData alloc]init];
    
    self.title = @"目录列表";
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
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];
    // Do any additional setup after loading the view from its nib.
    
    _folderArray = [[NSMutableArray alloc]initWithCapacity:0];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (_request != nil) {
        [_request clearDelegatesAndCancel];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleBackButtonClick:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (void)dismissControler
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (void)initDirecory
{
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"请求目录:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    NSString * logstr2 = [NSString stringWithFormat:@"请求目录:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FOLDER_LIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_request setPostValue:user.userID forKey:@"userID"];
    [_request setPostValue:@"1" forKey:@"src"];
    [_request setPostValue:APP_ID forKey:@"app_id"];
    [_request setPostValue:VERSIONS forKey:@"v"];
    [_request setPostValue:sig forKey:@"sig"];
    
    [_request setDelegate:self];
    [_request setDidStartSelector:@selector(requestFolderListStart:)];
    [_request setDidFailSelector:@selector(requestFolderListFail:)];
    [_request setDidFinishSelector:@selector(requestFolderListFinish:)];
    [_request setDidReceiveDataSelector:@selector(requestFolderListReceiveData:didReceiveData:)];
    
    [_request startAsynchronous];
}

- (void)requestFolderListStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
}
- (void)requestFolderListFail:(ASIHTTPRequest *)request
{
    [DejalBezelActivityView removeView];
}
- (void)requestFolderListFinish:(ASIHTTPRequest *)request
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.folderArray removeAllObjects];
    
    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    NSLog(@"jsonDic:%@",jsonDic);
    NSArray * array = [jsonDic objectForKey:@"data"];
    
    for (int i = 0; i < array.count; i ++) {
        
        NSDictionary * tmp = [array objectAtIndex:i];
        NSString * dataNum = [tmp objectForKey:@"dataNum"];
        NSString * folderID = [tmp objectForKey:@"folderID"];
        NSString * folderName = [tmp objectForKey:@"folderName"];
        NSString * type = [tmp objectForKey:@"type"];
        NSString * haschild = [tmp objectForKey:@"haschild"];
        
        FolderModel * folder = [[FolderModel alloc] init];
        folder.dataNum = dataNum;
        folder.folderID = folderID;
        folder.folderName = folderName;
        folder.type = type;
        folder.haschild = haschild;
        
        if ([@"回收站" isEqualToString:folderName]
            || [@"通话录音" isEqualToString:folderName]||[@"本地录音" isEqualToString:folderName]
            ){
            
        } else if ([@"现场录音" isEqualToString:folderName]){
            if (_file.type == kVoiceFile){
                [_folderArray addObject:folder];
            }
            [app.folderArray addObject:folder];
        }
        else if ([@"音频视频" isEqualToString:folderName]) {
            
            if (_file.type == kVideoFile){
                [_folderArray addObject:folder];
            }
            //添加到全局目录结构
            [app.folderArray addObject:folder];
        }
        else if ([@"照片图片" isEqualToString:folderName]) {
            
            if (_file.type == kPhotoFile){
                [_folderArray addObject:folder];
            }
            //添加到全局目录结构
            [app.folderArray addObject:folder];
        }
        else {
            [_folderArray addObject:folder];
            //添加到全局目录结构
            [app.folderArray addObject:folder];
        }
        
    }

    [DejalBezelActivityView removeView];
    [_contentView reloadData];
    [_jsonData setLength:0];
}
- (void)requestFolderListReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];
    
   
}

#pragma UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _folderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FolderListCell *cell = (FolderListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"FolderListCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    NSString * imageName = [self getFolderImageName:[folder.type integerValue]];
    cell.folderName.text = folder.folderName;
    [cell.folderImage setImage:[UIImage imageNamed:imageName]];
    
    NSString *haschild = folder.haschild;
    if ([haschild isEqualToString:@"true"]) {
        cell.folderPushBtn.hidden = NO;
        cell.folderPushBtn.tag = indexPath.row + 1000;
        [cell.folderPushBtn addTarget:self action:@selector(folderPushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.folderPushBtn.hidden = YES;
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  62.5f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolderModel * folder = [_folderArray objectAtIndex:indexPath.row];
    self.controler.folder = folder;
    self.controler.model.folderId = folder.folderID;
    self.controler.model.folderName = folder.folderName;
//    [self dismissControler];
    [self.navigationController popToViewController:self.controler animated:YES];
}
- (void)folderPushBtnClick:(UIButton *)btn
{
    int tag = btn.tag - 1000;
    FolderModel *folder = [_folderArray objectAtIndex:tag];
    ChooseChildFolder *choose = [[ChooseChildFolder alloc] initWithNibName:@"ChooseChildFolder" bundle:nil];
    choose.folderName = folder.folderName;
    choose.folderID = folder.folderID;
    choose.childFileModel = folder;
    choose.file = self.file;
    choose.controler = self.controler;
    [self.navigationController pushViewController:choose animated:YES];
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

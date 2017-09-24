//
//  ChildFolderView.m
//  notary
//
//  Created by wenbuji on 13-9-23.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ChildFolderView.h"
#import "FolderListCell.h"
#import "FolderModel.h"

@interface ChildFolderView ()

@end

@implementation ChildFolderView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    _jsonData = [[NSMutableData alloc] init];
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    request = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.folderName;
    
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
    
    
    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
    customRight.frame = CGRectMake(0, 0, 40, 40);
    [customRight addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [customRight setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];
    
    [self request];
}
- (void)handleBackButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)folderPushBtnClick:(UIButton *)btn
{
    int tag = btn.tag - 100000;
    FolderModel *model = [self.contentArray objectAtIndex:tag];
    NSString *folderID = model.folderID;
    NSString *folderName = model.folderName;
    ChildFolderView *child = [[ChildFolderView alloc] init];
    child.folderID = folderID;
    child.folderName = folderName;
    child.childFileModel = self.childFileModel;
    [self.navigationController pushViewController:child animated:YES];
}

#pragma UITableViewDelegate  and UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FolderListCell *cell = (FolderListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"FolderListCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FolderModel *model = [self.contentArray objectAtIndex:indexPath.row];
    cell.folderName.text = model.folderName;
    NSLog(@"%@",model.folderName);
    cell.folderImage.image = [UIImage imageNamed:@"file_other.png"];

    NSString *haschild = model.haschild;
    if ([haschild isEqualToString:@"true"]) {
        cell.folderPushBtn.hidden = NO;
        cell.folderPushBtn.tag = indexPath.row + 100000;
        [cell.folderPushBtn addTarget:self action:@selector(folderPushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.folderPushBtn.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第几行%d",indexPath.row);
    FolderModel *model = [self.contentArray objectAtIndex:indexPath.row];
    NSString *newID = model.folderID;
    [self moveFolderTo:newID];

}
- (void)moveFolderTo:(NSString *)newID
{
    BOOL isFolder = self.childFileModel.isFolder;
    NSString *oldID = self.childFileModel.serverFileId;
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    UserModel *user = [UserModel sharedInstance];
    NSString *userID = user.userID;
    NSString *phoneNum = user.phoneNumber;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:userID forKey:@"userID"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    if (isFolder) {
        [dic setObject:oldID forKey:@"folderID"];
    }else{
        [dic setObject:oldID forKey:@"fileID"];
    }
    [dic setObject:newID forKey:@"targetFolderID"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = nil;
    if (isFolder) {
        urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,PRO_FOLDER_MOVE];
    }else{
        urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,PRO_FILE_MOVE];
    }
    NSURL *url = [NSURL URLWithString:urls];
    moveRequest =  [[ASIFormDataRequest alloc] initWithURL:url];
    
    [moveRequest setPostValue:APP_ID forKey:@"app_id"];
    [moveRequest setPostValue:VERSIONS forKey:@"v"];
    [moveRequest setPostValue:@"1" forKey:@"src"];
    [moveRequest setPostValue:userID forKey:@"userID"];
    [moveRequest setPostValue:phoneNum forKey:@"mobileNo"];
    if (isFolder) {
        [moveRequest setPostValue:oldID forKey:@"folderID"];
    }else{
        [moveRequest setPostValue:oldID forKey:@"fileID"];
    }
    [moveRequest setPostValue:newID forKey:@"targetFolderID"];
    
    [moveRequest setPostValue:sig forKey:@"sig"];
    
    moveRequest.delegate = self;
    moveRequest.tag = 888;
    [moveRequest setRequestMethod:@"POST"];
    [moveRequest startAsynchronous];
    NSLog(@"newID== %@ oldID == %@",newID,oldID);
}

- (void)request
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    UserModel *user = [UserModel sharedInstance];
    NSString *userID = user.userID;
    NSString *phoneNum = user.phoneNumber;
    NSString *folderID = self.folderID;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:userID forKey:@"userID"];
    [dic setObject:folderID forKey:@"folderID"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,EVIDENCE_ROOT_LIST];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    request =  [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:userID forKey:@"userID"];
    [request setPostValue:phoneNum forKey:@"mobileNo"];
    [request setPostValue:folderID forKey:@"folderID"];
    [request setPostValue:sig forKey:@"sig"];
    
    request.delegate = self;
    request.tag = 998;
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}

#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");
    if (request.tag == 998) {
    NSDictionary *jsonDic = [_jsonData objectFromJSONData];
    NSArray *arr = [jsonDic objectForKey:@"data"];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *tmpDic = [arr objectAtIndex:i];
        NSString *folderID = [tmpDic objectForKey:@"folderID"];
        NSString *folderName = [tmpDic objectForKey:@"fName"];
        NSString *haschild = [tmpDic objectForKey:@"haschild"];
        
        FolderModel *model = [[FolderModel alloc] init];
        model.folderID = folderID;
        model.folderName = folderName;
        model.haschild = haschild;
        [self.contentArray addObject:model];
    }
    [self.contentVeiw reloadData];
    }else{
        NSDictionary *jsonDic = [_jsonData objectFromJSONData];
        NSLog(@"dic%@",jsonDic);
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
        if ([code intValue] == 0) {
            NSString *status = [[jsonDic objectForKey:@"data"] objectForKey:@"status"];
            if ([status intValue] == 0) {

//             移动成功发出通知，更新移动文件的文件夹
                NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:Notification_MoveFolder object:self];

                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else {
            [self alertWithMessage:codeInfo];
        }
    }
    [_jsonData setLength:0];
    [DejalBezelActivityView removeView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSLog(@"request Failed");
    [DejalBezelActivityView removeView];
    [self alertWithMessage:@"更新状态失败，请检查网络"];
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
@end

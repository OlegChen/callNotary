//
//  MessageCenter.m
//  notary
//
//  Created by wenbuji on 13-4-17.
//  modify by liwzh 14-11-11 消息获取方式和未读消息条数调整，消息列表改成分页加载
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "MessageCenter.h"
#import "MessageCenterCell.h"
#import "ShowMessageAll.h"
#import "AppDelegate.h"
@interface MessageCenter (){
    NSIndexPath *index;
}

@end

@implementation MessageCenter

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:NO];
    
    
}

- (void)makeView
{
    self.title = @"消息中心";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10.0f, 0.0f, 30.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    _messageTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];灰色
    
    _messageTableView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addTableViewDataSource
{
    if (_messageArr == nil) {//消息信息
        NSLog(@"_messageArr");
        _messageArr = [[NSMutableArray alloc] init];
    }
    if (_messageReadArr == nil) {//已读消息
        _messageReadArr = [[NSMutableArray alloc] init];
    }
    if (_timeArr == nil) {//时间
        _timeArr = [[NSMutableArray alloc] init];
    }
    if (_systemMsgIdArr == nil) {//消息id
        _systemMsgIdArr = [[NSMutableArray alloc]init];
    }
    for (int i = startIndex; i < [_msgArr count]; i++) {
        [_messageArr addObject:[[_msgArr objectAtIndex:i] objectForKey:@"msgInfo"]];
        [_systemMsgIdArr addObject:[[_msgArr objectAtIndex:i ] objectForKey:@"sysmsgId"]];
        [_messageReadArr addObject:[[_msgArr objectAtIndex:i]objectForKey:@"IsReadAlready"]];
        
        [_timeArr addObject:[[_msgArr objectAtIndex:i] objectForKey:@"createTime"]];
    }
    NSLog(@"_messageReadArr--->%@",_messageReadArr);
    [self.messageTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tmpDateNum = -1000;
        _msgArr = [[NSMutableArray alloc] init];
//        NSLog(@"init _msgArr--->%@",_msgArr);
    }
    return self;
}

- (void)viewDidLoad
{
     startIndex = 0;
     _jsonData = [[NSMutableData alloc]init];
    [self makeView];
    [self postHttpGetMsgList];
//    [self addTableViewDataSource];
    
    [super viewDidLoad];
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

//点击未读的消息，发送我们服务器，更新状态
- (void)postHttpMsgUpdate:(NSNumber *)num
{
    _tmpDateNum = [num intValue];
    NSString *sysMsgId = [[_msgArr objectAtIndex:[num intValue] ] objectForKey:@"sysmsgId"];
    
    UserModel * user = [UserModel sharedInstance];
    NSLog(@"userID---->%@", user.userID);
    NSString *phoneNum = user.phoneNumber;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:sysMsgId forKey:@"sysmsgId"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,MESSAGE_UPDATE_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:url];
    
    /*此处userID是写死的，38，用来测试的*/
    
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:sysMsgId forKey:@"sysmsgId"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:phoneNum forKey:@"mobileNo"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:sig forKey:@"sig"];
    
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSDictionary * jsonDic = [data objectFromJSONData];
    NSLog(@"jsonDid %@",jsonDic);
    NSString * code = [jsonDic objectForKey:@"code"];
    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
    NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
    if ([code intValue] == 0) {

        [_messageReadArr replaceObjectAtIndex:_tmpDateNum withObject:@"Y"];
        UserModel * user = [UserModel sharedInstance];
        user.unReadMsgNum = user.unReadMsgNum-1 ;

    }else {
        [self alertWithMessage:codeInfo];
    }
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");
    NSLog(@"_msgArr-->%@",_msgArr);
    @try{
//        [_messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    @catch(NSException *exception) {
        
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    [_messageTableView reloadData];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"request Failed");
    [self alertWithMessage:@"更新状态失败，请检查网络"];
}

//数据源委托
#pragma mark -
#pragma mark table delegate methods
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //实现的效果是：每行点中以后变蓝色，并且马上蓝色消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == _messageReadArr.count) {
        return;
    }
    NSLog(@"inde.row=%d",indexPath.row);
    //加载更多
    if (_messageReadArr.count == indexPath.row) {
        
        
        if (isLoadMsgList) return;
        
        startIndex += 10;
        
        [self postHttpGetMsgList];
        
        return;
    }
    else{
        if ([[_messageReadArr objectAtIndex:indexPath.row] isEqualToString:@"N"]) {
            [self performSelector:@selector(postHttpMsgUpdate:) withObject:[NSNumber numberWithInt: indexPath.row]];
        }
        ShowMessageAll *showMessageVC = [[ShowMessageAll alloc] init];
        showMessageVC.contentStr = [_messageArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:showMessageVC animated:YES];
    }
}

//表视图委托
#pragma mark -
#pragma mark table view data source methods
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_messageArr.count == 0 ){
        return 1;
    }
    if (_messageArr.count >= 10)
    {
        return _messageArr.count+1;
    }
    return _messageArr.count+1;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"_messarr=%@",_messageArr);
//        NSLog(@"indx.row=%d",indexPath.row);
        [_messageArr removeObjectAtIndex:[indexPath row]];//删除数组里的数据
        [_messageReadArr removeObjectAtIndex:indexPath.row];
//        NSLog(@"_messarr.count=%d",_messageArr.count);
        [self performSelector:@selector(postHttpRemoveMsgList:) withObject:[NSNumber numberWithInt: indexPath.row]];
//        index = indexPath;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
       
    }
}
//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"messageArr.count %d,%d",_messageArr.count,indexPath.row);
        tableView.backgroundView = nil;
        static NSString *CellIdentifier = @"default";
        MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MessageCenterCell" owner:self options:nil];
            cell = [objs lastObject];

            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else{
        //cell中本来就有一个subview，如果是重用cell，则把cell中自己添加的subview清除掉，避免出现重叠问题
            [[cell.subviews objectAtIndex:1] removeFromSuperview];
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
    if (0 == _messageArr.count) {
        cell.messageLabel.hidden = YES;
        cell.zeroLabel.hidden = NO;
        cell.leftImageView.hidden = YES;
        cell.timeLabel.hidden = YES;
 
    }  else if (_messageArr.count == indexPath.row){
        //cont - 1  == row 所以这里不需要再count + 1
        
        cell.messageLabel.hidden = NO;
        cell.zeroLabel.hidden = YES;
        cell.messageLabel.text = @"加载更多";

        cell.leftImageView.hidden = YES;
        cell.timeLabel.hidden = YES;
        //        tableView.userInteractionEnabled = NO;
        
    } else {
        cell.zeroLabel.hidden = YES;
        cell.timeLabel.text = [_timeArr objectAtIndex:indexPath.row];
        cell.messageLabel.text = [_messageArr objectAtIndex:indexPath.row];
        if ([[_messageReadArr objectAtIndex:indexPath.row] isEqualToString:@"N"]) {
            cell.leftImageView.image = [UIImage imageNamed:@"icon_talk_orange.png"];
  
    }
    }
    return cell;
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)postHttpRemoveMsgList:(NSNumber *)num{
    _tmpDateNum = [num intValue];
    NSString *sysMsgId = [[_msgArr objectAtIndex:[num intValue] ] objectForKey:@"sysmsgId"];
    
    UserModel * user = [UserModel sharedInstance];
    NSLog(@"userID---->%@", user.userID);
    NSString *phoneNum = user.phoneNumber;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:@"del" forKey:@"action"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:sysMsgId forKey:@"sysmsgId"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_MESSAGE_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:url];
    
    /*此处userID是写死的，38，用来测试的*/
    
    [request setPostValue:user.userID forKey:@"userID"];
    [request setPostValue:sysMsgId forKey:@"sysmsgId"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:phoneNum forKey:@"mobileNo"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:@"del" forKey:@"action"];
    [request setPostValue:sig forKey:@"sig"];
    
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}
- (void)postHttpGetMsgList
{
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
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_MESSAGE_URL];
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
    
    
    [tipsRequest setDidStartSelector:@selector(requestStartJiaobiao:)];
    [tipsRequest setDidFailSelector:@selector(requestFailJiaobiao:)];
    [tipsRequest setDidFinishSelector:@selector(requestFinishJiaobiao:)];
    [tipsRequest setDidReceiveDataSelector:@selector(requestReceiveDataJiaobiao:didReceiveData:)];
    
    
    
    tipsRequest.delegate = self;
    tipsRequest.tag= 8888;
    [tipsRequest setRequestMethod:@"POST"];
    [tipsRequest startAsynchronous];
}
#pragma ASIHttpRequestJiaobiao Delegate method
- (void)requestStartJiaobiao:(ASIHTTPRequest *)request
{
     isLoadMsgList = YES;
}
- (void)requestFailJiaobiao:(ASIHTTPRequest *)request
{
    
    
}
- (void)requestFinishJiaobiao:(ASIHTTPRequest *)request
{
    //__block self;
    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    NSString * code = [jsonDic objectForKey:@"code"];
    //   NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
      NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
    if ([code intValue] == 0) {
        
//        [_msgArr removeAllObjects];
        [_msgArr addObjectsFromArray:[jsonDic objectForKey:@"data"]];
    }else {
        //[self alertWithMessage:codeInfo];
    }
    
    [_jsonData setLength:0];
    isLoadMsgList = NO;
    [self addTableViewDataSource];
    [self.messageTableView reloadData];
    
}
- (void)requestReceiveDataJiaobiao:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)viewDidUnload {
    [self setMessageTableView:nil];
    [super viewDidUnload];
}
@end

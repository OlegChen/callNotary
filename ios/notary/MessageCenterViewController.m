//
//  MessageCenterViewController.m
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterCell.h"

#define HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL 50


@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    _messageTableView = [[UITableView alloc] init];
    _messageTableView.frame = CGRectMake(0, 0, 320, 460-44);
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    [self.view addSubview:_messageTableView];
}

- (void)addTableViewDataSource
{
    if (_messageArr == nil) {
        NSLog(@"_messageArr");
        _messageArr = [[NSMutableArray alloc] init];
    }
    
    /*在这里接受消息并存在_messageArr里面最后追加一条“没有了”*/

        for (int i = 0; i < [_tmpArr count]; i++) {
            [_messageArr addObject:[[_tmpArr objectAtIndex:i] objectForKey:@"msgInfo"]];
        }
//    [[_tmpArr objectAtIndex:indexPath.row] objectForKey:@"IsReadAlready"] 
    
    [_messageArr addObject:@"没有了          "];

    NSLog(@"_messageArr.count--->%d",_messageArr.count);
    [self.messageTableView reloadData];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];

    [self addTableViewDataSource];

    [super viewDidLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isChange = NO;
        _showAllIndexPathRow = -100;
        _showAllHight = -110;
        _upDateNum = -1000;
        _tmpArr = [[NSArray alloc] init];
        NSLog(@"init _tmpArr--->%@",_tmpArr);
    }
    return self;
}

//表视图委托
#pragma mark -
#pragma mark table view data source methods
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 ==_messageArr.count) {
        return 1;
    }
    return _messageArr.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MessageCenterCell");
    if (_messageArr.count > 0) {
    static NSString *CellIdentifier = @"messageCenter";
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MessageCenterCell" owner:self options:nil];
        cell = [objs lastObject];
        
    }
    else{
        //cell中本来就有一个subview，如果是重用cell，则把cell中自己添加的subview清除掉，避免出现重叠问题
        [[cell.subviews objectAtIndex:1] removeFromSuperview];
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];

        if (indexPath.row != _messageArr.count-1)
        {
            //未读的设置成未读状态
            if (([[[_tmpArr objectAtIndex:indexPath.row] objectForKey:@"IsReadAlready"] isEqualToString:@"N"] || [[[_tmpArr objectAtIndex:indexPath.row] objectForKey:@"IsReadAlready"] isEqualToString:@"n"]) && indexPath.row != _upDateNum)
            {
                cell.leftImageView.image = [UIImage imageNamed:@"icon_talk_orange"];
                
            }
        }
        if (indexPath.row == _messageArr.count - 1) {
            cell.leftImageView.hidden = YES;
            cell.messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.messageLabel.text = [_messageArr objectAtIndex:indexPath.row];
        if (_showAllIndexPathRow == indexPath.row) {
            cell.messageLabel.numberOfLines = 0;

            //算出文字的总长度
            int count = cell.messageLabel.text.length;
            int j = (count/17) + 1;
            CGRect rect = cell.messageLabel.frame;
            cell.messageLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 15 * j);
        }
        [UIView commitAnimations];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
    if (0 == _messageArr.count) {
        UITableViewCell *lastCell = [[UITableViewCell alloc] init];
        lastCell.textLabel.text = @"没有消息";
        lastCell.textLabel.textAlignment = UITextAlignmentCenter;
        return lastCell;
    }
    
    return nil;
}

- (void)postHttpMsgUpdate:(NSNumber *)num
{
    _tmpDateNum = [num intValue];
    NSString *sysMsgId = [[_tmpArr objectAtIndex:[num intValue] ] objectForKey:@"sysmsgId"];
    
    UserModel * user = [UserModel sharedInstance];
    NSLog(@"userID---->%@", user.userID);
    NSString *phoneNum = user.phoneNumber;
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:@"38" forKey:@"userID"];
    [dic setObject:sysMsgId forKey:@"sysmsgId"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,MESSAGE_UPDATE_URL];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:url];
    
    /*此处userID是写死的，38，用来测试的*/
    
    [request setPostValue:@"38" forKey:@"userID"];
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
        
        _upDateNum = _tmpDateNum;
    }else {
        [self alertWithMessage:codeInfo];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");
    NSLog(@"_tmpArr-->%@",_tmpArr);
    
    [_messageTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request Failed");
    [self alertWithMessage:@"更新状态失败，请检查网络"];
}

- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAllText:(NSNumber *)num
{

    NSString *str =  [_messageArr objectAtIndex:[num integerValue]];
    NSLog(@"%d",[str length]);
    if (str.length > 17&&_isChange == NO) {
        _showAllIndexPathRow = [num intValue];
        _isChange = YES;
        [_messageTableView reloadData];
    }else {
        _isChange = NO;
        _showAllHight = -100;
        _showAllIndexPathRow = -100;
        [_messageTableView reloadData];
    }
}

//数据源委托
#pragma mark -
#pragma mark table delegate methods

//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //实现的效果是：每行点中以后变蓝色，并且马上蓝色消失
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//在弹出警告后自动取消选中表视图单元
    NSLog(@"第%d行被选中",indexPath.row);
    //首先排除最后一行
    if (indexPath.row != _messageArr.count-1)
    {
        [self performSelector:@selector(showAllText:) withObject:[NSNumber numberWithInt: indexPath.row]];
        
        if ([[[_tmpArr objectAtIndex:indexPath.row] objectForKey:@"IsReadAlready"] isEqualToString:@"N"] || [[[_tmpArr objectAtIndex:indexPath.row] objectForKey:@"IsReadAlready"] isEqualToString:@"n"]){
            
            [self performSelector:@selector(postHttpMsgUpdate:) withObject:[NSNumber numberWithInt: indexPath.row]];
        }
    }
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (0 == _messageArr.count) {
        tableView.contentSize = CGSizeMake(320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL);
        tableView.frame = CGRectMake(0, 0, 320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL);
    }else if (_messageArr.count > 0){
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];

        if (_showAllIndexPathRow == indexPath.row) {
            NSString *str =  [_messageArr objectAtIndex:indexPath.row];
            int count = str.length;
            int j = (count/17) + 1;
            _showAllHight = HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL + 15 * j;
            tableView.contentSize = CGSizeMake(320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * (_messageArr.count-1) + _showAllHight);
            if(HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * (_messageArr.count-1)+_showAllHight >= 460-44 )
            {
                tableView.frame = CGRectMake(0, 0, 320, 460-44);
            }else if(HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * (_messageArr.count-1)+_showAllHight <460-44){
                
                tableView.frame = CGRectMake(0, 0, 320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * (_messageArr.count-1)+_showAllHight);
            }
            [UIView commitAnimations];
            return _showAllHight;
        }
        else if(_showAllIndexPathRow != indexPath.row&&_isChange == NO){
//            NSLog(@"&&&&&&&&&&&");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];

        tableView.contentSize = CGSizeMake(320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * _messageArr.count);
        if(HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * _messageArr.count >= 460-44 )
        {
            tableView.frame = CGRectMake(0, 0, 320, 460-44);
        }else{
        
            tableView.frame = CGRectMake(0, 0, 320, HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL * _messageArr.count);
        }
    }
        [UIView commitAnimations];

    return HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL;
    }

    NSLog(@"HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL %d",HEIGHT_FOR_MESSAGE_TABLEVIEW_CELL);
}

- (void)viewDidUnload {
    [self setMessageTableView:nil];
    [super viewDidUnload];
}
@end

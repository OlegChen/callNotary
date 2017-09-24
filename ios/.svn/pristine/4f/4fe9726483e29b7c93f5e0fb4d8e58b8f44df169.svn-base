//
//  ShowMessageAll.m
//  notary
//
//  Created by wenbuji on 13-4-17.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ShowMessageAll.h"

@interface ShowMessageAll ()

@end

@implementation ShowMessageAll

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _contentStr = [[NSString alloc] init];
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView
{
    self.title = @"消息详情";
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
    _allTableView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//表视图委托
#pragma mark -
#pragma mark table view data source methods

//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

//表视图显示表视图项时调用：第一次显示（根据视图大小显示多少个视图项就调用多少次）以及拖动时调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundView = nil;
    
    static NSString * CellIdentifier = @"MessageViewControllerCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:15];
        // 該行要顯示的內容
//        NSLog(@"%@",_contentStr);
        NSString *content = _contentStr;
        // 实例化单元格对象
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置显示文字
        cell.textLabel.text = content;
        // 設置自動換行(重要)
        cell.textLabel.numberOfLines = 0;
        // 設置顯示字體(一定要和之前計算時使用字體一至)
        cell.textLabel.font = font;
    }
        return cell;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列寬
    CGFloat contentWidth = 300;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:14];
    // 該行要顯示的內容
    NSString *content = _contentStr;
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    // 這裏返回需要的高度
    return size.height+30;
}

///在某行被选中前调用，返回nil表示该行不能被选中；另外也可返回重定向的indexPath，使选择某行时会跳到另一行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //实现的效果是：每行点中以后变蓝色，并且马上蓝色消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//在弹出警告后自动取消选中表视图单元
    
}
//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (void)viewDidUnload {
    [self setAllTableView:nil];
    [super viewDidUnload];
}
@end

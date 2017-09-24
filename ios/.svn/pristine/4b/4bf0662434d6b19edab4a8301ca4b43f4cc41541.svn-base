//
//  seeDocumentViewController.m
//  notary
//
//  Created by 肖 喆 on 13-11-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "seeDocumentViewController.h"

@interface seeDocumentViewController ()

@end

@implementation seeDocumentViewController
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  packId:(NSString*)packid packName:(NSString*)packname
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=packname;
        packidValue=packid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jsonData = [[NSMutableData alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    
    labelReminder=[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/2, 320, 30)];
    labelReminder.hidden=YES;
    labelReminder.backgroundColor=[UIColor clearColor];
    labelReminder.textAlignment=NSTextAlignmentCenter;
    labelReminder.font=[UIFont systemFontOfSize:16.0f];
    labelReminder.textColor=[UIColor lightGrayColor];
    labelReminder.text=@"暂无数据";
    [self.view addSubview:labelReminder];
    
    UIView*view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, 320, 40);
    view.backgroundColor=[UIColor  colorWithRed:129./255.
                                          green:198./255.
                                           blue:251./255.
                                          alpha:1.0f];
    
    NSArray*labelArr=[NSArray arrayWithObjects:@"序号",@"文件名",@"备注",@"操作", nil];
    for (int i = 0; i < 4; i++) {
        UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(80*i, 7, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13.0f];
        label.text=[labelArr objectAtIndex:i];
        label.textColor=[UIColor colorWithRed:49./255.
                                        green:115./255.
                                         blue:171./255.
                                        alpha:1.0f];
        [view addSubview:label];
        
    }
    [self.view addSubview:view];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;

    [self AppRequest:111 requestTag:nil];
	NSLog(@"packidValue:%@",packidValue);
   
}
-(void)back{

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return  [items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";

	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
		
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: SimpleTableIdentifier] ;
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		
	}
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    ///////////////
    UIView *lingV = [[UIView alloc] init];
    lingV.frame = CGRectMake(15, 80, 320, 1);
    lingV.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
    [cell.contentView addSubview:lingV];
    
    UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 29, 24)];
    [imageView setImage:[UIImage imageNamed:@"bg_no"]];
    [cell.contentView addSubview:imageView];
    
    UILabel*xuLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 29, 24)];
    xuLabel.backgroundColor=[UIColor clearColor];
    xuLabel.tag=11;
    xuLabel.textAlignment=NSTextAlignmentCenter;
    xuLabel.font=[UIFont systemFontOfSize:13.0f];
    xuLabel.textColor=[UIColor colorWithRed:39./255.
                                      green:72./255.
                                       blue:121./255.
                                      alpha:1.0f];
    [imageView addSubview:xuLabel];
    
    UILabel*nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 110, 80)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.tag=22;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLabel.numberOfLines = 5;
    nameLabel.font=[UIFont systemFontOfSize:12.0f];
    nameLabel.textColor=[UIColor colorWithRed:39./255.
                                        green:72./255.
                                         blue:121./255.
                                        alpha:1.0f];
    [cell.contentView addSubview:nameLabel];
    
    UILabel*commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 80)];
    commentLabel.backgroundColor=[UIColor clearColor];
    commentLabel.tag=33;
    commentLabel.textAlignment=NSTextAlignmentLeft;
    commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    commentLabel.numberOfLines = 5;
    commentLabel.font=[UIFont systemFontOfSize:12.0f];
    commentLabel.textColor=[UIColor colorWithRed:39./255.0f
                                        green:72./255.0f
                                         blue:121./255.0f
                                        alpha:1.0f];
    [cell.contentView addSubview:commentLabel];
    
       
    ////////////////////
    UILabel*labelOne=(UILabel*)[cell.contentView viewWithTag:11];
//    labelOne.text=[[items objectAtIndex:[indexPath row] ]objectForKey:@"applyInfoId"];
    
    labelOne.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    
    
    UILabel*labelTwo=(UILabel*)[cell.contentView viewWithTag:22];
    labelTwo.text=[[items objectAtIndex:[indexPath row] ]objectForKey:@"fileName"];
    
    UILabel*labelThree=(UILabel*)[cell.contentView viewWithTag:33];
    labelThree.text=[[items objectAtIndex:[indexPath row] ]objectForKey:@"comment"];
    
//    NSString*comment=[[items objectAtIndex:[indexPath row] ]objectForKey:@"comment"];
    
    if ([self.mark isEqualToString:@"1"]) {
        
        
        //  UILabel*labelFour=(UILabel*)[cell.contentView viewWithTag:44];
        
        
        UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        customLeft.tag=indexPath.row;
        customLeft.frame = CGRectMake(250, 25, 65, 28);
        [customLeft setBackgroundImage:[UIImage imageNamed:@"btn_cyan_4txt"] forState:UIControlStateNormal];
        //[customLeft setBackgroundImage:[UIImage imageNamed:@"blue_over.png"] forState:UIControlStateSelected ];
        [customLeft addTarget:self action:@selector(cancelApply:) forControlEvents:UIControlEventTouchDown];
        [customLeft setTitle:@"取消申请" forState:UIControlStateNormal];
        [customLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        customLeft.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        
        [cell.contentView addSubview:customLeft];
        
        
    }
    else {}
    //    cell.textLabel.text = [[items objectAtIndex:[indexPath row] ]objectForKey:@"packName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return   81;
	
}
-(void)cancelApply:(UIButton*)button{
     cellTag=button.tag;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"询问" message:@"是否确定取消申请公证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alertView.tag=1111;
    [alertView show];
   

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 1111) {
        
        if (buttonIndex == 0) {
            NSLog(@"点击了取消申请公证");
           [self AppRequest:222 requestTag:cellTag];
        }
    }
}

#pragma  ASIHttpRequest 
-(void)AppRequest:(int)tagrequest requestTag:(int)requestag{
    
    //查询可用公证申请包，供申请公证时选择接口
    UserModel * user = [UserModel sharedInstance];
    //request.shouldAttemptPersistentConnection   = YES;
    if (tagrequest == 111) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
        [dic setObject:packidValue forKey:@"packId"];
        
        
        NSString *resultMd5 = [URLUtil generateNormalizedString:dic];
        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",resultMd5,@"wqerf*6205"]];
        
        
        NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"qryApplyInfo.action"];
        NSURL * url = [NSURL URLWithString:urls];
        NSLog(@"request URL is: %@",url);
        ASIFormDataRequest*request =  [[ASIFormDataRequest alloc] initWithURL:url];
        request.tag=tagrequest;
        [request setPostValue:user.userID forKey:@"userID"];
        [request setPostValue:@"1" forKey:@"src"];
        [request setPostValue:APP_ID forKey:@"app_id"];
        [request setPostValue:VERSIONS forKey:@"v"];
        [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
        [request setPostValue:packidValue forKey:@"packId"];
        [request setPostValue:sig forKey:@"sig"];
        request.delegate = self;
        [request setRequestMethod:@"POST"];
        [request setDidFailSelector:@selector(AppRequestFail:)];
        [request setDidFinishSelector:@selector(AppRequestFinish:)];
        [request setDidReceiveDataSelector:@selector(AppRequestReceiveData:didReceiveData:)];
        [request startAsynchronous];

    }else{
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:@"1" forKey:@"src"];
        [dic setObject:APP_ID forKey:@"app_id"];
        [dic setObject:VERSIONS forKey:@"v"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
        [dic setObject:[[items objectAtIndex:requestag ]objectForKey:@"applyInfoId"] forKey:@"applyInfoId"];
        
        
        NSString *resultMd5 = [URLUtil generateNormalizedString:dic];
        NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",resultMd5,@"wqerf*6205"]];
        
        
        NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"delGzFile.action"];
        NSURL * url = [NSURL URLWithString:urls];
        NSLog(@"request URL is: %@",url);
        ASIFormDataRequest*request =  [[ASIFormDataRequest alloc] initWithURL:url];
        request.tag=tagrequest;
        [request setPostValue:user.userID forKey:@"userID"];
        [request setPostValue:@"1" forKey:@"src"];
        [request setPostValue:APP_ID forKey:@"app_id"];
        [request setPostValue:VERSIONS forKey:@"v"];
        [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
        [request setPostValue:[[items objectAtIndex:requestag ]objectForKey:@"applyInfoId"] forKey:@"applyInfoId"];
        [request setPostValue:sig forKey:@"sig"];
        request.delegate = self;
        [request setRequestMethod:@"POST"];
        [request setDidFailSelector:@selector(AppRequestFail:)];
        [request setDidFinishSelector:@selector(AppRequestFinish:)];
        [request setDidReceiveDataSelector:@selector(AppRequestReceiveData:didReceiveData:)];
        [request startAsynchronous];

    
    
    
    }
   
    
    
    
    
    
}

#pragma mak - ASIHTTPRequestDelegate
- (void)AppRequestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];
    //NSLog(@"-----_jsonData-%@",_jsonData);
    
}

-(void)AppRequestFinish:(ASIHTTPRequest *)request
{
    
   
    
    
  
    //第一次请求 表数据的内容
    if (request.tag == 111) {
        
        //设置表
        Tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 40,320 ,360) style:UITableViewStylePlain];
        Tableview.backgroundColor=[UIColor clearColor];
        
        Tableview.delegate=self;
        Tableview.dataSource=self;
        Tableview.hidden=NO;
        Tableview.separatorStyle = UITableViewCellAccessoryNone;

        [self.view addSubview:Tableview];
        
        NSDictionary *jsonDic = [_jsonData objectFromJSONData];
        
        NSMutableArray*getSArr= [jsonDic objectForKey:@"data"];
         NSLog(@"-----request.tag-%@",getSArr);
        if ([getSArr count] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCell" object:self];
            Tableview.hidden=YES;
            Tableview.hidden=YES;
            labelReminder.hidden=NO;
        }else{
        items=getSArr;
        [Tableview  reloadData];
            
        }
        [_jsonData setLength:0];
        
    }else {
       //第二次删除表数据的内容
      NSDictionary *jsonDic = [_jsonData objectFromJSONData];
       
        NSString*getStr=[[jsonDic objectForKey:@"data"] objectForKey:@"status"];
        
        if ([getStr isEqualToString:@"0"] ) {
            NSLog(@"successful");
            NSMutableArray*tmpArr=[NSMutableArray arrayWithArray:items];
            [tmpArr removeObjectAtIndex:cellTag];
            self.items=tmpArr;
            if ([self.items count] == 0) {
                
                
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCell" object:self];
                Tableview.hidden=YES;
                 labelReminder.hidden=NO;
            }else{
                [Tableview reloadData];}
            }else{
        
        
             }
        
        [_jsonData setLength:0];
    
    }
    
        
    
    
    
}
-(void)AppRequestFail:(ASIHTTPRequest*)request{
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

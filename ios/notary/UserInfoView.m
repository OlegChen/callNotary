//
//  UserInfoView.m
//  notary
//
//  Created by 肖 喆 on 13-9-10.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UserInfoView.h"
#import "AppDelegate.h"
#import "NewProofapplyView.h"

@interface UserInfoView ()

@end

@implementation UserInfoView

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
    _jsonFolderList = [[NSMutableData alloc]init];
    self.title = @"认证信息";
    

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

    //[[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest) name:@"postData" object:nil];
    
}
//-(void)mytest{
    
  //  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
}
- (void)handleBackButtonClick:(UIButton *)but {
    [self cancel];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSubmit:(id)sender
{
    [self requestList];
}

#pragma ASIHttpRequest handle method
- (void)requestList
{
    NSString * realName = self.txtName.text;
    NSString * idcard = self.txtId.text;
    
    BOOL isVeify = NO;
    NSString * message = nil;
    
    if ([realName isEqualToString:@""]||realName == nil){
        isVeify = YES;
        message = @"请输入姓名";
    }
    else if (![self isValidateEmail:idcard]){
        isVeify = YES;
        message = @"请正确输入身份证号码";
    }
    
    if (isVeify){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:realName forKey:@"realName"];
    [dic setObject:idcard forKey:@"idcard"];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"保存身份信息:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"保存身份信息:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SAVE_INFO];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * log = [NSString stringWithFormat:@"%@%@?app_id=%@&v=%@&src=1&userID=%@&realName=%@&idcard=%@&sig=%@",ROOT_URL,SAVE_INFO,APP_ID,VERSIONS,user.userID,realName,idcard,sig];
    
    debugLog(@"保存信息url %@",log);
    
    _requestRefresh = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRefresh setPostValue:realName forKey:@"realName"];
    [_requestRefresh setPostValue:idcard forKey:@"idcard"];
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
#pragma ASIHttpRequest Delegate methods
- (void)requestStart:(ASIHTTPRequest *)request
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
    
}
- (void)requestFail:(ASIHTTPRequest *)request
{
     [DejalBezelActivityView removeView];
}

-(BOOL)isValidateEmail:(NSString *)email {
    
    if ([email isEqualToString:@""]) return NO;
    
    NSString *emailRegex = @"^[1-9][0-9]{5}(19[0-9]{2}|200[0-9]|2010)(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[0-9]{3}[0-9xX]$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)requestFinish:(ASIHTTPRequest *)request
{
     [DejalBezelActivityView removeView];
    
    NSDictionary * jsonDic = [_jsonFolderList objectFromJSONData];
    
    NSLog(@"jsonDic %@",jsonDic);
    
    NSDictionary * data = [jsonDic objectForKey:@"data "];
    
    NSString * status = [data objectForKey:@"status"];
    
    if ([status intValue] == 0){
        
        UserModel * user = [UserModel sharedInstance];
        user.isExist = YES;
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存信息成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
        
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        
    
    if (buttonIndex == 0){
        
   
    [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:^(void){
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_NoticeInform" object:nil];
                                                      }];
        
        
    }else {
        
    }
        
    }
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
   
        
    [_jsonFolderList appendData:data];
    
    
}
- (void)cancel
{
    if (_requestRefresh != nil){
        [_requestRefresh cancel];
        [_requestRefresh setDelegate:nil];
        _requestRefresh = nil;
    }
    [DejalBezelActivityView removeView];
}
@end

//
//  Recharge.m
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Recharge.h"
#import "AppDelegate.h"
//#import "AlixPay.h"
#import "THUtility.h"
//#define ProductID_IAP1 @"1***01"
//#define ProductID_IAP2 @"1***02"
//#define ProductID_IAP3 @"1***03"
//#define ProductID_IAP4 @"1***04"
//#define ProductID_IAP5 @"1***05"
//#define ProductID_IAP6 @"1***06"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"


@interface Recharge ()

@end

@implementation Recharge

- (void)back
{
    [self  cancelStoreRequest];
    [self.navigationController popViewControllerAnimated:YES];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:NO];
}

- (void)makeView
{
    self.title = @"充值";
    self.navigationItem.hidesBackButton = YES;

    [self.rechargeBtn setBackgroundImage:[UIImage resizableImageWithName:@"红色按钮"] forState:UIControlStateNormal];
//    [self.rechargeBtn setBackgroundImage:[UIImage resizableImageWithName:@"通用灰按钮"] forState:UIControlStateHighlighted];
    [self.rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"左上角通用返回" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;

    [self.btn12 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn12 setTitle:ProductID_IAP_Recharge_TITLE_45 forState:UIControlStateNormal];
    self.btn12.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn50 setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮"] forState:UIControlStateNormal];
    [self.btn50 setTitle:ProductID_IAP_Recharge_TITLE_60 forState:UIControlStateNormal];
    self.btn50.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn98 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn98 setTitle:ProductID_IAP_Recharge_TITLE_108 forState:UIControlStateNormal];
    self.btn98.titleLabel.font = [UIFont systemFontOfSize: 18.0];
}

- (void)cancelStoreRequest
{
    if (nil != _asiRequest) {
        [_asiRequest clearDelegatesAndCancel];
        _asiRequest = nil;
    }
    [_request cancel];
    _request.delegate = nil;
    _request = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelStoreRequest];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
//    UIPrerenderedIcon
    [super viewDidLoad];
    _kRechargeButtonNumber = kRechargeButton168;

    [self makeView];
}
//调整12为45块钱 by liwzh
- (IBAction)btn12Click:(UIButton *)sender {
    _kRechargeButtonNumber = kRechargeButton68;
//    [self.btn12 setImage:[UIImage imageNamed:@"btn_h_18.png"] forState:UIControlStateNormal];
//    [self.btn50 setImage:[UIImage imageNamed:@"btn_l_60.png"] forState:UIControlStateNormal];
//    [self.btn98 setImage:[UIImage imageNamed:@"btn_l_108.png"] forState:UIControlStateNormal];
    [self.btn12 setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮"] forState:UIControlStateNormal];
    [self.btn12 setTitle:ProductID_IAP_Recharge_TITLE_45 forState:UIControlStateNormal];
    self.btn12.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn50 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn50 setTitle:ProductID_IAP_Recharge_TITLE_60 forState:UIControlStateNormal];
    self.btn50.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn98 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn98 setTitle:ProductID_IAP_Recharge_TITLE_108 forState:UIControlStateNormal];
    self.btn98.titleLabel.font = [UIFont systemFontOfSize: 18.0];

}
/**原先12块钱备份 by liwzh
- (IBAction)btn12Click:(UIButton *)sender {
    _kRechargeButtonNumber = kRechargeButton18;
    //    [self.btn12 setImage:[UIImage imageNamed:@"btn_h_18.png"] forState:UIControlStateNormal];
    //    [self.btn50 setImage:[UIImage imageNamed:@"btn_l_60.png"] forState:UIControlStateNormal];
    //    [self.btn98 setImage:[UIImage imageNamed:@"btn_l_108.png"] forState:UIControlStateNormal];
    [self.btn12 setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
    [self.btn12 setTitle:ProductID_IAP_Recharge_TITLE_18 forState:UIControlStateNormal];
    self.btn12.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn50 setBackgroundImage:[UIImage imageNamed:@"btn_blue2.png"] forState:UIControlStateNormal];
    [self.btn50 setTitle:ProductID_IAP_Recharge_TITLE_60 forState:UIControlStateNormal];
    self.btn50.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn98 setBackgroundImage:[UIImage imageNamed:@"btn_blue2.png"] forState:UIControlStateNormal];
    [self.btn98 setTitle:ProductID_IAP_Recharge_TITLE_108 forState:UIControlStateNormal];
    self.btn98.titleLabel.font = [UIFont systemFontOfSize: 18.0];

}
**/

- (IBAction)btn50Click:(UIButton *)sender {
    _kRechargeButtonNumber = kRechargeButton168;
//    [self.btn12 setImage:[UIImage imageNamed:@"btn_l_18.png"] forState:UIControlStateNormal];
//    [self.btn50 setImage:[UIImage imageNamed:@"btn_h_60.png"] forState:UIControlStateNormal];
//    [self.btn98 setImage:[UIImage imageNamed:@"btn_l_108.png"]forState:UIControlStateNormal];
    [self.btn12 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn12 setTitle:ProductID_IAP_Recharge_TITLE_45 forState:UIControlStateNormal];
    self.btn12.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn50 setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮"] forState:UIControlStateNormal];
    [self.btn50 setTitle:ProductID_IAP_Recharge_TITLE_60 forState:UIControlStateNormal];
    self.btn50.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn98 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn98 setTitle:ProductID_IAP_Recharge_TITLE_108 forState:UIControlStateNormal];
    self.btn98.titleLabel.font = [UIFont systemFontOfSize: 18.0];

}

- (IBAction)btn98Click:(UIButton *)sender {
    _kRechargeButtonNumber = kRechargeButton388;
//    [self.btn12 setImage:[UIImage imageNamed:@"btn_l_18.png"] forState:UIControlStateNormal];
//    [self.btn50 setImage:[UIImage imageNamed:@"btn_l_60.png"] forState:UIControlStateNormal];
//    [self.btn98 setImage:[UIImage imageNamed:@"btn_h_108.png"]forState:UIControlStateNormal];
    [self.btn12 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn12 setTitle:ProductID_IAP_Recharge_TITLE_45 forState:UIControlStateNormal];
    self.btn12.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn50 setBackgroundImage:[UIImage resizableImageWithName:@"浅蓝蓝色按钮"] forState:UIControlStateNormal];
    [self.btn50 setTitle:ProductID_IAP_Recharge_TITLE_60 forState:UIControlStateNormal];
    self.btn50.titleLabel.font = [UIFont systemFontOfSize: 18.0];

    [self.btn98 setBackgroundImage:[UIImage resizableImageWithName:@"蓝色按钮"] forState:UIControlStateNormal];
    [self.btn98 setTitle:ProductID_IAP_Recharge_TITLE_108 forState:UIControlStateNormal];
    self.btn98.titleLabel.font = [UIFont systemFontOfSize: 18.0];

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex--%d",buttonIndex);
    switch (buttonIndex) {
        case 0:{

            [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在连接App Store" width:0];
            if ([SKPaymentQueue canMakePayments]) {
                //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
                [self RequestProductData];
                NSLog(@"允许程序内付费购买");
            }
            else
            {
                NSLog(@"不允许程序内付费购买");
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message:@"你没允许应用程序内购买"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];

                [alerView show];

            }


            break;}
        case 1:{
            [self alixPay];

            break;}

        case 2:{
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [delegate sendPay2];
            break;
        }

        default:
            break;
    }

}

- (IBAction)btnRechargeClick:(UIButton *)sender {


//    UserModel * user = [UserModel sharedInstance];
//    if ([user.isUseAlipay isEqualToString:@"1"]) {
//
//        UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"appstore支付",@"支付宝支付", nil];
//
//        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [sheet showInView:self.view];
//
//
//    }else{


        [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在连接App Store" width:0];
        if ([SKPaymentQueue canMakePayments]) {
            //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            [self RequestProductData];
            NSLog(@"允许程序内付费购买");
        }
        else
        {
            NSLog(@"不允许程序内付费购买");
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"你没允许应用程序内购买"
                                                               delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];

            [alerView show];

        }


//    }

    NSLog(@"充值%d元",_kRechargeButtonNumber);
//#if 0
//    [self alixPay];//支付宝支付
//
//#else
//   #endif
}
#if 1
#pragma mark -
#pragma mark Application alixPay
-(void)alixPay{
    NSString *pricr = nil;
    if (_kRechargeButtonNumber == kRechargeButton18) {
        pricr = @"12";
    }else if (_kRechargeButtonNumber == kRechargeButton168){
        pricr = @"88";
    }else if (_kRechargeButtonNumber == kRechargeButton388){
        pricr = @"188";
    }else if (_kRechargeButtonNumber == kRechargeButton68){
        pricr = @"18";
    }

    //测试
    //pricr = @"0.01";

    NSLog(@"支付金额：%@",pricr);
    UserModel *user = [UserModel sharedInstance];
    NSString *userID = user.userID;


    _jsonData=[[NSMutableData alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userID forKey:@"userID"];
    [dic setObject:pricr forKey:@"price"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:@"100" forKey:@"payType"];
    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,@"wqerf*6205"]];


    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,@"payInit.action"];
    NSURL *url = [NSURL URLWithString:urls];
    NSLog(@"request URL is: %@",url);
    ASIFormDataRequest*request =  [[ASIFormDataRequest alloc] initWithURL:url];


    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:userID forKey:@"userID"];
    [request setPostValue:pricr forKey:@"price"];
    [request setPostValue:@"100" forKey:@"payType"];

    [request setPostValue:sig forKey:@"sig"];

    request.delegate = self;

    [request setRequestMethod:@"POST"];
    [request startAsynchronous];




}
#pragma mak - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
    NSLog(@"-----jsonData:%@",_jsonData);
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request Finish");

    NSString *appScheme = @"phonerecorder";
    NSDictionary *jsonDic = [_jsonData objectFromJSONData];
    
//     NSError *error;
//    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"-----jsonDic:%@",jsonDic);
    NSString *code = [jsonDic objectForKey:@"code"];
    if ([code intValue] == 0) {


        NSDictionary *sendStrDic = [jsonDic objectForKey:@"data"];

        NSString *str = [sendStrDic objectForKey:@"aliPayData"];


        NSDictionary *param = [self dictionaryWithJsonString:str];

        CGFloat fee = [[param objectForKey:@"total_fee"] floatValue];


        [self beginAlipayWithTradeNO:[param objectForKey:@"out_trade_no"] productName:[param objectForKey:@"subject"] productDescription:[param objectForKey:@"body"] amount:fee];


//        //旧的alipay
//
//    NSLog(@"-----request:%@",[sendStrDic objectForKey:@"sendStr"]);
//    AlixPay * alixpay = [AlixPay shared];
//    int ret = [alixpay pay:[sendStrDic objectForKey:@"sendStr"] applicationScheme:appScheme];
//    if (ret == kSPErrorAlipayClientNotInstalled) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                             message:@"您还没有安装支付宝快捷支付，请先安装。"
//                                                            delegate:self
//                                                   cancelButtonTitle:@"确定"
//                                                   otherButtonTitles:nil];
//        [alertView setTag:123];
//        [alertView show];
//       // [alertView release];
//    }
//    else if (ret == kSPErrorSignError) {
//        NSLog(@"签名错误！");
//    }
    }else{
        NSString *codeInfo = [jsonDic objectForKey:@"codeInfo"];
        UIAlertView *vie = [[UIAlertView alloc] initWithTitle:@"提示" message:codeInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [vie show];
    }

}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSLog(@"request Failed");

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 123) {
        NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}
#endif
#if 1

-(int)GetItemID:(NSString*)productID
{
    if ([productID isEqual:ProductID_IAP_Recharge_45])return 1317499045;
    if ([productID isEqual:ProductID_IAP_Recharge_60])return 1317499905;
    if ([productID isEqual:ProductID_IAP_Recharge_108])return 1317500145;

    return -1;
}
-(BOOL)putStringToItunes:(NSData*)iapData
{//iapData是用户购成功的transactionReceipt

    NSString* encodingStr = [THUtility encodeBase64WithData:iapData];
    NSLog(@"---encodingStr:%@",encodingStr);
    
    NSString * str=[[NSString alloc]initWithData:iapData encoding:NSUTF8StringEncoding];
    
    NSString *URL;

    NSString *environment=[self environmentForReceipt:str];
    NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@",environment);
    if ([environment isEqualToString:@"environment=Sandbox"]) {
        
        URL =@"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    else{
        
        URL=@"https://buy.itunes.apple.com/verifyReceipt";
    }
    
    
//    if (bSandbox)
//    {
//        URL =@"https://sandbox.itunes.apple.com/verifyReceipt";
//    }
//    else
//    {
//        URL=@"https://buy.itunes.apple.com/verifyReceipt";
//    }
    //NSString *
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];// autorelease];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    //设置contentType
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [encodingStr length]] forHTTPHeaderField:@"Content-Length"];

    NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
    NSData* resData = [body JSONData];
    [request setHTTPBody:resData];

    NSHTTPURLResponse *urlResponse=nil;
    NSError *errorr=nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&errorr];


//    JSONDecoder *jd = [[JSONDecoder alloc] init];
//    //NSString* slog = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
//    //[self sendLog:slog];
//    NSDictionary *dic = [jd objectWithData:receivedData];
    
    NSError *jsonParsingError = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&jsonParsingError];
    
    
    if([[dic objectForKey:@"status"] intValue]==0)//注意，status=@"0" 是验证收据成功
    {
        id rid = [dic objectForKey:@"receipt"];
        if (rid == NULL) {
            return false;
        }

        NSDictionary *receiptDic = [dic objectForKey:@"receipt"]; //[jd objectWithUTF8String:(const unsigned char *)[receiptStr UTF8String] length:(NSInteger)[receiptStr length]];
        if([self GetItemID:[receiptDic objectForKey:@"product_id"]] != [[receiptDic objectForKey:@"item_id"] intValue])
        {
            return false;
        }
        return true;
    }
    else if([[dic objectForKey:@"status"] intValue]==21007)
    {
        return [self putStringToItunes:iapData];
    }

    return false;
}

-(NSString * )environmentForReceipt:(NSString * )str
{
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray * arr=[str componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}


///////////
-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (_kRechargeButtonNumber) {
        case kRechargeButton18:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Recharge_18,nil];
            break;
        case kRechargeButton68:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Recharge_45,nil];
            break;
        case kRechargeButton168:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Recharge_60,nil];
            break;
        case kRechargeButton388:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Recharge_108,nil];
            break;

        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    _request = nil;
    _request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    _request.delegate=self;
    [_request start];
}
//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{


    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    // populate UI
    SKPayment *payment = nil;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        payment = [SKPayment paymentWithProduct:product];
        _storePrice = [NSString stringWithFormat:@"%@",product.price];
        NSLog(@"价格: %@" , _storePrice);

    }
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    //    [request autorelease];

}

- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];

}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [DejalBezelActivityView removeView];
    
     NSLog(@"------------------错误-----------------:%@", error);

    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
    [alerView show];
}

-(void) requestDidFinish:(SKRequest *)request
{
   // [DejalBezelActivityView removeView];

    NSLog(@"----------反馈信息结束-------------- %@ ",request);

}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    //    [transactions release];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//用户购买的操作有结果的时候 触发
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue-------- %@", transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {



//验证
//            if ([self putStringToItunes:transaction.transactionReceipt])
//                {
                
                  NSString* encodingStr = [THUtility encodeBase64WithData:transaction.transactionReceipt];
                    [self completeTransaction:transaction REceiptString:encodingStr];
                       NSLog(@"-----交易完成 --------");
                

//                }
//                else
//                {
//
//                }

                                //                [alerView release];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {

             //  [DejalBezelActivityView removeView];

            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                 [DejalBezelActivityView removeView];
//                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                     message:@"您购买失败，请重新尝试购买～"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];


                [alerView2 show];
                //                [alerView2 release];
            }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                //[self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
                [DejalBezelActivityView removeView];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction REceiptString:(NSString*)receiptString

{
    //   交易完成处理结果 验证凭证
    NSLog(@"%@",_storePrice);
    NSString *product = transaction.payment.productIdentifier;
    NSString *receipt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSLog(@"receipt%@",receipt);
    if ([product length] > 0) {
        logmessage;
        [self postHttp:receiptString];
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
        
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];


}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{

}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@" 交易恢复处理");

}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}


#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}


- (void)postHttp:(NSString *)receiptString
{logmessage;
    if (_storePrice) {

    NSLog(@"%@",_storePrice);
    UserModel * user = [UserModel sharedInstance];
    NSString *phoneNum = user.phoneNumber;

        NSLog(@"-----storePrice:%@",_storePrice);
//   payType Alipay:100 appstore:103

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:receiptString forKey:@"receipt"];
    [dic setObject:phoneNum forKey:@"mobileNo"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:_storePrice forKey:@"price"];
    [dic setObject:@"103" forKey:@"payType"];


    NSString *result = [URLUtil generateNormalizedString:dic];
    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];


    NSString * url = [NSString stringWithFormat:@"%@%@",ROOT_URL,PAY_INIT_ACTION];
//    NSURL * postServierURL = [NSURL URLWithString:url];
//    _asiRequest = [ASIFormDataRequest requestWithURL:postServierURL];
//    NSLog(@"_asiRequest-->%@",postServierURL);
//
//
//    //测试，先用的是38ID，后民要改成自己的ID；
//    [_asiRequest setPostValue:user.userID forKey:@"userID"];
//    [_asiRequest setPostValue:APP_ID forKey:@"app_id"];
//    [_asiRequest setPostValue:VERSIONS forKey:@"v"];
//    [_asiRequest setPostValue:phoneNum forKey:@"mobileNo"];
//    [_asiRequest setPostValue:@"1" forKey:@"src"];
//    [_asiRequest setPostValue:_storePrice forKey:@"price"];
//    //   payType Alipay:100 appstore:103
//    [_asiRequest setPostValue:receiptString forKey:@"receipt"];
//    [_asiRequest setPostValue:@"103" forKey:@"payType"];
//    [_asiRequest setPostValue:sig forKey:@"sig"];
        

        NSDictionary *paradic = @{
                              @"userID" : user.userID,
                              @"app_id" : APP_ID,
                              @"v" : VERSIONS,
                              @"mobileNo" : phoneNum,
                              @"src" : @"1",
                              @"price" : _storePrice,
                              @"receipt" : receiptString,
                              @"payType" : @"103",
                              @"sig" : sig,
                              };

        
        [NetWork postWithUrlString:url parameters:paradic success:^(id data) {

            NSDictionary * jsonDic =  [data objectFromJSONData];

            NSString * code = [jsonDic objectForKey:@"code"];
            NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];

            if (0 == [code intValue]) {
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"恭喜"
                                                                    message:@"您购买成功啦，录音币已存入你的账号，请注意查收"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];

                [alerView show];
            }else
            {
                [self alertWithMessage:codeInfo];
            }
            
            [DejalBezelActivityView removeView];

        } failure:^(NSError *error) {

            [DejalBezelActivityView removeView];
            NSLog(@"error --- %@",error);

        }];
        

//    [_asiRequest setDidFailSelector:@selector(requestAppstoreDeleteFileFail:)];
//    [_asiRequest setDidFinishSelector:@selector(requestAppstoreFileFinish:)];
//    [_asiRequest setDidReceiveDataSelector:@selector(requestAppstoreFileReceiveData:didReceiveData:)];
//
//
//    _asiRequest.delegate = self;
//    [_asiRequest setRequestMethod:@"POST"];
//    [_asiRequest startAsynchronous];
//
//        NSDictionary *d = _asiRequest.requestHeaders;
    
    }
}

//- (void)requestAppstoreFileReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    NSDictionary * jsonDic =  [data objectFromJSONData];
//
//    NSString * code = [jsonDic objectForKey:@"code"];
//    NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
//
//    if (0 == [code intValue]) {
//        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"恭喜"
//                                                            message:@"您购买成功啦，录音币已存入你的账号，请注意查收"
//                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
//
//        [alerView show];
//    }else
//    {
//        [self alertWithMessage:codeInfo];
//    }
//}


//-(void)requestAppstoreFileFinish:(ASIHTTPRequest *)request
//{
//    NSLog(@"-----------------------+++++++++++++++++++++++++++++++++++++request Finish");
//
//    NSLog(@"%@",request);
//
//    [DejalBezelActivityView removeView];
//
//}

//- (void)requestAppstoreDeleteFileFail:(ASIHTTPRequest *)request
//{
//    NSLog(@"request Failed");
//
//    NSLog(@"%@",request);
//
//}

- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
#endif
- (void)viewDidUnload {
    [self setBtn12:nil];
    [self setBtn50:nil];
    [self setBtn98:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)beginAlipayWithTradeNO:(NSString *)tradeNO productName:(NSString *)productName productDescription:(NSString *)productDescription amount:(CGFloat )amount
{

    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [self.productList objectAtIndex:indexPath.row];

    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */

    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2017103109643039";
    NSString *seller = @"csz@yuncuntianxia.com";
    NSString *privateKey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDCYrGEo6WUFpS+nlimgQuywmIBRkEbqD897h6dGHO6+eFO80V9//8U5zLW7gL/4uJNnFa7pqZ56LYn46KZAVsd9b/EQh5pTz7A01fe2IZbtPKTZX5f/1GmBM4PsfdlzELytFiuDS2nUgw6lY7Rs6ZVK2URGElJy89gBnapk5YPiWAx54lnkbwVycRNPVcfkAhBysbRUejRErFImseQ0sTXUxM6+52VjZkNfJP9Z2zZf0a7OUpzPvTldMnx3YE6mcj+rcP7piUfFbwu8Myk+Bkkfcea0a3XufYAMwOfaT5YVE+QupjWytqwOxL1dzuLSRQLOAnf1JS363vxP5smmsqjAgMBAAECggEAAp21aeWR6uZK5i3XX5ZJBATdsMqzQZ4IC9tSiia0GAYY5Ckd/E4frrZV1tKpM6xoA0dhW3EouGdLXEoR/CEqisKt7AQ/yIcKfynY+uTLGhzbTuSEyOH0xVk3NLrea35OQFnw/5ap0KCoDXnJzESwrmDBIXPEOLwHdHFh03JrCJZ4rP8EIhdkF5H6A8oPv3p+avFVQktZ4pB7i3uZE5HfpClCwgoHb+9C3tTu3t1ZvwrhRpaJzRcQdosXUX2ZfwjZeJ24WTfykaziSdEwL61QhSOub9/CEZWsOAF6FZSFClPBMiy/p3leYjfeHHOa4O9TsvUB+5y77QWHEYZsWHBMUQKBgQD4SxYfnTl7xn1Re5I+jf2nV5gvW35VU7KE1s9gKtwjp7sOin8PtNU72aMvO495MKBbKqkkFG5xCzfSek41LSBTjRxnSdbZK2mDMQ4CT6P0BgJ/ZacR1VQFtDDzSZ2VuiN0BAZKxV+xTTCJSTL8TWUdIy1e3kBL8hmQb/oBnzqirQKBgQDIa0Lc/Px6qUGKG16au+DGqmpC0Mmn1OyfZLEefzrG6ILahCPjzVxpXbO/X6zRS88ngq9iRQV4Wz0Bv0ZywxH7sahNVEN1RtfFRNvSyidjrmMGKOtaBfTMZjgGKOv8i2JWoseC1CtZG5EeMB9KHVKn4EpAA7FxeoOGxesUWCscjwKBgA0bybs5jcNfI1ad84ah8HZZRYuahPz0QkSJIsGtAZpQTKvj2/l0Tp2uS9M+jcCUNKMbiXqCKaKGORg/pMlh7Ib8uDcrytAEXrmyaU7t7XYAqzkWoM9sN9dlQABYLp2tChoh7EMeUIMH1DwrRSnU3DXBma+chEB+M6NQhh53zZyxAoGAYIBlHYsi9tzwldM/5jl4ra/4oltt/cXkeYs+TXTtlED4YMcnkNSdHo7jsc4bpFtgT6H5WNPrIlysL18uSKvsyMhuRW3BXYLS+kWBoyl7dd/OBnVFfX9Is/K0HyMtHdjvbM/MSQ5oIOvJIEQDjOg5mGPC3LfqhL18/zPlUVJyz7kCgYApO45PHkRehUEsuj/QvnfcmK3lIKJT+jAoFDfcCz/gDv0PbnKyewXbs4zxBjTLQZh71tpWixVxrIq9wzdBVP7zJTuNfnyw07mQcl9aSPsa+FTc9j8N0sPcAMXIBvFGQmy83aqViL+mpqy3PrXoLCmIgp3xs++Z5k5v83u8140N6g==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    order.notifyURL =  @"http://www.yuncuntianxia.com/charge/charge_payNotify_alipay"; //回调URL

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"phonerecorder";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA2"];

        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];

        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


@end


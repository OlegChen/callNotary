//
//  Recharge.h
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

typedef enum {
    kRechargeButtonEmpty = 0,
    kRechargeButton18 = 1,
    kRechargeButton68 = 18,
    kRechargeButton168 = 88,
    kRechargeButton388 = 188,
    kRechargeButtonNum
}kRechargeButtonClickType;

//payType Alipay:100 appstore:103

// 68、168、388 --》--》--》 18 、88、188

//定义金额
#define ProductID_IAP_Recharge_18 @"com.fengyz.notary.18"//$12    无用

#define ProductID_IAP_Recharge_45 @"purchaseRecordTel_18"//$45
#define ProductID_IAP_Recharge_60 @"purchaseRecordTel_88" //$60
#define ProductID_IAP_Recharge_108 @"purchaseRecordTel_188" //$108

//显示标题
#define ProductID_IAP_Recharge_TITLE_18 @"  12"
#define ProductID_IAP_Recharge_TITLE_45 @"  18"
#define ProductID_IAP_Recharge_TITLE_60 @"  88"
#define ProductID_IAP_Recharge_TITLE_108 @"  188"

@interface Recharge : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *_request;
    kRechargeButtonClickType _kRechargeButtonNumber;
    ASIFormDataRequest *_asiRequest;


@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}


@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;


@property (strong, nonatomic) IBOutlet UIButton *btn12;
@property (strong, nonatomic) IBOutlet UIButton *btn50;
@property (strong, nonatomic) IBOutlet UIButton *btn98;

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;


@property (strong,nonatomic)NSMutableData * jsonData;
@property (copy, nonatomic)     NSString *storePrice;
- (IBAction)btn12Click:(UIButton *)sender;
- (IBAction)btn50Click:(UIButton *)sender;
- (IBAction)btn98Click:(UIButton *)sender;
- (IBAction)btnRechargeClick:(UIButton *)sender;


- (void) requestProUpgradeProductData;
- (void) RequestProductData;
- (bool) CanMakePay;
- (void) buy:(int)type;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) PurchasedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;
- (void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent:(NSString *)product;
- (void) recordTransaction:(NSString *)product;


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end


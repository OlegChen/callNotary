//
//  About.h
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeeMsgModel.h"
#import "BasicViewController.h"

@interface UserCenter : UIViewController
<ASIHTTPRequestDelegate>
{
    FeeMsgModel *_feeMsg;
    ASIFormDataRequest *request;
    ASIFormDataRequest *signRequest;
    UIButton*leadBtn;
    //ASIFormDataRequest *_tipsRequest;
    ASIFormDataRequest *_shareRequest;
    ASIFormDataRequest * _fenXiangRequest;
    
    NSString *_shareText;
    NSString* _shareImageUrl;
    UIImage *_shareImage;

    
   // NSMutableArray *_msgArr;
    //int _noReadMsgCount;
    UIButton * btnNum;
    
    ASIFormDataRequest *_tipsRequest;
    NSMutableArray *_msgArr;
    
    int _noReadMsgCount;
    UIButton * btnNumMessage;
    
    NSMutableData *_jsonData;
    
}
- (IBAction)fangXiangShiJian:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *BackImage;
@property (strong, nonatomic) IBOutlet UIButton *FenXiangBtn;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *binNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *GNumberLaber;

@property (strong, nonatomic) IBOutlet UIProgressView *myProgressView;

- (IBAction)rechargeBtnClick:(UIButton *)sender;
- (IBAction)signBtnClick:(UIButton *)sender;

@end

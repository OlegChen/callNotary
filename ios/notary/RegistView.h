//
//  RegistView.h
//  notary
//
//  Created by 肖 喆 on 13-3-26.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistView : UIViewController<UITextFieldDelegate>
{
    UITextField * _txtNumber;
    UITextField * _txtVerifyNumber;
    UITextField * _txtPwd;
    UITextField * _txtAgainPwd;
    
    UIButton * _btnVerify;
    UIButton * _btnRegist;
    UIActivityIndicatorView * _indicatorView;
    
    UILabel * _labTimer;
    ASIFormDataRequest * _request;
    ASIFormDataRequest * _requestMessage;
    ASIFormDataRequest * _requestPhoneNumberVerify;
    
    NSString * _tmpNumber;
    NSTimer * timer;
}

@property (nonatomic, retain)NSString * tmpNumber;
@property (nonatomic, retain)IBOutlet UITextField * txtNumber;
@property (nonatomic, retain)IBOutlet UITextField * txtVerifyNumber;
@property (nonatomic, retain)IBOutlet UITextField * txtPwd;
@property (nonatomic, retain)IBOutlet UITextField * txtAgainPwd;
@property (nonatomic, retain)IBOutlet UIButton * btnVerify;
@property (nonatomic, retain)IBOutlet UIButton * btnRegist;
@property (nonatomic, retain)IBOutlet UILabel *  labTimer;


- (IBAction)btnVerifyClick:(id)sender;
- (IBAction)btnRegist:(id)sender;

@end

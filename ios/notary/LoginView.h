//
//  LoginView.h
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIButton * _btnLogin;
    UIButton * _btnMore;
    UIButton * _btnRegist;
    UITextField * _loginNumber;
    UITextField * _loginKeyWord;
    
    
    UIButton * _btnRemberPwd;
    UIButton * _btnAutoLogin;
    BOOL _isRemberPwd;
    BOOL _isAutoLogin;
    
    DejalActivityView * _indicatorView;
    NSUserDefaults * _userDefault;
    
    NSMutableData * _jsonData;
}

- (IBAction)guanwangButton:(id)sender;

@property (strong, nonatomic)IBOutlet UITextField * loginNumber;
@property (strong, nonatomic)IBOutlet UITextField * loginKeyWord;

@property (strong, nonatomic)IBOutlet UIButton * btnLogin;
@property (strong, nonatomic)IBOutlet UIButton * btnMore;
@property (strong, nonatomic)IBOutlet UIButton * btnRegist;
@property (strong, nonatomic)IBOutlet UIButton * btnRemberPwd;
@property (strong, nonatomic)IBOutlet UIButton * btnAutoLogin;
@property (strong, nonatomic) IBOutlet UIButton *rexianNum;

- (IBAction)btnRemberPwdClick:(id)sender;
- (IBAction)btnAutoLoginClick:(id)sender;
- (IBAction)rexianBtn:(id)sender;

- (IBAction)btnLoginClick:(id)sender;

- (IBAction)hiddenKedborad:(id)sender;

- (IBAction)btnMoreClick:(id)sender;

- (IBAction)btnRegistClick:(id)sender;

@end

//
//  ForgetPWDView.h
//  notary
//
//  Created by 肖 喆 on 13-4-28.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPWDView : UIViewController
{
  ASIFormDataRequest *  _requestMessage;
ASIFormDataRequest * _requestRestore;
}

@property (nonatomic, retain)IBOutlet UITextField * txtTelNumber;
@property (nonatomic, retain)IBOutlet UITextField * txtNumber;
@property (nonatomic, retain)IBOutlet UIButton * btnPwd;
@property (nonatomic, retain)IBOutlet UIButton * btnConfirm;
@property (nonatomic, retain)IBOutlet UILabel *  labTimer;

- (IBAction)btnPwdClick:(id)sender;
- (IBAction)btnbtnConfirm:(id)sender;
@end

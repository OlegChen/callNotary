//
//  ContactUs.h
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactUs : UIViewController<MFMailComposeViewControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSString *placeHoldText;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)sendBtnClick:(UIButton *)sender;
- (IBAction)callPhoneNumBtnClick:(UIButton *)sender;
- (IBAction)emailUsBtnClick:(UIButton *)sender;

@end

//
//  ChangePassNumber.h
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassNumber : UIViewController<UIAlertViewDelegate>
{
    UIActivityIndicatorView * _indicatorView;
}
@property (strong, nonatomic) IBOutlet UITextField *oldNum;
@property (strong, nonatomic) IBOutlet UITextField *nowNum;
@property (strong, nonatomic) IBOutlet UITextField *yesNowNum;
- (IBAction)changeNumBtnClick:(UIButton *)sender;
- (IBAction)notChangeBtnClick:(UIButton *)sender;



@end

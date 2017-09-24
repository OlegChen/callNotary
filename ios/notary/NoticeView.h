//
//  NoticeView.h
//  notary
//
//  Created by 肖 喆 on 13-9-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
@interface NoticeView : UIViewController
{
    BOOL isCheck;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIView *sureBgView;

@property (weak, nonatomic) IBOutlet UIButton *btnTrue;

- (IBAction)sure:(id)sender;
- (IBAction)makeSure:(UIButton *)sender;

@end

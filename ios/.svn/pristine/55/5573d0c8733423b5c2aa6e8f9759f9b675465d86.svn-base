//
//  CustomAlertView.h
//  notary
//
//  Created by 肖 喆 on 13-3-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIAlertView <UITextFieldDelegate>
{
    UITextField * _showTextField;
    NSString * _keyWord;
    
}
@property (nonatomic,strong) NSString * keyWord;
@property (nonatomic,strong) UITextField * showTextField;
@property int maxLength;

- (id)initWithAlertTitle:(NSString *)title;
- (NSString *)getKeyWord;

@end

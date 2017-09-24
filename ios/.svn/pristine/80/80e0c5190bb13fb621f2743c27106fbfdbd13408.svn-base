//
//  KeyboardView.h
//  notary
//
//  Created by 肖 喆 on 13-3-7.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYTextPopView.h"

@protocol KeyboardViewDelegate;

@interface KeyboardView : UIView<ZSYPopoverDelegata>
{

    id <KeyboardViewDelegate> _delegate;
    UITextField * _txtNumber;
    UIButton * _btn0;
    UIButton * _btn1;
    UIButton * _btn2;
    UIButton * _btn3;
    UIButton * _btn4;
    UIButton * _btn5;
    UIButton * _btn6;
    UIButton * _btn7;
    UIButton * _btn8;
    UIButton * _btn9;
    
    UIButton * _btnDelete;
    UIButton * _btnSharp;
    UIButton * _btnStar;
    UIButton * _btnKeyboard;
    UIButton * _btnAction;
    
    NSMutableString * _txtString;
}

@property id <KeyboardViewDelegate> delegate;

@property (strong,nonatomic) IBOutlet UIButton * btn0;
@property (strong,nonatomic) IBOutlet UIButton * btn1;
@property (strong,nonatomic) IBOutlet UIButton * btn2;
@property (strong,nonatomic) IBOutlet UIButton * btn3;
@property (strong,nonatomic) IBOutlet UIButton * btn4;
@property (strong,nonatomic) IBOutlet UIButton * btn5;
@property (strong,nonatomic) IBOutlet UIButton * btn6;
@property (strong,nonatomic) IBOutlet UIButton * btn7;
@property (strong,nonatomic) IBOutlet UIButton * btn8;
@property (strong,nonatomic) IBOutlet UIButton * btn9;

@property (strong,nonatomic) IBOutlet UIButton * btnDelete;
@property (strong,nonatomic) IBOutlet UIButton * btnSharp;
@property (strong,nonatomic) IBOutlet UIButton * btnStar;
@property (strong,nonatomic) IBOutlet UIButton * btnKeyboard;
@property (strong,nonatomic) IBOutlet UIButton * btnAction;

@property (strong,nonatomic) IBOutlet UITextField * txtNumber;

- (IBAction)numButtonClick:(UIButton *)sender;
- (IBAction)numDelete:(UIButton *)sender;
- (IBAction)numAction:(UIButton *)sender;
- (IBAction)keyboradAction:(UIButton *)sender;

@end


@protocol KeyboardViewDelegate <NSObject>

- (void)notificationKeyboard;
- (void)notificationKeyboardChangeNumber:(NSString *)number;

@end
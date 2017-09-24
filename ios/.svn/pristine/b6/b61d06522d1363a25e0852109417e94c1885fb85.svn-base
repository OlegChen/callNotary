//
//  CustomAlertView.m
//  notary
//
//  Created by 肖 喆 on 13-3-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAlertTitle:(NSString *)title
{
    
 self = [super initWithTitle:title
                        message:@"---blank---" // password field will go here
                       delegate:self
              cancelButtonTitle:@"取消"
              otherButtonTitles:@"确定", nil];
    
    if (self) {
        
      

        
    }
    return self;
}
- (void)show {
    //添加text
    
    // Textfield for the password
    // Position it over the message section of the alert
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(14, 45, 256, 25)];
    //    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"关键字";
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.returnKeyType = UIReturnKeyDone;
    // Pad out the left side of the view to properly inset the text
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 19)];
    passwordField.leftView = paddingView;
    
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    // Set delegate
    passwordField.delegate = self;
    
    // Set as property
    self.showTextField = passwordField;
    
    
    // Add to subview
    [self addSubview:_showTextField];

    
    // Show alert
    [super show];
    
    // present keyboard for text entry
    [_showTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    
}
- (NSString *)getKeyWord {
    
    return _showTextField.text;
}
-(void)layoutSubviews{
    //修改背景图片
      /*
     
     for (UIView *v in self.subviews) {
     if ([v isKindOfClass:[UIImageView class]]) {
     UIImageView *imageV = (UIImageView *)v;
     UIImage *image = [UIImage imageNamed:kAlertViewBackground];
     image = [[image stretchableImageWithLeftCapWidth:0 topCapHeight:kAlertViewBackgroundCapHeight] retain];
     [imageV setImage:image];
     }
     if ([v isKindOfClass:[UILabel class]]) {
     UILabel *label = (UILabel *)v;
     if ([label.text isEqualToString:self.title]) {
     label.font = [kAlertViewTitleFont retain];
     label.numberOfLines = 0;
     label.lineBreakMode = UILineBreakModeWordWrap;
     label.textColor = kAlertViewTitleTextColor;
     label.backgroundColor = [UIColor clearColor];
     label.textAlignment = UITextAlignmentCenter;
     label.shadowColor = kAlertViewTitleShadowColor;
     label.shadowOffset = kAlertViewTitleShadowOffset;
     }else{
     label.font = [kAlertViewMessageFont retain];
     label.numberOfLines = 0;
     label.lineBreakMode = UILineBreakModeWordWrap;
     label.textColor = kAlertViewMessageTextColor;
     label.backgroundColor = [UIColor clearColor];
     label.textAlignment = UITextAlignmentCenter;
     label.shadowColor = kAlertViewMessageShadowColor;
     label.shadowOffset = kAlertViewMessageShadowOffset;
     }
     }
     if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
     UIButton *button = (UIButton *)v;
     UIImage *image = nil;
     if (button.tag == 1) {
     image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", @"gray"]];
     }else{
     image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", @"black"]];
     }
     image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
     button.titleLabel.font = kAlertViewButtonFont;
     button.titleLabel.minimumFontSize = 10;
     button.titleLabel.textAlignment = UITextAlignmentCenter;
     button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
     button.backgroundColor = [UIColor clearColor];
     [button setBackgroundImage:image forState:UIControlStateNormal];
     [button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
     [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
     }
     }
     */
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([@"" isEqualToString:textField.text]) return NO;
    
    else {
     
        _keyWord = textField.text;
        return YES;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _keyWord = textField.text;

}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
//    if(strlen([textField.text UTF8String]) >= _maxLength && range.length != 1)
//        return NO;
//    
//    return YES;
    
    if (range.length >= _maxLength) {
        return NO;
    }
    return YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

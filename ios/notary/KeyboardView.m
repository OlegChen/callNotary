//
//  KeyboardView.m
//  notary
//
//  Created by 肖 喆 on 13-3-7.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//



#import "KeyboardView.h"
#import "CustomAlertView.h"
#import "CardCell.h"

#import "Call_Note_sqliteTool.h"

@implementation KeyboardView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _txtString = [[NSMutableString alloc]init];
    _txtNumber.userInteractionEnabled = NO;
    
    for (int i = 0; i < 6; i ++) {
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, (i < 1 ? i * 45 :((i - 1) * 55 + 45 )) + 0.5, [UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].scale);
        layer.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:layer];
        
    }
    
    for (int i = 0; i < 4; i ++) {
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(i * ([UIScreen mainScreen].bounds.size.width / 3.0), 45, 1/[UIScreen mainScreen].scale, self.bounds.size.height - 45);
        layer.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:layer];
        
    }
    
    
}

- (IBAction)numButtonClick:(UIButton *)sender
{

    UIButton * tmp = sender;
    [_txtString appendString:[NSString stringWithFormat:@"%ld",(long)tmp.tag]];
    _txtNumber.text = _txtString;
    
    if (_txtNumber.text.length == 0) return;
    
    [_delegate notificationKeyboardChangeNumber:_txtString];
}
- (IBAction)numDelete:(UIButton *)sender
{
    //截取之前
    if (_txtString.length <= 0) return;
    
    NSRange range = NSMakeRange(_txtString.length - 1, 1);
    [_txtString deleteCharactersInRange:range];
    _txtNumber.text = _txtString;
    
    
    //截取之后
    if (_txtString.length <= 0){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"show_call_note" object:self userInfo:nil];
        
        return;
    }else {
      [_delegate notificationKeyboardChangeNumber:_txtString];  
    }

}
#pragma mark - ZSYpopDelegate
-(void)popoView:(ZSYTextPopView *)popview content:(NSString *)content clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"popview---%ld",(long)popview.tag);
    NSLog(@"content---content:-%@",content);
    NSLog(@"content---clickedButtonAtIndex:%ld",(long)buttonIndex);
    
    if (popview.tag == 1 && buttonIndex == 1) {
        
//        CustomAlertView * alert = (CustomAlertView *)alertView;
//        NSString * keyword = [alert getKeyWord];
        
        NSString * regex = @"0[0-9]{2,3}";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:content];
        
        if (!isMatch) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入区号不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:@"" phoneNum:_txtString call_time:time];
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",CardCell.getTransferTel,content,_txtString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
    }
    
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                         message:@"hhfhfshfhsfhhfhsfhsfhshhjfhhdjhshjh"
//                                                        delegate:nil
//                                               cancelButtonTitle:@"确定"
//                                               otherButtonTitles:nil];
//    [alertView show];
    
}


- (IBAction)numAction:(UIButton *)sender
{
    
    if (_txtString == nil || [_txtString isEqualToString:@""]){
        
        return;
        
    }
//    if(_txtString.length < 5) {
//        return;
//    }
    else if ([_txtString hasPrefix:@"0"]) {
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:@"" phoneNum:_txtString call_time:time];
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",CardCell.getTransferTel,_txtString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
    else if (_txtString.length <=9){
        if (IOS7_OR_LATER) {
           ZSYTextPopView*CustomView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            CustomView.titleName.text = @"请输入区号";
            CustomView.maxLength=10;
            CustomView.tag=1;
            CustomView.myDelegate=self;
            [CustomView show];

        }else{
        
            CustomAlertView * alert = [[CustomAlertView alloc] initWithAlertTitle:@"请输入区号"];
            alert.delegate = self;
            alert.maxLength = 4;
            
            [alert show];
        }
       
    }
    else {
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:@"" phoneNum:_txtString call_time:time];
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",CardCell.getTransferTel,_txtString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
    

    /*
    //这种调用还能返回原应用
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:number];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:callWebview];
    [self.superview.superview addSubview:callWebview];
     */
}
- (IBAction)keyboradAction:(UIButton *)sender
{
    [_delegate notificationKeyboard];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == alertView.firstOtherButtonIndex) {
        
        
        
    }else {
        
        CustomAlertView * alert = (CustomAlertView *)alertView;
        NSString * keyword = [alert getKeyWord];
        
        NSString * regex = @"0[0-9]{2,3}";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:keyword];
        
        if (!isMatch) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入区号不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:@"" phoneNum:_txtString call_time:time];
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",CardCell.getTransferTel,keyword,_txtString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
    }
    
}


@end

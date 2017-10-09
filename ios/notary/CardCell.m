//
//  CardCell.m
//  notary
//
//  Created by 肖 喆 on 13-3-13.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "CardCell.h"
#import "CustomAlertView.h"

#import "Call_Note_sqliteTool.h"

@implementation CardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.but addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.butFull addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];

} 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    } 
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)popoView:(ZSYTextPopView *)popview content:(NSString *)content clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"popview---%ld",(long)popview.tag);
//    NSLog(@"content---content:-%@",content);
//    NSLog(@"content---clickedButtonAtIndex:%ld",(long)buttonIndex);
    
        
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
    [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.tel.text call_time:time];

    
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",CardCell.getTransferTel,content,self.tel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    
    
    
}
            
+(NSString*)getTransferTel{
    
    UserModel * user = [UserModel sharedInstance];
    NSString *transfer_tel= user.transfer_tel;
    if (transfer_tel!=nil&&![transfer_tel isEqualToString:@""]) {
        return transfer_tel;
    }
    return DEFAULT_NUMBER;
}

- (void)callTheNumber
{
//    if(self.tel.text.length < 5) {
//        return;
//    }
//    else
    if ([self.tel.text hasPrefix:@"0"]) {
        
    
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",CardCell.getTransferTel,[self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.tel.text call_time:time];
        
    }
    else if (self.tel.text.length <=9){
        
        if (IOS7_OR_LATER) {
            ZSYTextPopView*alertView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            alertView.titleName.text = @"请输入区号";
            alertView.maxLength=10;
            alertView.tag=1;
            alertView.myDelegate=self;
            [alertView show];
        }else{
            CustomAlertView * alert = [[CustomAlertView alloc] initWithAlertTitle:@"请输入区号"];
            alert.delegate = self;
            alert.maxLength = 4;
            
            [alert show];
        }
       
    }
    else{
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",CardCell.getTransferTel,[self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSLog(@"%@",CardCell.getTransferTel);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
        NSLog(@"%@",number);
        
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.tel.text call_time:time];
        

    }

    //(0[1-9]{2,3})
}
- (void)call
{
//    callAlertView  = [[UIAlertView alloc] initWithTitle:@"您的拨号会被录音" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [callAlertView show];
    [self callTheNumber];
}
//comment by liwzh 没有用到混淆
//- (void)call:(NSString *)tel
//{
//   if ([self.tel.text hasPrefix:@"0"]) {
//        
//        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",DEFAULT_NUMBER,tel];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
//    }
//    else if (self.tel.text.length >=5 && self.tel.text.length <=8){
//        
//        if (IOS7_OR_LATER) {
//            ZSYTextPopView*alertView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
//            alertView.titleName.text = @"请输入区号";
//            alertView.maxLength=10;
//            alertView.tag=1;
//            alertView.myDelegate=self;
//            [alertView show];
//        }else{
//            CustomAlertView * alert = [[CustomAlertView alloc] initWithAlertTitle:@"请输入区号"];
//            alert.delegate = self;
//            alert.maxLength = 4;
//            
//            [alert show];
//        }
//       
//    }
//    else if (self.tel.text.length >= 10) {
//        
//        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",DEFAULT_NUMBER,tel];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
//    }
//    
//}

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
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.tel.text call_time:time];

        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",CardCell.getTransferTel,keyword,self.tel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
}


- (void)setHeadImageName:(NSString *)headImageName{

    _headImageName = headImageName;
    
    [self.but setImage:[UIImage imageNamed:headImageName] forState:UIControlStateNormal];

}


@end

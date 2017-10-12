//
//  Call_note_Cell.m
//  notary
//
//  Created by he on 15/5/14.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Call_note_Cell.h"
#import "Call_Note_sqliteTool.h"

@implementation Call_note_Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)call_note_cell_click:(UIButton *)sender {
    
    [self callTheNumber];
}

- (void)callTheNumber
{
    //    if(self.tel.text.length < 5) {
    //        return;
    //    }
    //    else
    if ([self.phoneNum.text hasPrefix:@"0"]) {
        
        
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.phoneNum.text call_time:time];
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",Call_note_Cell.getTransferTel,self.phoneNum.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
    else if (self.phoneNum.text.length <=9){
        
//        if (IOS7_OR_LATER) {
            ZSYTextPopView*alertView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            alertView.titleName.text = @"请输入区号";
            alertView.maxLength=10;
            alertView.tag=1;
            alertView.myDelegate=self;
            [alertView show];
//        }else{
//            CustomAlertView * alert = [[CustomAlertView alloc] initWithAlertTitle:@"请输入区号"];
//            alert.delegate = self;
//            alert.maxLength = 4;
//            
//            [alert show];
//        }
        
    }
    else{
        
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",Call_note_Cell.getTransferTel,self.phoneNum.text];
        
       // NSString * number = [NSString stringWithFormat:@"tel://4008786688,,%@",self.phoneNum.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.phoneNum.text call_time:time];
        
        
        //NSLog(@"%@",self.phoneNum.text);
        
      
    }
    
    //(0[1-9]{2,3})
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
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name.text phoneNum:self.phoneNum.text call_time:time];
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",Call_note_Cell.getTransferTel,keyword,self.phoneNum.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
}



+(NSString*)getTransferTel{
    
    UserModel * user = [UserModel sharedInstance];
    NSString *transfer_tel= user.transfer_tel;
    if (transfer_tel!=nil&&![transfer_tel isEqualToString:@""]) {
        return transfer_tel;
    }
    return DEFAULT_NUMBER;
}

@end

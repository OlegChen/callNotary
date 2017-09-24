//
//  Call_note_Cell.h
//  notary
//
//  Created by he on 15/5/14.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Call_note_Cell : UITableViewCell<ZSYPopoverDelegata>
{
    UIAlertView *callAlertView;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *time;

- (IBAction)call_note_cell_click:(UIButton *)sender;

+(NSString*)getTransferTel;

@end

//
//  CardCell.h
//  notary
//
//  Created by 肖 喆 on 13-3-13.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYTextPopView.h"

@interface CardCell : UITableViewCell<ZSYPopoverDelegata>
{
    UIAlertView *callAlertView;
}

@property (nonatomic ,copy) NSString *headImageName;

 
@property(weak,nonatomic)IBOutlet UIButton * but;
@property(weak,nonatomic)IBOutlet UIButton * butFull;
@property(weak,nonatomic)IBOutlet UILabel * name;
@property(weak,nonatomic)IBOutlet UILabel * tel;



- (void)call;
- (void)call:(NSString *)tel;
+(NSString*)getTransferTel;
@end

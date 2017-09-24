//
//  MeTableViewCell.h
//  notary
//
//  Created by he on 15/4/26.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;


@property (weak, nonatomic) IBOutlet UIButton *badge;



@end

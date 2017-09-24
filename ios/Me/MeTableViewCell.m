//
//  MeTableViewCell.m
//  notary
//
//  Created by he on 15/4/26.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell

- (void)awakeFromNib {

    self.image.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.badge setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

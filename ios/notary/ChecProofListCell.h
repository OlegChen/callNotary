//
//  ChecProofListCell.h
//  notary
//
//  Created by 肖 喆 on 13-9-23.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChecProofListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labFileName;

@property (weak, nonatomic) IBOutlet UILabel * labFolderName;

@property (weak, nonatomic) IBOutlet UIImageView * imageIcon;

@property (weak, nonatomic) IBOutlet UIImageView * imageCheck;

@end

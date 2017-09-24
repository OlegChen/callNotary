//
//  MessageCenterCell.h
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *zeroLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

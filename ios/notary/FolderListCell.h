//
//  FolderListCell.h
//  notary
//
//  Created by wenbuji on 13-9-23.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *folderImage;
@property (strong, nonatomic) IBOutlet UILabel *folderName;
@property (strong, nonatomic) IBOutlet UIButton *folderPushBtn;


@end

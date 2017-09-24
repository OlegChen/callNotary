//
//  ListProofCell.h
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListProofCell : UITableViewCell
{

    
    
}
@property (nonatomic, weak)IBOutlet UILabel  * labName;
@property (nonatomic, weak)IBOutlet UILabel  * labSize;
@property (nonatomic, weak)IBOutlet UILabel  * labTime;
@property (nonatomic, weak)IBOutlet UILabel  * labMessage;
@property (nonatomic, weak)IBOutlet UIImageView * imageTitle;


@end

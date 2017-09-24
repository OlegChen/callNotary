//
//  SettingCell.m
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"11");
    }
    return self;
}

- (void)awakeFromNib
{
//    NSLog(@"fffff");
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.backgroundColor = [UIColor clearColor];
    [self.myImageView addSubview:_numLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{    
    [super setSelected:NO animated:NO];
}

@end

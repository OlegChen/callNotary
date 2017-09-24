//
//  DownloadCell.m
//  notary
//
//  Created by 肖 喆 on 13-4-12.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)changeDownLoadStatus:(UITableView *)tableView andDownLoadFile:(DownloadFile *)down delegate:(id <DownloadDelegate>)delegaete;
{
    
    
    if (_file.isDownLoading) {
        
        _file.isDownLoading = NO;
        _file.downStatus = ZIPFILE_DOWNLOAD_NO;
        
        [down cancel];
        
    }else {
        
        _file.isDownLoading = YES;
        _file.downStatus = ZIPFILE_DOWNLOADING;
        
        DownloadFile * newDown = [DownloadFile launchRequest:_file immediately:YES];
        newDown.myDelegate = delegaete;

    }
    
    [tableView reloadData];
}
- (void)showErrorMessage:(NSString *)messgae
{
    _file.isDownLoading = NO;
    _file.downStatus = ZIPFILE_DOWNLOAD_NO;
    self.labErrorMessage.text = messgae;
}
@end

//
//  DownloadCell.h
//  notary
//
//  Created by 肖 喆 on 13-4-12.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadHistory.h"

@interface DownloadCell : UITableViewCell
{
    UIProgressView * _progressView;
    UILabel * _labName;
    UILabel * _labSize;
    UILabel * _labDate;
    UILabel * _labMessage;
    UIImageView * _imageTitle;
    
    UILabel * _labErrorMessage;
    
    ASIHTTPRequest * _request;
    BOOL _isDownLoading;
    FileModel * _file;
}

@property (nonatomic, strong)IBOutlet UIProgressView * progressView;
@property (nonatomic, strong)IBOutlet UILabel * labName;
@property (nonatomic, strong)IBOutlet UILabel * labSize;
@property (nonatomic, strong)IBOutlet UILabel * labDate;
@property (nonatomic, strong)IBOutlet UILabel * labMessage;

@property (nonatomic, strong)IBOutlet UIImageView * imageTitle;
@property (nonatomic, strong)IBOutlet UILabel * labErrorMessage;


@property  BOOL isDownLoading;
@property (nonatomic, strong)ASIHTTPRequest * request;
@property (nonatomic, strong)FileModel * file;

- (void)changeDownLoadStatus:(UITableView *)tableView andDownLoadFile:(DownloadFile *)down delegate:(id <DownloadDelegate>)delegaete;
- (void)showErrorMessage:(NSString *)messgae;

@end

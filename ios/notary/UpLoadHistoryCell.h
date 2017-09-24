//
//  UpLoadHistoryCell.h
//  notary
//
//  Created by wenbuji on 13-3-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpLoadHistory.h"

@interface UpLoadHistoryCell : UITableViewCell
{
    FileModel * _file;
    AsyncSocket * _socket;
}

@property (nonatomic, strong)FileModel * file;
@property (nonatomic, strong)AsyncSocket * socket;


@property (nonatomic, strong)IBOutlet UILabel * labName;
@property (nonatomic, strong)IBOutlet UILabel * labSize;
@property (nonatomic, strong)IBOutlet UILabel * labDate;
@property (nonatomic, strong)IBOutlet UILabel * labMessage;
@property (nonatomic, strong)IBOutlet UILabel * labFinishMessage;
@property (nonatomic, strong)IBOutlet UIImageView * imageTitle;
@property (nonatomic, strong)IBOutlet UIProgressView * progressView;

- (void)changeUploadStatus:(UITableView *)tableView andUploadFile:(UpLoadContinue *)upload delegate:(id <UploadContinueDelegate>)delegate;

- (void)showErrorMessage:(NSString *)messgae;
@end

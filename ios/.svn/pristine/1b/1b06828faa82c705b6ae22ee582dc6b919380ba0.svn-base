//
//  UpLoadHistoryCell.m
//  notary
//
//  Created by wenbuji on 13-3-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UpLoadHistoryCell.h"
#import "UploadFile.h"


@implementation UpLoadHistoryCell



-(void)awakeFromNib {

}

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

    // Configure the view for the selected state
}
//- (IBAction)btnContinueClick:(id)sender
//{
//    UploadFile * upload = [UploadFile initWithFileModel:_file andDelegate:_uploadHistory];
//    [upload start];
//}
- (void)changeUploadStatus:(UITableView *)tableView andUploadFile:(UpLoadContinue *)upload delegate:(id <UploadContinueDelegate>)delegate
{
    if (_file.isDownLoading)
    {
        _file.isDownLoading = NO;
        _file.downStatus = ZIPFILE_DOWNLOAD_NO;
        
        [upload cancel];
        _progressView.progressTintColor = [UIColor grayColor];
        _labFinishMessage.text = @"等待上传";
//        cell.progress.progressTintColor = [UIColor grayColor];
    }
    else
    {
        _file.isDownLoading = YES;
        _file.downStatus = ZIPFILE_DOWNLOADING;
        
       UpLoadContinue * newUpload =  [UpLoadContinue lauchSocket:_file immediately:YES];
        newUpload.delegate = delegate;
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _labFinishMessage.text = @"文件上传中";
    }
    
    [tableView reloadData];
}
@end

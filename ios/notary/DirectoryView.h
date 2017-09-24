//
//  DirectoryView.h
//  notary
//
//  Created by 肖 喆 on 13-4-8.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadView.h"

@interface DirectoryView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _folderArray;
    UITableView * _contentView;
    UploadView * _controler;
    FileModel * _file;
    NSMutableData * _jsonData;
    ASIFormDataRequest * _request;
}
@property (strong, nonatomic) IBOutlet UITableView * contentView;
@property (strong, nonatomic) UploadView * controler;
@property (strong, nonatomic) FileModel * file;
@end

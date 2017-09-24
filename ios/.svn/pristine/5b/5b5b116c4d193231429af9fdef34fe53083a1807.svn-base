//
//  ChooseChildFolder.h
//  notary
//
//  Created by wenbuji on 13-9-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseChildFolder : UIViewController
{
    ASIFormDataRequest *request;
    ASIFormDataRequest *moveRequest;
    FileModel *_childFileModel;
    UploadView * _controler;

}
@property (weak, nonatomic) IBOutlet UITableView *contentVeiw;
@property (strong,nonatomic)NSMutableArray * contentArray;
@property (strong,nonatomic)NSMutableData * jsonData;

@property (strong, nonatomic) NSString *folderID;
@property (strong, nonatomic) NSString *folderName;
@property (strong, nonatomic) FileModel *childFileModel;
@property (strong, nonatomic) UploadView *controler;
@property (strong, nonatomic) FileModel *file;//要上传的文件

@end

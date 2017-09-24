//
//  FolderListView.h
//  notary
//
//  Created by 肖 喆 on 13-9-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderListView : UIViewController
{
    ASIFormDataRequest *request;
    ASIFormDataRequest *moveRequest;
}
@property (weak, nonatomic) IBOutlet UITableView *contentVeiw;
@property (strong,nonatomic)NSMutableArray * contentArray;
@property (strong,nonatomic)NSMutableData * jsonData;
@property (strong,nonatomic) FileModel *myFileModel;
@end

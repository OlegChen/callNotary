//
//  ChecProofListView.h
//  notary
//
//  Created by 肖 喆 on 13-9-23.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
@interface ChecProofListView : UIViewController<ZSYPopoverListDatasource, ZSYPopoverListDelegate,ZSYPopoverListViewDelegate,ZSYTextViewDelegate>
{
    ASIFormDataRequest * _request;
    int startIndex ;  //分页参数
    NSMutableArray * _fileIds;
    FolderModel * _parentFolder;
    ZSYPopoverListView *listView;
    NSArray*allDataArr;
   ZSYPopoverListView*listtView;
    NSString * message;
}

@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic)NSMutableData * jsonData;
@property (strong, nonatomic)NSMutableData * jsonData1;
@property (strong, nonatomic)NSMutableArray * contentArray;
@property (strong,nonatomic)NSMutableArray * fileIds;

@property (strong,nonatomic)FolderModel * rootFolder;
@property (strong,nonatomic)FolderModel * parentFolder;

@property (strong,nonatomic)ASIFormDataRequest * request;
@property (strong,nonatomic)ASIFormDataRequest * requestApplygz;

@property(nonatomic,retain)  ZSYPopoverListView *listView;
@property(nonatomic,retain)   NSArray*allDataArr;



@end

//
//  NotaryView.h
//  notary
//
//  Created by 肖 喆 on 13-5-20.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDNestedTableViewController.h"

@interface NotaryView : SDNestedTableViewController<SDGroupCellDelegate>
{
    ASIFormDataRequest * _requestRefresh;
    ASIFormDataRequest * _requestSubCells;
    ASIFormDataRequest * _requestApplygz;
    
    NSMutableData * _jsonFolderList;
    NSMutableData * _jsonSubCells;
    NSMutableArray * _folderArray;
    NSMutableDictionary * _subCells;
    NSMutableArray * _fileIds;
    
    BOOL _reloading;
}

@end


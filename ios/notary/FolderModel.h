//
//  FolderModel.h
//  notary
//
//  Created by 肖 喆 on 13-4-7.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    kDeleteFile = 0,
    kAddFile,
    
}FolderFileStatus;

@interface FolderModel : NSObject
{
    NSString * _folderID;
    NSString * _folderName;
    NSString * _dataNum;
    NSString * _type;
    NSString *_haschild;
    FolderFileStatus status;      //记录文件夹做了什么动作 删除文件 增加文件
}

@property (nonatomic, retain)NSString * folderID;
@property (nonatomic, retain)NSString * folderName;
@property (nonatomic, retain)NSString * dataNum;
@property (nonatomic, retain)NSString * type;
@property (nonatomic,  strong)NSString *haschild;

@end

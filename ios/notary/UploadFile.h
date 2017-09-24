//
//  UploadFile.h
//  notary
//
//  Created by 肖 喆 on 13-4-1.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "FileModel.h"

@protocol UploadFileDelegate;

@interface UploadFile : NSObject
{
    AsyncSocket  * _socket;
    FileModel * _model;
//    id <UploadFileDelegate> _delegate;
    BOOL _connectStatus;
    BOOL _isHiddenView;
    
    BOOL _isStart;      //判断是否调用stop函数用
    BOOL _isFirstUpload;
    
    NSString * _srcid;
}

@property (nonatomic, strong)NSString * srcid;
@property (nonatomic, strong)AsyncSocket  * socket;
@property (nonatomic, strong)FileModel * model;
@property (nonatomic,assign) id <UploadFileDelegate> delegate;
@property BOOL connectStatus;
@property BOOL isHiddenView;
+ (UploadFile *)initWithFileModel:(FileModel *)file andDelegate:(id <UploadFileDelegate>)delegate;
+ (id)sharedInstance;

- (void)cancel;
- (void)stop;
- (void)start;
- (void)startWith:(NSData *)data;
- (void)viewWillDisappear;
@end

@protocol UploadFileDelegate <NSObject>

- (void)notificationUploadStart;
- (void)notificationUploadPause;
- (void)notificationUploadFinished;
- (void)notificationUploadFailed:(NSError *)error;
- (void)notificationUploadProgress:(float)progress;

@end
//
//  UpLoadContinue.h
//  notary
//
//  Created by 肖 喆 on 13-5-14.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "UploadContinueDelegate.h"

@interface UpLoadContinue : NSObject
{
    AsyncSocket * _socket;
    FileModel * _file;
}

@property (nonatomic, retain)AsyncSocket * socket;
@property (nonatomic, retain)FileModel * file;
@property (nonatomic, assign)id<UploadContinueDelegate> delegate;

+ (UpLoadContinue *)lauchSocket:(FileModel *)file immediately:(BOOL)immediately;
- (void)cancel;

@end

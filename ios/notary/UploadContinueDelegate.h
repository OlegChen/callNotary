//
//  UploadContinueDelegate.h
//  notary
//
//  Created by 肖 喆 on 13-5-14.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@protocol UploadContinueDelegate <NSObject>

- (void)notificationUploadStart:(FileModel *)file;
- (void)notificationUploadPause:(FileModel *)file;
- (void)notificationUploadFinished:(FileModel *)file;
- (void)notificationUploadFailed:(NSError *)error FileModel:(FileModel *)file;
- (void)notificationUploadProgress:(float)progress FileModel:(FileModel *)file;

@end

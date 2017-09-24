//
//  DownloadDelegate.h
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@protocol DownloadDelegate <NSObject>


- (void)notificationStartDownload:(ASIHTTPRequest *)request;
- (void)notificationUpdateCellProgress:(ASIHTTPRequest *)request;
- (void)notificationFinish:(ASIHTTPRequest *)request;
- (void)notificationError:(ASIHTTPRequest *)request message:(NSString *)message;

@end

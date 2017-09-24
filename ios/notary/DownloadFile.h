//
//  DownloadFile.h
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadDelegate.h"

@interface DownloadFile : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASIHTTPRequest * _request;
   
}

@property (nonatomic, retain)ASIHTTPRequest * request;
@property (unsafe_unretained,assign) id <DownloadDelegate> myDelegate;
@property (strong,nonatomic)NSMutableData * jsonData;
//@property (nonatomic, retain) id <DownloadDelegate> myDelegate;

+ (DownloadFile *)launchRequest:(FileModel *)file immediately:(BOOL)immediately;
- (void)cancel;

@end

//
//  Preview.h
//  notary
//
//  Created by 肖 喆 on 13-4-25.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AES.h"
#import "FileModel.h"
#import "MWPhotoBrowser.h"

@protocol PreviewDelegate;

@interface Preview : NSObject<MWPhotoBrowserDelegate,AESDelegate>
{
    UIViewController * _controler;
    FileModel * _file;
    MPMoviePlayerViewController *_moviePlayerView;
    id <PreviewDelegate> _delegate;
    UIAlertView * _alertError;
    
    UIDocumentInteractionController * _docInteractionController;
}

- (id)initWithControler:(UIViewController *)controler andFileModel:(FileModel *)fileModel;

@property id <PreviewDelegate> delegate;
@property (nonatomic,strong) NSArray *photos;

- (void)initialize;
- (void)removeViewFromCurrentView;

@end

@protocol PreviewDelegate <NSObject>

- (void)notificationBack:(FileModel *)fileModel;

@end

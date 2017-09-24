//
//  PreviewView.h
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AES.h"
/*
    视频，图片，音频，预览
 */
@interface PreviewView : UIViewController<AESDelegate>
{
    FileModel * _file;
//    MPMoviePlayerController * player;
    MPMoviePlayerViewController *_moviePlayerView;
}

@property (nonatomic, strong)FileModel * file;
@property (nonatomic, strong) MPMoviePlayerViewController * moviePlayerView;

@end

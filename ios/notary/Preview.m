//
//  Preview.m
//  notary
//
//  Created by 肖 喆 on 13-4-25.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Preview.h"

#import "UpLoadHistory.h"
#import "ListProofView.h"
#import "DownLoadHistory.h"
#import "SearchView.h"

#import "TGRImageViewController.h"

@implementation Preview

- (id)initWithControler:(UIViewController *)controler andFileModel:(FileModel *)fileModel
{
    if (self = [super init]) {
        
        _controler = controler;
        _file = fileModel;
        
    }
    return self;
}
- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)initialize
{
    UserModel * user = [UserModel sharedInstance];
    AES * aes = nil;
    //扩展明是不加.的 
    NSString * extendName = [FileModel getExtendName:_file.name];
    if (_file.type == kVideoFile) {//视频
        
        aes =  [[AES alloc] initWithId:user.userID secretKey:user.secretKey fid:_file.serverFileId extendName:extendName fPath:_file.targetName];
        aes.delegate = self;
        
        if ([aes isDecrypted]) {
            
            [self handleVideo];
            
        }else {
            [aes decrypt];
        }
          
    }else if (_file.type == kPhotoFile){//图片
        
        aes =  [[AES alloc] initWithId:user.userID secretKey:user.secretKey fid:_file.serverFileId extendName:extendName fPath:_file.targetName];
        aes.delegate = self;
        
        if ([aes isDecrypted]) {
            
            [self handlePhoto];
            
        }else {
            [aes decrypt];
        }
        
    }else if (_file.type == kVoiceFile){//音频
        
        aes =  [[AES alloc] initWithId:user.userID secretKey:user.secretKey fid:_file.serverFileId extendName:extendName fPath:_file.targetName];
        aes.delegate = self;
        
        if ([aes isDecrypted]) {
            
            [self handleVoice];
            
        }else {
            [aes decrypt];
        }
        
    }
    else {
        
        aes =  [[AES alloc] initWithId:user.userID secretKey:user.secretKey fid:_file.serverFileId extendName:extendName fPath:_file.targetName];
        aes.delegate = self;
        
        if ([aes isDecrypted]) {
            
            [self handleOtherFile];
            
        }else {
            
            [aes decrypt];
            
        }

        
    }
}

- (void)handleVideo
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:_controler name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_controler selector: @selector(playingDone:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    NSLog(@"----_file.targetName:%@",_file.targetName);
    NSURL * url = [NSURL fileURLWithPath:_file.targetName];

    logmessage;
    debugLog([url absoluteString]);
    
    _moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    //这个属性不设置，播放没有声音
    _moviePlayerView.moviePlayer.useApplicationAudioSession = NO;
    [_moviePlayerView.moviePlayer prepareToPlay];
    [_moviePlayerView.moviePlayer play];
    
    [_controler presentMoviePlayerViewControllerAnimated:_moviePlayerView];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:_moviePlayerView.view];
}
- (void)handleOtherFile
{
   
    if ([_controler isKindOfClass:[ListProofView class]]){
        ListProofView * listview = (ListProofView *)_controler;
        [listview handleOtherFile:_file];
    }
    else if ([_controler isKindOfClass:[SearchView class]])
    {
        SearchView * listview = (SearchView *)_controler;
        [listview handleOtherFile:_file];
    }
    else if ([_controler isKindOfClass:[DownLoadHistory class]])
    {
        DownLoadHistory * listview = (DownLoadHistory *)_controler;
        [listview handleOtherFile:_file];
    }

}
- (void)handleVoice
{
    NSURL * url = [NSURL fileURLWithPath:_file.targetName];
    _moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    //这个属性不设置，播放没有声音
    _moviePlayerView.moviePlayer.useApplicationAudioSession = NO;
    [_moviePlayerView.moviePlayer prepareToPlay];
    [_moviePlayerView.moviePlayer play];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:_moviePlayerView.view];
    [_controler presentMoviePlayerViewControllerAnimated:_moviePlayerView];
}
- (void)handlePhoto
{
    logmessage;
    if (IOS7_OR_LATER) {
        NSData *targetData=[NSData dataWithContentsOfFile:_file.targetName];
    

        UIImage *image2=[UIImage imageWithData:targetData];
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:image2];
        UINavigationController * userCenterNav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [userCenterNav.navigationBar setBarStyle:UIBarStyleBlack];
        [userCenterNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        
       [_controler presentViewController:userCenterNav animated:YES completion:nil];

        
    }else{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    NSLog(@"------路径:%@",_file.targetName);
   
    photo = [MWPhoto photoWithFilePath:_file.targetName];
    [photos addObject:photo];
    self.photos = photos;
  
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:browser];
    [_controler presentViewController:na animated:YES completion:nil];
    }
     //[_controler presentViewController:na animated:YES completion:nil];
}

#pragma mark MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

#pragma mark AESDelegate
//解密成功
- (void)notificationDecryptSuccess:(AES *)aes
{
    logmessage;
    if (_file.type == kVideoFile) {//视频
        [self handleVideo];
        
    }else if (_file.type == kPhotoFile){//图片
        
        [self handlePhoto];
        
    }else if (_file.type == kVoiceFile){//图片
        
        [self handleVoice];
        
    }
    else { //ios 原生不支持的文件类型
        
        [self handleOtherFile];
        
        //使用其他打开
    }
    
}

//解密失败
- (void)notificationDecryptError:(AES *)aes
{
    logmessage;
    if (_delegate && [_delegate respondsToSelector:@selector(notificationBack:)]) {
        [_delegate notificationBack:_file];
    }
   // [self alertErrorMessage:@"该文件下载数据不完整,请在“下载记录”中删除该文件后重新下载"];
}

- (void) alertErrorMessage:(NSString *)msg
{
    _alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定",nil];

    [_alertError show];
}
#pragma UIDocumentInteractionControllerDelegate methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return _controler;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller

{
    
    return _controler.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller

{
    
    return _controler.view.frame;
    
}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
{
    
    
}
@end

//
//  PreviewView.m
//  notary
//
//  Created by 肖 喆 on 13-4-11.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "PreviewView.h"
#import "AppDelegate.h"
#import "TGRImageViewController.h"

@interface PreviewView ()
- (void)handleVideo;
- (void)handleVoice;
- (void)handlePhoto;
@end

@implementation PreviewView

- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) hiddenTab:YES];
}


- (void)makeNav
{
    self.title = @"资料预览";
    self.navigationItem.hidesBackButton = YES;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40.0f, 0.0f, 50.0f, 25.0f);
    [btn setImage:[UIImage imageNamed:@"return.png" ]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) playingDone:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];

    switch ([[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue]) {
        case MPMovieFinishReasonUserExited:
            NSLog(@"用户点击完成");
            [_moviePlayerView.view removeFromSuperview];
            [self back];
            break;
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"自动播放完成");
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"播放出错");
            [self  alertWithMessage:@"播放失败,文件出错"];
            break;
        default:
            break;
    }
}


-(void)onClickImage{
    //点击操作内容
    logmessage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
// ---------------------播放完成的时候通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playingDone:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    [self makeNav];
    
    UserModel * user = [UserModel sharedInstance];
    
    AES * aes = nil;
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
        
    }else {//音频
        
        aes =  [[AES alloc] initWithId:user.userID secretKey:user.secretKey fid:_file.serverFileId extendName:extendName fPath:_file.targetName];
        aes.delegate = self;
        
        if ([aes isDecrypted]) {
            
            [self handleVoice];
            
        }else {
            [aes decrypt];
        }
        
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleVideo
{
    NSURL * url = [NSURL fileURLWithPath:_file.targetName];
    
    logmessage;
    debugLog([url absoluteString]);
    
    _moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //        [_moviePlayerView.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    _moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    //这个属性不设置，播放没有声音
    _moviePlayerView.moviePlayer.useApplicationAudioSession = NO;
    [_moviePlayerView.moviePlayer prepareToPlay];
    [_moviePlayerView.moviePlayer play];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_moviePlayerView.view];
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
    [[[UIApplication sharedApplication] keyWindow] addSubview:_moviePlayerView.view];

}
- (void)handlePhoto
{
    logmessage;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44)];
    image.backgroundColor = [UIColor whiteColor];
    NSLog(@"_file.targetName:%@",_file.targetName);
    image.image = [UIImage imageWithContentsOfFile:_file.targetName];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.userInteractionEnabled = YES;
    image.multipleTouchEnabled = YES;
    image.exclusiveTouch = YES;
    //添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [image addGestureRecognizer:singleTap];
    
    
    [self.view addSubview:image];
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
        
//        [self handleVoice];
        //使用其他打开
    }

}

//解密失败
- (void)notificationDecryptError:(AES *)aes
{
    logmessage;
}
@end

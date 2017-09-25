//
//  SoundrecordViewController.m
//  notary
//
//  Created by 肖 喆 on 14-12-22.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "SoundrecordViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadView.h"
#import "NSData+Extension.h"
#import "UserModel.h"
@interface SoundrecordViewController ()<AVAudioPlayerDelegate,UIAlertViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    UILabel *messLab;
    AVAudioPlayer *audioPlayer;
    NSString *s_AudioName;
    UIView *bottomV;
    UISlider * progressView;
    UIView *mainV;
    UIView *midView;
    float currentTime;
    NSTimer *timer;
    NSString * totalTime;
    UIButton *pauseBtn;
    float currentRecordTime;
    BOOL isRecording;
    UIButton *recordBtn;
    UIButton *stopBtn;
    UIButton *recordpauseBtn;
    NSTimer *_timer;
    int m ;
    UILabel *Hlab;
    UILabel *Mlab;
    UILabel *Slab;
    UILabel *nameLab;
    BOOL isPause;
    NSMutableDictionary *fileDic;
    NSMutableArray *fileNameArr;
}
@end
@implementation SoundrecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    fileDic = [[NSMutableDictionary alloc] init];
    fileNameArr = [NSMutableArray array];
    UserModel *user = [UserModel sharedInstance];
    NSString *namePlistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmxName.plist",user.userID]];
    NSString *plistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmx.plist",user.userID]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:namePlistPath];
    NSLog(@"%@---%@",dic,arr);
    if (dic != nil&& arr !=nil){
        fileDic = dic;
        fileNameArr = arr;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"现场录音";
    self.navigationController.navigationBarHidden = NO;
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    isRecording = NO;
    [app hiddenTab:YES];
    m = 0;
    //添加时间进度
    UIImageView *timeImg = [[UIImageView alloc] init];
    timeImg.image = [UIImage imageNamed:@"bg_recordtime"];
    CGFloat timeH = IS_IPHONE_5 ? 40 :30;
    timeImg.frame = CGRectMake(30,timeH, 260, 70);
    [self.view addSubview:timeImg];
    
    //添加时间
    for (int i = 0;i<3;i++){
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.frame = CGRectMake(10+(i*87), 10, 70, 50);
        timeLab.tag = i;
        timeLab.text = @"00";
        timeLab.font = [UIFont boldSystemFontOfSize:28];
        timeLab.textAlignment = NSTextAlignmentCenter;
        [timeImg addSubview:timeLab];
        if (timeLab.tag == 0){
            Hlab = timeLab;
        }else if (timeLab.tag ==1){
            Mlab = timeLab;
        } else if (timeLab.tag == 2){
            Slab = timeLab;
        }
    }

     [self animation];
    [self addControl];
 }

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)back
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
    
    //结束录音
    [self.recorder stop];
    self.recorder=nil;
    [_audioAnimation stopAnimating];
    
    //清除文件
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:[self documentPathWith:self.fileName]]){
        [filemanager removeItemAtPath:[self documentPathWith:self.fileName] error:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)handleBackButtonClick:(UIButton *)btn
{
    [audioPlayer stop];
    [timer invalidate];
    timer = nil;
    //关闭时钟
    if (_timer) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在进行录音操作，返回将丢失当前录音数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)animation
{
    NSMutableArray *ImgArr = [NSMutableArray array];
    _audioAnimation = [[UIImageView alloc] init];
    CGFloat audioH = IS_IPHONE_5 ? 160 : 130;
    _audioAnimation.frame = CGRectMake(59,audioH, 202, 131);
    [self.view addSubview:_audioAnimation];
        for (int i = 1; i < 11; i++){
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ani_record0%d",i]];
            if (i == 10){
            image = [UIImage imageNamed:@"ani_record10"];
            }
            [ImgArr addObject:image];
        }
    _audioAnimation.image = [UIImage imageNamed:@"ani_record01"];
    _audioAnimation.animationImages = ImgArr;
    _audioAnimation.animationRepeatCount = 0;
    _audioAnimation.animationDuration = 1.0;
}
-(void)addControl
{
    for (int i =0;i< 3;i++){
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        CGFloat btnH = IS_IPHONE_5 ? 315 :280;
        btn.frame = CGRectMake(72.5 +(i*65),btnH, 45, 45);
        if (i == 0){
            stopBtn = btn;
             [btn setImage:[UIImage imageNamed:@"btn_record_stop"] forState:UIControlStateNormal];
        } else if (i == 1){
            recordBtn = btn;
             [btn setImage:[UIImage imageNamed:@"btn_record_record"] forState:UIControlStateNormal];
        } else if (i == 2){
            recordpauseBtn = btn;
            [btn setImage:[UIImage imageNamed:@"btn_record_pause"] forState:UIControlStateNormal];
         }
        [btn addTarget:self action:@selector(recordEvent:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:btn];
    }
    
    messLab = [[UILabel alloc] init];
    CGFloat labH = IS_IPHONE_5 ? 400 : 340;
    messLab.frame = CGRectMake(75,labH, 202, 30);
    messLab.textColor = [UIColor blackColor];
    messLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:messLab];
    
    bottomV = [[UIView alloc] init];
    CGFloat bottomY = IS_IPHONE_5 ? 568 :480;
    bottomV.frame = CGRectMake(0, bottomY-64, 320, 50);
    bottomV.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    [self.view addSubview:bottomV];
    
    UIView *midLine = [[UIView alloc] init];
    midLine.frame = CGRectMake(160, 0, 1, 50);
    midLine.backgroundColor = [URLUtil colorWithHexString:@"#eeeeee"];
    [bottomV addSubview:midLine];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.frame = CGRectMake(0, 0,320, 1);
    topLine.backgroundColor = [URLUtil colorWithHexString:@"#eeeeee"];
    [bottomV addSubview:topLine];
    
    UIButton *playBtn = [[UIButton alloc] init];
    playBtn.frame = CGRectMake(40, 10, 80, 30);
   [playBtn setTitleColor:[URLUtil colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
    [bottomV addSubview:playBtn];
    
    UIButton *uploadBtn = [[UIButton alloc] init];
    uploadBtn.frame = CGRectMake(200, 10, 80, 30);
    [uploadBtn setTitleColor:[URLUtil colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchDown];
    [bottomV addSubview:uploadBtn];
    
    //添加遮盖
    mainV = [[UIView alloc] init];
    mainV.frame = self.view.frame;
    mainV.alpha = 0.8;
    mainV.hidden = YES;
    [mainV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
    mainV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:mainV];
    
    midView = [[UIView alloc] init];
    CGFloat midH = IS_IPHONE_5 ? 150:120;
    midView.frame = CGRectMake(20,midH, 280, 130);
    midView.alpha = 1.0;
    midView.hidden = YES;
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"播放录音";
    lab.frame = CGRectMake(10, 10, 120, 20);
    [midView addSubview:lab];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.frame = CGRectMake(0, 40, 280, 1);
    lineV.backgroundColor = [URLUtil colorWithHexString:@"#eeeeee"];
    [midView addSubview:lineV];
    
    progressView = [[UISlider alloc] init];
    progressView.frame = CGRectMake(10, 55, 250, 30);
    [progressView setMinimumValue:0.0f];
    [progressView setMaximumValue:1.0f];
    [progressView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [progressView setContinuous:NO];
    progressView.minimumTrackTintColor = [UIColor colorWithRed:224.0/255 green:38.0/255 blue:0/255 alpha:1.0];
    [progressView setThumbImage:[UIImage imageNamed:@"bg_play_point"] forState:UIControlStateNormal];
     [midView addSubview:progressView];
    
    nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake(10, 100, 200, 20);
    nameLab.font = [UIFont systemFontOfSize:12];
    [midView addSubview:nameLab];
    
    pauseBtn = [[UIButton alloc] init];
    pauseBtn.frame = CGRectMake(220, 90, 30, 30);
    [pauseBtn addTarget:self action:@selector(btn_PlayAudio_Click:) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:pauseBtn];

}
//处理播放中断
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
//    NSLog(@"%f",player.currentTime);
    [player play];
}
//处理录音中断
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"开始中断");
    [_timer invalidate];
    _timer = nil;
    [_audioAnimation stopAnimating];
    [self.recorder stop];
    [self saveInfomationToPlistFile];
    isRecording = NO;
    FileModel *folder = [[FileModel alloc] init];
    folder.folderName = @"本地文件";
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeUploadFileSuccess object:folder];
}
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
     NSLog(@"结束中断,继续程序运行");
//    NSLog(@"%f",self.recorder.currentTime);
    //添加时钟
    if ([_timer isValid]) {
        
    }
    else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    }
    [_audioAnimation startAnimating];
    [self recordSound];
    isRecording = YES;
    isPause =   NO;
    m = 0;
}
-(void)sliderValueChange:(UISlider *)sender
{
    if (pauseBtn.isSelected){
    [audioPlayer pause];
    audioPlayer.currentTime = sender.value *[totalTime intValue];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    }
}
-(void)touch
{
    mainV.hidden = YES;
    midView.hidden = YES;
    [audioPlayer pause];
    [timer invalidate];
    timer = nil;
}
- (NSString *)GetNameWithTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *locationString = [df stringFromDate:nowDate];
    NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
}
-(void)play
{
    mainV.hidden = NO;
    midView.hidden = NO;
    nameLab.text = [NSString stringWithFormat:@"文件名：%@.wav",[self GetNameWithTime]];
    if (audioPlayer != nil){
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
        selector:@selector(playProgress) userInfo:nil repeats:YES];
    }
    [pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_file_pause"] forState:UIControlStateNormal];
    pauseBtn.selected = YES;
}
-(void)btn_PlayAudio_Click:(UIButton *)btn
{
    if (btn.selected){
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_file_play"] forState:UIControlStateNormal];
        
        [audioPlayer pause];
        [timer invalidate];
        timer = nil;
        btn.selected = NO;
        currentTime = audioPlayer.currentTime;

    } else {
                btn.selected = YES;
                if(audioPlayer != nil)
                {
                    
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_file_pause"] forState:UIControlStateNormal];
                    
                    //准备播放
        [audioPlayer prepareToPlay];
                    //播放
        if (currentTime){
                        NSLog(@"%f",currentTime);
                        audioPlayer.currentTime = currentTime;
                        [audioPlayer play];
                        currentTime = 0;
                    } else {
                        [audioPlayer play];
                    }
                }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
            selector:@selector(playProgress) userInfo:nil repeats:YES];

            }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    [pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_file_play"] forState:UIControlStateNormal];
    [timer invalidate];
    timer = nil;
    progressView.value = 1.0;
    pauseBtn.selected = NO;

}
- (void)playProgress
{
     //通过音频播放时长的百分比,给progressview进行赋值;
    if ([totalTime intValue] > 0){
        float value = audioPlayer.currentTime/[totalTime floatValue];
        [progressView setValue:value];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //确认返回
    if (alertView.tag == 10){
        if (buttonIndex == 0){
            
        }else if (buttonIndex == 1){
            [self back];
        }
        
      //上传
    }else {
    if (buttonIndex == 0){
        
    }else if(buttonIndex == 1) {
        [self upload];
    }
     }
}
-(void)uploadData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"免费赠送20M空间,超出部分5录音币/M" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:@"确定上传", nil];
    alert.tag = 20;
    [alert show];
}
-(void)upload
{
    FileModel *model = [[FileModel alloc] init];
    model.actionType = kUploadFile;
    model.path = [NSURL fileURLWithPath:[self documentPathWith:self.fileName]];
    NSLog(@"%@",model.path);
    model.type = kVoiceFile;
    model.targetName = [self documentPathWith:self.fileName];
    model.image = [UIImage imageNamed:@"icon_upload"];
    model.name = self.fileName;
    NSData *data = nil;
    data = [NSData dataWithContentsOfFile:[self documentPathWith:self.fileName]];
    model.md5 = [data MD5String];
    model.size = [NSString stringWithFormat:@"%d",data.length];
    data = nil;
    UploadView *upload = [[UploadView alloc] initWithNibName:[NSString stringWithFormat:@"UploadView%@",IS_IPHONE_5?@"-ip5":@""] bundle:nil];
    upload.model = model;
    [self.navigationController pushViewController:upload animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSMutableAttributedString *)changeStringColorWithTextString:(NSString *)textstr MyStr:(NSString *)mystr Log:(int)log
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textstr];
    UIColor *red = [UIColor blueColor];
    [attrString addAttribute:NSForegroundColorAttributeName value:red range:NSMakeRange(log,mystr.length)];
    return attrString;
}
-(void)saveInfomationToPlistFile
{
    UserModel *user = [UserModel sharedInstance];
    NSString *namePlistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmxName.plist",user.userID]];
    [fileNameArr addObject:self.fileName];
    [fileNameArr writeToFile:namePlistPath atomically:YES];
    
    NSString *plistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmx.plist",user.userID]];
    NSMutableDictionary *doc = [NSMutableDictionary dictionary];
    [doc setObject:[NSString stringWithFormat:@"%@",self.fileName] forKey:self.fileName];
    [doc setObject:@"未上传" forKey:@"uploadState"];
    [fileDic setValue:doc forKey:self.fileName];
    [fileDic writeToFile:plistPath atomically:YES];
}
-(void)recordEvent:(UIButton *)btn
{
    if (btn.tag == 0){
        if (isRecording && !isPause){
        //录音停止与初始化播放器
        [self.recorder stop];
        self.recorder=nil;
        isRecording = NO;
        [self saveAudio];
    //存储本地文件信息到plist文件 及存储每个文件的名字到plist
        [self saveInfomationToPlistFile];
        // 动画暂停
        [_audioAnimation stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat bottomY = IS_IPHONE_5 ? 568 :480;
            bottomV.frame = CGRectMake(0, bottomY-40-64, 320, 40);
        }];
        //录音按钮变灰
         [recordBtn setImage:[UIImage imageNamed:@"btn_record_record"] forState:UIControlStateNormal];
        //停止按钮变亮
        [btn setImage:[UIImage imageNamed:@"btn_record_stop_highlight"] forState:UIControlStateNormal];
            
            //时间时钟停止
            if (_timer) {
                
                if ([_timer isValid]) {
                    [_timer invalidate];
                }
            }
            //必须要有这一步操作，不然会报错，指针不用的时候就让他置为空
            _timer = nil;
            m = 0;
            messLab.hidden = NO;
            NSString *text = @"文件已保存在本地录音文件夹中";
            messLab.attributedText = [self changeStringColorWithTextString:text MyStr:@"本地录音文件夹" Log:6];
            
            //发出通知修改图标
            FileModel *folder = [[FileModel alloc] init];
            folder.folderName = @"本地文件";
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeUploadFileSuccess object:folder];
        }
        
    } else if(btn.tag == 1){
        [_audioAnimation startAnimating];
        [self recordSound];
        isRecording = YES;
        isPause = NO;
        messLab.text = @"为保证录音质量，请靠近声源";
         [UIView animateWithDuration:0.3 animations:^{
            CGFloat bottomY = IS_IPHONE_5 ? 568 :480;
            bottomV.frame = CGRectMake(0, bottomY-64, 320, 40);
         
        }];
        //录音按钮变亮
        [btn setImage:[UIImage imageNamed:@"btn_record_record_highlight"] forState:UIControlStateNormal];
        //暂停按钮变灰
         [recordpauseBtn setImage:[UIImage imageNamed:@"btn_record_pause"] forState:UIControlStateNormal];
        //停止按钮变灰
         [stopBtn setImage:[UIImage imageNamed:@"btn_record_stop"] forState:UIControlStateNormal];
        //添加时钟
        if ([_timer isValid]) {
            
        }
        else{
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
        }

       //提示Lab
     
        
    } else if(btn.tag == 2){
        if (isRecording){
         [_audioAnimation stopAnimating];
        [self pauseRecord];
        isPause = YES;
        //暂停按钮变亮
        [btn setImage:[UIImage imageNamed:@"btn_record_pause_highlight"] forState:UIControlStateNormal];

        //录音按钮变灰
         [recordBtn setImage:[UIImage imageNamed:@"btn_record_record"] forState:UIControlStateNormal];
            
            //时间时钟停止
            if (_timer) {
                
                if ([_timer isValid]) {
                    [_timer invalidate];
                }
            }
            //必须要有这一步操作，不然会报错，指针不用的时候就让他置为空
            _timer = nil;
         
        }
        
    }
}
-(void)count:(NSTimer *)_timer
{
    m++;
    if (m == 3){
        messLab.hidden = YES;
    }
     if (m/60 > 0){
         if (m/60 < 10){
        Mlab.text = [NSString stringWithFormat:@"0%d",m/60];
         } else {
        Mlab.text = [NSString stringWithFormat:@"%d",m/60];
         }
    }
    if (m/3600 > 0){
        if (m/3600 < 10){
        Hlab.text = [NSString stringWithFormat:@"0%d",m/3600];
        }else {
        Hlab.text = [NSString stringWithFormat:@"%d",m/3600];
        }
    }
    if (m%60 == 0){
        Slab.text = @"00";
    } else if (m%60 < 10) {
        Slab.text = [NSString stringWithFormat:@"0%d",m%60];
    } else {
        Slab.text = [NSString stringWithFormat:@"%d",m%60];
    }
     NSLog(@"%d",m);
 }

-(void)recordSound
{
    if (isRecording){
        [self.recorder recordAtTime:currentRecordTime];
     } else {
         Mlab.text = @"00";
         Hlab.text = @"00";
         Slab.text = @"00";
         NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                 
                                 [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                 
                                 AVFormatIDKey,
                                 
                                 [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                 
                                 [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                 
                                 [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                 
                                 [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                 
                                 [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                 
                                 nil];
     [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.fileName = [NSString stringWithFormat:@"%@.wav",[self GetNameWithTime]];
      
    NSString *filePath = [self documentPathWith:self.fileName];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSLog(@"%@>>>>>>>>>>%@", fileUrl,self.fileName);
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc] initWithURL:fileUrl settings:settings error:&error];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
    [self.recorder record];
    }
 }
-(void)saveAudio
{
    NSString *filePath=[self documentPathWith:self.fileName];
    debugLog(filePath);
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
 
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    //获得音频文件时间长度
    audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    audioPlayer.volume=8;
    audioPlayer.delegate = self;
    double timeSpan = [audioPlayer duration];
    totalTime = [NSString stringWithFormat:@"%f",timeSpan];
    
 }
-(void)pauseRecord
{
    [self.recorder pause];
    currentRecordTime = self.recorder.currentTime;
}

-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:fileName];
}
@end
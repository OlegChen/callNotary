//
//  SaveView.m
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import "SaveView.h"
#import "AddressView.h"
#import "AppDelegate.h"
#import "FileUploadView.h"
#import "UploadView.h"
#import "NSData+Extension.h"
#import "WSCoachMarksView.h"
#import "FaroeseView.h"
#import "UserInfoView.h"
#import "NewProofapplyView.h"
#import "NoticeView.h"
#import "SoundrecordViewController.h"
@interface SaveView ()

- (void)handlesaveMovieToCameraRoll;
- (void)handleStartRecording;
- (void)handleStopRecording;
//保存video到相册
- (void)handleWriteToLibrary:(NSURL *)path;
//保存照片到相册
- (void)handleWriteImageToLibrary:(UIImage *)image;
@end

@implementation SaveView

- (void)initNavigationBar {
    
}

- (void)myInit {

    self.title = @"存证宝";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
//LogInAgain
-(void)addMessageNum{
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.window.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
    
    UserModel * user = [UserModel sharedInstance];
    _noReadMsgCount = user.unReadMsgNum;
    
    if (_noReadMsgCount  > 0) {

    btnNumMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNumMessage.userInteractionEnabled = NO;
    btnNumMessage.tag = 1001;
    btnNumMessage.titleLabel.font = [UIFont systemFontOfSize:12];
    btnNumMessage.frame = CGRectMake(280, 3, 15, 15);
    [btnNumMessage setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [btnNumMessage setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
    //[self.navigationController.navigationBar addSubview:btnNum];
    
    [delgate.tabBar.bottomView addSubview:btnNumMessage];
    }
//    btnNum = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnNum.userInteractionEnabled = NO;
//    btnNum.tag = 1001;
//    btnNum.titleLabel.font = [UIFont systemFontOfSize:12];
//    btnNum.frame = CGRectMake(20, 5, 15, 15);
//    [btnNum setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
//    [btnNum setTitle:[NSString stringWithFormat:@"%d",_noReadMsgCount]forState:UIControlStateNormal];
//    [self.navigationController.navigationBar addSubview:btnNum];
    
}
-(void)removeMessageNum{
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.tabBar.bottomView.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }  
    }
    
    //[btnNumMessage removeFromSuperview];
}

//- (void)postHttpGetTipsNum
//{
//    
//    _msgArr = [[NSMutableArray alloc] initWithCapacity:10];
//    
//    UserModel * user = [UserModel sharedInstance];
//    NSString *phoneNum = user.phoneNumber;
//    NSLog(@"userID---->%@", user.userID);
//     NSLog(@"phoneNum---->%@", phoneNum);
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:APP_ID forKey:@"app_id"];
//    [dic setObject:VERSIONS forKey:@"v"];
//    [dic setObject:@"1" forKey:@"src"];
//    [dic setObject:phoneNum forKey:@"mobileNo"];
//    [dic setObject:user.userID forKey:@"userID"];
//    NSString *result = [URLUtil generateNormalizedString:dic];
//    NSString *sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];
//    
//    NSString *urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,SYSTEM_MESSAGE_URL];
//    NSURL *url = [NSURL URLWithString:urls];
//    NSLog(@"request URL is: %@",url);
//    
//    _tipsRequest = [ASIFormDataRequest requestWithURL:url];
//    
//    /*此处userID是写死的，38，用来测试的*/
//    
//    [_tipsRequest setPostValue:user.userID forKey:@"userID"];
//    [_tipsRequest setPostValue:APP_ID forKey:@"app_id"];
//    [_tipsRequest setPostValue:VERSIONS forKey:@"v"];
//    [_tipsRequest setPostValue:phoneNum forKey:@"mobileNo"];
//    [_tipsRequest setPostValue:@"1" forKey:@"src"];
//    [_tipsRequest setPostValue:sig forKey:@"sig"];
//    
//    
//    
//    
//    _tipsRequest.delegate = self;
//    _tipsRequest.tag= 8888;
//    [_tipsRequest setRequestMethod:@"POST"];
//    [_tipsRequest startAsynchronous];
//}
//- (void)request:(ASIHTTPRequest *)request1 didReceiveData:(NSData *)data
//{
//    
//    [_jsonData appendData:data];
//   
//        
//        
//    
//}
//- (void) alertWithMessage:(NSString *)msg
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//
//-(void)requestFinished:(ASIHTTPRequest *)request22
//{
//    
//    NSLog(@"");
//    NSLog(@"--------datadatadatadatadata%@",_jsonData);
//    //__block self;
//    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
//    NSString * code = [jsonDic objectForKey:@"code"];
//    //   NSString * codeInfo = [jsonDic objectForKey:@"codeInfo"];
//    //  NSLog(@"--------%@",[jsonDic objectForKey:@"data"]);
//    if ([code intValue] == 0) {
//        
//        [_msgArr removeAllObjects];
//        [_msgArr addObjectsFromArray:[jsonDic objectForKey:@"data"]];
//        NSLog(@"_msgArr-->%@",_msgArr);
//        _noReadMsgCount = 0;
//        
//        for (int i = 0; i < [_msgArr count]; i++) {
//            if ([[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"N"] || [[[_msgArr objectAtIndex:i] objectForKey:@"IsReadAlready"] isEqualToString:@"n"]) {
//                _noReadMsgCount++;
//            }
//        }
//    }else {
//        //[self alertWithMessage:codeInfo];
//    }
//    [self addMessageNum];
//    
//    [_jsonData setLength:0];
//    //    NSData *da = [request responseData];
//    //    JSONDecoder *jd = [[JSONDecoder alloc] init];
//    //    NSDictionary *ret = [jd objectWithData:da];
//    //    NSLog(@"retretretret ---- > %@",ret);
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"request Failed");
//    //    [self alertWithMessage:@"数据加载失败,请检查网络"];
//}

- (void)viewWillAppear:(BOOL)animated {
    
    _jsonData=[[NSMutableData alloc] init];
    [super viewWillAppear:animated];
    [Tool getOSCNotice2:@"nil"];
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:NO];
    
    self.navigationController.navigationBarHidden = YES;
    [self touch];
   // [self addMessageNum];
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    //[self postHttpGetTipsNum];
    [self addMessageNum];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeMessageNum];

}
-(void)viewDidDisappear:(BOOL)animated{
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(delayVison) userInfo:nil repeats:NO];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(void)noticeInform{
    
    
    UserModel * user = [UserModel sharedInstance];
    if (user.isExist){
        
        NewProofapplyView * notary = [[NewProofapplyView alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        
        UserInfoView * infoView = [[UserInfoView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:infoView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UserModel * user = [UserModel sharedInstance];
    self.currentNum.textColor = [URLUtil colorWithHexString:@"#8491a2"];
    self.currentNum.font = [UIFont systemFontOfSize:14];
    self.currentNum.textColor = [UIColor colorWithRed:109/255.0 green:113/255.0 blue:116/255.0 alpha:1.0];
    self.succRecordNum.textColor = [URLUtil colorWithHexString:@"#396195"];
    self.succRecordNum.font = [UIFont boldSystemFontOfSize:13];
    self.succRecordNum.text = [NSString stringWithFormat:@"%@人",user.succRecordNum];
    // Do any additional setup after loading the view from its nib.
   NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
//    if (![ud boolForKey:@"mybool"]==YES) {
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(noticeInform) name:@"Notification_NoticeInform1" object:nil];
        [ud setBool:YES forKey:@"mybool"];
//    }else{
//            [[NSNotificationCenter defaultCenter] removeObserver:self];

//    }

     [self myInit];
//    NSDictionary *markDef = [self.coachMarks objectAtIndex:index];
//    NSString *markCaption = [markDef objectForKey:@"caption"];
//    CGRect markRect = [[markDef objectForKey:@"rect"] CGRectValue];
    
    
   
//    NSDictionary * dic =[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:CGRectMake(164, 278, 133, 133)],@"rect",@"点击这里进行通话录音",@"caption", nil];
//    
//    NSDictionary * dic1 =[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:CGRectMake(10, 480+88-50, 90, 80)],@"rect",@"通话证据都保存在这里",@"caption", nil];
//    NSArray * arr = [[NSArray alloc] initWithObjects:dic,dic1, nil];
//
//
//    WSCoachMarksView * wscoach = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(IS_IPHONE_5?88:0)) coachMarks:arr];
//    wscoach.delegate=self;

    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedSave"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedSave"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchSave"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchSave"]) {
        
        
    }else {
        leadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leadBtn.frame =CGRectMake(0, 0, 320, 480+(IS_IPHONE_5?88:0));
        [leadBtn setBackgroundImage:[UIImage imageNamed:(IS_IPHONE_5?@"walkthroughs-1.png":@"walkthroughs-1x960.png")] forState:UIControlStateNormal];
        
        [leadBtn addTarget:self action:@selector(userDidTap) forControlEvents:UIControlEventTouchUpInside];
        AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delgate.window addSubview:leadBtn];
        
    }
    
    _folderArray = [NSMutableArray array];
    _jsonFolderList = [[NSMutableData alloc] init];
    [self requestFolderList];
    
    backView = [[UIView alloc] init];
    CGFloat high = IS_IPHONE_5 ? 568 -49.5 : 480- 49.5;
    backView.frame = CGRectMake(0, 0, 320, high);
    backView.alpha = 0.7;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
    backView.backgroundColor = [URLUtil colorWithHexString:@"#000000"];
    [self.view addSubview:backView];
    backView.hidden = YES;
    
    midView = [[UIView alloc] init];
    CGFloat highY = IS_IPHONE_5 ? 180 : 130;
    midView.frame = CGRectMake(40,highY, 240,170);
    midView.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    [self.view addSubview:midView];
    midView.hidden = YES;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"录音模式";
    lab.frame = CGRectMake(18, 14, 75, 14);
    lab.textColor = [URLUtil colorWithHexString:@"#555555"];
    lab.font = [UIFont boldSystemFontOfSize:14];
    [midView addSubview:lab];
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"(首次录音请提前测试音质)";
    lab1.textColor = [URLUtil colorWithHexString:@"#555555"];
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.frame = CGRectMake(75, 14, 200, 14);
    [midView addSubview:lab1];
    
    
    NSArray *arr = [NSArray arrayWithObjects:@"本地录音(需手动上传)",@"实时录音(证据效力更强)",@"取消",nil];
    for (int i = 0;i<3;i++){
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(18,37+ i*44, 204, 35);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(VouClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setContentHorizontalAlignment:UIControlContentVerticalAlignmentCenter];
        if (btn.tag == 2){
            [btn setBackgroundColor:[URLUtil colorWithHexString:@"#eeeeee"]];
            [btn setTitleColor:[URLUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        } else {
            if (btn.tag == 0){
            [btn setBackgroundColor:[URLUtil colorWithHexString:@"#e9b230"]];
            } else if (btn.tag == 1){
            [btn setBackgroundColor:[URLUtil colorWithHexString:@"#38a7da"]];
            }
            [btn setTitleColor:[URLUtil colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];

         }
        [midView addSubview:btn];
    }
}
-(void)VouClick:(UIButton *)btn
{
    if (btn.tag == 0){
        SoundrecordViewController *sound = [[SoundrecordViewController alloc] init];
        [self.navigationController pushViewController:sound animated:YES];
    } else if(btn.tag == 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否拨打400电话进行现场录音" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
     } else if (btn.tag == 2){
        [self touch];
    }
}
-(void)touch
{
    backView.hidden = YES;
    midView.hidden = YES;
}
-(void)userDidTap{
    
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunchSave"];
    
    [leadBtn removeFromSuperview];


}
- (void)coachMarksView:(WSCoachMarksView*)coachMarksView willNavigateToIndex:(NSUInteger)index{
    NSLog(@"willNavigateToIndex");
}
- (void)coachMarksView:(WSCoachMarksView*)coachMarksView didNavigateToIndex:(NSUInteger)index{

    
    NSLog(@"didNavigateToIndex");
}
- (void)coachMarksViewWillCleanup:(WSCoachMarksView*)coachMarksView{

      NSLog(@"coachMarksViewWillCleanup");
}
- (void)coachMarksViewDidCleanup:(WSCoachMarksView*)coachMarksView{

     NSLog(@"coachMarksViewDidCleanup");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma btn click  法律咨询
- (IBAction)btnFaroese:(UIButton *)sender {
    FaroeseView *faroseView = [[FaroeseView alloc]initWithNibName:@"FaroeseView" bundle:nil];
    [self.navigationController pushViewController:faroseView animated:YES];
    
}
- (IBAction)appLiactionBtn:(id)sender {
    NSUserDefaults * defauls =  [NSUserDefaults standardUserDefaults];
    NSString * notice =  [defauls objectForKey:@"Notice"];
    
    if (notice == nil){
        
        NoticeView * notView = [[NoticeView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        @try {
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        return;
    }
    
    UserModel * user = [UserModel sharedInstance];
    if (user.isExist){
        
        NewProofapplyView * notary = [[NewProofapplyView alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        
        UserInfoView * infoView = [[UserInfoView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:infoView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    

}

- (IBAction)btnRecordClick:(UIButton *)but
{
   
    AddressView * address = [[AddressView alloc] initWithNibName:@"AddressView" bundle:nil];
    [self.navigationController pushViewController:address animated:YES];

}
- (IBAction)btnUploadClick:(UIButton *)but
{
    FileUploadView * upload = [[FileUploadView alloc] initWithNibName:@"FileUploadView" bundle:nil];
    [self.navigationController pushViewController:upload animated:YES];
}
- (IBAction)btnPhotoClick:(UIButton *)but
{
    
   AppDelegate * app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app hiddenTab:YES];
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //相片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    if(nil == _pickerForPhoto) {
      self.pickerForPhoto = [[UIImagePickerController alloc] init];
    }
    
    _pickerForPhoto.delegate = self;
    _pickerForPhoto.allowsEditing = NO;
    _pickerForPhoto.sourceType = sourceType;
    _pickerForPhoto.videoQuality=UIImagePickerControllerQualityTypeLow;

//    [self presentModalViewController:_pickerForPhoto animated:YES];
    [self presentViewController:_pickerForPhoto animated:YES completion:nil];
    _pickerForPhoto = nil;

}

- (IBAction)btnDBClick:(UIButton *)but
{

    AppDelegate * app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app hiddenTab:YES];
    
    if (nil == _pickerForVideo) {
        _pickerForVideo = [[UIImagePickerController alloc] init];
    }
    _pickerForVideo.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    _pickerForVideo.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
//    [self presentModalViewController:_pickerForVideo animated:YES];
    [self presentViewController:_pickerForVideo animated:YES completion:nil];
    _pickerForVideo.videoMaximumDuration = 120;
    _pickerForVideo.delegate = self;

}
- (IBAction)btnCurrentRecordClick:(UIButton *)but
{
    backView.hidden = NO;
    midView.hidden = NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        NSLog(@"qqq");
    }else if(buttonIndex == 1){
        NSString * number = [NSString stringWithFormat:@"tel://%@",SITE_RECORDING_NUMBER];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        [self touch];
    }
}
- (void)saveImage:(UIImage *)photo{
    //拍摄后保存
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    //拍照 摄像完成之后都会调用这个方法 要tag区别吧
    FileModel * model = [[FileModel alloc] init];
    model.actionType = kUploadFile;
    NSData * data = nil;
    if (_pickerForVideo == picker) {
        
        NSURL * url = info[UIImagePickerControllerMediaURL];
        
        [self handleWriteToLibrary:url];
        NSURL * videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        model.path = videoURL;
        model.type = kVideoFile;
        model.targetName = [videoURL absoluteString];
        
        data  = [NSData dataWithContentsOfURL:model.path];
        
        NSString * logstr = [NSString stringWithFormat:@"视频文件路径 %@",model.path];
        debugLog(logstr);
        
        [self handlePreViewImage:videoURL andModel:model];
        
        
    }else {

        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self handleWriteImageToLibrary:image];
        
        NSString * fileName = [[NSString alloc] init];
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            debugLog(fileName);
        }else {
            
            fileName = [self handleTimeStampAsString:fileName];
            
        }

        model.image = image;
        model.targetName = fileName;
        model.type = kPhotoFile;
        data = UIImageJPEGRepresentation(model.image,DEFAULT_IMAGE_COMPRESS);
        image = nil;
    }

    model.md5 = [data MD5String];
    model.size = [NSString stringWithFormat:@"%d",data.length];
    picker = nil;
        
        if (IS_IPHONE_5) {
            self.upload = [[UploadView alloc] initWithNibName:@"UploadView-ip5" bundle:nil];
        }else {
            self.upload = [[UploadView alloc] initWithNibName:@"UploadView" bundle:nil];
            
        }
     self.upload.isPresent = NO;
    self.upload.ispaizao = YES;
     self.upload.model = model;
     UINavigationController * nava = [[UINavigationController alloc] initWithRootViewController:self.upload];
    
    if (IOS7_OR_LATER) {
        [nava.navigationBar setBarStyle:UIBarStyleBlack];
        [nava.navigationBar setTranslucent:YES];
        [nava.navigationBar setBackgroundImage:[UIImage imageNamed:@"navios7_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
      
    }else{
        [nava.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
     
    }
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:self.upload animated:NO];
//    [self presentViewController:nava animated:NO completion:nil];
    self.upload = nil;
    model = nil;

}
- (void)test:(FileModel *)model
{
    
  
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    AppDelegate * app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app hiddenTab:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker dismissModalViewControllerAnimated:YES];
}


#pragma handlemethods 
- (void)handlesaveMovieToCameraRoll
{
    
}
- (void)handleStartRecording
{
    
}
- (void)handleStopRecording
{
    
}
- (void)handleWriteToLibrary:(NSURL *)path
{
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:path completionBlock:
     ^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        }
        
    }];
}
- (void)handleWriteImageToLibrary:(UIImage *)image
{
    
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:(ALAssetOrientation)[image imageOrientation]
                          completionBlock:nil];
    
}
- (NSString *)handleTimeStampAsString:(NSString *)path
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-d"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
    
}
- (void)handlePreViewImage:(NSURL *)path andModel:(FileModel *)model
{
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * img = [[UIImage alloc] initWithCGImage:image];
    model.image = img;
    
}

//网络请求获取全局文件夹
- (void)requestFolderList
{
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"文件夹列表:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"文件夹列表:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FOLDER_LIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    if (nil != _requestRefresh) {
        
        [_requestRefresh cancel];
        _requestRefresh.delegate = nil;
        _requestRefresh = nil;
    }
    
    _requestRefresh = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRefresh setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRefresh setPostValue:user.userID forKey:@"userID"];
    [_requestRefresh setPostValue:APP_ID forKey:@"app_id"];
    [_requestRefresh setPostValue:VERSIONS forKey:@"v"];
    [_requestRefresh setPostValue:@"1" forKey:@"src"];
    [_requestRefresh setPostValue:sig forKey:@"sig"];
    
    [_requestRefresh setDelegate:self];
    [_requestRefresh setDidStartSelector:@selector(requestStart:)];
    [_requestRefresh setDidFailSelector:@selector(requestFail:)];
    [_requestRefresh setDidFinishSelector:@selector(requestFinish:)];
    [_requestRefresh setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestRefresh startAsynchronous];
}
- (void)requestStart:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        [self handleActivityStart];
        
    }
    
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (request == _requestRefresh) {
        
        [_jsonFolderList appendData:data];
        
    }
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
         [self handleActivityStop];
        
    }
}
- (void)requestFinish:(ASIHTTPRequest *)request
{
    if (request == _requestRefresh) {
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary * jsonDic = [_jsonFolderList objectFromJSONData];
        NSLog(@"%@",jsonDic);
        NSArray * array = [jsonDic objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i ++) {
            
            NSDictionary * tmp = [array objectAtIndex:i];
            NSString * dataNum = [tmp objectForKey:@"dataNum"];
            NSString * folderID = [tmp objectForKey:@"folderID"];
            NSString * folderName = [tmp objectForKey:@"folderName"];
            NSString * type = [tmp objectForKey:@"type"];
            NSString * haschild = [tmp objectForKey:@"haschild"];
            
            FolderModel * folder = [[FolderModel alloc] init];
            folder.dataNum = dataNum;
            folder.folderID = folderID;
            folder.folderName = folderName;
            folder.type = type;
            folder.haschild = haschild;
            
            if ([@"音频视频" isEqualToString:folderName]
                      || [@"照片图片" isEqualToString:folderName] ||
                      [@"现场录音" isEqualToString:folderName]){
                
                [_folderArray addObject:folder];
                
                //添加到全局目录结构
                [app.folderArray addObject:folder];
                
            }
            else {
                [_folderArray addObject:folder];
                
                }
            
        }
    }
    
    [self handleActivityStop];

}
- (void)handleActivityStop
{
    [DejalBezelActivityView removeView];
}
- (void)handleActivityStart
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:nil];
}

- (IBAction)appLacationAction:(id)sender {
    
    NSUserDefaults * defauls =  [NSUserDefaults standardUserDefaults];
    NSString * notice =  [defauls objectForKey:@"Notice"];
    NSLog(@"notc=%@",notice);
    if (notice == nil){
        
        NoticeView * notView = [[NoticeView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        @try {
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        return;
    }
    
    UserModel * user = [UserModel sharedInstance];
    if (user.isExist){
        
        NewProofapplyView * notary = [[NewProofapplyView alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notary];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        
        UserInfoView * infoView = [[UserInfoView alloc]init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:infoView];
        if (IOS7_OR_LATER) {
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [nav.navigationBar setTranslucent:NO];
        }
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
 
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

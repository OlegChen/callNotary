//
//  UploadView.m
//  notary
//
//  Created by 肖 喆 on 13-3-27.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UploadView.h"
#import "BWStatusBarOverlay.h"
#import "DirectoryView.h"
#import "AppDelegate.h"
#import "MobClick.h"

@interface UploadView ()<UIAlertViewDelegate>
{
    BOOL isPause;
}

- (NSMutableString *)handleGetJsonString;
- (NSString * )handleGetImageName;
- (NSString *)handleGetVideoName;
- (NSString *)handleGetSrcId:(NSString *)targetName;
- (NSString *)handleGetCurrentTime;
- (void)start;

@end

@implementation UploadView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
//    self.btnSend.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
//    self.btnCancel.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    [self.btnSend setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.txtFileName.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    self.txtFileName.textColor = [URLUtil colorWithHexString:@"#555555"];
    self.txtFileName.font = [UIFont systemFontOfSize:14];
    self.txtFileName.layer.masksToBounds = YES;
    self.txtFileName.layer.cornerRadius = 4;
    self.txtFileName.layer.borderColor = [[URLUtil colorWithHexString:@"#cccccc"] CGColor];
    self.txtFileName.layer.borderWidth = 1;
self.txtDirectory.backgroundColor = [URLUtil colorWithHexString:@"#ffffff"];
    self.txtDirectory.layer.masksToBounds = YES;
    self.txtDirectory.textColor = [URLUtil colorWithHexString:@"#555555"];
    self.labSize.textColor = [URLUtil colorWithHexString:@"#555555"];
    self.txtDirectory.font = [UIFont systemFontOfSize:14];
    self.txtDirectory.layer.cornerRadius = 4;
    self.txtDirectory.layer.borderWidth = 1;
    self.txtDirectory.layer.borderColor = [[URLUtil colorWithHexString:@"#cccccc"] CGColor];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.frame = CGRectMake(0,180, 320, 1);
    lineV.backgroundColor = [URLUtil colorWithHexString:@"#dddddd"];
    [self.view addSubview:lineV];
    
    UIView *topV = [[UIView alloc] init];
    topV.frame = CGRectMake(0, 0, 160, 1);
    topV.backgroundColor = [URLUtil colorWithHexString:@"#dddddd"];
    [self.btnSend addSubview:topV];
    
    UIView *topV1 = [[UIView alloc] init];
    topV1.frame = CGRectMake(0, 0, 160, 1);
    topV1.backgroundColor = [URLUtil colorWithHexString:@"#dddddd"];
    [self.btnCancel addSubview:topV1];
    
    UIView *midV = [[UIView alloc] init];
    midV.frame = CGRectMake(159, 0, 1, 63);
    midV.backgroundColor =[URLUtil colorWithHexString:@"#dddddd"];
    [self.btnSend addSubview:midV];
    [self.btnCancel setContentHorizontalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.btnSend setContentHorizontalAlignment:UIControlContentVerticalAlignmentCenter];
    self.btnName.textColor = [URLUtil colorWithHexString:@"#999999"];
     self.btnSize.textColor = [URLUtil colorWithHexString:@"#999999"];
    self.btnmulu.textColor = [URLUtil colorWithHexString:@"#999999"];
    self.progress.minimumTrackTintColor = [UIColor colorWithRed:224.0/255 green:38.0/255 blue:0/255 alpha:1.0];
    self.progress.value = 0;
    [self.progress setThumbImage:[UIImage imageNamed:@"bg_play_point"] forState:UIControlStateNormal];

    _model.isFirstUpload = YES;
    _isShowAlertFinish = YES;
    self.title = @"文件上传";
    _customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _customLeft.frame = CGRectMake(0, 0, 40, 40);
    [_customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:_customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    [_imagePreView setImage:_model.image];
    
    _txtDirectory.enabled = NO;
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app hiddenTab:YES];
    
    if (_model.type == 1) {
         _dateTimeForFileName =[self handleGetImageName];
        NSString *nameStr = [NSString stringWithFormat:@"img_%@",_dateTimeForFileName];
        _txtFileName.attributedText = [self resetContentWithStr:nameStr HeadIndent:10];
        if (app.folderArray.count > 0){
            
            for (FolderModel * folder in app.folderArray){
                if ([@"照片图片" isEqualToString:folder.folderName]){
                    _folder = folder;
                    _model.folderId = _folder.folderID;
                    _model.folderName = _folder.folderName;
                }
            }

        }
        
    }else if(_model.type == 0) {
        
        _dateTimeForFileName =[self handleGetVideoName];
        NSString *nameStr = [NSString stringWithFormat:@"video_%@",_dateTimeForFileName];
        _txtFileName.attributedText = [self resetContentWithStr:nameStr HeadIndent:10];
        if (app.folderArray.count > 0){
            
            for (FolderModel * folder in app.folderArray){
                if ([@"音频视频" isEqualToString:folder.folderName]){
                    _folder = folder;
                    _model.folderId = _folder.folderID;
                    _model.folderName = _folder.folderName;
                }
            }
        }
    } else if(_model.type == 2) {
        
        NSString *nameStr = [NSString stringWithFormat:@"voice_%@",_model.name];
        _txtFileName.attributedText = [self resetContentWithStr:nameStr HeadIndent:10];
        if (app.folderArray.count > 0){
            
            for (FolderModel * folder in app.folderArray){
                if ([@"现场录音" isEqualToString:folder.folderName]){
                    _folder = folder;
                    _model.folderId = _folder.folderID;
                    _model.folderName = _folder.folderName;
                }
            }
        }

    }
    
    _labSize.text = [NSString getAutoKBorMBNumber:_model.size];
    
}

//设置缩进
- (NSMutableAttributedString *)resetContentWithStr:(NSString *)str HeadIndent:(int)indent
{
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString :str];
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    
    paragraphStyle. alignment = NSTextAlignmentLeft ;
    
    paragraphStyle. maximumLineHeight = 60 ;  //最大的行高
    
    paragraphStyle. lineSpacing = 5 ;  //行自定义行高度
    
    [paragraphStyle setFirstLineHeadIndent : indent ]; //首行缩进 根据用户昵称宽度在加5个像素
    
    [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , str.length)];
    return attributedString;
    
}

-(void)removeMessageNum{
    
    
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIButton*button in  delgate.window.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
    for (UIButton*button in  self.view.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
    for (UIButton*button in  delgate.tabBar.bottomView.subviews) {
        NSLog(@"----view%@",button);
        if (button.frame.size.height == 15) {
            [button removeFromSuperview];
        }
    }
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isShowAlertFinish = YES;
    
    if (nil != _folder) {
        _txtDirectory.attributedText = [self resetContentWithStr:_folder.folderName HeadIndent:10];
    }
    [MobClick beginLogPageView:@"本地上传"];
    [self removeMessageNum];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [_upload.socket disconnect];
    _upload.delegate = nil;
    _upload = nil;
//    self.model = nil;
    
    [MobClick endLogPageView:@"本地上传"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}
- (FileModel *)handleGetUploadFileModel:(NSString *)srcid
{
    UserModel * user = [UserModel sharedInstance];
    NSMutableString * jsonStr = [[NSMutableString alloc]initWithCapacity:0];
    
   
}

- (void)handleBackButtonClick:(UIButton *)but
{
    if (_isUploading){
        [_upload cancel];
    }
if (_isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSString * )handleGetImageName
{
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"EEE-MMM-d"];//中文表示 周二，4月
    [df setDateFormat:@"yyyyMMddHHmmss"];//获得数字时间
    NSString *locationString = [df stringFromDate:nowDate];
    
//    NSString * name = [NSString stringWithFormat:@"IMG_%@",locationString];
      NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
 
}
- (NSString *)handleGetVideoName
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *locationString = [df stringFromDate:nowDate];
    NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
}
- (NSString *)handleGetCurrentTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];//中文表示 周二，4月
//    [df setDateFormat:@"yyyyMMddHHMMss"];//获得数字时间
    NSString *locationString = [df stringFromDate:nowDate];
    NSString * name = [NSString stringWithFormat:@"%@",locationString];
    return name;
}




- (IBAction)btnCancelClick:(id)sender
{
    if (_upload != nil) {
        
        [_upload cancel];
//        _progress.progress = 0;
        self.progress.value = 0;
        _btnSend.enabled = YES;
        [_btnSend setTitle:@"开始" forState:UIControlStateNormal];
        _isUploading = NO;
    }
    
    if (_isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)btnSendClick:(id)sender
{
    [MobClick event:@"上传事件"];
    
    NSString * fileName = _txtFileName.text;
    if (fileName == nil || [fileName isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSString * temp = [fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([temp isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
        
    }
    if (_model.type != 2){
    NSString * regex = @"^[\u4e00-\u9fa5a-zA-Z0-9_]+$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:fileName];
    
    if (!isMatch) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件名不能包含特殊符号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
       }
    
    NSString * dir = _txtDirectory.text;
    if (dir == nil || [dir isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择上传目录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }

    
    if (_model.type == kVideoFile) {

        _model.name = [[NSString stringWithFormat:@"%@.mov",_txtFileName.text] lowercaseString];
        
    }else if(_model.type == kPhotoFile) {
        
        _model.name = [[NSString stringWithFormat:@"%@.png",_txtFileName.text] lowercaseString];
        
    } else if (_model.type == kVoiceFile){
        
     }
    
    _btnSelectDirectory.enabled = NO;
    _txtFileName.enabled = NO;
//    _customLeft.enabled = NO;
    _btnCancel.enabled = NO;
    UIButton *but = (UIButton *)sender;
    
    if (self.ispaizao && !_isUploading &&!isPause){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"免费赠送20M空间,超出部分5录音币/M" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:@"确定上传", nil];
        [alert show];
        return;
    }
    if (!_isUploading) {
        _isUploading = YES;
        isPause = NO;
        _upload = [UpLoadContinue lauchSocket:_model immediately:YES];
        _upload.delegate = self;
        [but setTitle:@"暂 停" forState:UIControlStateNormal];
    }else {
        _isUploading = NO;
        [_upload cancel];
        [but setTitle:@"开 始" forState:UIControlStateNormal];
        isPause = YES;
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
    }else if (buttonIndex == 1){
        _isUploading = YES;
        isPause = NO;
        _upload = [UpLoadContinue lauchSocket:_model immediately:YES];
        _upload.delegate = self;
        [self.btnSend setTitle:@"暂 停" forState:UIControlStateNormal];

    }
}
- (IBAction)btnSelectDirectoryClick:(id)sender
{
    DirectoryView * dir = [[DirectoryView alloc] initWithNibName:@"DirectoryView" bundle:nil];
    dir.controler = self;
    dir.file = _model;
    [self.navigationController pushViewController:dir animated:YES];
}
- (IBAction)btnCloseKeyBoradClick:(id)sender
{
 
}
- (void)notificationUploadProgress:(float)progress FileModel:(FileModel *)file;
{
    _customLeft.enabled = YES;
    _btnCancel.enabled = YES;
//    _progress.progress = progress;
    self.progress.value = progress;
}
- (void)notificationUploadFailed:(NSError *)error FileModel:(FileModel *)file;
{
    _isUploading = NO;    
    [_upload cancel];
    _upload.delegate = nil;
    _upload = nil;
    _customLeft.enabled = YES;
    _btnCancel.enabled = YES;
    [_btnSend setTitle:@"开始" forState:UIControlStateNormal];
}
- (void)notificationUploadFinished:(FileModel *)file;
{
//    _progress.progress = 1;
    self.progress.value = 1;
    _btnSend.enabled = NO;
    _btnCancel.enabled = NO;
    [_btnSend setTitle:@"开始" forState:UIControlStateNormal];
    
    _labMessage.hidden = NO;
    _labMessage.text = @"上传已完成";
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([app.uploadArray containsObject:file]){
        [app.uploadArray removeObject:file];
    }
    [app.uploadSocket removeObjectForKey:file.md5];
    
    //保存上传状态信息
    UserModel *user = [UserModel sharedInstance];
    NSString *plistPath = [self documentPathWith:[NSString stringWithFormat:@"%@_cmx.plist",user.userID]];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
    NSMutableDictionary *doc = [dic objectForKey:file.name];
    NSLog(@"%@",doc);
    [doc setValue:file.folderName forKey:@"uploadState"];
    [dic setValue:doc forKey:file.name];
    [dic writeToFile:plistPath atomically:YES];
//    NSLog(@"%@-----%@",dic,doc);
    if (_isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:fileName];
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
        [UIView beginAnimations:nil context:nil];
        [UIView animateWithDuration:1 animations:nil];
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        self.view.frame = viewFrame;
        [UIView commitAnimations];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{ 

        [UIView beginAnimations:nil context:nil];
        [UIView animateWithDuration:1 animations:nil];
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = -90;
        self.view.frame = viewFrame;
        [UIView commitAnimations];
    
    return YES;
}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(strlen([textField.text UTF8String]) >= 45 && range.length != 1)
        return NO;
    
    return YES;

}

- (NSString *)handleGetSrcId:(NSString *)md5
{
    NSString * srcid = @"";
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc] init];
    //@"select * from UFile where srcid = ?";
    NSString * sql = @"select * from FileModel where md5 = ? and uid = ?";
    //[NSString stringWithFormat:@"select * from FileModel where targetName = %@",targetName];
    
    
    NSArray * par = [NSArray arrayWithObjects:md5,user.uid,nil];
    FMResultSet * result = [db query:sql parameter:par];
    
    NSString * logstr = [NSString stringWithFormat:@"select * from FileModel where md5 = %@ and uid = %@",md5,user.uid];
//    debugLog(logstr);
    
    while (result.next) {
        NSString * temp = [result stringForColumn:@"srcid"];
        if (nil != temp) {
            srcid = temp;
        }
    }
    [db close];
    db = nil;
    
    return srcid;
}

@end

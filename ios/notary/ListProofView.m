//
//  ListProofView.m
//  notary
//
//  Created by 肖 喆 on 13-3-28.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "ListProofView.h"
#import "FileModel.h"
#import "AppDelegate.h"
#import "ListProofCell.h"
#import "PreviewView.h"
#import "DownLoadHistory.h"

#import "FolderListView.h"
#import "FileDetailView.h"
#import "NSData+Extension.h"
#import "proBtn.h"
@interface ListProofView ()<UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>
{
    UIView *backView;
    UIView *midView;
    FileModel *fileStr;
    UIView *backV;
    proBtn *upBtn;
    proBtn *downBtn;
    UIButton *  mRight;
    int m;
    NSMutableArray *AllNameArr;
    NSMutableDictionary *AllInfoDic;
    UIButton * customRight;
    FileModel * fileStr1;
    NSIndexPath *indexPath1;
 }

- (void)requestFileList;
//- (void)handleEditItemClick;
@end

@implementation ListProofView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)reloadtableview
{
    [_contentView reloadData];
}

////网络请求
//- (void)requestFolderList
//{
//    
//    UserModel * user = [UserModel sharedInstance];
//    
//    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
//    
//    [dic setObject:user.userID forKey:@"userID"];
//    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
//    
//    NSString * result = [URLUtil generateNormalizedString:dic];
//    
//    NSString * logstr = [NSString stringWithFormat:@"文件夹列表:sig 原始 %@",result];
//    debugLog(logstr);
//    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
//    NSString * logstr2 = [NSString stringWithFormat:@"文件夹列表:sig 加密后 %@",sig];
//    debugLog(logstr2);
//    
//    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,FOLDER_LIST_URL];
//    NSURL * url = [NSURL URLWithString:urls];
//    
//    if (nil != _requestRefresh) {
//        
//        [_requestRefresh cancel];
//        _requestRefresh.delegate = nil;
//        _requestRefresh = nil;
//    }
//    
//    _requestRefresh = [[ASIFormDataRequest alloc] initWithURL:url];
//    
//    [_requestRefresh setPostValue:user.phoneNumber forKey:@"mobileNo"];
//    [_requestRefresh setPostValue:user.userID forKey:@"userID"];
//    [_requestRefresh setPostValue:APP_ID forKey:@"app_id"];
//    [_requestRefresh setPostValue:VERSIONS forKey:@"v"];
//    [_requestRefresh setPostValue:@"1" forKey:@"src"];
//    [_requestRefresh setPostValue:sig forKey:@"sig"];
//    
//    [_requestRefresh setDelegate:self];
//    [_requestRefresh setDidStartSelector:@selector(requestStart:)];
//    [_requestRefresh setDidFailSelector:@selector(requestFail:)];
//    [_requestRefresh setDidFinishSelector:@selector(requestFinish:)];
//    [_requestRefresh setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
//    
//    [_requestRefresh startAsynchronous];
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
#pragma  - mark 加载数据

//    if (_rootFolderID == nil) {
//        
//        [self requestFolderList];
//        
//    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListForder:) name:Notification_MoveFolder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadtableview) name:@"reloadTableView" object:nil];
    startIndex = 0;
    fileStr = nil;
    self.title = _parentFolder.folderName;
    
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage resizableImageWithName:@"标题栏背景"] forBarMetrics:UIBarMetricsDefault];
    }

    
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeft.frame = CGRectMake(0, 0, 40, 40);
    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [customLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:255];
    
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:255];
    
    if ([_parentFolder.folderName isEqualToString:@"回收站"]||self.isHuiFloder ) {
        _contentView.frame = CGRectMake(0, 44, 320,self.view.frame.size.height -64);
        [self.navigationController setNavigationBarHidden:YES];
        UIView *navBar = [[UIView alloc] init];
        navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navios7_bg.png"]];
        navBar.frame = CGRectMake(0, 0, 320, 64);
        [self.view addSubview:navBar];
        
        UIButton *  mLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        mLeft.frame = CGRectMake(20, 20, 40, 40);
        [mLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [mLeft setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [navBar addSubview:mLeft];
        if (!self.isHuiFloder){
        mRight = [UIButton buttonWithType:UIButtonTypeCustom];
         mRight.frame = CGRectMake(260,20, 40, 40);
        [mRight addTarget:self action:@selector(handleEditItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [mRight setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
        mRight.selected = YES;
        [navBar addSubview:mRight];
        }
    } else {
        //回收站不应该有长安事件   modify by liwzh
        //先判是否是长按事件
        
    if (!self.isSearchFrom &&![_parentFolder.type isEqualToString:@"6"]){
        if (self.isRootFloder){
//            customRight = [UIButton buttonWithType:UIButtonTypeCustom];
//            customRight.frame = CGRectMake(0, 0, 40, 40);
//            [customRight addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//            [customRight setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
//            
//            UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
//            self.navigationItem.rightBarButtonItem = rightButton;
        }
        _lpgr = [[UILongPressGestureRecognizer alloc] init];
        [_lpgr addTarget:self action:@selector(handleLongPress:)];
        _lpgr.minimumPressDuration = 1.0;
        _lpgr.delegate = self;
        [_contentView addGestureRecognizer:_lpgr];
        }
    }
    
    [_viewDrop setCenter:CGPointMake(280, 50)];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_bg"]];
    _innerView.backgroundView = imageView;
    
#pragma  - mark title颜色
    UIColor *Color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:Color forKey:UITextAttributeTextColor];
    
    //大功告成
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // Do any additional setup after loading the view from its nib.
    _fileArray = [[NSMutableArray alloc] init];
    _jsonData = [[NSMutableData alloc]init];
//    NSLog(@"%@",self.parentFolder.folderName);
    if ([self.parentFolder.type isEqualToString:@"6"]){
        _contentView.hidden = NO;
        m=1;
      [self getMoreLocData];
    }else {
      [self requestFileList];
    }
}
-(NSString *)getPlistPathWithFileMark:(BOOL)filemark
{
    UserModel *user = [UserModel sharedInstance];
    if (filemark){
        return [self documentPathWith:[NSString stringWithFormat:@"%@_cmxName.plist",user.userID]];
    }else{
        return [self documentPathWith:[NSString stringWithFormat:@"%@_cmx.plist",user.userID]];
    }
}
-(void)getMoreLocData
{
    [_fileArray removeAllObjects];
    
    NSString *namePlistPath = [self getPlistPathWithFileMark:YES];
    AllNameArr = [NSMutableArray arrayWithContentsOfFile:namePlistPath];
    NSString *plistPath = [self getPlistPathWithFileMark:NO];
    AllInfoDic = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
    
    for (int i = 0;i< AllNameArr.count;i++){
        if (i>=10*m) return;
        //因为文件名会变动，所以获取时间通过键值或plist文件中的文件名
        NSMutableDictionary *doc = [AllInfoDic objectForKey:[AllNameArr objectAtIndex:AllNameArr.count-i-1]];
        NSArray *nub = [doc allKeys];
        for (int n= 0;n<nub.count;n++){
            NSString *title = nub[n];
            if (![title isEqualToString:@"uploadState"]){
              NSString *KeyName = [nub objectAtIndex:n];
                NSString *ValueName = [doc objectForKey:KeyName];
                NSString *StateStr = [doc objectForKey:@"uploadState"];
                //本地录音文件内容
                //把字符串转成时间
                NSString *time = [KeyName substringWithRange:NSMakeRange(0, KeyName.length-4)];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
                NSDate *date = [dateformatter dateFromString:time];
                
                NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc] init];
                [dateformatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [dateformatter1 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
                NSString *timeStr = [dateformatter1 stringFromDate:date];
                NSString *sizeStr = [self getSizeStrWithFileName:ValueName];
                //得到模型数据
                FileModel * file = [[FileModel alloc] init];
                file.name = ValueName;
                file.targetName = [self documentPathWith:file.name];
                file.size = sizeStr;
                file.datatime = timeStr;
                file.folderName = StateStr;
                file.folderId = _parentFolder.folderID;
                file.type = 2;
                file.isFolder = NO;
                [_fileArray addObject:file];

             }
        }
        
    }

}
-(NSString *)getSizeStrWithFileName:(NSString *)fileName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    double fileSize = 0;
    NSString *filePath = [self documentPathWith:fileName];
    NSString *sizeStr = nil;
    if([manager fileExistsAtPath:filePath])
    {
        fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0;
    }
    if (fileSize > 1024){
        sizeStr = [NSString stringWithFormat:@"%.02fM",fileSize/1024];
    } else {
        sizeStr = [NSString stringWithFormat:@"%.0fK",fileSize];
    }
    return sizeStr;
    
}
-(NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}

-(void)changeName:(NSString *)name{

    NSLog(@"***************%@",name);
    _fileArray = [[NSMutableArray alloc] init];
    _jsonData = [[NSMutableData alloc]init];
    [self requestFileList];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//#pragma - mark satusBar 颜色
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//    statusBarView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:statusBarView];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [Tool getOSCNotice2:@"nil"];
    AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delgate hiddenTab:YES];
    [MobClick beginLogPageView:@"证据列表"];
    if ([self.parentFolder.type isEqualToString:@"6"]){
        _contentView.hidden = NO;
        [self getMoreLocData];
    }
    [_contentView reloadData];
    if (self.isRootFloder){
        customRight.hidden = NO;
    }else{
        customRight.hidden = YES;
    }
}
-(void)touch
{
    backView.hidden = YES;
    midView.hidden = YES;
}
   
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 0){
        
    }else if(btn.tag == 1){
        
    }else if(btn.tag == 2){
        
    }else if(btn.tag == 3){
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //隐藏
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    if (nil != _requestDelete) {
        [_requestDelete clearDelegatesAndCancel];
        _requestDelete = nil;
    }
    
    if (nil != _requestRestore) {

        [_requestRestore clearDelegatesAndCancel];
        _requestRestore = nil;
    }
    if (nil != _requestRestoreAll) {

        [_requestRestoreAll clearDelegatesAndCancel];
        _requestRestoreAll = nil;
    }
    if (nil != _requestClearAll) {

        [_requestClearAll clearDelegatesAndCancel];
        _requestClearAll = nil;
    }
    if (nil != _requestApplygz){
        [_requestApplygz clearDelegatesAndCancel];
        _requestApplygz = nil;
    }
    if (nil != _request) {
        [_request clearDelegatesAndCancel];
        _request = nil;
    }
    [MobClick endLogPageView:@"证据列表"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)edit:(UIButton *)btn
{
    UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil
                    delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"新建文件夹", nil];
    sheet.delegate = self;
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (void)handleBackButtonClick:(UIButton *)but
{
    [_contentView reloadData];
    if (nil != _request) {
        [_request cancel];
        _request = nil;
    }
    if ([_parentFolder.folderName isEqualToString:@"回收站"]){
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)handleEditItemClick:(UIButton *)btn
{
    if (btn.selected){
        backV = [[UIView alloc] init];
        backV.frame = CGRectMake(214,55, 106, 82);
        [self.view addSubview:backV];
        
       UIImageView *backImg = [[UIImageView alloc] init];
        backImg.image = [UIImage imageNamed:@"bg_pop"];
        backImg.frame = CGRectMake(0,0, 106, 82);
        [backV addSubview:backImg];
        btn.selected = NO;
        
        upBtn = [[proBtn alloc] init];
        upBtn.frame = CGRectMake(5, 10, 96, 30);
        upBtn.layer.masksToBounds = YES;
        upBtn.layer.cornerRadius = 2;
        [upBtn setImage:[UIImage imageNamed:@"btn_deleteall"] forState:UIControlStateNormal];
        upBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [upBtn setTitle:@"清除全部" forState:UIControlStateNormal];
        [upBtn setTitleColor:[URLUtil colorWithHexString:@"022237"] forState:UIControlStateNormal];
        [upBtn addTarget:self action:@selector(proBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        upBtn.tag = 10;
        [backV addSubview:upBtn];
        
        downBtn = [[proBtn alloc] init];
        downBtn.frame = CGRectMake(5, 50, 96, 30);
        downBtn.layer.masksToBounds = YES;
        downBtn.layer.cornerRadius = 2;
        [downBtn setImage:[UIImage imageNamed:@"btn_recover"] forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(proBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [downBtn setTitleColor:[URLUtil colorWithHexString:@"022237"] forState:UIControlStateNormal];
        downBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [downBtn setTitle:@"还原全部" forState:UIControlStateNormal];
        downBtn.tag = 20;
        [backV addSubview:downBtn];
        
    }else {
        btn.selected = YES;
        [backV removeFromSuperview];
    }
}
-(void)proBtnClick:(proBtn *)btn
{
    if (btn.tag == 10){
        _alertRecoverAll = [[UIAlertView alloc]
                            initWithTitle:@"提示"
                            message:@"确定要清空全部"
                            delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alertRecoverAll.delegate = self;
        _alertRecoverAll.tag = btn.tag;
        [_alertRecoverAll show];
    }else if (btn.tag == 20){
        _alertRecoverAll = [[UIAlertView alloc]
                            initWithTitle:@"提示"
                            message:@"确定要还原全部"
                            delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alertRecoverAll.delegate = self;
        _alertRecoverAll.tag = btn.tag;
        [_alertRecoverAll show];

    }
}
#pragma UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _innerView) {
        return 2;
    }
    
    if (_fileArray.count == 0) {
        return 1;
    }
    
    if (_fileArray.count >= 10)
    {
      return _fileArray.count + 1;
    }
    
    return _fileArray.count ;
}

-(NSMutableAttributedString *)changeStringColorWithTextString:(NSString *)textstr MyStr:(NSString *)mystr Log:(int)log
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textstr];
    UIColor *red = [UIColor blueColor];
    [attrString addAttribute:NSForegroundColorAttributeName value:red range:NSMakeRange(log,mystr.length)];
    return attrString;
 }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _innerView){
        
        UITableViewCell * incell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"incell"];
        incell.textLabel.font = [UIFont systemFontOfSize:11];
        incell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        
        if (indexPath.row == 0){

            incell.textLabel.text = @"清除全部";
        }else {
            incell.textLabel.text = @"还原全部";
        }
        
        return incell;
    }
    
    ListProofCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (nil == cell) {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"ListProofCell" owner:self options:nil];
        cell = [objs lastObject];
       
    }
    
    if (_fileArray.count == 0) {
        
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"没有文件";
        
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.labTime.hidden = YES;
        cell.imageTitle.hidden = YES;
        tableView.userInteractionEnabled = NO;
        
    }
    
    else if (_fileArray.count == indexPath.row){
        cell.labMessage.hidden = NO;
        cell.labMessage.text = @"加载更多";
        cell.labName.hidden = YES;
        cell.labSize.hidden = YES;
        cell.labTime.hidden = YES;
        cell.imageTitle.hidden = YES;
//        tableView.userInteractionEnabled = NO;
        
    }
else {
        if ([self.parentFolder.type isEqualToString:@"6"]){
            FileModel *model = [_fileArray objectAtIndex:indexPath.row];
            cell.labSize.text = model.size;
            cell.labTime.text = model.datatime;
            if ([model.folderName isEqualToString:@"未上传"]){
            cell.labName.text = [NSString stringWithFormat:@"本地现场_%@(未上传)",model.name];
            } else {
                NSString *proStr = [NSString stringWithFormat:@"本地现场_%@(已上传至云端%@文件夹中)",model.name,model.folderName];
                cell.labName.attributedText = [self changeStringColorWithTextString:proStr MyStr:model.folderName Log:12+model.name.length];
            }
            cell.labName.numberOfLines = 0;
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_call"]];
            
        } else {
        FileModel * file = [_fileArray objectAtIndex:indexPath.row];
        NSFileManager * manager = [NSFileManager defaultManager];
        cell.labSize.text = [NSString getAutoKBorMBNumber:file.size];
        cell.labTime.text = file.datatime;
        cell.labName.text = file.name;
        cell.labName.numberOfLines = 0;
        if (file.isFolder) {
            
            cell.labName.text = file.name ;
            [cell.imageTitle setImage:[UIImage imageNamed:@"file_other"]];
            
        }
        else if (file.type == kVideoFile) {
                        
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];

            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_video"]];
                
            }
            
        }else if (file.type == kPhotoFile) {
                        
            cell.labName.text = file.name;//[NSString trimeExtendName:file.name];
            //如果下载并解密完成 这路径下就会存在这个文件
            NSString * path = [[Sandbox thumbnail]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",file.name,file.serverFileId]];
            
            if ([manager fileExistsAtPath:path]) {
                UIImage * image =   [[UIImage alloc] initWithContentsOfFile:path];
                [cell.imageTitle setImage:image];
            }else {
                [cell.imageTitle setImage:[UIImage imageNamed:@"icon_picture"]];
                
                
            }

        }else if (file.type == kVoiceFile) {
            
           
            cell.labName.text = file.name;
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_call"]];
        }
        else {
            
            cell.labName.text = file.name;
            [cell.imageTitle setImage:[UIImage imageNamed:@"icon_other"]];
        }
        
         tableView.userInteractionEnabled = YES;
    }
}
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _innerView) {
        return 50.0f;
    }
    
    return  75.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mRight.selected = YES;
    [backV removeFromSuperview];
    _currentLongPressCellIndex = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _innerView) {
        
        if (indexPath.row == 0){
            
            _alertRecoverAll = [[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"确定要清空全部"
                                delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _alertRecoverAll.delegate = self;
            _alertRecoverAll.tag = indexPath.row;
            [_alertRecoverAll show];
            
        }else {
            _alertRecoverAll = [[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"确定要还原全部"
                                delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _alertRecoverAll.delegate = self;
            _alertRecoverAll.tag = indexPath.row;
            [_alertRecoverAll show];

        }
    
        
        return;
    }
   
    
    if (_fileArray.count == 0 ) return;
    
    //加载更多
    if (_fileArray.count == indexPath.row) {
        if ([self.parentFolder.type isEqualToString:@"6"])
        {
            if (isLoadFileList) return;
        [DejalActivityView activityViewForView:self.view withLabel:@"加载数据中..."];
            m++;
            [self getMoreLocData];
            [_contentView reloadData];
            [DejalActivityView removeView];
            isLoadFileList = NO;
            return;
        } else {
             if (isLoadFileList) return;
             startIndex += 10;
             [self requestFileList];
             return;
        }
    }
    
    FileModel * file = [_fileArray objectAtIndex:indexPath.row];
    
    if (file.isFolder){
        ListProofView * listProof = [[ListProofView alloc] initWithNibName:@"ListProofView" bundle:nil];
        listProof.isSearchFrom = self.isSearchFrom;
        //临时父亲folder
        FolderModel * folder = [[FolderModel alloc]init];
        folder.folderID = file.serverFileId;
        folder.folderName = file.name;
        
        listProof.parentFolder = folder;
        listProof.isRootFloder = NO;
        //rootfolder 是为了向下传递root值
        listProof.rootFolder = self.rootFolder;
        if ([_parentFolder.folderName isEqualToString:@"回收站"]){
            listProof.isHuiFloder = YES;
        }
        listProof.rootFolderID = self.rootFolderID;
        customRight.hidden = YES;
        [self.navigationController pushViewController:listProof animated:YES];
        return;
    }
    
    
        //查找数据库看是否已经下载完成，如果完成破防或者预览
      if ([_parentFolder.folderName isEqualToString:@"回收站"]) {
        
        _alertRecover = [[UIAlertView alloc]
                               initWithTitle:@"提示"
                               message:@"是否恢复"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               otherButtonTitles:@"确定", nil];
        _alertRecover.tag = indexPath.row;
        
        [_alertRecover show];
        
        return;
    } else if ([self.parentFolder.type isEqualToString:@"6"]){
        fileStr = [_fileArray objectAtIndex:indexPath.row];
        if ([fileStr.folderName isEqualToString:@"未上传"]){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"播放",@"上传至云端",@"发送到...",@"重命名", nil];
        action.tag = 10;
        action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [action showInView:self.view];
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"播放",@"发送到...", nil];
            action.tag = 20;
            action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [action showInView:self.view];
        }
        return;
        
    } else {
        FileDetailView * detail = [[FileDetailView alloc]init];
        detail.file = file;
        detail.delegate = self;
        [self.navigationController pushViewController:detail animated:YES];
        
        return;
    }
 
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath1 = indexPath;
    fileStr1 = [_fileArray objectAtIndex:indexPath.row];
    if ([_parentFolder.folderName isEqualToString:@"回收站"]) {
        //回收站列表中调用
         alerthuishou = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要永久性的删除该文件吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerthuishou show];
        
    }else if ([self.parentFolder.type isEqualToString:@"6"]){
        alertbendi = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该文件吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertbendi.tag = indexPath.row;
        [alertbendi show];
      }else {
          alertother = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该文件吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
          [alertother show];
          
      }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _innerView) {
        return NO;
    }
    else if (_fileArray.count == indexPath.row) {
        return NO;
    }
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//删除除了回收站以外的列表用函数
- (void)requestDeleteFile:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.serverFileId forKey:@"fileIDs"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"删除文件:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"删除文件:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,DELETE_FOLDER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:user.userID forKey:@"userID"];
        [request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [request setPostValue:file.serverFileId forKey:@"fileIDs"];
    [request setPostValue:@"1" forKey:@"src"];
    [request setPostValue:APP_ID forKey:@"app_id"];
    [request setPostValue:VERSIONS forKey:@"v"];
    [request setPostValue:sig forKey:@"sig"];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    NSString * logstrurl = [NSString stringWithFormat:@"%@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
    debugLog(logstrurl);
    
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestDeleteFileStart:)];
    [request setDidFailSelector:@selector(requestDeleteFileFail:)];
    [request setDidFinishSelector:@selector(requestDeleteFileFinish:)];
    [request setDidReceiveDataSelector:@selector(requestDeleteFileReceiveData:didReceiveData:)];
    
    [request startAsynchronous];
}
- (void)requestFileList
{
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:_parentFolder.folderID forKey:@"folderID"];
    if([_parentFolder.folderName isEqualToString:@"回收站"]) {
        [dic setObject:@"0" forKey:@"folderType"];
    }
    [dic setObject:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
//    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,GET_FOLDERLIST_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _request = [[ASIFormDataRequest alloc] initWithURL:url];
    [_request setPostValue:user.userID forKey:@"userID"];
    [_request setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_request setPostValue:_parentFolder.folderID forKey:@"folderID"];
    [_request setPostValue:@"1" forKey:@"src"];
    [_request setPostValue:APP_ID forKey:@"app_id"];
    [_request setPostValue:VERSIONS forKey:@"v"];
    [_request setPostValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"startIndex"];
    [_request setPostValue:sig forKey:@"sig"];
    
    //如果是回收站
    if([_parentFolder.folderName isEqualToString:@"回收站"]) {
        
        [_request setPostValue:@"0" forKey:@"folderType"];
        
        NSString * logstr = [NSString stringWithFormat:@"回收站列表: %@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&folderID=%@&folderType=%@&startIndex=%d&sig=%@",urls,user.userID,user.phoneNumber,APP_ID,VERSIONS,_parentFolder.folderID,@"0",startIndex,sig];
        debugLog(logstr);
    }else {
        
        NSString * logstr = [NSString stringWithFormat:@"列表: %@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&folderID=%@&startIndex=%d&sig=%@",urls,user.userID,user.phoneNumber,APP_ID,VERSIONS,_parentFolder.folderID,startIndex,sig];
        debugLog(logstr);
    }
    
    [_request setDelegate:self];
    [_request setDidStartSelector:@selector(requestFolderListStart:)];
    [_request setDidFailSelector:@selector(requestFolderListFail:)];
    [_request setDidFinishSelector:@selector(requestFolderListFinish:)];
    [_request setDidReceiveDataSelector:@selector(requestFolderListReceiveData:didReceiveData:)];
    
    [_request startAsynchronous];
}

- (void)requestFolderListStart:(ASIHTTPRequest *)request
{
    logmessage;
    isLoadFileList = YES;
    [DejalActivityView activityViewForView:self.view withLabel:@"加载数据中..."];
}
- (void)requestFolderListFail:(ASIHTTPRequest *)request
{

    [DejalActivityView removeView];
}
- (void)requestFolderListFinish:(ASIHTTPRequest *)request
{

    NSDictionary * jsonDic = [_jsonData objectFromJSONData];
    
    debugLog([jsonDic description]);
    
    NSArray * array = [jsonDic objectForKey:@"data"];

    for(int i = 0; i < array.count; i++) {
        
        NSDictionary * temp = [array objectAtIndex:i];
        NSString * type =     [temp objectForKey:@"type"];
        //folderID这个变量有歧义，服务器返回的是文件的id，或者文件夹的id
        //根据返回的信息不能判断出 文件属于那个文件夹下,所以还原的时候，也就无法本地更新
        //ProofView列表中的数量图标
        NSString * folderID = [temp objectForKey:@"folderID"]; 
        NSString * fName    = [[temp objectForKey:@"fName"] lowercaseString];
        NSString * size     = [temp objectForKey:@"size"];
        NSString * time =     [temp objectForKey:@"createTime"];
        
        if ([type intValue] == 1) {  //1文件 0文件夹
            
            FileModel * file = [[FileModel alloc] init];
            file.name = fName;
            file.size = size;
            file.datatime = time;
            file.folderId = _parentFolder.folderID;//[NSString stringWithFormat:@"%d",[folderID intValue]];
            file.serverFileId = [NSString stringWithFormat:@"%d",[folderID intValue]];     //证据列表返回的folderID 就是 serverFileId
            
            file.type = [FileModel getFileType:file.name];
             if (file.type == kVideoFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox videoPath] stringByAppendingPathComponent:cryptName];
            }
            else if (file.type == kPhotoFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox imagePath] stringByAppendingPathComponent:cryptName];
//                file.type = kPhotoFile;
                
            }
            else if (file.type == kVoiceFile) {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox voicePath] stringByAppendingPathComponent:cryptName];

            }
            //ios 不支持的文件类型
            else {
                
                NSString * cryptName = [NSString trimeExtendName:file.name unique:file.serverFileId];
                
                file.targetName = [[Sandbox otherFilePath] stringByAppendingPathComponent:cryptName];

            }
            
            [_fileArray addObject:file];
            
        }else { //文件夹
            
            FileModel * file = [[FileModel alloc] init];
            
            file.isFolder = YES;
            file.type = kFolderFile;   //解决bug新增加的变量
            file.name = fName;
            file.size = size;
            file.datatime = time;
            file.folderId = _parentFolder.folderID;//[NSString stringWithFormat:@"%d",[folderID intValue]];
            file.serverFileId = [NSString stringWithFormat:@"%d",[folderID intValue]];     //证据列表返回的folderID 就是 serverFileId
            
            [_fileArray addObject:file];
            
        }
        
        
    }//end for
    
    [DejalActivityView removeView];
    _contentView.hidden = NO;
    [_contentView reloadData];
    
    //清空
    [_jsonData setLength:0];
    isLoadFileList = NO;
    
}
- (void)requestFolderListReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    [_jsonData appendData:data];    
    
}

- (void)requestDeleteFileStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    

}
- (void)requestDeleteFileFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestDeleteFileFinish:(ASIHTTPRequest *)request
{
       if (startIndex == 0){
        [_fileArray removeAllObjects];
        [self requestFileList];
    } else {
        FileModel * file = [request.userInfo objectForKey:@"File"];
        [_fileArray removeObject:file];
        [_contentView reloadData];

    }
 }
- (void)requestDeleteFileReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"删除文件 dic %@",dic);
    NSString *code = [dic objectForKey:@"code"];
    if ([code intValue] == 0){
        //通知更新列表
        FolderModel * folder = [[FolderModel alloc] init];
        folder.folderID = _parentFolder.folderID;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeDeleteFile object:folder];
    }
}


- (void)requestRestore:(FileModel *)file {
    
    UserModel * user = [UserModel sharedInstance];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    if (file.isFolder) {
        [dic setObject:file.serverFileId forKey:@"folderIDs"];
    }else {
        [dic setObject:file.serverFileId forKey:@"fileIDs"];
    }
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"回收站还原:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"回收站还原:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RESTORE_RECOVER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _requestRestore = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRestore setPostValue:user.userID forKey:@"userID"];
        [_requestRestore setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRestore setPostValue:@"1" forKey:@"src"];
    [_requestRestore setPostValue:APP_ID forKey:@"app_id"];
    [_requestRestore setPostValue:VERSIONS forKey:@"v"];
    [_requestRestore setPostValue:sig forKey:@"sig"];
    
    [_requestRestore setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    if (file.isFolder) {
        
        [_requestRestore setPostValue:file.serverFileId forKey:@"folderIDs"];
        
        NSString * logstr = [NSString stringWithFormat:@"回收站还原: %@?userID=%@&folderIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
        
    }else {
        
        [_requestRestore setPostValue:file.serverFileId forKey:@"fileIDs"];
        NSString * logstr = [NSString stringWithFormat:@"回收站还原: %@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
    }
    
    
    [_requestRestore setDelegate:self];
    [_requestRestore setDidStartSelector:@selector(requestRestoreStart:)];
    [_requestRestore setDidFailSelector:@selector(requestRestoreFail:)];
    [_requestRestore setDidFinishSelector:@selector(requestRestoreFinish:)];
    [_requestRestore setDidReceiveDataSelector:@selector(requestRestoreReceiveData:didReceiveData:)];
    
    [_requestRestore startAsynchronous];

    
}
- (void)requestRestoreStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestRestoreFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestRestoreFinish:(ASIHTTPRequest *)request
{
    FileModel * file = [request.userInfo objectForKey:@"File"];
    [_fileArray removeObject:file];
    [_contentView reloadData];
//    [self requestFileList];
}
- (void)requestRestoreReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"恢复文件 dic %@",dic);
}


- (void)requestDelete:(FileModel *)file
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    if (file.isFolder) {
        [dic setObject:file.serverFileId forKey:@"folderIDs"];
    }else {
        [dic setObject:file.serverFileId forKey:@"fileIDs"];
    }
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"回收站删除:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"回收站删除:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,CLEAR_RECOVER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _requestDelete = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestDelete setPostValue:user.userID forKey:@"userID"];
        [_requestDelete setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestDelete setPostValue:@"1" forKey:@"src"];
    [_requestDelete setPostValue:APP_ID forKey:@"app_id"];
    [_requestDelete setPostValue:VERSIONS forKey:@"v"];
    [_requestDelete setPostValue:sig forKey:@"sig"];
    
    [_requestDelete setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    if (file.isFolder) {
        
        [_requestDelete setPostValue:file.serverFileId forKey:@"folderIDs"];
        
        NSString * logstr = [NSString stringWithFormat:@"回收站删除: %@?userID=%@&folderIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
        
    }else {
        
        [_requestDelete setPostValue:file.serverFileId forKey:@"fileIDs"];
        NSString * logstr = [NSString stringWithFormat:@"回收站还原: %@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
    }
    
    
    [_requestDelete setDelegate:self];
    [_requestDelete setDidStartSelector:@selector(requestDeleteStart:)];
    [_requestDelete setDidFailSelector:@selector(requestDeleteFail:)];
    [_requestDelete setDidFinishSelector:@selector(requestDeleteFinish:)];
    [_requestDelete setDidReceiveDataSelector:@selector(requestDeleteReceiveData:didReceiveData:)];
    
    [_requestDelete startAsynchronous];
    

}

- (void)requestDeleteStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestDeleteFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestDeleteFinish:(ASIHTTPRequest *)request
{
    
    if (startIndex == 0)
    {
      [_fileArray removeAllObjects];
      [self requestFileList];
    }else {
        FileModel * file = [request.userInfo objectForKey:@"File"];
        [_fileArray removeObject:file];
        [_contentView reloadData];
    }
    //add by liwzh 更新余量信息
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeLogInAgain object:nil];
}
- (void)requestDeleteReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    FileModel * file = [request.userInfo objectForKey:@"File"];
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"删除文件 dic %@",dic);
    NSString *code = [dic objectForKey:@"code"];
    if ([code intValue] == 0 &&file.type != kFolderFile){
        //通知更新列表
        FolderModel * folder = [[FolderModel alloc] init];
        folder.folderID = _parentFolder.folderID;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeDeleteFile object:folder];
    }
    
}

- (void)requestRestoreAll{
    
    UserModel * user = [UserModel sharedInstance];
    if (_fileArray.count == 0) return;
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RESTORE_RECOVER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _requestRestoreAll = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRestoreAll setPostValue:user.userID forKey:@"userID"];
        [_requestRestoreAll setPostValue:user.phoneNumber forKey:@"mobileNo"];
    NSMutableString * folders = [[NSMutableString alloc]init];
    NSMutableString * files = [[NSMutableString alloc]init];
    
    
    for (int i = 0; i < _fileArray.count; i++) {
        
        FileModel * file = [_fileArray objectAtIndex:i];
        
        if (file.isFolder) {
            
            [folders appendString:file.serverFileId];
            [folders appendString:@","];
            
        }else {
            [files appendString:file.serverFileId];
            [files appendString:@","];
        }
        
    }
    
    [_requestRestoreAll setPostValue:folders forKey:@"folderIDs"];
    [_requestRestoreAll setPostValue:files forKey:@"fileIDs"];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
        [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:folders forKey:@"folderIDs"];
    [dic setObject:files forKey:@"fileIDs"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"还原全部:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"还原全部:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    [_requestRestoreAll setPostValue:@"1" forKey:@"src"];
    [_requestRestoreAll setPostValue:APP_ID forKey:@"app_id"];
    [_requestRestoreAll setPostValue:VERSIONS forKey:@"v"];
    [_requestRestoreAll setPostValue:sig forKey:@"sig"];
    
    
    NSString * logstrurl = [NSString stringWithFormat:@"还原全部: %@?userID=%@&folderIDs=%@&fileIDs=%@",urls,user.userID,folders,files];
    debugLog(logstrurl);
    
    
    [_requestRestoreAll setDelegate:self];
    [_requestRestoreAll setDidStartSelector:@selector(requestRestoreAllStart:)];
    [_requestRestoreAll setDidFailSelector:@selector(requestRestoreAllFail:)];
    [_requestRestoreAll setDidFinishSelector:@selector(requestRestoreAllFinish:)];
    [_requestRestoreAll setDidReceiveDataSelector:@selector(requestRestoreAllReceiveData:didReceiveData:)];
    
    [_requestRestoreAll startAsynchronous];
}


- (void)requestRestoreAllStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestRestoreAllFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestRestoreAllFinish:(ASIHTTPRequest *)request
{
    [_fileArray removeAllObjects];
    [_contentView reloadData];
    [self requestFileList];
}
- (void)requestRestoreAllReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"恢复全部文件 dic %@",dic);
}



- (void)requestClearAll
{
    if (_fileArray.count == 0) return;
    
    UserModel * user = [UserModel sharedInstance];
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,CLEAR_RECOVER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    _requestClearAll = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestClearAll setPostValue:user.userID forKey:@"userID"];
    [_requestClearAll setPostValue:user.phoneNumber forKey:@"mobileNo"];
    NSMutableString * folders = [[NSMutableString alloc]init];
    NSMutableString * files = [[NSMutableString alloc]init];
    
    
    for (int i = 0; i < _fileArray.count; i++) {
        
        FileModel * file = [_fileArray objectAtIndex:i];
        
        if (file.isFolder) {
            
            [folders appendString:file.serverFileId];
            [folders appendString:@","];
            
        }else {
            [files appendString:file.serverFileId];
            [files appendString:@","];
        }
        
    }
    NSLog(@"---------folders:%@",folders);
    NSLog(@"---------files:%@",files);
    
    [_requestClearAll setPostValue:folders forKey:@"folderIDs"];
    [_requestClearAll setPostValue:files forKey:@"fileIDs"];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:folders forKey:@"folderIDs"];
    [dic setObject:files forKey:@"fileIDs"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
//    NSString * logstr = [NSString stringWithFormat:@"清空回收站:sig 原始 %@",result];
//    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
//    NSString * logstr2 = [NSString stringWithFormat:@"清空回收站:sig 加密后 %@",sig];
//    debugLog(logstr2);
    
    [_requestClearAll setPostValue:@"1" forKey:@"src"];
    [_requestClearAll setPostValue:APP_ID forKey:@"app_id"];
    [_requestClearAll setPostValue:VERSIONS forKey:@"v"];
    [_requestClearAll setPostValue:sig forKey:@"sig"];
    
    
    
//    NSString * logstrurl = [NSString stringWithFormat:@"清空全部: %@?userID=%@&folderIDs=%@&fileIDs=%@",urls,user.userID,folders,files];
//    debugLog(logstrurl);
    
    
    [_requestClearAll setDelegate:self];
    [_requestClearAll setDidStartSelector:@selector(requestClearAllStart:)];
    [_requestClearAll setDidFailSelector:@selector(requestClearAllFail:)];
    [_requestClearAll setDidFinishSelector:@selector(requestClearAllFinish:)];
    [_requestClearAll setDidReceiveDataSelector:@selector(requestClearAllReceiveData:didReceiveData:)];
    
    [_requestClearAll startAsynchronous];

}

- (void)requestClearAllStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestClearAllFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestClearAllFinish:(ASIHTTPRequest *)request
{
    [_fileArray removeAllObjects];
    [_contentView reloadData];
//    [self requestFileList];
    //add by liwzh 更新余量信息
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeLogInAgain object:nil];
}
- (void)requestClearAllReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"清空全部文件 dic %@",dic);
}

#pragma mark zxypopDelegate
-(void)popoView:(ZSYTextPopView *)popview content:(NSString *)content clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"popview---%ld",(long)popview.tag);
//    NSLog(@"content---content:-%@",content);
//    NSLog(@"content---clickedButtonAtIndex:%ld",(long)buttonIndex);
    if (popview.tag == 1 && buttonIndex == 1) {
//        CustomAlertView * alert = (CustomAlertView *)alertView;
//        NSString * keyword = [alert getKeyWord];
        //修改文件夹名字
        [self requestRenameFolder:content];
    }else if (popview.tag == 2 && buttonIndex == 1) {
        if ([self.parentFolder.type isEqualToString:@"6"]){
            NSString *newName = [NSString stringWithFormat:@"%@.wav",content];
            NSString *namePlistPath = [self getPlistPathWithFileMark:YES];
             for (int n=0;n< AllNameArr.count;n++){
                NSString *name = AllNameArr[n];
                if ([name isEqualToString:fileStr.name]){
                    [AllNameArr removeObjectAtIndex:n];
                    [AllNameArr insertObject:newName atIndex:n];
                }
            }
            [AllNameArr writeToFile:namePlistPath atomically:YES];

            NSString *plistPath = [self getPlistPathWithFileMark:NO];
             for (int i = 0;i<_fileArray.count;i++){
                FileModel *filemodel = [_fileArray objectAtIndex:i];
            if ([filemodel.name isEqualToString:fileStr.name]){
                //把当前路径下的文件名改了
                NSFileManager *manager = [NSFileManager defaultManager];
                if ([manager fileExistsAtPath:[self documentPathWith:filemodel.name]]){
                    NSString *newPath = [self documentPathWith:newName];
                    [manager moveItemAtPath:[self documentPathWith:filemodel.name] toPath:newPath error:nil];
                }
                //改当前表中的数据及Plist文件中的名字
                NSMutableDictionary *Doc = [AllInfoDic objectForKey:filemodel.name];
                NSArray *keyArr = [Doc allKeys];
                for (int n=0;n<keyArr.count;n++){
                    NSString *keyName = keyArr[n];
                    if (![keyName isEqualToString:@"uploadState"]){
                        [Doc setValue:newName forKey:keyName];
                        [AllInfoDic removeObjectForKey:filemodel.name];
                        [AllInfoDic setValue:Doc forKey:newName];
                        [AllInfoDic writeToFile:plistPath atomically:YES];
                    }
                }
                
                
                filemodel.name = newName;
                filemodel.targetName = [self documentPathWith:filemodel.name];
                [_fileArray removeObjectAtIndex:i];
                [_fileArray insertObject:filemodel atIndex:i];
                [_contentView reloadData];
                return;
                }
            }
        }else {
        //修改文件名字
        [self requestRename:content];
        }
    
    }else if (popview.tag == 3 && buttonIndex == 1){
        
        //创建文件夹名字
        [self requestCreateFolder:content];
    
    }
    
    
}
//修改文件夹名字
-(void)startTimer{
    
    ZSYTextPopView*RenameView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    RenameView.titleName.text = @"输入文件夹名";
    RenameView.maxLength=60;
    RenameView.tag=1;
    RenameView.myDelegate=self;
    [RenameView show];



}
//修改文件名字
-(void)startTimerAlert4RenameTimer{
    
    ZSYTextPopView*RenameView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    RenameView.titleName.text = @"输入文件名";
    RenameView.maxLength=60;
    RenameView.tag=2;
    RenameView.myDelegate=self;
    [RenameView show];

}
//创建文件夹名字
-(void)startAddFolder{
    
    ZSYTextPopView*AddFolderView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    AddFolderView.titleName.text = @"输入文件夹名";
    AddFolderView.maxLength=60;
    AddFolderView.tag=3;
    AddFolderView.myDelegate=self;
    [AddFolderView show];
}

//重命名文件
-(void)resetName
{
    
}
#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alerthuishou == alertView){
        if (buttonIndex == 0){
            
        }else {
            [self requestDelete:fileStr1];
        }
        return;
    }else if (alertbendi == alertView){
        if (buttonIndex == 0){
            
        }else {
            NSFileManager *manager = [NSFileManager defaultManager];
            fileStr1 = [_fileArray objectAtIndex:alertbendi.tag];
            NSString *filePath = [self documentPathWith:fileStr1.name];
            if ([manager fileExistsAtPath:filePath]){
                [manager removeItemAtPath:filePath error:nil];
            }
            NSString *namePlistPath = [self getPlistPathWithFileMark:YES];
            [AllNameArr removeObjectAtIndex:AllNameArr.count- alertbendi.tag -1];
            [AllNameArr writeToFile:namePlistPath atomically:YES];
            
            NSString *plistPath = [self getPlistPathWithFileMark:NO];
            [AllInfoDic removeObjectForKey:fileStr1.name];
            [AllInfoDic writeToFile:plistPath atomically:YES];
            //删除现有模型数据中的当前行
            [_fileArray removeObjectAtIndex:alertbendi.tag];
            [_contentView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationLeft];  //删除对应数据的cell
            
            //通知更新列表
            FolderModel * folder = [[FolderModel alloc] init];
            folder.folderID = _parentFolder.folderID;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeDeleteFile object:folder];
        }
        return;
    }else if (alertother == alertView){
        if (buttonIndex == 0){
            
        }else{
            if (fileStr.type == kFolderFile){
                //删除文件夹
                [self requestDelete:fileStr1];
            }else {
                //文件列表中调用
                [self requestDeleteFile:fileStr1];
            }
        }
        return;
    }else if (_alertUpload == alertView){
        if (buttonIndex == 0){
            
        }else if(buttonIndex == 1) {
            [self upload];
        }
        return;
    }else if(_alertRecoverAll == alertView) {
        
        int index = alertView.tag;
        if (index == 10) {
            [self handleEditItemClick:mRight];
            
            //清空全部
            if (buttonIndex == alertView.firstOtherButtonIndex)
            {
                [self requestClearAll];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeDeleteAllFile object:nil];
                //add by liwzh 更新余量信息
                 [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeLogInAgain object:nil];
            }

        }else  {
            [self handleEditItemClick:mRight];

            //还原全部
            if (buttonIndex == alertView.firstOtherButtonIndex)
            {
                [self requestRestoreAll];
                
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NoticeRestoreAllFile object:_fileArray];
            }
        }
        
        return;
        
    }
    
    int index = alertView.tag;
    FileModel * file = nil;
    
    if (_fileArray.count > 0){
       file = [_fileArray objectAtIndex:index];
    }
    
    if (_alertRecover == alertView) {
        
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            //恢复回收站数据
            [self requestRestore:file];
        }
        
    }// 新建文件夹操作
    else if (_alert4Folder == alertView)
    {
        CustomAlertView * alert = (CustomAlertView *)alertView;
        NSString * keyword = [alert getKeyWord];
        
        if (alert == _alert4Folder) {
            [self requestCreateFolder:keyword];
        }
        
    }//修改文件名称
    else if (_alert4Rename == alertView) {
        
        if (buttonIndex == 0){
            
        }
        else {
            CustomAlertView * alert = (CustomAlertView *)alertView;
            NSString * keyword = [alert getKeyWord];
            if ([self.parentFolder.type isEqualToString:@"6"]){
            NSString *newName = [NSString stringWithFormat:@"%@.wav",keyword];
            
            //修改文件名
            NSString *namePlistPath = [self getPlistPathWithFileMark:YES];
            for (int n = 0; n< AllNameArr.count;n++){
                    NSString *name = AllNameArr[n];
                    if ([name isEqualToString:fileStr.name]){
                        [AllNameArr removeObjectAtIndex:n];
                        [AllNameArr insertObject:newName atIndex:n];
                    }
                }
                [AllNameArr writeToFile:namePlistPath atomically:YES];
            //修改文件信息
            NSString *plistPath = [self getPlistPathWithFileMark:NO];
                 for (int i = 0;i<_fileArray.count;i++){
                    FileModel *filemodel = [_fileArray objectAtIndex:i];
                    if ([filemodel.name isEqualToString:fileStr.name]){
                        
                    //把当前路径下的文件名改了
                    NSFileManager *manager = [NSFileManager defaultManager];
                    if ([manager fileExistsAtPath:[self documentPathWith:filemodel.name]]){
                            NSString *newPath = [self documentPathWith:newName];
                            [manager moveItemAtPath:[self documentPathWith:filemodel.name] toPath:newPath error:nil];
                        }
                        //改当前表中的数据及Plist文件中的名字
                        NSMutableDictionary *Doc = [AllInfoDic objectForKey:filemodel.name];
                        NSArray *keyArr = [Doc allKeys];
                for (int n=0;n<keyArr.count;n++){
                    NSString *keyName = keyArr[n];
                if (![keyName isEqualToString:@"uploadState"]){
                    [Doc setValue:newName forKey:keyName];
                    [AllInfoDic removeObjectForKey:filemodel.name];
                    [AllInfoDic setValue:Doc forKey:newName];
                    [AllInfoDic writeToFile:plistPath atomically:YES];
                    }
                }
                        
                filemodel.name = newName;
                filemodel.targetName = [self documentPathWith:filemodel.name];

                [_fileArray removeObjectAtIndex:i];
                [_fileArray insertObject:filemodel atIndex:i];
                [_contentView reloadData];
                    }
                }
                
            } else {
                [self requestRename:keyword];
            }
            
        }
        
        
    }//修改文件夹名称
    else if (_alert4RenameFolder == alertView)
    {
        if (buttonIndex == 0){
            
        }
        else {
            CustomAlertView * alert = (CustomAlertView *)alertView;
            NSString * keyword = [alert getKeyWord];
            
            [self requestRenameFolder:keyword];
        }
    }
    else {
        
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            
            file.downStatus = ZIPFILE_DOWNLOADING;
            [DownloadFile launchRequest:file immediately:YES];
            
            DownLoadHistory *downLoadHisVC = [[DownLoadHistory alloc] init];
            downLoadHisVC.isPresent = YES;
            
            UINavigationController * navDown = [[UINavigationController alloc]initWithRootViewController:downLoadHisVC];
            
            [self.navigationController presentViewController:navDown animated:YES completion:nil];
            
        }
    }
}


- (void)requestRename:(NSString *)name
{
    NSString * fullname = name;
    
    FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
    
    NSRange range = [file.name rangeOfString:@"." options:NSBackwardsSearch];
    
    if (range.length > 0){
        
        NSString * ext = [file.name substringFromIndex:range.location];
        
        fullname = [NSString stringWithFormat:@"%@%@",name,ext];
    }
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.serverFileId forKey:@"fileID"];
    [dic setObject:fullname forKey:@"name"];
    /*
     if (file.isFolder) {
     [dic setObject:file.serverFileId forKey:@"folderIDs"];
     }else {
     [dic setObject:file.serverFileId forKey:@"fileIDs"];
     }
     */
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"修改文件夹名:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"修改文件夹名:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RE_NAME];
    NSURL * url = [NSURL URLWithString:urls];
    
    
    debugLog(@"%@%@?app_id=%@&v=%@&src=1&userID=%@&mobileNo=%@&fileID=%@&name=%@&sig=%@",ROOT_URL,RE_NAME,APP_ID,VERSIONS,user.userID,user.phoneNumber,file.folderId,fullname,sig);
    
    _requestRename = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRename setPostValue:user.userID forKey:@"userID"];
    [_requestRename setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRename setPostValue:@"1" forKey:@"src"];
    [_requestRename setPostValue:APP_ID forKey:@"app_id"];
    [_requestRename setPostValue:VERSIONS forKey:@"v"];
    [_requestRename setPostValue:file.serverFileId forKey:@"fileID"];
    [_requestRename setPostValue:fullname forKey:@"name"];
    [_requestRename setPostValue:sig forKey:@"sig"];
    
    [_requestRename setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    /*
     if (file.isFolder) {
     
     [_requestDelete setPostValue:file.serverFileId forKey:@"folderIDs"];
     
     NSString * logstr = [NSString stringWithFormat:@"回收站删除: %@?userID=%@&folderIDs=%@",urls,user.userID,file.serverFileId];
     debugLog(logstr);
     
     }else {
     
     [_requestDelete setPostValue:file.serverFileId forKey:@"fileIDs"];
     NSString * logstr = [NSString stringWithFormat:@"回收站还原: %@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
     debugLog(logstr);
     }
     */
    
    [_requestRename setDelegate:self];
    [_requestRename setDidStartSelector:@selector(requestRenameStart:)];
    [_requestRename setDidFailSelector:@selector(requestRenameFail:)];
    [_requestRename setDidFinishSelector:@selector(requestRenameFinish:)];
    [_requestRename setDidReceiveDataSelector:@selector(requestRenameReceiveData:didReceiveData:)];
    
    [_requestRename startAsynchronous];
    
    
}

- (void)requestRenameFolder:(NSString *)name
{
    FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
    
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:file.serverFileId forKey:@"folderID"];
    [dic setObject:name forKey:@"name"];
    /*
    if (file.isFolder) {
        [dic setObject:file.serverFileId forKey:@"folderIDs"];
    }else {
        [dic setObject:file.serverFileId forKey:@"fileIDs"];
    }
    */
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"修改文件夹名:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"修改文件夹名:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,RE_NAME_FOLDER];
    NSURL * url = [NSURL URLWithString:urls];
    
    
    debugLog(@"%@%@?app_id=%@&v=%@&src=1&userID=%@&mobileNo=%@&folderID=%@&name=%@&sig=%@",ROOT_URL,RE_NAME_FOLDER,APP_ID,VERSIONS,user.userID,user.phoneNumber,file.folderId,name,sig);
    
    _requestRename = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestRename setPostValue:user.userID forKey:@"userID"];
    [_requestRename setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestRename setPostValue:@"1" forKey:@"src"];
    [_requestRename setPostValue:APP_ID forKey:@"app_id"];
    [_requestRename setPostValue:VERSIONS forKey:@"v"];
    [_requestRename setPostValue:file.serverFileId forKey:@"folderID"];
    [_requestRename setPostValue:name forKey:@"name"];
    [_requestRename setPostValue:sig forKey:@"sig"];
    
    [_requestRename setUserInfo:[NSDictionary dictionaryWithObject:file forKey:@"File"]];
    
    /*
    if (file.isFolder) {
        
        [_requestDelete setPostValue:file.serverFileId forKey:@"folderIDs"];
        
        NSString * logstr = [NSString stringWithFormat:@"回收站删除: %@?userID=%@&folderIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
        
    }else {
        
        [_requestDelete setPostValue:file.serverFileId forKey:@"fileIDs"];
        NSString * logstr = [NSString stringWithFormat:@"回收站还原: %@?userID=%@&fileIDs=%@",urls,user.userID,file.serverFileId];
        debugLog(logstr);
    }
    */
    
    [_requestRename setDelegate:self];
    [_requestRename setDidStartSelector:@selector(requestRenameStart:)];
    [_requestRename setDidFailSelector:@selector(requestRenameFail:)];
    [_requestRename setDidFinishSelector:@selector(requestRenameFinish:)];
    [_requestRename setDidReceiveDataSelector:@selector(requestRenameReceiveData:didReceiveData:)];
    
    [_requestRename startAsynchronous];

    
}
- (void)requestRenameStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestRenameFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestRenameFinish:(ASIHTTPRequest *)request
{
    [_fileArray removeAllObjects];
    [self requestFileList];
}
- (void)requestRenameReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSDictionary * dic = [data objectFromJSONData];
    

    NSLog(@"清空全部文件 dic %@",dic);
}
#pragma mark db methods
- (FileModel *)queryById:(NSString *)srcid
{
    
    UserModel * user = [UserModel sharedInstance];
    
    DataBaseManager * db = [[DataBaseManager alloc]init];
    NSString * sql = [NSString stringWithFormat:@"select * from FileModel where serverFIleId = %@ and uid = %@",srcid,user.uid];
    debugLog(sql);
    
    FMResultSet * result =  [db query:sql];
    FileModel * file = [[FileModel alloc]init];
    
    while (result.next) {
        
        file.fid = [NSString stringWithFormat:@"%d",[result intForColumn:@"id"]];
        file.name = [result stringForColumn:@"name"];
        file.targetName = [result stringForColumn:@"targetname"];
        file.size = [result stringForColumn:@"size"];
        file.downStatus = [result intForColumn:@"status"];
        file.type = [result intForColumn:@"type"];
        file.srcid = [result stringForColumn:@"srcid"];
        file.actionType = [result intForColumn:@"actiontype"];
        file.datatime = [result stringForColumn:@"datatime"];
        file.serverFileId = [result stringForColumn:@"serverFIleId"];
    }
    [db close];
    
    return file;
    
}

#pragma mark PreviewDelegate

- (void)playingDone:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    switch ([[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue]) {
        case MPMovieFinishReasonUserExited:
            NSLog(@"用户点击完成");
            
            [self dismissMoviePlayerViewControllerAnimated];
            break;
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"自动播放完成");
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"播放出错");
//            [self  alertWithMessage:@"播放失败,文件出错"];
            break;
        default:
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
            break;
    }
}

//次方法会被调用多次
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //通过点击的point 判断按下的是那个cell
    
    CGPoint point = [gestureRecognizer locationInView:_contentView];
    
    NSIndexPath * indexPath = [_contentView indexPathForRowAtPoint:point];
    _indexPath4Sheet = indexPath;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        
        FileModel * filemodel = [_fileArray objectAtIndex:indexPath.row];
        
        if (indexPath != nil) {
            
            if (filemodel.isFolder) {
                UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重命名",@"删除", nil];
                sheet.delegate = self;
                
                sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [sheet showInView:self.view];
                sheet.tag =2 ;
                
            }else {
            
                UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重命名",@"删除",@"下载", nil];
                sheet.delegate = self;
                sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [sheet showInView:self.view];
                sheet.tag = 3;
            }
            
        }
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        
    {
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
    }

    
}
-(void)playAudioWithFile:(FileModel *)file
{
    Preview * preview = [[Preview alloc] initWithControler:self andFileModel:file];
    preview.delegate = self;
    [preview initialize];
}
-(void)sendToApp
{
    NSURL *URL = [NSURL fileURLWithPath:fileStr.targetName];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Present Open In Menu
        [self.documentInteractionController presentOpenInMenuFromRect:[self.view frame] inView:self.view animated:YES];
    }
    
 
}
-(void)upload
{
    FileModel *model = [[FileModel alloc] init];
    model.actionType = kUploadFile;
    model.name = fileStr.name;
    model.path = [NSURL fileURLWithPath:[self documentPathWith:fileStr.name]];
    NSLog(@"%@",model.path);
    model.type = kVoiceFile;
    model.targetName = [self documentPathWith:fileStr.name];
    model.image = [UIImage imageNamed:@"icon_upload"];
    
    NSData *data = nil;
    data = [NSData dataWithContentsOfFile:[self documentPathWith:fileStr.name]];
    model.md5 = [data MD5String];
    model.size = [NSString stringWithFormat:@"%d",data.length];
    data = nil;
    UploadView *upload = [[UploadView alloc] initWithNibName:[NSString stringWithFormat:@"UploadView%@",IS_IPHONE_5?@"-ip5":@""] bundle:nil];
    upload.model = model;
    [self.navigationController pushViewController:upload animated:YES];

}
 -(void)uploadData
{
    _alertUpload = [[UIAlertView alloc] initWithTitle:@"提示" message:@"免费赠送20M空间,超出部分5录音币/M" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:@"确定上传", nil];
     [_alertUpload show];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 10){
        //上传
        if (buttonIndex == 1){
            [self uploadData];
                        //重命名
        }else if (buttonIndex == 3){
            if (IOS7_OR_LATER) {
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTimerAlert4RenameTimer) userInfo:nil repeats:NO];
                
            }else{
                
                _alert4Rename = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件名"];
                _alert4Rename.delegate = self;
                _alert4Rename.maxLength = 60;
                [_alert4Rename show];
            }
            //播放
        }else if(buttonIndex == 0){
            [self playAudioWithFile:fileStr];
            //打开方式
        }else if(buttonIndex== 2){
            [self sendToApp];
        }else if (buttonIndex== 4){
            
        }

    }else if (actionSheet.tag == 20){
        if (buttonIndex== 0){
            [self playAudioWithFile:fileStr];
        }else if (buttonIndex == 1){
            [self sendToApp];
        }else {
            
        }
    }else {
    
    //tag 1 2 3
    UIActionSheet * tmp = actionSheet;
    int tag = tmp.tag;
    
    //编辑按钮操作
    if (tag == 1){
        
        if (buttonIndex == 0){
            [self addFolder:nil];
        }
        else if (buttonIndex == 1)
        {
            
        }
        
    }//文件夹操作
    else if (tag == 2)
    {
        
        if (buttonIndex == 0) {
            
            if (IOS7_OR_LATER) {
               
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];

            }else{
            
                _alert4RenameFolder = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件夹名"];
                _alert4RenameFolder.delegate = self;
                _alert4RenameFolder.maxLength = 60;
                [_alert4RenameFolder show];
            }
            
        }
        ///删除
        else if (buttonIndex == 1){
//            
//            FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
//            
//            FolderListView * fList = [[FolderListView alloc]init];
//            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:fList];
//            fList.myFileModel = file;
//            
//            
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
            [_fileArray removeAllObjects];
            [self requestDeleteFolder:file.serverFileId];

            
        }
        
        else if (buttonIndex == 2){
            

        }
        
        
    }//文件操作
    else if (tag == 3)
    {
        if (buttonIndex == 0) {
            
            if (IOS7_OR_LATER) {
                
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTimerAlert4RenameTimer) userInfo:nil repeats:NO];
                
            }else{

            _alert4Rename = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件名"];
            _alert4Rename.delegate = self;
            _alert4Rename.maxLength = 60;
            [_alert4Rename show];
        }
        }//移动文件
        else if (buttonIndex == 1){
//            
//            FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
//            
//            FolderListView * fList = [[FolderListView alloc]init];
//            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:fList];
//            fList.myFileModel = file;
//            
//            
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            
            FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
            
            [self requestDeleteFile:file];

            
        }//删除文件
        else if (buttonIndex == 3){
            
            
        }//下载文件
        else if (buttonIndex == 2){
            
            
            FileModel * file = [_fileArray objectAtIndex:_indexPath4Sheet.row];
            
            FileModel * tmp =  [self queryById:file.serverFileId];
            
            if (tmp.serverFileId != nil && ![_parentFolder.folderName isEqualToString:@"回收站"]) {
                
                if (tmp.downStatus != ZIPFILE_DOWNLOADED){
                    
                    DownLoadHistory *downLoadHisVC = [[DownLoadHistory alloc] init];
                    downLoadHisVC.isPresent = YES;
                    
                    UINavigationController * navDown = [[UINavigationController alloc]initWithRootViewController:downLoadHisVC];
                    
                    [self.navigationController presentViewController:navDown animated:YES completion:nil];
                    
                    
                }else { //已经下载完成了
                    
                    Preview *preview = [[Preview alloc] initWithControler:self andFileModel:tmp];
                    preview.delegate = self;
                    [preview initialize];
                }
                
                return;
            }
            //查找数据库看是否已经下载完成，如果完成破防或者预览
            else if ([_parentFolder.folderName isEqualToString:@"回收站"]) {
                
                _alertRecover = [[UIAlertView alloc]
                                 initWithTitle:@"提示"
                                 message:@"是否恢复"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@"确定", nil];
                _alertRecover.tag = _indexPath4Sheet.row;
                
                [_alertRecover show];
                
                return;
            }
            
            else {  //提示开启新的下载
                
                file.downStatus = ZIPFILE_DOWNLOADING;
                [DownloadFile launchRequest:file immediately:YES];
                
                
                
                DownLoadHistory *downLoadHisVC = [[DownLoadHistory alloc] init];
                downLoadHisVC.isPresent = YES;
                
                UINavigationController * navDown = [[UINavigationController alloc]initWithRootViewController:downLoadHisVC];
                
                [self.navigationController presentViewController:navDown animated:YES completion:nil];
            }
            
        }
    }
        
    }
}
- (void)requestApplygz:(FileModel *)model
{
    
    
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:model.serverFileId forKey:@"fileID"];
    NSString * result = [URLUtil generateNormalizedString:dic];
    NSString * logstr = [NSString stringWithFormat:@"立即公正:sig 原始 %@",result];
    debugLog(logstr);
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"立即公正:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,APPLYGZ_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    NSString * logurl = [NSString stringWithFormat:@"立即公正:%@%@?userID=%@&mobileNo=%@&src=1&app_id=%@&v=%@&fileID=%@&sig=%@",ROOT_URL,APPLYGZ_URL,user.userID,user.phoneNumber,APP_ID,VERSIONS,model.serverFileId,sig];
    debugLog(logurl);
    
    _requestApplygz = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [_requestApplygz setPostValue:user.userID forKey:@"userID"];
    [_requestApplygz setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestApplygz setPostValue:@"1" forKey:@"src"];
    [_requestApplygz setPostValue:APP_ID forKey:@"app_id"];
    [_requestApplygz setPostValue:VERSIONS forKey:@"v"];
    [_requestApplygz setPostValue:model.serverFileId forKey:@"fileID"];
    [_requestApplygz setPostValue:sig forKey:@"sig"];
    
    [_requestApplygz setDelegate:self];
    [_requestApplygz setDidStartSelector:@selector(requestApplygzStart:)];
    [_requestApplygz setDidFailSelector:@selector(requestApplygzFail:)];
    [_requestApplygz setDidFinishSelector:@selector(requestApplygzFinish:)];
    [_requestApplygz setDidReceiveDataSelector:@selector(requestApplygzReceiveData:didReceiveData:)];
    
    [_requestApplygz startAsynchronous];
}
- (void)requestApplygzStart:(ASIHTTPRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}
- (void)requestApplygzFail:(ASIHTTPRequest *)request
{
    
}
- (void)requestApplygzFinish:(ASIHTTPRequest *)request
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的文件公证申请已经提交，我们的客服会联系您，或者您可以         登陆我们官方网站进行申请" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

    [_contentView reloadData];
    [self requestFileList];
}
- (void)requestApplygzReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{

    NSDictionary * dic = [data objectFromJSONData];
    NSLog(@"立即公正 dic %@",dic);
}
#pragma UIDocumentInteractionControllerDelegate methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}
- (void)handleOtherFile:(FileModel *)file
{
    NSString * urlName = file.targetName;
    [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL fileURLWithPath:urlName];
    
    NSLog(@"urlstring %@",file.targetName);
    
    
    if (_docInteractionController == nil)
    {
        _docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        
        _docInteractionController.delegate = self;
    }
    else
    {
        _docInteractionController.URL = url;
    }
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    //    [_docInteractionController presentOptionsMenuFromRect:navRect inView:_controler.view  animated:YES];
    [_docInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
}

- (void)addFolder:(UIButton *)btn
{
    
    if (IOS7_OR_LATER) {
        
         [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startAddFolder) userInfo:nil repeats:NO];
        
    }else{
    
        _alert4Folder = [[CustomAlertView alloc] initWithAlertTitle:@"输入文件夹名"];
        _alert4Folder.delegate = self;
        _alert4Folder.maxLength = 60;
        [_alert4Folder show];
    
    }
    

}

- (void)requestCreateFolder:(NSString *)name
{
    
    NSString * temp = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([temp isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
        
    }
    
    
    BOOL charact = [NSString isIncludeSpecialCharact:name];
    
    if (charact) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能包含特殊字符" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSString * regex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:name];
    
    if (!isMatch) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹名称不能包含特殊符号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [_fileArray removeAllObjects];
    
    UserModel * user = [UserModel sharedInstance];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:APP_ID forKey:@"app_id"];
    [dic setObject:VERSIONS forKey:@"v"];
    [dic setObject:@"1" forKey:@"src"];
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:name forKey:@"folderName"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    [dic setObject:self.parentFolder.folderID forKey:@"parentFolderId"];
    [dic setObject:self.rootFolderID forKey:@"rootFolderID"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"创建文件夹:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"创建文件夹:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,CREATE_FOLDER_URL];
    
    NSString * log = [NSString stringWithFormat:@"%@%@?userID=%@&mobileNo=%@&folderName=%@&src=1&app_id=%@&v=%@&sig=%@&parentFolderId=%@&rootFolderID=%@",ROOT_URL,CREATE_FOLDER_URL,user.userID,user.phoneNumber,name,APP_ID,VERSIONS,sig,self.parentFolder.folderID,self.rootFolderID];
    debugLog(@"创建文件夹 %@",log);
    
    NSURL * url = [NSURL URLWithString:urls];
    _requestCreateFolder = [[ASIFormDataRequest alloc] initWithURL:url];
    [_requestCreateFolder setPostValue:user.userID forKey:@"userID"];
    [_requestCreateFolder setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestCreateFolder setPostValue:name forKey:@"folderName"];
    
    [_requestCreateFolder setPostValue:@"1" forKey:@"src"];
    [_requestCreateFolder setPostValue:APP_ID forKey:@"app_id"];
    [_requestCreateFolder setPostValue:VERSIONS forKey:@"v"];
    [_requestCreateFolder setPostValue:sig forKey:@"sig"];
    [_requestCreateFolder setPostValue:self.parentFolder.folderID forKey:@"parentFolderId"];
    [_requestCreateFolder setPostValue:self.rootFolderID forKey:@"rootFolderID"];
    
    [_requestCreateFolder setDelegate:self];
    [_requestCreateFolder setDidStartSelector:@selector(requestStart:)];
    [_requestCreateFolder setDidFailSelector:@selector(requestFail:)];
    [_requestCreateFolder setDidFinishSelector:@selector(requestFinish:)];
    [_requestCreateFolder setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    
    [_requestCreateFolder startAsynchronous];
}
#pragma ASIHttpRequest Delegate method
- (void)requestStart:(ASIHTTPRequest *)request
{
    /*
    if (request == _requestRefresh) {
        
        [self handleActivityStart];
     
    }
    else if (request == _requestCreateFolder){
        
    }
    else if (request == _requestDeleteFolder){
        [self handleActivityStart];
    }
     */
}
- (void)requestFail:(ASIHTTPRequest *)request
{
    /*
    if (request == _requestRefresh) {
        
        _customLeft.enabled = YES;
        [self handleActivityStop];
        
    }
    else if (request == _requestCreateFolder){
        
    }
    else if (request == _requestDeleteFolder){
        [self handleActivityStop];
    }
    */
}
- (void)requestFinish:(ASIHTTPRequest *)request
{
    
//    if (request == _requestRefresh) {
        /*
        _customLeft.enabled = YES;
        
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.folderArray removeAllObjects];
        
        //清空
        [_folderArray removeAllObjects];
        
        NSDictionary * jsonDic = [_jsonFolderList objectFromJSONData];
        
        NSArray * array = [jsonDic objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i ++) {
            
            NSDictionary * tmp = [array objectAtIndex:i];
            NSString * dataNum = [tmp objectForKey:@"dataNum"];
            NSString * folderID = [tmp objectForKey:@"folderID"];
            NSString * folderName = [tmp objectForKey:@"folderName"];
            NSString * type = [tmp objectForKey:@"type"];
            
            FolderModel * folder = [[FolderModel alloc] init];
            folder.dataNum = dataNum;
            folder.folderID = folderID;
            folder.folderName = folderName;
            folder.type = type;
            
            
            if ([@"回收站" isEqualToString:folderName]){
                
                _recover = folder;
                [_btnRecoverNum setTitle:_recover.dataNum forState:UIControlStateNormal];
                
                
            }else if ([@"音频视频" isEqualToString:folderName]
                      || [@"照片图片" isEqualToString:folderName]){
                
                [_folderArray addObject:folder];
                
                //添加到全局目录结构
                [app.folderArray addObject:folder];
                
            }
            else {
                
                [_folderArray addObject:folder];
                
            }
            
            NSString * logstr = [NSString stringWithFormat:@"ListFloder: folderID(%@),folderName(%@),folderType(%@),dataNum(%@)",folder.folderID,folder.folderName,folder.type,folder.dataNum];
            
            debugLog(logstr);
        }
        
        
        [self handleActivityStop];
        [_contentView reloadData];
        [_jsonFolderList setLength:0];
        
        [self doneLoadingTableViewData];
         */
        
//    }
//    else if (request == _requestCreateFolder){
    
//        [self requestFolderList];
        [self requestFileList];
//    }
    /*
    else if (request == _requestDeleteFolder){
        
        [self handleActivityStop];
        
        NSDictionary * dic = request.userInfo;
        FolderModel * folder = [dic objectForKey:@"model"];
        [_folderArray removeObject:folder];
        
        [_contentView reloadData];
    }
    */
}
- (void)requestReceiveData:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
//    if (request == _requestRefresh) {
//        
//        [_jsonFolderList appendData:data];
//        
//    }
//    else if (request == _requestCreateFolder){
    
        NSDictionary * jsonDic = [data objectFromJSONData];
        NSString * code = [jsonDic objectForKey:@"code"];
        NSString * codeInfo =  [jsonDic objectForKey:@"codeInfo"];
        
        NSString * message = [NSString stringWithFormat:@"%@",codeInfo];
        
        if ([code intValue] != 0) {
            
            [self alertMessage:message];
        }
        
//    }
//    else if (request == _requestDeleteFolder){
//        
//    }
    
}
- (void)alertMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)requestDeleteFolder:(NSString *)folderID
{
    UserModel * user = [UserModel sharedInstance];
    
    NSMutableDictionary * dic = [URLUtil publicDataDictionary];
    
    [dic setObject:user.userID forKey:@"userID"];
    [dic setObject:folderID forKey:@"folderIDs"];
    [dic setObject:user.phoneNumber forKey:@"mobileNo"];
    
    NSString * result = [URLUtil generateNormalizedString:dic];
    
    NSString * logstr = [NSString stringWithFormat:@"删除文件夹:sig 原始 %@",result];
    debugLog(logstr);
    
    NSString * sig = [URLUtil md5:[NSString stringWithFormat:@"%@%@",result,ATTACH]];;
    NSString * logstr2 = [NSString stringWithFormat:@"删除文件夹:sig 加密后 %@",sig];
    debugLog(logstr2);
    
    NSString * urls = [NSString stringWithFormat:@"%@%@",ROOT_URL,DELETE_FOLDER_URL];
    NSURL * url = [NSURL URLWithString:urls];
    
    _requestDeleteFolder = [[ASIFormDataRequest alloc] initWithURL:url];
//    _requestDeleteFolder.userInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
    
    [_requestDeleteFolder setPostValue:user.userID forKey:@"userID"];
    [_requestDeleteFolder setPostValue:user.phoneNumber forKey:@"mobileNo"];
    [_requestDeleteFolder setPostValue:folderID forKey:@"folderIDs"];
    [_requestDeleteFolder setPostValue:@"1" forKey:@"src"];
    [_requestDeleteFolder setPostValue:APP_ID forKey:@"app_id"];
    [_requestDeleteFolder setPostValue:VERSIONS forKey:@"v"];
    [_requestDeleteFolder setPostValue:sig forKey:@"sig"];
    
    [_requestDeleteFolder setDelegate:self];
    [_requestDeleteFolder setDidStartSelector:@selector(requestStart:)];
    [_requestDeleteFolder setDidFailSelector:@selector(requestFail:)];
    [_requestDeleteFolder setDidFinishSelector:@selector(requestFinish:)];
    [_requestDeleteFolder setDidReceiveDataSelector:@selector(requestReceiveData:didReceiveData:)];
    [_requestDeleteFolder startAsynchronous];
}

- (void)updateListForder:(NSNotification*)notification{
    [_fileArray removeAllObjects];
    [self requestFileList];
}
@end

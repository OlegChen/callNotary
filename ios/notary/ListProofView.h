//
//  ListProofView.h
//  notary
//
//  Created by 肖 喆 on 13-3-28.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preview.h"
#import "ZSYTextPopView.h"
#import "FileDetailView.h"

@interface ListProofView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PreviewDelegate,UIActionSheetDelegate,ZSYPopoverDelegata,changeFileNameDelegate>
{
    NSString *    _titleString;
    FolderModel * _parentFolder;
    
    NSMutableArray * _fileArray;
    UITableView * _contentView;
    
    ASIFormDataRequest * _request;
    NSMutableData * _jsonData;
    
    UIAlertView * _alertRecover;
    UIAlertView * _alertRecoverAll;
    UIAlertView *_alertUpload;
    UIAlertView *alerthuishou;
    UIAlertView *alertbendi;
    UIAlertView *alertother;
    UIView * _viewDrop;
    ASIFormDataRequest * _requestDelete;
    
    ASIFormDataRequest * _requestRestore;
    ASIFormDataRequest * _requestRestoreAll;
    ASIFormDataRequest * _requestClearAll;
    ASIFormDataRequest * _requestApplygz;
    ASIFormDataRequest * _requestCreateFolder;
    ASIFormDataRequest * _requestRename;
    ASIFormDataRequest * _requestDeleteFolder;
    
//
    ASIFormDataRequest * _requestRefresh;

    
    int  _currentLongPressCellIndex;
    UILongPressGestureRecognizer * _lpgr;
    
    NSIndexPath * _indexPath4Sheet;
    UIDocumentInteractionController * _docInteractionController;
    int startIndex ;  //分页参数
    BOOL isLoadFileList;  //是否正在加载数据
    
    CustomAlertView * _alert4Folder;
    CustomAlertView * _alert4Rename;
    CustomAlertView * _alert4RenameFolder;
   
}

@property BOOL isSearchFrom;

@property (strong,nonatomic)NSString * rootFolderID;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (strong, nonatomic)NSString * titleString;
@property (strong, nonatomic)IBOutlet UIButton * btnAdd;
@property (strong, nonatomic)IBOutlet UIButton * btnRecover;
@property (strong, nonatomic)FolderModel * parentFolder;
@property (strong, nonatomic)IBOutlet UITableView * contentView;
@property (strong, nonatomic)IBOutlet UIView * viewDrop;
@property (strong, nonatomic)IBOutlet UITableView * innerView;
@property (strong, nonatomic)Preview * preview;
@property (strong, nonatomic)FolderModel * rootFolder;
@property (assign ,nonatomic) BOOL isRootFloder;
@property (assign ,nonatomic) BOOL isHuiFloder;

- (void)handleOtherFile:(FileModel *)file;

@end

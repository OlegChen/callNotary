//
//  ProofView.h
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "FolderModel.h"
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "ZSYTextPopView.h"
#import "BasicViewController.h"
//#import "BaseViewController.h"

@interface ProofView :UIViewController <UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,ZSYPopoverDelegata>
{
    UIButton * _btnAdd;
    UIButton * _btnRecover;
    UIButton * _btnRecoverNum;
    UITableView * _contentView;
    
    CustomAlertView * _alert4Search;
    CustomAlertView * _alert4Folder;
    CustomAlertView * _alert4RenameFolder;
    UIAlertView * _alert4Delete;
    NSMutableArray * _folderArray;
    FolderModel * _recover;  //回收站实体
    
    NSMutableData * _jsonData;
    int _uploadCount;
    

    UIButton * _customLeft;
    
	EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    
    ASIFormDataRequest * _requestRefresh;
    ASIFormDataRequest * _requestCreateFolder;
    ASIFormDataRequest * _requestDeleteFolder;
    ASIFormDataRequest * _requestRename;
    NSMutableData * _jsonFolderList;
    NSIndexPath *  _indexPath4Sheet;
    
    UIButton * leadBtn;
    
    ASIFormDataRequest *_tipsRequest;
    NSMutableArray *_msgArr;
    
    int _noReadMsgCount;
    UIButton * btnNumMessage;
    
    NSMutableData *_jsonData1;
}

@property (strong, nonatomic)IBOutlet UIButton * btnAdd;
@property (strong, nonatomic)IBOutlet UIButton * btnRecover;
@property (strong, nonatomic)IBOutlet UITableView * contentView;
@property (strong, nonatomic)FolderModel * recover;
@property (strong, nonatomic)UIAlertView * alert4Delete;
@property (strong, nonatomic)UILongPressGestureRecognizer * logpress;


- (IBAction)btnAddClick:(UIButton *)but;
- (IBAction)btnRecoverClick:(UIButton *)but;

@end

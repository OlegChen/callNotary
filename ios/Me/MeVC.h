//
//  MeVC.h
//  notary
//
//  Created by he on 15/4/24.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FolderModel.h"

@interface MeVC : UITableViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *_contentTextArr;
    NSArray *_contentImageArr;
    NSMutableArray *_msgArr;
    int _noReadMsgCount;
    
    int _upLoadCount;
    int _downLoadCount;
    
    ASIFormDataRequest *_tipsRequest;
    ASIFormDataRequest *_outRequest;
    ASIFormDataRequest *_shareRequest;
    
    NSMutableArray * _folderArray;
    ASIFormDataRequest * _requestRefresh;
    ASIFormDataRequest * _requestCreateFolder;
    ASIFormDataRequest * _requestDeleteFolder;
    ASIFormDataRequest * _requestRename;

    NSMutableData *_jsonData1;
    
    NSString *_shareText;
    NSString* _shareImageUrl;
    UIImage *_shareImage;
    
    NSMutableData * _jsonData;
    int _uploadCount;
    
    NSMutableData * _jsonFolderList;
}


@property (strong, nonatomic) IBOutlet UITableView *myTableView;



@end

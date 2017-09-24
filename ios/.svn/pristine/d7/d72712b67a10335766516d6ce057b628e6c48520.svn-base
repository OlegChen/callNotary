//
//  DownLoadHistory.h
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Preview.h"
#import "AES.h"


@interface DownLoadHistory : UIViewController<AESDelegate, DownloadDelegate,PreviewDelegate,UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *_dataSourceArr;
    NSArray *_barBtnItemEditArr;
    NSArray *_barBtnItemDoneArr;
    
    NSMutableDictionary * _downloadeRequest;
    NSMutableArray * _files;
     
    AppDelegate * _app; 
    UIAlertView * _alertRecoverAll;
    UIView * _viewDrop;
    BOOL _isPresent; 
    FileModel *fileStr;
    UIDocumentInteractionController * _docInteractionController;
}
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView * viewDrop;
@property (strong, nonatomic) IBOutlet UITableView * innerView;
@property BOOL isPresent;

@property (nonatomic,strong)NSArray *photos;
- (void)handleOtherFile:(FileModel *)file;
@end

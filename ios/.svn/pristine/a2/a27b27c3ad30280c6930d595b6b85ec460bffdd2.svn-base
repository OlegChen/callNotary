//
//  UpLoadHistory.h
//  notary
//
//  Created by wenbuji on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpLoadContinue.h"
#import "AppDelegate.h"
@interface UpLoadHistory : UIViewController<UploadContinueDelegate>
{
    NSMutableArray *_dataSourceArr;
    NSArray *_barBtnItemEditArr;
    NSArray *_barBtnItemDoneArr;
    
    NSMutableArray * _files;
    
    UIView * _viewDrop;
    UIAlertView * _alertRecoverAll;
    AppDelegate * _app;
    
    NSMutableDictionary * _uploadeRequest;
    NSMutableArray * _uploadFiles;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView * contentView;
@property (strong, nonatomic) IBOutlet UIView * viewDrop;
@property (strong, nonatomic) IBOutlet UITableView * innerView;
@end

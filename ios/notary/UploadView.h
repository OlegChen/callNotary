//
//  UploadView.h
//  notary
//
//  Created by 肖 喆 on 13-3-27.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "AsyncSocket.h"
#import "UploadFile.h"
#import "UpLoadContinue.h"

@interface UploadView : UIViewController<UploadFileDelegate,UITextFieldDelegate,UploadContinueDelegate>
{
//    FileModel * _model;
    FolderModel * _folder;
    UIImageView * _imagePreView;
    AsyncSocket  * _socket;
    UIButton * _btnSend;

    
    UIButton * _btnSelectDirectory;
//    UITextField * _txtDirectory;
//    UITextField * _txtFileName;
    NSString * _dateTimeForFileName;
    UIButton * _btnCloseKeyBorad;
    UIButton * _btnCancel;
    UILabel * _labMessage;
    BOOL _isUploading;
    BOOL _isShowAlertFinish;
    
    UILabel * _labSize;
    
    BOOL _isPresent;
    
    UpLoadContinue * _upload;
    UIButton * _customLeft;
}
@property BOOL isPresent;
@property (nonatomic,assign) BOOL ispaizao;
@property (nonatomic, strong)FileModel * model;
@property (nonatomic, strong)IBOutlet UIImageView * imagePreView;
@property (nonatomic, strong)IBOutlet UIButton * btnSend;
@property (strong, nonatomic) IBOutlet UISlider *progress;
@property (nonatomic, strong)FolderModel * folder;
@property (nonatomic, strong)IBOutlet UIButton * btnSelectDirectory;
@property (strong, nonatomic) IBOutlet UILabel *txtDirectory;
@property (strong, nonatomic) IBOutlet UILabel *txtFileName;
 @property (nonatomic, strong)IBOutlet UIButton * btnCloseKeyBorad;
@property (nonatomic, strong)IBOutlet UIButton * btnCancel;
@property (nonatomic, strong)IBOutlet UILabel * labMessage;
@property (nonatomic, strong)IBOutlet UILabel * labSize;
@property (strong, nonatomic) IBOutlet UILabel *btnName;
@property (strong, nonatomic) IBOutlet UILabel *btnSize;
@property (strong, nonatomic) IBOutlet UILabel *btnmulu;
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnCloseKeyBoradClick:(id)sender;

- (IBAction)btnSendClick:(id)sender;
- (IBAction)btnSelectDirectoryClick:(id)sender;
@end

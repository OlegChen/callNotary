//
//  SaveView.h
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadView.h"
#import "WSCoachMarksView.h"
#import "BasicViewController.h"
@interface SaveView :UIViewController <UIAlertViewDelegate,WSCoachMarksViewDelegate,ASIHTTPRequestDelegate>
{
    UIButton * _btnRecord;
    UIButton * _btnUpload;
    UIButton * _btnPhoto;
    UIButton * _btnDV;
    UIButton * _btnCurrentRecord;
    UIButton * _btnFaroese;

    BOOL readyToRecordAudio;
    BOOL readyToRecordVideo;
	BOOL recordingWillBeStarted;
	BOOL recordingWillBeStopped;
    
	BOOL recording;
    
    UIImagePickerController * _pickerForVideo;
    UIImagePickerController * _pickerForPhoto;
    UploadView * _upload;
    
  
    
    UIButton *leadBtn;
    
    ASIFormDataRequest *_tipsRequest;
    NSMutableArray *_msgArr;
    
    int _noReadMsgCount;
    UIButton * btnNumMessage;

    UIView *backView;
    UIView *midView;
    ASIFormDataRequest * _requestRefresh;
    NSMutableArray * _folderArray;
    NSMutableData * _jsonFolderList;
    
   


}
@property (strong,nonatomic) UIImagePickerController * pickerForPhoto;
@property (strong,nonatomic) IBOutlet UIButton * btnRecord;
@property (strong,nonatomic) IBOutlet UIButton * btnUpload;
@property (strong,nonatomic) IBOutlet UIButton * btnPhoto;
@property (strong,nonatomic) IBOutlet UIButton * btnDV;
@property (strong,nonatomic) IBOutlet UIButton * btnCurrentRecord;
@property (strong,nonatomic) UploadView * upload;
@property (strong,nonatomic)NSMutableData * jsonData;
@property (strong, nonatomic) IBOutlet UIButton *btnFaroese;//法律咨询

- (IBAction)btnRecordClick:(UIButton *)but;
- (IBAction)btnUploadClick:(UIButton *)but;
- (IBAction)btnPhotoClick:(UIButton *)but;
- (IBAction)btnDBClick:(UIButton *)but;
- (IBAction)btnCurrentRecordClick:(UIButton *)but;
- (IBAction)butClick:(UIButton *)but;
@property (strong, nonatomic) IBOutlet UILabel *currentNum;
- (IBAction)btnFaroese:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *succRecordNum;
@property (strong, nonatomic) IBOutlet UIButton *appLacationBtn;
- (IBAction)appLacationAction:(id)sender;

@end

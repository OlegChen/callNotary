//
//  FileDetailView.h
//  notary
//
//  Created by 肖 喆 on 13-9-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYTextPopView.h"
#import "Preview.h"
//******更改文件名字的delegate*****//
@protocol changeFileNameDelegate <NSObject>

@optional
-(void)changeName:(NSString*)name;

@end
@interface FileDetailView : UIViewController<ZSYPopoverDelegata,PreviewDelegate>
{
    CustomAlertView * _alert4Rename;
    
    id<changeFileNameDelegate> _delegate;
}

@property (nonatomic,strong) id<changeFileNameDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *filename;//文件名
@property (weak, nonatomic) IBOutlet UILabel *fileNumber;//文件大小
@property (weak, nonatomic) IBOutlet UILabel *saveTime;//保存时间
@property (weak, nonatomic) IBOutlet UILabel *desc;//来源类型
@property (strong, nonatomic) IBOutlet UIImageView *fileTypeImage;//文件的类型图片

//以下三个是title
@property (strong, nonatomic) IBOutlet UILabel *manLabel;
@property (strong, nonatomic) IBOutlet UILabel *outLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *manNumber;//主叫号码
@property (weak, nonatomic) IBOutlet UILabel *outNumber;//被叫号码
@property (weak, nonatomic) IBOutlet UILabel *labTime;//通话时长

@property (strong,nonatomic)FileModel * file;
- (IBAction)rename:(id)sender;

@property (strong,nonatomic)ASIFormDataRequest * request;
@property (strong,nonatomic)ASIFormDataRequest * requestRename;
@property (strong, nonatomic)ASIFormDataRequest* requestHeader;
@property (strong,nonatomic)NSMutableData * jsonData;
@property (weak, nonatomic) IBOutlet UIButton *btnDownLoad;
@property (weak, nonatomic) IBOutlet UIButton *btnRename;

- (IBAction)download:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)deleteFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMove;

- (IBAction)move:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomView;


@end

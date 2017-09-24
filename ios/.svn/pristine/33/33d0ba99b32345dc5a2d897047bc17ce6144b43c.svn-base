//
//  FileUploadView.h
//  notary
//
//  Created by 肖 喆 on 13-3-21.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"


@interface FileUploadView : UIViewController
{
    UIButton * _btnPhoto;
    UIButton * _btnDV;
    
    AsyncSocket * _sock;
    
    UIImagePickerController * _picker4Video;
    UIImagePickerController * _picker4Photo;
    
}

@property (nonatomic,strong)IBOutlet UIButton * btnPhoto;
@property (nonatomic,strong)IBOutlet UIButton * btnDV;

- (IBAction)btnPhotoClick:(id)sender;
- (IBAction)btnDVClick:(id)sender;

@end

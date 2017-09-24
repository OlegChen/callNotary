//
//  UserInfoView.h
//  notary
//
//  Created by 肖 喆 on 13-9-10.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIViewController
{
    ASIFormDataRequest * _requestRefresh;
    NSMutableData * _jsonFolderList;
}

@property (weak,nonatomic)IBOutlet UITextField * txtName;

@property (weak,nonatomic)IBOutlet UITextField * txtId;

@property (weak,nonatomic)IBOutlet UIButton * btnSubmit;

@property (strong,nonatomic)ASIFormDataRequest * requestRefresh;

- (IBAction)btnSubmit:(id)sender;

@end

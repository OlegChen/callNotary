//
//  NewProofapplyView.h
//  notary
//
//  Created by 肖 喆 on 13-9-22.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
@interface NewProofapplyView : UIViewController
{
    NSMutableArray * _folderArray;
    NSMutableData * _jsonData;
}

@property (strong,nonatomic)ASIFormDataRequest * requestRefresh;
@property (strong,nonatomic)NSMutableArray * folderArray;
@property (strong,nonatomic)NSMutableData * jsonData;

@property (weak,nonatomic)IBOutlet UITableView * contentView;


@end

//
//  ShowMessageAll.h
//  notary
//
//  Created by wenbuji on 13-4-17.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMessageAll : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *allTableView;
@property (strong,nonatomic) NSString *contentStr;
@end
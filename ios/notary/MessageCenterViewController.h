//
//  MessageCenterViewController.h
//  notary
//
//  Created by wenbuji on 13-3-18.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _messageArr;
    UITableView* _messageTableView;
    int _upDateNum;
    int _tmpDateNum;
    
    int _showAllIndexPathRow;
    int _showAllHight;
    BOOL _isChange;
}
@property (strong, nonatomic) UITableView *messageTableView;

@property (strong,nonatomic) NSArray *tmpArr;
@end

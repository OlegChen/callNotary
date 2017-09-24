//
//  MessageCenter.h
//  notary
//
//  Created by wenbuji on 13-4-17.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenter : UIViewController
{
    
    NSMutableArray * _msgArr;
    NSMutableArray * _messageArr;
    NSMutableArray * _messageReadArr;
    NSMutableArray * _systemMsgIdArr;
    NSMutableArray *_timeArr;
    UITableView* _messageTableView;
//    int _upDateNum;
    int _tmpDateNum;
    int startIndex ;  //分页参数
    NSMutableData * _jsonData;
    BOOL isLoadMsgList;  //是否正在加载数据
//    int _showAllIndexPathRow;
//    int _showAllHight;
//    BOOL _isChange;
}

@property (strong, nonatomic) IBOutlet UITableView *messageTableView;

//@property (strong,nonatomic) NSArray *tmpArr;

@end

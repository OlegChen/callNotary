//
//  RecommendationView.h
//  notary
//
//  Created by stian on 14/12/25.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendationView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    int startIndex;
    NSMutableArray * _recommendArr;
    UITableView *recommendTableView;
}
@property (strong,nonatomic)NSMutableData * recommendJsonData;
@property (strong,nonatomic)NSDictionary *jsonDiction;
@property (strong,nonatomic)NSMutableArray *recommendArr;
@property (strong,nonatomic)UITableView *recommendTableView;
@end

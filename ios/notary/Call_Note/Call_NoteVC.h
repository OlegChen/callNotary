//
//  Call_NoteVC.h
//  notary
//
//  Created by he on 15/4/23.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardView.h"

@interface Call_NoteVC : UIViewController<KeyboardViewDelegate,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,ZSYPopoverDelegata> {
    
    UIAlertView *callAlertView;
    
    BOOL _isShowKeyBorad;
    KeyboardView * _keyboard;
    NSMutableArray * _cards;
    NSMutableDictionary * _cardDic;
    NSArray * _allKeys;
    
    UITableView * _contentTable;
    UITableView * _sortTable;
    
    BOOL _isFilter;  //是否根据条件过滤
    
    UISearchBar * _search;
    NSArray * _filterArray;    //过滤后的
    
    
    
    
    NSUInteger _selectedCount;
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
}

@property (nonatomic,strong) UITableView * contentTable;
@property (nonatomic,strong) UITableView * sortTable;
//@property (nonatomic,strong) IBOutlet UISearchBar * search;
@property (nonatomic,strong) NSMutableArray * searchByName;
@property (nonatomic,strong) NSMutableArray * searchByPhone;
@property (nonatomic,strong) NSMutableDictionary * cardDic;
@property (nonatomic,strong) NSMutableArray * listContent;


@end

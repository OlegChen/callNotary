//
//  SearchView.h
//  notary
//
//  Created by 肖 喆 on 13-4-9.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _keyWord; 
    NSMutableArray * _fileArray;
    UITableView * _contentView; 
    
    NSMutableData * _jsonData;
    UIDocumentInteractionController * _docInteractionController;
    int startIndex ;  //分页参数
    BOOL isLoadFileList;  //是否正在加载数据
}

@property (nonatomic, strong)NSString * keyWord;
@property (nonatomic, strong)IBOutlet UITableView * contentView;

- (void)handleOtherFile:(FileModel *)file;

@end

//
//  seeDocumentViewController.h
//  notary
//
//  Created by 肖 喆 on 13-11-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seeDocumentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{

      NSString*packidValue;
      UITableView*Tableview;
       NSMutableArray *items;
      int cellTag;
      UILabel*labelReminder;


}

@property (strong, nonatomic)NSMutableData * jsonData;
@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic, strong) NSString *mark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  packId:(NSString*)packid packName:(NSString*)packname;
@end

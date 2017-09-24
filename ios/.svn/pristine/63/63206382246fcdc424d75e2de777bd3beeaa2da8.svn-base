//
//  SDGroupCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSubCell.h"
#import "SDSelectableCell.h"
#import "SDGroupCellDelegate.h"

typedef enum {
    AllSubCellsCommandChecked,
    AllSubCellsCommandUnchecked,
    AllSubCellsCommandNone,
} AllSubCellsCommand;

static const int height = 70;
static const int subCellHeight = 40;

@interface SDGroupCell : SDSelectableCell <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *expandBtn;
    AllSubCellsCommand subCellsCommand;
    
    //新增加的
    id <SDGroupCellDelegate> _groupCelldelegate;
    NSString * _uniqueid;

}

@property (assign) BOOL isExpanded;
@property (assign) IBOutlet UITableView *subTable;
@property (assign) IBOutlet SDSubCell *subCell;
@property (nonatomic) int subCellsAmt;
@property (assign) int selectedSubCellsAmt;
@property (nonatomic, assign) NSMutableDictionary *selectableSubCellsState;
@property  id <SDGroupCellDelegate> groupCelldelegate;
@property (nonatomic,strong)NSString * uniqueid;
@property (nonatomic,strong)IBOutlet UIImageView * folderImage;
@property (nonatomic,strong)IBOutlet UIButton * btnBig;

- (void) subCellsToggleCheck;
- (void) rotateExpandBtn:(id)sender;
- (void) rotateExpandBtnToExpanded;
- (void) rotateExpandBtnToCollapsed;
- (void) autoExpandCells;
+ (int) getHeight;
+ (int) getsubCellHeight;

@end

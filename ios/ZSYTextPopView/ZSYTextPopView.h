//
//  ZSYPopoverListView.h
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZSYPopoverListViewButtonBlock)();

@class ZSYTextPopView;

@protocol ZSYPopoverDelegata <NSObject>

//- (void)returnTheContent:(NSString *)content;
- (void)popoView:(ZSYTextPopView*)popview content:(NSString*)content clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ZSYTextPopView : UIView<UITextFieldDelegate>{

    
    UITextField * _showTextField;
     NSString * _keyWord;
  //  id<ZSYPopoverDelegata>myDelegate;

}


@property int maxLength;
@property (nonatomic, retain) UILabel *titleName;
@property (nonatomic,strong) UITextField * showTextField;
@property (nonatomic,strong) id<ZSYPopoverDelegata>myDelegate;
//展示界面
- (void)show;

//消失界面
- (void)dismiss;

//列表cell的重用
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier;

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath;            // returns nil if cell is not visible or index path is out of

//设置确定按钮的标题，如果不设置的话，不显示确定按钮
- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block;

//设置取消按钮的标题，不设置，按钮不显示
- (void)setCancelButtonTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block;

//选中的列表元素
- (NSIndexPath *)indexPathForSelectedRow;
@end


//
//  UIBarButtonItem+XH.m
//  House
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "UIBarButtonItem+XH.h"
#import "UIImage+XH.h"

@implementation UIBarButtonItem (XH)
+ (UIBarButtonItem *)barButtonItem:(NSString *)imageName higImageNmae:(NSString *)higImageNmae tager:(id)tager action:(SEL)action frame:(CGRect)frame title:(NSString *)title;
{
    // 1.创建左边按钮
    UIButton *btn = [[UIButton alloc] init];
    // 2.设置默认状态图片
    if (![imageName  isEqual:@""]) {
    [btn setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
        
            // 3.设置高亮状态图片
    [btn setImage:[UIImage imageWithName:higImageNmae] forState:UIControlStateHighlighted];
    }

    // 4.添加点击事件监听
    //    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:tager action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置frame
    btn.frame = frame;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
    if (![title  isEqual:@""] ) {
 
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
        btn.titleLabel.font =[UIFont systemFontOfSize:17];
        
//        [btn setTitleColor:[UIColor colorWithRed:57/255.0 green:154/255.0 blue:62/155.0 alpha:1.0] forState:UIControlStateNormal];
//        
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    
    
    }
    
    [btn setTitleColor:[UIColor colorWithRed:57/255.0 green:154/255.0 blue:62/155.0 alpha:1.0] forState:UIControlStateNormal];
    
    //btn.backgroundColor = [UIColor redColor];
    
    btn.contentMode = UIViewContentModeLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
    // 5.根据按钮创建UIBarButtonItem
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 6.返回UIBarButtonItem
    return item;
}



@end

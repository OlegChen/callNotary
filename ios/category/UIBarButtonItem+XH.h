//
//  UIBarButtonItem+XH.h
//  House
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XH)
/**
 *  自定义的barButtonItem
 */
+ (UIBarButtonItem *)barButtonItem:(NSString *)imageName higImageNmae:(NSString *)higImageNmae tager:(id)tager action:(SEL)action frame:(CGRect)frame title:(NSString *)title;

@end

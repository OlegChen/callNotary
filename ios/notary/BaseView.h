//
//  BaseView.h
//  notary
//
//  Created by 肖 喆 on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseView : UITabBarController
{
    UIButton * button;
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

- (void)hiddenWithCenterButton:(BOOL)isHiden;

@end

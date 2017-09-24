//
//  BaseView.m
//  notary
//
//  Created by 肖 喆 on 13-3-19.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()

@end

@implementation BaseView


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addCenterButtonWithImage:[UIImage imageNamed:@"circle.png"] highlightImage:[UIImage imageNamed:@"circle.png"]];
    
    NSArray * items =    self.tabBar.items;
    UITabBarItem * ite = [items objectAtIndex:0];
    NSLog(@"%@",ite);
    
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    UIViewController* viewController = [[UIViewController alloc] init] ;
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0] ;
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
     button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(centerButClick:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
//    [self.tabBar addSubview:button];
//    [self.tabBar insertSubview:button atIndex:10];

    [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)centerButClick:(UIButton *)sender {
    [self setSelectedIndex:0];
}
- (void)hiddenWithCenterButton:(BOOL)isHiden
{
    button.hidden = isHiden;

}


@end

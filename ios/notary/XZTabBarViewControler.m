//
//  XZTabBarViewControler.m
//  LDrama
//
//  Created by 肖 喆￼ on 12-11-20.
//  Copyright (c) 2012年 肖 喆￼. All rights reserved.
//

#define ScreenWith [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#import "XZTabBarViewControler.h"
#import <QuartzCore/QuartzCore.h>



@interface XZTabBarViewControler ()


@end

@implementation XZTabBarViewControler
@synthesize bottomView;


- (void)dealloc {
    
//    RELEASE(topView);
//    RELEASE(bottomView);
//    RELEASE(tabs);
//    RELEASE(tabsImages);
//    RELEASE(clickImages);
//    RELEASE(controllers);
//    RELEASE(buttonBackGround);
    
    [topView release],topView = nil;
    [bottomView release],bottomView = nil;
    [tabs release], tabs = nil;
    [tabsImages release],tabsImages = nil;
    [clickImages release],clickImages = nil;
    [controllers release], controllers = nil;
    [buttonBackGround release],buttonBackGround = nil;
    [btn release],btn = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showBtnImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidenBtnImage" object:nil];
    
    
    
    [super dealloc];
}

- (id)initWithTab:(NSArray *)backImages andClickImages:(NSArray *)highlightImages andViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        controllers = [viewControllers retain];
        tabsImages = [backImages retain];
        clickImages = [highlightImages retain];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isShowKeyBoard = YES;
    
//    if (IS_IPHONE_5) {
//
//
//        if (IOS7_OR_LATER) {
//            topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 548+20)];
//            topView.backgroundColor = [UIColor whiteColor];
//            [self.view addSubview:topView];
//            bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 498.5+20, ScreenWith, 49.5)];
//            bottomView.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:bottomView];
//        }else{
//            topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 548)];
//            topView.backgroundColor = [UIColor whiteColor];
//            [self.view addSubview:topView];
//            bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 498.5, ScreenWith, 49.5)];
//            bottomView.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:bottomView];
//        }
//
//    }else {
//        if (IOS7_OR_LATER) {
//
            topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
            topView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:topView];
            
            bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49.5, ScreenWith, 49.5)];
            bottomView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:bottomView];
            
//        }else{
//            topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 20)];
//            topView.backgroundColor = [UIColor whiteColor];
//            [self.view addSubview:topView];
//
//            bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 20 - 49.5, ScreenWith, 49.5)];
//            bottomView.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:bottomView];
//        }
//    }
    
    
    UIImage *image = [UIImage resizableImageWithName:@"菜单栏左和右背景.png"];
    UIImageView* bottomViewBackground = [[UIImageView alloc]initWithImage:image];
    bottomViewBackground.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49);
    
    [bottomView addSubview:bottomViewBackground];
    [bottomViewBackground release];
    
    CGFloat buttonWidth = 320.f/[controllers count];
    CGFloat buttonHeight = 49.5f;
    
    for (int i = 0 ; i < [controllers count]; i++) {
        
        UIImage* normal = ((UIImageView *)[tabsImages objectAtIndex:i]).image;
        UIImage* hilight = ((UIImageView *)[clickImages objectAtIndex:i]).image;
        
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:normal forState:UIControlStateNormal];
        [but setImage:hilight forState:UIControlStateHighlighted];
        [but setImage:hilight forState:UIControlStateSelected];
        [but setImage:hilight forState:UIControlStateDisabled];
        [but setImage:hilight forState:(UIControlStateHighlighted|UIControlStateSelected)];
        
        but.frame = CGRectMake(buttonWidth * i,0, buttonWidth, buttonHeight);
        //but.imageView.frame = CGRectMake(0, 0, 30, 30);
        
        //特殊处理
        if (i == 0) {
            but.frame = CGRectMake(20,0, 69, buttonHeight);
        }
        if (i == 1) {
           // but.frame = CGRectMake(buttonWidth * i + 10,-15,
                                   //((UIImageView *)[tabsImages objectAtIndex:i]).frame.size.width
                                   //,((UIImageView *)[tabsImages objectAtIndex:i]).frame.size.height);
            
            but.frame = CGRectMake(89, 0, [UIScreen mainScreen].bounds.size.width - 89 - 89, buttonHeight);
            
            but.selected = YES;
            
            btn = but;
            
        }
        if (i == 2) {
            but.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 69 - 20,0, 69, buttonHeight);
            
            
        }
        //特殊处理结束
        
        
        but.imageView.contentMode = UIViewContentModeCenter;
        
        but.backgroundColor = [UIColor clearColor];
        but.tag = i + 1;
        [bottomView addSubview:but];
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }//end for
    
    //竖线
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(89, 0, 1, buttonHeight)];
    line1.image = [UIImage imageNamed:@"tabbar_bottom_line"];
    [bottomView addSubview:line1];
    
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 89 - 3, 0, 1, buttonHeight)];
    line2.image = [UIImage imageNamed:@"tabbar_bottom_line"];
    [bottomView addSubview:line2];
    

    
    UIViewController* root = [controllers objectAtIndex:1];
    root.view.frame = topView.frame;
    [topView addSubview:root.view];
    
#pragma - mark 按钮变换 监听
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBtnImage) name:@"showBtnImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenBtnImage) name:@"hidenBtnImage" object:nil];
    
}


- (void)showBtnImage{
    
    isShowKeyBoard = YES;
    
    [btn setImage:[UIImage imageNamed:@"键盘选中"] forState:UIControlStateSelected];

}

- (void)hidenBtnImage{
    
    isShowKeyBoard = NO;

    [btn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateSelected];

}


- (void)normalBtnImge{
    
    [btn setImage:[UIImage imageNamed:@"拨号"] forState:UIControlStateNormal];



}


-(void)checkNetwork{
    Reachability*r= [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case 0:{
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"啊哦~网络好像断开了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            break;}
            
        default:
            break;
    }

}
- (void)buttonClick:(UIButton *)but {
    
    [NSThread  detachNewThreadSelector:@selector(checkNetwork) toTarget:self withObject:nil];
  
    for (UIView* view in bottomView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* temp = (UIButton *)view;
            if (but.tag != temp.tag) {
                [temp setSelected:NO];
            }else {
                
                
                //NSLog(@"%d",but.tag);
                
                if (but.tag == 2) {
                    
                    
                    if(but.tag == 2 && but.selected == YES ){
                        
                        //通知 弹出键盘
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pullKeyboard" object:self];
                        
                        
                    }else{

                    
                    
                        if (isShowKeyBoard == YES) {
                            
                            //收起键盘的tu
                            [self showBtnImage];
                            
                        }else{
                            
                            //弹出键盘的图
                            [self hidenBtnImage];
                            
                        }
                        
                    }
                    
                }
                
                
//                if(but.tag == 2 && but.selected == YES ){
//                    
//                    //通知 弹出键盘
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pullKeyboard" object:self];
//                    
//                    
//                    
//                    //键盘 收起图
//                    //[but setImage:[UIImage imageNamed:@"我的选中"] forState:UIControlStateNormal];
//                    
//                
//                }
//                    else if (but.tag == 2) {
//                    
//                    //键盘 弹出图
//                    [but setImage:[UIImage imageNamed:@"我的"] forState:UIControlStateNormal];
//                    
//                }else{
//                
//                    //原图
//                    [but setImage:[UIImage imageNamed:@"拨号"] forState:UIControlStateNormal];
//                    
//                }
                
                [but setSelected:YES];
                
                NSLog(@"%d",btn.tag);
                
                if (but.tag == 1 || but.tag == 3) {
                    
                    [self normalBtnImge];

                }
                
                
            }
        }
    }

    UIViewController* root = [controllers objectAtIndex:but.tag - 1];
    root.view.frame = topView.frame;
    [topView addSubview:root.view];
    


}
- (void)hiddenTab:(BOOL)hidden
{

    bottomView.hidden = hidden;
}
@end

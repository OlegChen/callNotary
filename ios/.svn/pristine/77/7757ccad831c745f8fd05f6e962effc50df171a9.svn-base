//
//  ViewController.m
//  GuideViewController
//
//  Created by 发兵 杨 on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"
#import "AppDelegate.h"
@implementation ViewController
@synthesize gotoMainViewBtn = _gotoMainViewBtn;

@synthesize imageView;
@synthesize left = _left;
@synthesize right = _right;
@synthesize pageScroll;
@synthesize pageControl;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,  480+(IS_IPHONE_5?88:0))];
	// Do any additional setup after loading the view, typically from a nib.
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    
    pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);

    pageScroll.bounces=NO;
    
    //pageControl.alwaysBounceVertical=NO;
    //设定 ScrollView 的 Frame，逐页滚动时，如果横向滚动，按宽度为一个单位滚动，纵向时，按高度为一个单位滚动
    NSLog(@"---------size.height:%f",self.view.frame.size.height);
    
    pageScroll.backgroundColor = [UIColor clearColor]; // ScrollView 背景色，即 View 间的填充色
    
    
   
        
    //向 ScrollView 中加入第一个 View，View 的宽度 200 加上两边的空隙 5 等于 ScrollView 的宽度
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,480+(IS_IPHONE_5?88:0))];
    view1.image=[UIImage imageNamed:(IS_IPHONE_5?@"startImage1_five":@"startImage1_four")];
    //view1.backgroundColor = [UIColor redColor];
        [pageScroll addSubview:view1];
    
  
    
    //第二个 View，它的宽度加上两边的空隙 5 等于 ScrollView 的宽度，两个 View 间有 10 的间距
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(320,0,320,480+(IS_IPHONE_5?88:0))];
    view2.image = [UIImage imageNamed:(IS_IPHONE_5?@"startImage2_five":@"startImage2_four")];
    view2.backgroundColor = [UIColor greenColor];
    [pageScroll addSubview:view2];
//    [view2 release];
    //第三个 View
    UIImageView *view3 = [[UIImageView alloc] initWithFrame:CGRectMake(640,0,320,480+(IS_IPHONE_5?88:0))];
    view3.image = [UIImage imageNamed:(IS_IPHONE_5?@"startImage3_five":@"startImage3_four")];

    view3.backgroundColor = [UIColor blueColor];
    
    [pageScroll addSubview:view3];
//    [view3 release];
    
    UIImageView *view4 = [[UIImageView alloc] initWithFrame:CGRectMake(960,0,320,480+(IS_IPHONE_5?88:0))];
    view4.userInteractionEnabled=YES;
    view4.image = [UIImage imageNamed:(IS_IPHONE_5?@"startImage4_five":@"startImage4_four")];
    
    view4.backgroundColor = [UIColor blueColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 220, 190, 135);
    
//    [btn setTitle:@"进入" forState:UIControlStateNormal];
//    [btn setTitle:@"进入" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:btn];
    [pageScroll addSubview:view4];
    
//    [view4 release];
    
    [self.view addSubview:pageScroll];
    
    //这个属性很重要，它可以决定是横向还是纵向滚动，一般来说也是其中的 View 的总宽度，和总的高度
    //这里同时考虑到每个 View 间的空隙，所以宽度是 200x3＋5＋10＋10＋5＝630
    //高度上与 ScrollView 相同，只在横向扩展，所以只要在横向上滚动
    pageScroll.contentSize = CGSizeMake(320*4, 480+(IS_IPHONE_5?88:0));
    
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    pageScroll.contentOffset = CGPointMake(0, 0);
    
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    pageScroll.pagingEnabled = YES;
    
}

- (void)viewDidUnload
{
    
    [self setGotoMainViewBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{   
    [_gotoMainViewBtn release];
    [super dealloc];
    [self.imageView release];
    [self.left release];
    [self.right release];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}





- (IBAction)gotoMainView:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

     LoadingView * loading  = nil;
    if(IS_IPHONE_5) {
        loading = [[LoadingView alloc] initWithNibName:@"LoadingView-ip5" bundle:nil];
        
    }else {
        loading = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
    }
    
     AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delgate.window.rootViewController = loading;

    
//    [self presentViewController:app.menuController animated:YES completion:nil];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end

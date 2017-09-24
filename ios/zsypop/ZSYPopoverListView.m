//
//  ZSYPopoverListView.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import <QuartzCore/QuartzCore.h>
//#import "CacheMemoryTestViewController.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
//#import "CacheMemoryTestAppDelegate.h"

static const CGFloat ZSYCustomButtonHeight = 40;

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

static const char * const kZSYPopoverListButtonClickForDone = "kZSYPopoverListButtonClickForDone";

@interface ZSYPopoverListView ()
                 //主的选择列表视图

@property (nonatomic, retain) UIButton *doneButton;                             //确定选择按钮
@property (nonatomic, retain) UIButton *cancelButton;                           //取消选择按钮
@property (nonatomic, retain) UIControl *controlForDismiss;                     //没有按钮的时候，才会使用这个
//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation ZSYPopoverListView
@synthesize datasource = _datasource;
@synthesize textviewdatasource=_textviewdatasource;
@synthesize delegate = _delegate;
@synthesize mainPopoverListView = _mainPopoverListView;
@synthesize doneButton = _doneButton;
@synthesize cancelButton = _cancelButton;
@synthesize titleName = _titleName;
@synthesize textView;
@synthesize controlForDismiss = _controlForDismiss;
@synthesize myDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         [self initTheInterface];
       [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (myDiss) name:@"dissview" object:nil];
    }
    return self;
}

-(void)myDiss{

    NSLog(@"通知收到啦");
  [self dismiss];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dissview" object:nil];
}
- (void)initTheInterface
{
    
    self.backgroundColor=[UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:40./255.
                               green:90./255.
                               blue:131./255.
                               alpha:1.0f] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    CGFloat xWidth = self.bounds.size.width;
    UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xWidth, 42)];
    [imageView setImage:[UIImage imageNamed:@"status-bar-progress.png"]];
    [self addSubview:imageView];
    
    _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleName.font = [UIFont systemFontOfSize:18.0f];
   // self.titleName.backgroundColor = [UIColor colorWithRed:59./255.
                                                 //green:89./255.
                                                  //blue:152./255.
                                                 //alpha:1.0f];
    self.titleName.backgroundColor=[UIColor clearColor];
    
    self.titleName.textAlignment = NSTextAlignmentCenter;
    self.titleName.textColor = [UIColor whiteColor];
   
    self.titleName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleName.frame = CGRectMake(0, 0, xWidth, 42.0f);
    [self addSubview:self.titleName];
    
    CGRect tableFrame = CGRectMake(0, 42.0f, xWidth, self.bounds.size.height-210.0f);
    _mainPopoverListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.mainPopoverListView.dataSource = self;
    self.mainPopoverListView.delegate = self;
    [self addSubview:self.mainPopoverListView];
    
    //AppDelegate  *appDel = (AppDelegate *)[[UIApplication  sharedApplication]delegate];
    
   // CacheMemoryTestViewController*CacheMemory=[[CacheMemoryTestViewController alloc] init];
    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    customLeft.frame = CGRectMake((300-115)/2, 225, 115, 42);
    [customLeft setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [customLeft setBackgroundImage:[UIImage imageNamed:@"blue_over.png"] forState:UIControlStateSelected ];
    [customLeft setTitle:@"提交" forState:UIControlStateNormal];
    [customLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customLeft.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [customLeft addTarget:myDelegate action:@selector(handleBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:customLeft];
    
   

    
    textView=[[UITextView alloc] initWithFrame:CGRectMake(40, 140, 220, 70)];
    textView.delegate=self;
    textView.font=[UIFont systemFontOfSize:18.0f];
    //textView.text=@"22222";
    
    textView.tag=222;
    textView.backgroundColor= [UIColor colorWithRed:240./255.
                                        green:240./255.
                                        blue:240./255.
                                        alpha:1.0f];
    
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.layer.borderWidth = 1.0f;
    textView.layer.cornerRadius = 5.0f;
    textView.clipsToBounds = TRUE;
    [self addSubview:textView];
    
    PlaceHolderlabel=[[UILabel alloc] init];
    PlaceHolderlabel.frame =CGRectMake(47, 150, 150, 20);
    PlaceHolderlabel.textColor=[UIColor blackColor];
    PlaceHolderlabel.text = @"请输入公证事由...";
    PlaceHolderlabel.font=[UIFont systemFontOfSize:17.0f];
    PlaceHolderlabel.enabled = NO;//lable必须设置为不可用
    PlaceHolderlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:PlaceHolderlabel];


    
}
-(void)textViewDidChange:(UITextView *)textView1
{
   
    if (textView1.text.length == 0) {
        PlaceHolderlabel.text = @"请输入公证事由...";
    }else{
        PlaceHolderlabel.text = @"";
    }
}


- (void)dealloc {

    //self.myDelegate = nil;
    //[super  dealloc];
}


//-(void)handleBackButtonClick{
//
//
//    if (myDelegate  && [myDelegate  respondsToSelector:@selector(returnTheContent:)]) {
//       [myDelegate  returnTheContent:textView.text];
//    }
//     
//  //  NSLog(@"text = %@",textView.text);
//
//}
-(void)layoutSubviews{
    
    NSLog(@"XXXXX---%@",textView.text);
    
        
}
- (void)drawRect:(CGRect)rect

{
    
     NSLog(@"-------%@",textView.text);
    
}



- (void)refreshTheUserInterface
{
    if (self.cancelButton || self.doneButton)
    {
        self.mainPopoverListView.frame = CGRectMake(0, 32.0f, self.mainPopoverListView.frame.size.width, self.mainPopoverListView.frame.size.height - ZSYCustomButtonHeight);
    }
    if (self.doneButton && nil == self.cancelButton)
    {
        self.doneButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width, ZSYCustomButtonHeight);
    }
    else if (nil == self.doneButton && self.cancelButton)
    {
        self.cancelButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width, ZSYCustomButtonHeight);
    }
    else if (self.doneButton && self.cancelButton)
    {
        self.doneButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width / 2.0f, ZSYCustomButtonHeight);
        self.cancelButton.frame = CGRectMake(self.bounds.size.width / 2.0f, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width / 2.0f, ZSYCustomButtonHeight);
    }
    if (nil == self.cancelButton && nil == self.doneButton)
    {
        if (nil == _controlForDismiss)
        {
            _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _controlForDismiss.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
            [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (NSIndexPath *)indexPathForSelectedRow
{
    return [self.mainPopoverListView indexPathForSelectedRow];
}
#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    return 0;
}
-(BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView1 resignFirstResponder];
        return NO;
    }
    if (self.textviewdatasource && [self.textviewdatasource respondsToSelector:@selector(yangtextView:yangshouldChangeTextInRange:yangreplacementText:)]) {
        return [self.textviewdatasource yangtextView:self yangshouldChangeTextInRange:range yangreplacementText:text];
    }
   
    //NSLog(@"----111%@",textView1.text);
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:cellForRowAtIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
     PlaceHolderlabel.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     PlaceHolderlabel.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didSelectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show
{
    [self refreshTheUserInterface];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlForDismiss)
    {
        [keywindow addSubview:self.controlForDismiss];
    }
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.5f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Reuse Cycle
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier
{
    return [self.mainPopoverListView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mainPopoverListView cellForRowAtIndexPath:indexPath];
}

+ (UIImage *)normalButtonBackgroundImage
{
	const size_t locationCount = 4;
	CGFloat opacity = 1.0;
    CGFloat locations[locationCount] = { 0.0, 0.5, 0.5 + 0.0001, 1.0 };
    CGFloat components[locationCount * 4] = {
		179/255.0, 185/255.0, 199/255.0, opacity,
		121/255.0, 132/255.0, 156/255.0, opacity,
		87/255.0, 100/255.0, 130/255.0, opacity,
		108/255.0, 120/255.0, 146/255.0, opacity,
	};
	return [self glassButtonBackgroundImageWithGradientLocations:locations
													  components:components
												   locationCount:locationCount];
}

+ (UIImage *)cancelButtonBackgroundImage
{
	const size_t locationCount = 4;
	CGFloat opacity = 1.0;
    CGFloat locations[locationCount] = { 0.0, 0.5, 0.5 + 0.0001, 1.0 };
    CGFloat components[locationCount * 4] = {
		164/255.0, 169/255.0, 184/255.0, opacity,
		77/255.0, 87/255.0, 115/255.0, opacity,
		51/255.0, 63/255.0, 95/255.0, opacity,
		78/255.0, 88/255.0, 116/255.0, opacity,
	};
	return [self glassButtonBackgroundImageWithGradientLocations:locations
													  components:components
												   locationCount:locationCount];
}

+ (UIImage *)glassButtonBackgroundImageWithGradientLocations:(CGFloat *)locations
												  components:(CGFloat *)components
											   locationCount:(NSInteger)locationCount
{
	const CGFloat lineWidth = 1;
	const CGFloat cornerRadius = 4;
	UIColor *strokeColor = [UIColor colorWithRed:1/255.0 green:11/255.0 blue:39/255.0 alpha:1.0];
	
	CGRect rect = CGRectMake(0, 0, cornerRadius * 2 + 1, ZSYCustomButtonHeight);
    
	BOOL opaque = NO;
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, [[UIScreen mainScreen] scale]);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, locationCount);
	
	CGRect strokeRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
	UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:cornerRadius];
	strokePath.lineWidth = lineWidth;
	[strokeColor setStroke];
	[strokePath stroke];
	
	CGRect fillRect = CGRectInset(rect, lineWidth, lineWidth);
	UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:cornerRadius];
	[fillPath addClip];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGFloat capHeight = floorf(rect.size.height * 0.5);
	return [image resizableImageWithCapInsets:UIEdgeInsetsMake(capHeight, cornerRadius, capHeight, cornerRadius)];
}

#pragma mark - Button Method
- (void)setCancelButtonTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setBackgroundImage:[ZSYPopoverListView cancelButtonBackgroundImage] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    [self.cancelButton setTitle:aTitle forState:UIControlStateNormal];
    objc_setAssociatedObject(self.cancelButton, kZSYPopoverListButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}

- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _doneButton)
    {
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setBackgroundImage:[ZSYPopoverListView normalButtonBackgroundImage] forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
    }
    [self.doneButton setTitle:aTitle forState:UIControlStateNormal];
    objc_setAssociatedObject(self.doneButton, kZSYPopoverListButtonClickForDone, [block copy], OBJC_ASSOCIATION_RETAIN);
}
#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    ZSYPopoverListViewButtonBlock __block block;
    
    if (button == self.cancelButton)
    {
        block = objc_getAssociatedObject(sender, kZSYPopoverListButtonClickForCancel);
    }
    else
    {
        block = objc_getAssociatedObject(sender, kZSYPopoverListButtonClickForDone);
    }
    if (block)
    {
        block();
    }
    [self animatedIn];
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:self];
}
@end

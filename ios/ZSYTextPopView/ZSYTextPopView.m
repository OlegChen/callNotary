//
//  ZSYPopoverListView.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "ZSYTextPopView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const CGFloat ZSYCustomButtonHeight = 40;

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

static const char * const kZSYPopoverListButtonClickForDone = "kZSYPopoverListButtonClickForDone";

@interface ZSYTextPopView ()
@property (nonatomic, retain) UITableView *mainPopoverListView;                 //主的选择列表视图
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

@implementation ZSYTextPopView

@synthesize mainPopoverListView = _mainPopoverListView;
@synthesize doneButton = _doneButton;
@synthesize cancelButton = _cancelButton;
@synthesize titleName = _titleName;
@synthesize controlForDismiss = _controlForDismiss;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    self.backgroundColor=[UIColor whiteColor];

    _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleName.font = [UIFont systemFontOfSize:17.0f];
//    self.titleName.backgroundColor = [UIColor colorWithRed:59./255.
//                                                 green:89./255.
//                                                  blue:152./255.
//                                                 alpha:1.0f];
//
    self.titleName.textAlignment = NSTextAlignmentCenter;
    self.titleName.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    CGFloat xWidth = self.bounds.size.width;
    self.titleName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleName.frame = CGRectMake(0, 0, xWidth, 35.0f);
    [self addSubview:self.titleName];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(14, 45, 222, 25)];
    //    passwordField.secureTextEntry = YES;
    [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    passwordField.placeholder = @"关键字";
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.returnKeyType = UIReturnKeyDone;
    // Pad out the left side of the view to properly inset the text
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 19)];
    passwordField.leftView = paddingView;
    
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    // Set delegate
    passwordField.delegate = self;
    
    // Set as property
    self.showTextField = passwordField;
    
    
    // Add to subview
    [self addSubview:_showTextField];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    line.frame = CGRectMake(0, 85, xWidth, 0.5f);
    [self addSubview:line];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    line2.frame = CGRectMake(xWidth / 2.0, 85, 0.5f, 60);
    [self addSubview:line2];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(150, 90, 60, 30);
    sureBtn.tag=1;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(zoomInAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(30, 90, 60, 30);
    cancelBtn.tag=0;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(zoomInAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    // Show alert
  
    
    // present keyboard for text entry
    [_showTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    

    
   
   
}
-(void)zoomInAction:(UIButton*)button{

  
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(
                       popoView: content: clickedButtonAtIndex:)]) {
        
        [_myDelegate popoView:self content:_showTextField.text clickedButtonAtIndex:button.tag];
       
        
    }
  
        [self dismiss];
    


}
- (NSString *)getKeyWord {
    
    return _showTextField.text;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([@"" isEqualToString:textField.text]) return NO;
    
    else {
        
        _keyWord = textField.text;
        return YES;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _keyWord = textField.text;
    
}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //    if(strlen([textField.text UTF8String]) >= _maxLength && range.length != 1)
    //        return NO;
    //
    //    return YES;
    NSLog(@"-------1-%d",_maxLength);
    NSLog(@"-------2-%d",textField.text.length);
    NSLog(@"-------2-%@",string);
    if ([textField.text length]>_maxLength) {
        textField.text=[textField.text substringToIndex:_maxLength];
    }
//    if (textField.text.length >= _maxLength) {
//        return NO;
//    }
    return YES;
    
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
                              keywindow.bounds.size.height/2.0f-75);
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
        [self.cancelButton setBackgroundImage:[ZSYTextPopView cancelButtonBackgroundImage] forState:UIControlStateNormal];
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
        [self.doneButton setBackgroundImage:[ZSYTextPopView normalButtonBackgroundImage] forState:UIControlStateNormal];
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
    //[self animatedOut];
}
@end

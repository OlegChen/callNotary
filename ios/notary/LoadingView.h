//
//  LoadingView.h
//  notary
//
//  Created by 肖 喆 on 13-4-24.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIViewController
{
    UIActivityIndicatorView * _indicatorView;
    UIImageView *logoImageView1;
    UIButton *photoButton;
}

@property (strong, nonatomic) IBOutlet UIImageView *backimage;
@property (nonatomic,retain)IBOutlet UIActivityIndicatorView * indicatorView;
@property (strong,nonatomic)NSDictionary *jsonDiction;
@property (retain, nonatomic) NSString *photoURL;
@property (retain, nonatomic) NSString *jumpURL;



@end

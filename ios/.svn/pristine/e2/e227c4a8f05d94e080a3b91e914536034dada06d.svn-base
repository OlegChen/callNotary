//
//  BasicViewController.h
//  notary
//
//  Created by 肖 喆 on 14-3-21.
//  Copyright (c) 2014年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController<ASIHTTPRequestDelegate>{


    ASIFormDataRequest *_tipsRequest;
     NSMutableArray *_msgArr;
    
    int _noReadMsgCount;
    UIButton * btnNumMessage;

}
@property (nonatomic,strong)NSMutableArray *_msgArr;
- (void)postHttpGetTipsNum;
- (void) alertWithMessage:(NSString *)msg;
-(void)addMessageNum;
-(void)removeMessageNum;
@end

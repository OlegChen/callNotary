//
//  SettingView.h
//  notary
//
//  Created by 肖 喆 on 13-3-5.
//  Copyright (c) 2013年 肖 喆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SettingView : UIViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *_contentTextArr;
    NSArray *_contentImageArr;
    NSMutableArray *_msgArr;
    int _noReadMsgCount;
    
    int _upLoadCount;
    int _downLoadCount;
    
    ASIFormDataRequest *_tipsRequest;
    ASIFormDataRequest *_outRequest;
    ASIFormDataRequest *_shareRequest;
    
    NSString *_shareText;
    NSString* _shareImageUrl;
    UIImage *_shareImage;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

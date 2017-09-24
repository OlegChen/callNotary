//
//  UserModel.h
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
{
    NSString * _uid;
    NSString * _userCode;
    NSString * _userID;
    NSString * _userName;
    NSString * _password;
    NSString * _phoneNumber;
    NSString * _secretKey;
    NSString * _isUseAlipay;
    NSString * _succRecordNum;
}
@property (strong, nonatomic)NSString * userCode;
@property (strong, nonatomic)NSString * userID;    //服务器id
@property (strong, nonatomic)NSString * userName;
@property (strong, nonatomic)NSString * password;
@property (strong, nonatomic)NSString * phoneNumber;
@property (strong, nonatomic)NSString * secretKey;
@property (strong, nonatomic)NSString * succRecordNum;

@property (strong, nonatomic)NSString * uid;//本地数据库id
@property BOOL isExist; //是否已经保存过 真是姓名，身份证号码
@property (strong, nonatomic)NSString * isUseAlipay;//判断是不是使用支付宝
@property int unReadMsgNum;//未读消息数量
@property (strong, nonatomic)NSString * transfer_tel;//中转电话400或者固话号码
+ (UserModel *)sharedInstance;
- (void)unLogin;
@end

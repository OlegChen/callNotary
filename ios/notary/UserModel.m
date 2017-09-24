//
//  UserModel.m
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "UserModel.h"

static UserModel * instance;

@implementation UserModel

+ (UserModel *)sharedInstance
{
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}
- (void)unLogin
{
    _userCode = nil;
    _userID = nil;
    _userName = nil;
    _password = nil;
    _phoneNumber = nil;
    _isUseAlipay = nil;
}
@end

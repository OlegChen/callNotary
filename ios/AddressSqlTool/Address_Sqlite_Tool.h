//
//  Address_Sqlite_Tool.h
//  notary
//
//  Created by he on 15/5/18.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address_Sqlite_Tool : NSObject

+ (void)setupAddressSqlite;

+(void)insertAddressWithName:(NSString *)name phoneNum:(NSString *)phoneNum;

+ (NSArray *)cacheWithAddressParameters;

+ (NSArray *)getSearchDataWithStr:(NSString *)str;

//批量插
+ (void)insertData:(NSMutableArray *)arr;
@end

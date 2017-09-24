//
//  Call_Note_sqliteTool.h
//  notary
//
//  Created by he on 15/5/13.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Call_Note_sqliteTool : NSObject

+ (void)setupSqlite;

+ (NSArray *)cacheWithParameters;

+(void)insertCall_NoteWithName:(NSString *)name phoneNum:(NSString *)phoneNum call_time:(NSString *)call_time;

+ (NSString *)getNowTime;

+(void)deleteCall_NoteWithName:(NSString *)name phoneNum:(NSString *)phoneNum call_time:(NSString *)call_time t_id:(NSString *)t_id;



@end

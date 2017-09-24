//
//  Call_Note_sqliteTool.m
//  notary
//
//  Created by he on 15/5/13.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Call_Note_sqliteTool.h"

#import "Call_Note_Model.h"
#import "FMDatabase.h"

@implementation Call_Note_sqliteTool

static FMDatabase *_db;


/*
 * 通话记录表
 */
+ (void)setupSqlite{
    
    _db = [FMDatabase databaseWithPath:[Sandbox storePath]];
    
    // 打开数据库
    if ([_db open]) {
        
        // 创建表
        BOOL success = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_call_note(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, phoneNum TEXT NOT NULL, call_time TEXT NOT NULL);"];
        
        if (success) {
            debugLog(@"创建表成功");
        }else
        {
            debugLog(@"创建表失败");
        }
    }else
    {
        debugLog(@"打开失败");
    }
    
}

//读取到的数据
+ (NSArray *)cacheWithParameters//:(IWRequestParameters *)parameters
{
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM t_call_note"];
    
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        
        Call_Note_Model *model = [[Call_Note_Model alloc]init];
        
        //int Id = [set intForColumn:Id];
        model.name = [set stringForColumn:@"name"];
        model.phoneNum = [set stringForColumn:@"phoneNum"];
        model.call_time = [set stringForColumn:@"call_time"];
        
        // 将模型添加到数组中
        [models addObject:model];
    }
    // 3.返回数组
    return models;
}

//插入数据
+(void)insertCall_NoteWithName:(NSString *)name phoneNum:(NSString *)phoneNum call_time:(NSString *)call_time{
    
    // 增加一条数据，在表中插入一条记录user值，由于id是自增，可以不传
    
    
    // 1.拿到数据库对象插入数据
    
    BOOL success = [_db executeUpdate:@"INSERT INTO t_call_note(name , phoneNum , call_time) VALUES(? , ? , ?);", name , phoneNum , call_time];
    if (success) {
        debugLog(@"保存数据成功");
    }else
    {
        debugLog(@"保存数据失败");
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_call_note" object:self userInfo:nil];
    
    
}

//删除数据
+(void)deleteCall_NoteWithName:(NSString *)name phoneNum:(NSString *)phoneNum call_time:(NSString *)call_time t_id:(NSString *)t_id{
    
    
    
    // 删除数据
    
    BOOL success = [_db executeUpdate:@"delete from t_call_note where call_time=?", call_time];
    if (success) {
        debugLog(@"删除数据成功");
    }else
    {
        debugLog(@"删除数据失败");
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_call_note" object:self userInfo:nil];
    
    
}



+ (NSString *)getNowTime{

    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM-dd hh:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    

    return locationString;

}

@end

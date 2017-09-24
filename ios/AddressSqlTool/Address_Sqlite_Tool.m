//
//  Address_Sqlite_Tool.m
//  notary
//
//  Created by he on 15/5/18.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Address_Sqlite_Tool.h"
#import "AddressCard.h"
#import "FMDatabase.h"

@implementation Address_Sqlite_Tool

static FMDatabase *_db;


/*
 * 通话记录表
 */
+ (void)setupAddressSqlite{
    
    _db = [FMDatabase databaseWithPath:[Sandbox storePath]];
    
    // 打开数据库
    if ([_db open]) {
        
        // 创建表
        BOOL success = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_address(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, phoneNum TEXT NOT NULL);"];
        
        if (success) {
            debugLog(@"创建表成功");
            
            BOOL success = [_db executeUpdate:@"delete from t_address"];
            [_db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_address'"];
            
                if (success) {
                    debugLog(@"清空数据数据成功");
                }else
                {
                    debugLog(@"清空数据失败");
                }

            
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
+ (NSArray *)cacheWithAddressParameters//:(IWRequestParameters *)parameters
{
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM t_address"];
    
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        
        AddressCard *model = [[AddressCard alloc]init];
        
        //int Id = [set intForColumn:Id];
        model.name = [set stringForColumn:@"name"];
        model.tel = [set stringForColumn:@"phoneNum"];
        
        // 将模型添加到数组中
        [models addObject:model];
    }
    // 3.返回数组
    return models;
}


+ (void)insertData:(NSMutableArray *)arr
{
    
    
    if (arr.count / 500 >= 1) {
        
        for (int i = 0; i < arr.count / 500 ; i ++) {
            
            
            [_db open];
            
            [_db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int j = i * 500; j < (i + 1) * 500; j ++) {
                    
                    AddressCard *card = arr[j];
                    
                    
                    NSString *sql = @"INSERT INTO t_address(name , phoneNum) VALUES(? , ? )";
                    BOOL a = [_db executeUpdate:sql,card.name,card.tel];
                    if (!a) {
                        NSLog(@"插入失败1");
                    }
                    
                    NSLog(@"保存数据成功");
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [_db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [_db commit];
                }
            }
            

            
            //最后剩下的

            [_db open];
            
            [_db beginTransaction];
            //BOOL isRollBack = NO;
            @try {
                for (long j = (arr.count / 500) * 500; j< arr.count; j++) {
                    
                    AddressCard *card = arr[j];
                    
                    
                    NSString *sql = @"INSERT INTO t_address(name , phoneNum) VALUES(? , ? )";
                    BOOL a = [_db executeUpdate:sql,card.name,card.tel];
                    if (!a) {
                        NSLog(@"插入失败1");
                    }
                    
                    NSLog(@"保存数据成功");
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [_db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [_db commit];
                }
            }

        
        }
        
        
        
        
    }else {
        
        
        [_db open];
        
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i<arr.count; i++) {
                
                AddressCard *card = arr[i];
                
                
                NSString *sql = @"INSERT INTO t_address(name , phoneNum) VALUES(? , ? )";
                BOOL a = [_db executeUpdate:sql,card.name,card.tel];
                if (!a) {
                    NSLog(@"插入失败1");
                }
                
                NSLog(@"保存数据成功");
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        }
        @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
        
        
    
    }
    

}

//插入数据
+(void)insertAddressWithName:(NSString *)name phoneNum:(NSString *)phoneNum{
    
    // 增加一条数据，在表中插入一条记录user值，由于id是自增，可以不传
    
    
    // 1.拿到数据库对象插入数据
//    
    BOOL success = [_db executeUpdate:@"INSERT INTO t_address(name , phoneNum) VALUES(? , ? );", name , phoneNum ];
    if (success) {
        debugLog(@"保存数据成功");
    }else
    {
        debugLog(@"保存数据失败");
    }
//
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_call_note" object:self userInfo:nil];
    
    
}

//删除数据
+(void)deleteAddressWithName:(NSString *)name phoneNum:(NSString *)phoneNum call_time:(NSString *)call_time t_id:(NSString *)t_id{
    
    
    
    // 删除数据
//    
//    BOOL success = [_db executeUpdate:@"delete from t_call_note where call_time=?", call_time];
//    if (success) {
//        debugLog(@"删除数据成功");
//    }else
//    {
//        debugLog(@"删除数据失败");
//    }
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_call_note" object:self userInfo:nil];
    
    
}

/*
 * 模糊查询
 */
+ (NSArray *)getSearchDataWithStr:(NSString *)str{

    FMResultSet *set = nil;
    
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_address WHERE name like '%@%%' or phoneNum like '%@%%'",str,str];//模糊查询，查找alpha中 以 item.dream_keyword 开头的内容
    
    set = [_db executeQuery:sql];
    
    //set = [_db executeQuery:@"select * from t_address where name like '%?%' or phoneNum like '%?%'",str,str];
    
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        

        
        AddressCard *model = [[AddressCard alloc]init];
        
        //int Id = [set intForColumn:Id];
        model.name = [set stringForColumn:@"name"];
        model.tel = [set stringForColumn:@"phoneNum"];
        
        // 将模型添加到数组中
        [models addObject:model];
    }
    // 3.返回数组
    return models;
    
       // select * from tb_name t ifnull(t.cloum) like '%a%' or ifnull(t.cloum) like '%b%' or ifnull(t.cloum) like '%c%'
    
}




@end

//
//  DataBaseManager.m
//  fengyz
//
//  Created by 肖 喆 on 13-1-4.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabase.h"



@implementation DataBaseManager


- (void)dealloc {
    
    [_dbPath release],_dbPath = nil;
    [_db release],_db = nil;
    [super dealloc];
}

- (id)init {
    
    if (self = [super init]) {
        
         _db = [[FMDatabase databaseWithPath:[Sandbox storePath]]retain];
     
    }
    return self;
}


- (FMResultSet *)query:(NSString *)sql parameter:(NSArray *)parameter
{
    if ([_db open] == NO) {
        NSLog(@"query open db failed !");
    }
    FMResultSet* results = [_db executeQuery:sql withArgumentsInArray:parameter];
    return results;
}
- (FMResultSet *)query:(NSString *)sql
{
    if ([_db open] == NO) {
        NSLog(@"query open db failed !");
    }
    FMResultSet* results = [_db executeQuery:sql];
    return results;
}
- (BOOL)insert:(NSString *)sql parameter:(NSArray *)parameter {
    return [self update:sql parameter:parameter];
}
- (BOOL)update:(NSString *)sql parameter:(NSArray *)parameter {
    
    if ([_db open] == NO) {
        NSLog(@"update open db failed !");
    }
    if ([_db executeUpdate:sql withArgumentsInArray:parameter] == NO) {
        NSLog(@"%@ failed !",sql);
        [_db close];
        return NO;
    }
    [_db close];
    return YES;
}

//- (NSMutableArray *)query:(NSString *)sql parameter:(NSArray *)parameter {
//    
//    if ([_db open] == NO) {
//        NSLog(@"query open db failed !");
//    }
//    FMResultSet* results = [_db executeQuery:sql withArgumentsInArray:parameter];
//    NSMutableArray* shopcarts = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    while ([results next]) {
//        NSLog(@"results is %@",results);
//        /*
//        MyShopingCartModel* cart = [[MyShopingCartModel alloc] init];
//        cart.myShopingCartModelGoodsID = [results stringForColumn:@"ID"];
//        cart.myShopingCartModelGoodsTitle = [results stringForColumn:@"NAME"];
//        cart.myShopingCartModelGoodsPrice = [NSString stringWithFormat:@"%.2f",
//                                             [results doubleForColumn:@"PRICE"]];
//        cart.myShopingCartModelGoodsNumber = [NSString stringWithFormat:@"%d",
//                                              [results intForColumn:@"NUMBER"]];
//        [shopcarts addObject:cart];
//        [cart release];
//        */
//    }
//     
//    [_db close];
//    return [shopcarts autorelease];
//}
//
//
//
//- (NSMutableArray *)query:(NSString *)sql {
//    
//    if ([_db open] == NO) {
//        NSLog(@"open db failed !");
//    }
//    FMResultSet* results = [_db executeQuery:sql];
//    NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    while ([results next]) {
//        
//        NSLog(@"%@",results);
//        
//        NSString * sceneName = [results stringForColumnIndex:0];
//        NSString * cityID = [ results stringForColumnIndex:1];
//        NSString * cityName  = [results stringForColumnIndex:2];
//        
//        [arr addObject:[NSArray arrayWithObjects:sceneName,cityID,cityName, nil]];
//        
//        NSLog(@"%@%@%@",sceneName,cityID,cityName);
//        
//        
//        /*
//        MyShopingCartModel* cart = [[MyShopingCartModel alloc] init];
//        cart.myShopingCartModelGoodsID = [results stringForColumn:@"ID"];
//        cart.myShopingCartModelGoodsTitle = [results stringForColumn:@"NAME"];
//        cart.myShopingCartModelGoodsPrice = [NSString stringWithFormat:@"%.2f",
//                                             [results doubleForColumn:@"PRICE"]];
//        cart.myShopingCartModelGoodsNumber = [NSString stringWithFormat:@"%d",
//                                              [results intForColumn:@"NUMBER"]];
//        ShopsMainModel* shopsModel = [[ShopsMainModel alloc] init];
//        shopsModel.shopsMainModelID = [NSString stringWithFormat:@"%d",
//                                       [results intForColumn:@"TRADERID"]];
//        cart.shopsMainModel = shopsModel;
//        [shopsModel release];
//        [shopcarts addObject:cart];
//        [cart release];
//        */
//    }
//    [_db close];
//    return [arr autorelease];
//}

- (void)test {
    
    DataBaseManager* db = [[DataBaseManager alloc] init];
    
    NSString * sql_city = @"INSERT INTO city(ID,NAME,sceneAreaCount) VALUES (?,?,?);";
    NSArray * par_city = [NSArray arrayWithObjects:@"1001",@"北京",@"75", nil];
    [db insert:sql_city parameter:par_city];
    
    NSString * sql_sceneRegion = @"INSERT INTO sceneRegion(ID,NAME,SCENECOUNT,CITY_ID) VALUES (?,?,?,?);";
    NSArray * par_sceneRegion = [NSArray arrayWithObjects:@"1",@"故宫",@"75",@"1001", nil];
    [db insert:sql_sceneRegion parameter:par_sceneRegion];
    
    NSString * sql_history = @"INSERT INTO history(KEY) VALUES (?);";
    NSArray * par_history = [NSArray arrayWithObjects:@"北京", nil];
    [db insert:sql_history parameter:par_history];
    
}
- (void)close {
    [_db close];
}
@end

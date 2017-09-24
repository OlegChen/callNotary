//
//  DataBaseManager.h
//  fengyz
//
//  Created by 肖 喆 on 13-1-4.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBaseManager : NSObject
{
    FMDatabase * _db;
    NSString * _dbPath;
}

- (void)copyDBToDocumnet;
//add
- (BOOL)insert:(NSString *)sql parameter:(NSArray *)parameter;
//update and delete
- (BOOL)update:(NSString *)sql parameter:(NSArray *)parameter;

//select
- (FMResultSet *)query:(NSString *)sql parameter:(NSArray *)parameter;
- (FMResultSet *)query:(NSString *)sql;

- (void)close;

- (void)test;

@end

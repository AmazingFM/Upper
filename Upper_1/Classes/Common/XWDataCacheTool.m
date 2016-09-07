//
//  XWDataCacheTool.m
//  新闻
//
//  Created by user on 15/10/5.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "XWDataCacheTool.h"

static FMDatabaseQueue *_queue;

@implementation XWDataCacheTool

+(void)initialize
{
    NSString *path= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"news.sqlite"];
    _queue=[FMDatabaseQueue databaseQueueWithPath:path];
    //创建表
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"create table if not exists info(ID integer primary key autoincrement,data blob,idstr text)"];
        if(!b){
            NSLog(@"创建表失败");
        }
    }];
   // NSLog(@"%@",path);
}


+(void)addArr:(NSArray *)arr andId:(NSString *)idstr
{
    //NSLog(@"data   %@",idstr);
    for(NSDictionary *dict in arr) {
        [self addDict:dict andId:idstr];
    }
}
+(void)addDict:(NSDictionary *)dict andId:(NSString *)idstr
{
    [_queue inDatabase:^(FMDatabase *db) {
            NSData *data=[NSKeyedArchiver archivedDataWithRootObject:dict];
            [db executeUpdate:@"insert into info(data,idstr) values(?,?)",data,idstr];
            
    }];
    
}
//返回数组
+(NSArray *)dataWithID:(NSString *)ID
{
    __block NSMutableArray *arr=nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result=[db executeQuery:@"select * from info where idstr=?",ID];
        if(result){
            arr=[NSMutableArray array];
            while ([result next]) {
                NSData *data=[result dataForColumn:@"data"];
                // NSString *idstr=[result stringForColumn:@"idstr"];
                //转成字典
                NSDictionary *dict=[NSKeyedUnarchiver unarchiveObjectWithData:data];
                [arr addObject:dict];
            }
        }
        
    }];
    return arr;
}
#pragma mark 删除对应的数据
+(void)deleteWidthId:(NSString *)ID
{
    
    [_queue inDatabase:^(FMDatabase *db) {
        //delete from info where idstr='T1348648517839'
        BOOL b=[db executeUpdate:@"delete  from info where idstr=?",ID];
        if(!b){
            NSLog(@"删除失败");
        }
    }];
    
}

@end

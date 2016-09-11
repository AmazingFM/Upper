//
//  MessageManager.m
//  Upper
//
//  Created by freshment on 16/7/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "MessageManager.h"
#import "UPTimerManager.h"
#import "UPDataManager.h"
#import "XWHttpTool.h"
#import "Info.h"
#import "UUMessage.h"

@interface MessageManager()
{
    FMDatabase *messageDb;
}

@property (nonatomic, retain) NSMutableArray<UUMessage *> *messageList;
@property (nonatomic, retain) NSMutableDictionary *groupMessageList;

@end

@implementation MessageManager

+ (instancetype)shared
{
    static MessageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MessageManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeDB];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kNotifierLogin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:kNotifierLogout object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullMessage) name:kNotifierMessagePull object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:kNotifierMessageSending object:nil];
    }
    return self;
}

- (void)initEnv
{
    [self.messageList removeAllObjects];
    [self.groupMessageList removeAllObjects];
}

- (void)initializeDB
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"home:%@",path);
    messageDb = [FMDatabase databaseWithPath:[path stringByAppendingPathComponent:@"message.sqlite"]];
    
    BOOL flag = [messageDb open];
    if (flag) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    
    //建表消息列表
    flag = [messageDb executeUpdate:@"create table if not exists messages_detail (id integer primary key autoincrement, from_id text, to_id text, nick_name text, message_desc text, message_from integer, message_type integer, add_time text, status text)"];
    
    flag = [messageDb executeUpdate:@"create table if not exists messages_group (id integer primary key autoincrement, from_id text unique, to_id text, nick_name text, newest_message text, add_time text, status text)"];
    
//    flag = [messageDb executeUpdate:@"create unique index from_id_index on messages_group(from_id)"];
    
    if (flag) {
        NSLog(@"建表messages成功");
    } else {
        NSLog(@"建表messages失败");
    }
    
    [self test:@"20160825121212"];
    [messageDb close];
}



- (NSMutableArray *)messageList
{
    if (_messageList==nil) {
        _messageList = [NSMutableArray new];
    }
    return _messageList;
}

- (NSMutableDictionary*)groupMessageList
{
    if (_groupMessageList==nil) {
        _groupMessageList = [NSMutableDictionary new];
    }
    return _groupMessageList;
}

- (void)login:(NSNotification *)notice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierLogin object:nil];
    [UPTimerManager createTimer:@"TimeToPullMessage" notice:kNotifierMessagePull heartTime:10.0f];
    [[UPTimerManager shared] startTimeMachine:@"TimeToPullMessage"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kNotifierLogin object:nil];
}

- (void)logout:(NSNotification *)notice
{
    [[UPTimerManager shared] stopTimeMachine:@"TimeToPullMessage"];
}


- (void)pullMessage
{
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setValue:@"MessageGet" forKey:@"a"];

    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];

    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSLog(@"MessageGet:%@", dict);

        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];

            int totalCnt =  [resp_data[@"total_count"] intValue];
            if (totalCnt!=0) {
                NSString *msglist = resp_data[@"message_list"];
                if ([msglist isKindOfClass:[NSArray class]]) {
                    NSMutableArray *msgArr = (NSMutableArray*)msglist;
                    for (NSDictionary *dict in msgArr) {
                        UUMessage *msg = [[UUMessage alloc] init];
                        msg.from = UUMessageFromOther;
                        msg.type = UUMessageTypeText;
                        msg.strId = dict[@"from_id"];
                        msg.strToId = dict[@"to_id"];
                        msg.strName = dict[@"nick_name"];
                        msg.strContent = dict[@"message_desc"];
                        msg.strTime = dict[@"add_time"];
                        msg.status = dict[@"status"];
                        
                        if (self.groupMessageList[msg.strId]==nil) {
                            self.groupMessageList[msg.strId] = msg;
                        } else {
                            UUMessage *oldMsg = self.groupMessageList[msg.strId];
                            if ([oldMsg.strTime compare:msg.strTime]==NSOrderedAscending) {
                                self.groupMessageList[msg.strId] = msg;
                            }
                        }
                        [self.messageList addObject:msg];
                    }
                    
                    BOOL result = [self updateMessages];
                    if (result) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierMessageComing object:self.messageList];
                        [self.messageList removeAllObjects];
                        NSLog(@"更新成功");
                    }
                    
                    result = [self updateGroupMessage];
                    if (result) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierMessageGroupUpdate object:self.groupMessageList];
                        [self.groupMessageList removeAllObjects];
                        NSLog(@"更新成功");
                    }

                    
                }
            }
        }
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];
}

- (void)sendMessage:(NSNotification *)notification
{
    UUMessage *msg = notification.object;
    
    NSDictionary *headParam1 = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithDictionary:headParam1];
    [params1 setValue:@"MessageSend" forKey:@"a"];

    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"to_id"];
    [params1 setValue:@"0"forKey:@"message_type"];
    [params1 setValue:msg.strContent forKey:@"message_desc"];
    [params1 setValue:@"" forKey:@"expire_time"];

    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params1 success:^(id json) {

        NSDictionary *dict = (NSDictionary *)json;
        NSLog(@"MessageSend, %@", dict);
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
//            NSDictionary *resp_data = dict[@"resp_data"];
            NSLog(@"send message successful!");
        }
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark - 操作表:消息detail
- (BOOL)updateMessages
{
    [messageDb open];
    
    [messageDb beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (UUMessage *msg in self.messageList)
        {
            NSString *sql = @"insert into messages_detail (from_id, to_id, nick_name, message_desc, message_from, message_type, add_time, status) values(?,?,?,?,?,?,?,?)";
            BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, [NSNumber numberWithInt:msg.from], [NSNumber numberWithInt:msg.type], msg.strTime, msg.status ];
            if (!a) {
                NSLog(@"插入失败");
            }
        }

    } @catch (NSException *exception) {
        isRollBack = YES;
        [messageDb rollback];
    } @finally {
        if (!isRollBack) {
            [messageDb commit];
        }
    }
    [messageDb close];
    return !isRollBack;
}

/**
 *根据参数获取指定位置的记录
 */
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId
{
    [messageDb open];
    
    long begin = range.location;
    long end = range.location+range.length;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail order by add_time desc limit %ld,%ld", begin, end];
    
    NSMutableArray *msglist = [NSMutableArray new];
    
    FMResultSet *s = [messageDb executeQuery:querySql];
    if ([s next]) {
        UUMessage *msg = [[UUMessage alloc] init];
        
        msg.strId = [s stringForColumnIndex:1];
        msg.strToId = [s stringForColumnIndex:2];
        msg.strName = [s stringForColumnIndex:3];
        msg.strContent = [s stringForColumnIndex:4];
        msg.from = [s intForColumnIndex:5];
        msg.type = [s intForColumnIndex:6];
        msg.strTime = [s stringForColumnIndex:7];
        msg.status = [s stringForColumnIndex:8];
    
        [msglist addObject:msg];
    }
    [messageDb close];
    return msglist;
}

#pragma mark - 操作表:消息组
- (BOOL)updateGropuMessageStatus:(NSString *)user_id
{
    [messageDb open];
    NSString *updateSql = [NSString stringWithFormat:@"update messages_group set status='1' where from_id='%@'", user_id];
    BOOL res = [messageDb executeUpdate:updateSql];
    if (!res) {
        NSLog(@"更新失败");
    } else {
        NSLog(@"更新成功");
    }
    [messageDb close];
    return res;
}

/**
 if exists(select 1 from 表 where xxxx)
 begin
 update 表 set xxxxxx
 end
 else
 begin
 insert into 表(xxx)
 select xxxxx
 end
 */
- (BOOL)updateGroupMessage
{
    [messageDb open];
    
    [messageDb beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (NSString *key in self.groupMessageList) {
            UUMessage *msg = self.groupMessageList[key];
            NSString *sql = @"insert or replace into messages_group (from_id, to_id, nick_name, newest_message, add_time, status) values(?,?,?,?,?,?)";

            BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, msg.strTime, msg.status ];
            if (!a) {
                NSLog(@"插入失败");
            }
        }
        
    } @catch (NSException *exception) {
        isRollBack = YES;
        [messageDb rollback];
    } @finally {
        if (!isRollBack) {
            [messageDb commit];
        }
    }
    [messageDb close];
    return !isRollBack;
}

/**
 *from_id text, to_id text, nick_name text, newest_message text, add_time text, status text
 */

- (NSMutableArray *)getMessageGroup
{
    [messageDb open];
    
    NSMutableArray *messageGoup = [NSMutableArray new];
    
    NSString *querySql = @"select * from messages_group order by add_time desc";
    FMResultSet *s = [messageDb executeQuery:querySql];
    if ([s next]) {
        UUMessage *msg = [[UUMessage alloc] init];
        
        msg.strId = [s stringForColumnIndex:1];
        msg.strToId = [s stringForColumnIndex:2];
        msg.strName = [s stringForColumnIndex:3];
        msg.strContent = [s stringForColumnIndex:4];
        msg.strTime = [s stringForColumnIndex:5];
        msg.status = [s stringForColumnIndex:6];
        
        [messageGoup addObject:msg];
    }
    [messageDb close];
    return messageGoup;
}

/**
 *根据参数获取指定位置的记录
 */
- (NSMutableDictionary *)getMessageGroup:(NSRange)range;
{
    [messageDb open];
    
    long begin = range.location;
    long end = range.location+range.length;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from messages_group order by add_time desc limit %ld,%ld", begin, end];
    
    NSMutableDictionary *msgDict = [NSMutableDictionary new];
    
    FMResultSet *s = [messageDb executeQuery:querySql];
    if ([s next]) {
        UUMessage *msg = [[UUMessage alloc] init];
        
        msg.strId = [s stringForColumnIndex:1];
        msg.strToId = [s stringForColumnIndex:2];
        msg.strName = [s stringForColumnIndex:3];
        msg.strContent = [s stringForColumnIndex:4];
        msg.strTime = [s stringForColumnIndex:5];
        msg.status = [s stringForColumnIndex:6];
        
        msgDict[msg.strId] = msg;
    }
    [messageDb close];
    return msgDict;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)test:(NSString *)time
{
    [self.messageList removeAllObjects];
    [self.groupMessageList removeAllObjects];
    for (int i=0; i<999; i++) {
        UUMessage *msg = [[UUMessage alloc] init];
        msg.from = UUMessageFromOther;
        msg.type = UUMessageTypeText;
        msg.strId = [NSString stringWithFormat:@"%d", i+1000];
        msg.strToId = @"2000";
        msg.strName = [NSString stringWithFormat:@"name_%d", i+1000];
        msg.strContent = [NSString stringWithFormat:@"content_%d", i+1000];
        msg.strTime = time;//@"20160825111111";
        msg.status = @"0";
        
        [self.messageList addObject:msg];
        
        if (self.groupMessageList[msg.strId]==nil) {
            self.groupMessageList[msg.strId] = msg;
        } else {
            UUMessage *oldMsg = self.groupMessageList[msg.strId];
            if ([oldMsg.strTime compare:msg.strTime]==NSOrderedAscending) {
                self.groupMessageList[msg.strId] = msg;
            }
        }

    }
    BOOL result = [self updateMessages];
    result = [self updateGroupMessage];
    return result;
}
@end

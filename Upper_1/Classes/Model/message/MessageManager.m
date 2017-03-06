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
#import "YMNetwork.h"


#define SYSTEMTABLE @"SysTable"
#define USRTABLE    @"UsrTable"

@implementation GroupMessage

- (NSMutableArray *)messageList
{
    if (_messageList==nil) {
        _messageList = [NSMutableArray new];
    }
    return _messageList;
}

@end

@interface MessageManager()
{
//    FMDatabase *messageDb;
}

@property (nonatomic, retain) NSMutableArray<UUMessage *> *messageList;
@property (nonatomic, retain) NSMutableArray<UUMessage *> *groupMessageList;

@property (nonatomic, retain) FMDatabaseQueue *fmQueue;
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
//        [self initializeDB];
        
        //这是在一个代码块中
        [self.fmQueue inDatabase:^(FMDatabase *db) {
            //建表消息列表
            BOOL flag = [db executeUpdate:@"create table if not exists SysTable (local_id char(10) not null, local_name varchar(50) not null, remote_id varchar(10) not null, remote_name varchar(50) not null, msg_desc varchar(512) not null, source integer not null, add_time char(14) not null, msg_status char(1), msg_type integer not null, msg_key varchar(256)) "];
            
            flag = [db executeUpdate:@"create table if not exists UsrTable (local_id char(10) not null, local_name varchar(50) not null, remote_id varchar(10) not null, remote_name varchar(50) not null, msg_desc varchar(512) not null, source integer not null, add_time char(14) not null, msg_status char(1), msg_type integer not null, msg_key varchar(256)) "];
            
            if (flag) {
                NSLog(@"建表messages成功");
            } else {
                NSLog(@"建表messages失败");
            }

            //保持数据库开启
            if (![db open]) {
                
                return ;
            }  
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kNotifierLogin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:kNotifierLogout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMessages) name:kNotifierMessagePull object:nil];
    }
    return self;
}

- (void)login:(NSNotification *)notice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kNotifierLogin object:nil];
    
    [UPTimerManager createTimer:@"TimeToPullMessage" notice:kNotifierMessagePull heartTime:10.0f];
    [[UPTimerManager shared] startTimeMachine:@"TimeToPullMessage"];
}

- (void)logout:(NSNotification *)notice
{
    [[UPTimerManager shared] stopTimeMachine:@"TimeToPullMessage"];
}

-(FMDatabaseQueue *)fmQueue
{
    if (_fmQueue== nil) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/message.sqlite"];
        _fmQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        NSLog(@"%@",dbPath);
    }
    
    return _fmQueue;
}

- (void)initializeDB
{
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSLog(@"home:%@",path);
//    messageDb = [FMDatabase databaseWithPath:[path stringByAppendingPathComponent:@"message.sqlite"]];
//    
//    BOOL flag = [messageDb open];
//    if (flag) {
//        NSLog(@"数据库打开成功");
//    } else {
//        NSLog(@"数据库打开失败");
//    }
//    
//    //建表消息列表
//    flag = [messageDb executeUpdate:@"create table if not exists SysTable (local_id char(10) not null, local_name varchar(50) not null, remote_id varchar(10) not null, remote_name varchar(50) not null, msg_desc varchar(512) not null, source integer not null, add_time char(14) not null, msg_status char(1), msg_type integer not null, msg_key varchar(256)) "];
//    
//    flag = [messageDb executeUpdate:@"create table if not exists UsrTable (local_id char(10) not null, local_name varchar(50) not null, remote_id varchar(10) not null, remote_name varchar(50) not null, msg_desc varchar(512) not null, source integer not null, add_time char(14) not null, msg_status char(1), msg_type integer not null, msg_key varchar(256)) "];
//
//    if (flag) {
//        NSLog(@"建表messages成功");
//    } else {
//        NSLog(@"建表messages失败");
//    }
//    [messageDb close];
}

- (NSDictionary *)parseMessages:(NSArray *)msgArr
{
    NSMutableArray *sysMsgList = [NSMutableArray new];
    NSMutableArray *actMsgList = [NSMutableArray new];
    NSMutableArray *usrMsgList = [NSMutableArray new];
    
    if (msgArr.count==0) {
        return nil;
    }
    
    for (NSDictionary *dict in msgArr) {
        PrivateMessage *priMsg  = [[PrivateMessage alloc] init];
        priMsg.remote_id        = dict[@"from_id"];
        priMsg.remote_name      = dict[@"nick_name"];
        priMsg.msg_desc     = dict[@"message_desc"];
        priMsg.add_time         = dict[@"add_time"];
        priMsg.status           = dict[@"status"];
        priMsg.message_type     = dict[@"message_type"];//不存数据库
        
        priMsg.source           = MessageSourceOther;
        priMsg.local_id         = [UPDataManager shared].userInfo.ID;
        priMsg.local_name       = [UPDataManager shared].userInfo.nick_name;
        priMsg.msg_key          = @"uniquexxx";
        
        
        //99为邀请类消息， from_id为0时为系统消息
        if ([priMsg.remote_id intValue]==0) {
            priMsg.localMsgType = MessageTypeSystemGeneral;
        } else {
            int msgType = [priMsg.message_type intValue];
            if (msgType==99) {
                priMsg.localMsgType = MessageTypeActivityInvite;
            } else if (msgType==98) {
                priMsg.localMsgType = MessageTypeActivityChangeLauncher;
            } else {
                priMsg.localMsgType = MessageTypeCommonText;
            }
        }
        
        switch (priMsg.localMsgType) {
            case MessageTypeSystemGeneral:
            {
                [sysMsgList addObject:priMsg];
            }
                break;
            case MessageTypeActivityInvite:
            case MessageTypeActivityChangeLauncher:
            {
                [actMsgList addObject:priMsg];
            }
                break;
            case MessageTypeCommonText:
            case MessageTypeCommonImage:
            case MessageTypeCommonMix:
            {
                [usrMsgList addObject:priMsg];
            }
                break;
            default:
                break;
        }
    }
    
    NSMutableDictionary *msgGroupDict = [NSMutableDictionary new];
    [msgGroupDict setObject:sysMsgList forKey:SysMsgKey];
    [msgGroupDict setObject:actMsgList forKey:ActMsgKey];
    [msgGroupDict setObject:usrMsgList forKey:UsrMsgKey];
    
    return msgGroupDict;
}

- (void)insertMsgGroupDict:(NSDictionary *)msgGroupDict
{
    [self.fmQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        
        NSString *sysInsertSql = @"insert into SysTable (local_id, local_name, remote_id, remote_name, msg_desc, source, add_time, msg_status, msg_type, msg_key) values(?,?,?,?,?,?,?,?,?,?)";
        
        NSString *usrInsertSql = @"insert into UsrTable (local_id, local_name, remote_id, remote_name, msg_desc, source, add_time, msg_status, msg_type, msg_key) values(?,?,?,?,?,?,?,?,?,?)";
        
        NSArray *insertSqls = @[sysInsertSql, usrInsertSql];
        NSArray *msgKeys = @[SysMsgKey, UsrMsgKey];
        
        @try {
            for (int i=0; i<2; i++) {
                NSString *insertSql = insertSqls[i];
                
                NSMutableArray *msgList = [NSMutableArray new];
                if (i==0) {
                    [msgList addObjectsFromArray:msgGroupDict[SysMsgKey]];
                    [msgList addObjectsFromArray:msgGroupDict[ActMsgKey]];
                } else if (i==1) {
                    [msgList addObjectsFromArray:msgGroupDict[UsrMsgKey]];
                }
                
                
                if (msgList.count>0) {
                    for (PrivateMessage *msg in msgList) {
                        BOOL a = [db executeUpdate:insertSql,
                                  msg.local_id,     msg.local_name,
                                  msg.remote_id,    msg.remote_name,
                                  msg.msg_desc, [NSNumber numberWithInt:msg.source],
                                  msg.add_time,     msg.status,
                                  [NSNumber numberWithInt:msg.localMsgType],
                                  msg.msg_key];
                        if (!a) {
                            NSLog(@"插入失败：%@",msgKeys[i]);
                        }
                    }
                }
            }
        }@catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        } @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
    }];
}

- (void)requestMessages
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"MessageGet" forKey:@"a"];
    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"MessageGet:%@", dict);
        
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            int totalCnt =  [resp_data[@"total_count"] intValue];
            if (totalCnt!=0) {
                NSString *msglist = resp_data[@"message_list"];
                if ([msglist isKindOfClass:[NSArray class]]) {
                    NSMutableArray *msgArr = (NSMutableArray*)msglist;
                    
                    NSDictionary *msgGroupDict = [self parseMessages:msgArr];
                    
                    if (msgGroupDict) {
                        [self insertMsgGroupDict:msgGroupDict];
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierMessageComing object:nil userInfo:msgGroupDict];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (NSArray<PrivateMessage *> *)getMessagesByType:(MessageType)type
{
    __block NSMutableArray<PrivateMessage *> *msgList = [NSMutableArray new];
    [self.fmQueue inDatabase:^(FMDatabase *db) {
        NSString *queryCondition = nil;
        
        if (type==MessageTypeSystem) {
            queryCondition = @"msg_type=3";
        } else if (type==MessageTypeActivity) {
            queryCondition = @"msg_type=4 or msg_type=5";
        }
        
        if (type==MessageTypeSystem ||
            type==MessageTypeActivity) {
            NSString *querySql = [NSString stringWithFormat:@"select * from SysTable where %@ order by add_time desc",queryCondition];
            FMResultSet *s = [db executeQuery:querySql];
            while (s.next) {
                PrivateMessage *msg = [[PrivateMessage alloc] init];
                msg.local_id        = [s stringForColumn:@"local_id"];
                msg.local_name      = [s stringForColumn:@"local_name"];
                msg.remote_id       = [s stringForColumn:@"remote_id"];
                msg.remote_name     = [s stringForColumn:@"remote_name"];
                msg.msg_desc        = [s stringForColumn:@"msg_desc"];
                msg.source          = [s intForColumn:@"source"];
                msg.add_time        = [s stringForColumn:@"add_time"];
                msg.status          = [s stringForColumn:@"msg_status"];
                msg.localMsgType    = [s intForColumn:@"msg_type"];
                msg.msg_key         = [s stringForColumn:@"msg_key"];
                
                [msgList addObject:msg];
            }
        } else if (type==MessageTypeCommon) {
            NSString *querySql = [NSString stringWithFormat:@"select * from (select * from UsrTable where local_id='%@' order by add_time asc) group by remote_id", [UPDataManager shared].userInfo.ID];
            
            FMResultSet *s = [db executeQuery:querySql];
            while (s.next) {
                PrivateMessage *msg = [[PrivateMessage alloc] init];
                msg.local_id        = [s stringForColumn:@"local_id"];
                msg.local_name      = [s stringForColumn:@"local_name"];
                msg.remote_id       = [s stringForColumn:@"remote_id"];
                msg.remote_name     = [s stringForColumn:@"remote_name"];
                msg.msg_desc        = [s stringForColumn:@"msg_desc"];
                msg.source          = [s intForColumn:@"source"];
                msg.add_time        = [s stringForColumn:@"add_time"];
                msg.status          = [s stringForColumn:@"msg_status"];
                msg.localMsgType    = [s intForColumn:@"msg_type"];
                msg.msg_key         = [s stringForColumn:@"msg_key"];
                
                [msgList addObject:msg];
            }
        }
    }];
    
    return msgList;
}

- (NSArray<PrivateMessage *> *)getMessagesByUser:(NSString *)userId
{
    __block NSMutableArray<PrivateMessage *> *msgList = [NSMutableArray new];
    [self.fmQueue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from UsrTable where local_id='%@' and remote_id='%@' order by add_time desc", [UPDataManager shared].userInfo.ID, userId];
        FMResultSet *s = [db executeQuery:querySql];
        while (s.next) {
            PrivateMessage *msg = [[PrivateMessage alloc] init];
            msg.local_id        = [s stringForColumn:@"local_id"];
            msg.local_name      = [s stringForColumn:@"local_name"];
            msg.remote_id       = [s stringForColumn:@"remote_id"];
            msg.remote_name     = [s stringForColumn:@"remote_name"];
            msg.msg_desc        = [s stringForColumn:@"msg_desc"];
            msg.source          = [s intForColumn:@"source"];
            msg.add_time        = [s stringForColumn:@"add_time"];
            msg.status          = [s stringForColumn:@"msg_status"];
            msg.localMsgType    = [s intForColumn:@"msg_type"];
            msg.msg_key         = [s stringForColumn:@"msg_key"];
            
            [msgList addObject:msg];
        }
    }];

    return msgList;
}

- (BOOL)insertOneMessage:(PrivateMessage *)msg
{
    __block BOOL ret;
    [self.fmQueue inDatabase:^(FMDatabase *db) {
        NSString *usrInsertSql = @"insert into UsrTable (local_id, local_name, remote_id, remote_name, msg_desc, source, add_time, msg_status, msg_type, msg_key) values(?,?,?,?,?,?,?,?,?,?)";
        
        ret = [db executeUpdate:usrInsertSql,
                  msg.local_id,     msg.local_name,
                  msg.remote_id,    msg.remote_name,
                  msg.msg_desc, [NSNumber numberWithInt:msg.source],
                  msg.add_time,     msg.status,
                  [NSNumber numberWithInt:msg.localMsgType],
                  msg.msg_key];
        if (!ret) {
            NSLog(@"发送信息插入失败");
        }

    }];
    return ret;
}

- (UUMessage *)msgInGroup:(NSString *)fromID andType:(UUMessageType)msgType
{
    UUMessage *message = nil;
    
    for (UUMessage *msg in self.groupMessageList) {
        //处理三种类型的消息
        switch (msgType) {
            case UPMessageTypeNormal:
                if ([msg.strId isEqualToString:fromID]) {
                    message = msg;
                }
                break;
            case UPMessageTypeSys:
                if (msg.type==UPMessageTypeSys) {
                    message = msg;
                }
                break;
            case UPMessageTypeInvite:
                if (msg.type==UPMessageTypeInvite) {
                    message = msg;
                }
                break;
        }
    }
    
    return message;
}

#pragma mark - 操作表:消息detail
- (BOOL)updateOneMessage:(UUMessage *)msg
{
//    [messageDb open];
//    NSString *sql = @"insert into messages_detail (from_id, to_id, nick_name, message_desc, message_from, message_type, add_time, status) values(?,?,?,?,?,?,?,?)";
//    BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, [NSNumber numberWithInt:msg.from], [NSNumber numberWithInt:msg.type], msg.strTime, msg.status ];
//    [messageDb close];
//    return a;
    return NO;
}

/**
 *根据参数获取指定位置的记录
 */
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId andType:(UUMessageType)msgType
{
//    [messageDb open];
//    
//    long begin = range.location;
//    long end = range.location+range.length;
//    
//    if (msgType==UPMessageTypeNormal) {
//        NSString *to_id = [UPDataManager shared].userInfo.ID;
//        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where from_id='%@' and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld",userId, to_id, UPMessageTypeNormal,begin, end];
//        
//        NSMutableArray *msglist = [NSMutableArray new];
//        
//        FMResultSet *s = [messageDb executeQuery:querySql];
//        while (s.next) {
//            UUMessage *msg = [[UUMessage alloc] init];
//            
//            msg.strId = [s stringForColumnIndex:1];
//            msg.strToId = [s stringForColumnIndex:2];
//            msg.strName = [s stringForColumnIndex:3];
//            msg.strContent = [s stringForColumnIndex:4];
//            msg.from = [s intForColumnIndex:5];
//            msg.type = [s intForColumnIndex:6];
//            msg.strTime = [s stringForColumnIndex:7];
//            msg.status = [s stringForColumnIndex:8];
//            
//            msg.subType = UPMessageSubTypeText;
//            
//            [msglist addObject:msg];
//        }
//        [messageDb close];
//        return msglist;
//    } else if (msgType==UPMessageTypeInvite) {
//        NSString *to_id = [UPDataManager shared].userInfo.ID;
//        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld", to_id, UPMessageTypeInvite,begin, end];
//        
//        NSMutableArray *msglist = [NSMutableArray new];
//        
//        FMResultSet *s = [messageDb executeQuery:querySql];
//        while (s.next) {
//            UUMessage *msg = [[UUMessage alloc] init];
//            
//            msg.strId = [s stringForColumnIndex:1];
//            msg.strToId = [s stringForColumnIndex:2];
//            msg.strName = [s stringForColumnIndex:3];
//            msg.strContent = [s stringForColumnIndex:4];
//            msg.from = [s intForColumnIndex:5];
//            msg.type = [s intForColumnIndex:6];
//            msg.strTime = [s stringForColumnIndex:7];
//            msg.status = [s stringForColumnIndex:8];
//            
//            msg.subType = UPMessageSubTypeText;
//            
//            [msglist addObject:msg];
//        }
//        [messageDb close];
//        return msglist;
//    } else if (msgType==UPMessageTypeSys) {
//        NSString *to_id = [UPDataManager shared].userInfo.ID;
//        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld", to_id, UPMessageTypeSys,begin, end];
//        
//        NSMutableArray *msglist = [NSMutableArray new];
//        
//        FMResultSet *s = [messageDb executeQuery:querySql];
//        while (s.next) {
//            UUMessage *msg = [[UUMessage alloc] init];
//            
//            msg.strId = [s stringForColumnIndex:1];
//            msg.strToId = [s stringForColumnIndex:2];
//            msg.strName = [s stringForColumnIndex:3];
//            msg.strContent = [s stringForColumnIndex:4];
//            msg.from = [s intForColumnIndex:5];
//            msg.type = [s intForColumnIndex:6];
//            msg.strTime = [s stringForColumnIndex:7];
//            msg.status = [s stringForColumnIndex:8];
//            
//            msg.subType = UPMessageSubTypeText;
//            
//            [msglist addObject:msg];
//        }
//        [messageDb close];
//        return msglist;
//    }
    return nil;
}

#pragma mark - 操作表:消息组
- (BOOL)updateGropuMessageStatus:(NSString *)user_id
{
//    [messageDb open];
//    NSString *updateSql = [NSString stringWithFormat:@"update messages_group set status='1' where from_id='%@'", user_id];
//    BOOL res = [messageDb executeUpdate:updateSql];
//    if (!res) {
//        NSLog(@"更新失败");
//    } else {
//        NSLog(@"更新成功");
//    }
//    [messageDb close];
//    return res;
    return NO;
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
//    [messageDb open];
//    
//    [messageDb beginTransaction];
//    BOOL isRollBack = NO;
//    
//    @try {
//        for (UUMessage *msg in self.groupMessageList) {
//            NSString *sql = @"insert or replace into messages_group (from_id, to_id, nick_name, newest_message, message_type, add_time, status) values(?,?,?,?,?,?,?)";
//
//            BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, [NSNumber numberWithInt:msg.type], msg.strTime, msg.status ];
//            if (!a) {
//                NSLog(@"插入失败");
//            }
//        }
//    } @catch (NSException *exception) {
//        isRollBack = YES;
//        [messageDb rollback];
//    } @finally {
//        if (!isRollBack) {
//            [messageDb commit];
//        }
//    }
//    [messageDb close];
//    return !isRollBack;
    return NO;
}

/**
 *from_id text, to_id text, nick_name text, newest_message text, add_time text, status text
 */

- (NSMutableArray *)getMessageGroup
{
//    [messageDb open];
//    
//    NSMutableArray *messageGoup = [NSMutableArray new];
//    
//    NSString *to_id = [UPDataManager shared].userInfo.ID;
//    NSString *querySql = [NSString stringWithFormat:@"select * from messages_group where to_id='%@' order by status asc, add_time desc", to_id];
//
//    FMResultSet *s = [messageDb executeQuery:querySql];
//    while ([s next]) {
//        UUMessage *msg = [[UUMessage alloc] init];
//        
//        msg.strId = [s stringForColumnIndex:1];
//        msg.strToId = [s stringForColumnIndex:2];
//        msg.strName = [s stringForColumnIndex:3];
//        msg.strContent = [s stringForColumnIndex:4];
//        msg.type = [s intForColumnIndex:5];
//        msg.strTime = [s stringForColumnIndex:6];
//        msg.status = [s stringForColumnIndex:7];
//        
//        [messageGoup addObject:msg];
//    }
//    [messageDb close];
//    return messageGoup;
    return nil;
}

/**
 *根据参数获取指定位置的记录
 */
- (NSMutableArray *)getMessageGroup:(NSRange)range
{
//    [messageDb open];
//    
//    long begin = range.location;
//    long end = range.location+range.length;
//
//    GroupMessage *sysGroup = [[GroupMessage alloc] init];
//    sysGroup.groupID = kGroupMsgSys;
//    GroupMessage *invGroup = [[GroupMessage alloc] init];
//    invGroup.groupID = kGroupMsgInv;
//    GroupMessage *usrGroup = [[GroupMessage alloc] init];
//    usrGroup.groupID = kGroupMsgUsr;
//    
//    NSMutableArray *msglist = [[NSMutableArray alloc] init];
//    [msglist addObject:sysGroup];
//    [msglist addObject:invGroup];
//    [msglist addObject:usrGroup];
//    
//    NSString *to_id = [UPDataManager shared].userInfo.ID;
//    NSString *querySql = [NSString stringWithFormat:@"select * from messages_group where to_id='%@' and order by status desc, add_time desc limit %ld,%ld", to_id, begin, end];
//    
//    FMResultSet *s = [messageDb executeQuery:querySql];
//    while ([s next]) {
//        
//        UUMessage *msg = [[UUMessage alloc] init];
//        
//        msg.strId = [s stringForColumnIndex:1];
//        msg.strToId = [s stringForColumnIndex:2];
//        msg.strName = [s stringForColumnIndex:3];
//        msg.strContent = [s stringForColumnIndex:4];
//        msg.type = [s intForColumnIndex:5];
//        msg.strTime = [s stringForColumnIndex:6];
//        msg.status = [s stringForColumnIndex:7];
//        
//        switch (msg.type) {
//            case UPMessageTypeSys:
//                [sysGroup.messageList addObject:msg];
//                break;
//            case UPMessageTypeInvite:
//                [invGroup.messageList addObject:msg];
//                break;
//            case UPMessageTypeNormal:
//                [usrGroup.messageList addObject:msg];
//                break;
//        }
//    }
//    
//    [messageDb close];
//    return msglist;
    return nil;
}

- (void)dealloc
{
    [self.fmQueue close];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)test:(NSString *)time
{
//    [self.messageList removeAllObjects];
//    [self.groupMessageList removeAllObjects];
//    for (int i=0; i<10; i++) {
//        UUMessage *msg = [[UUMessage alloc] init];
//        msg.from = UUMessageFromOther;
//        msg.type = UPMessageTypeNormal;
//        msg.subType = UPMessageSubTypeText;
//        msg.strId = [NSString stringWithFormat:@"%d", i+100];
//        msg.strToId = [UPDataManager shared].userInfo.ID;
//        msg.strName = [NSString stringWithFormat:@"name_%d", i+1000];
//        msg.strContent = [NSString stringWithFormat:@"contentsfjsiefisjijsjffjief减肥法是否你是否是的发生你垫付未付金额覅是对方莫问面覅我分明的收费么偶IM法萨芬_%d", i+1000];
//        msg.strTime = time;//@"20160825111111";
//        msg.status = @"0";
//        
//        [self.messageList addObject:msg];
//        
//        UUMessage *message = [self msgInGroup:msg.strId andType:msg.type];
//        if (message) {
//            if ([message.strTime compare:msg.strTime]==NSOrderedAscending) {
//                message.strContent = msg.strContent;
//                message.strTime = msg.strTime;
//                message.status = msg.status;
//            }
//        } else {
//            [self.groupMessageList addObject:msg];
//        }
//    }
//    BOOL result = [self updateMessages];
//    result = [self updateGroupMessage];
//    return result;
    return NO;
}
@end

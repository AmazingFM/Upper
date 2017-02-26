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

#import "PrivateMessage.h"

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
    FMDatabase *messageDb;
}

@property (nonatomic, retain) NSMutableArray<UUMessage *> *messageList;
@property (nonatomic, retain) NSMutableArray<UUMessage *> *groupMessageList;

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
//    flag = [messageDb executeUpdate:@"create table if not exists messages_detail (id integer primary key autoincrement, from_id text, to_id text, nick_name text, message_desc text, message_from integer, message_type integer, add_time text, status text)"];
//    
//    flag = [messageDb executeUpdate:@"create table if not exists messages_group (id integer primary key autoincrement, from_id text unique, to_id text, nick_name text, newest_message text, message_type integer, add_time text, status text)"];
    
    flag = [messageDb executeUpdate:@"create table if not exists messages_detail (id integer primary key autoincrement, from_id text, to_id text, nick_name text, message_desc text, message_from integer, message_type integer, add_time text, status text)"];
    
    flag = [messageDb executeUpdate:@"create table if not exists messages_group (id integer primary key autoincrement, from_id text unique, to_id text, nick_name text, newest_message text, message_type integer, add_time text, status text)"];

    
    
    if (flag) {
        NSLog(@"建表messages成功");
    } else {
        NSLog(@"建表messages失败");
    }

    [messageDb close];
}



- (NSMutableArray *)messageList
{
    if (_messageList==nil) {
        _messageList = [NSMutableArray new];
    }
    return _messageList;
}

- (NSMutableArray *)groupMessageList
{
    if (_groupMessageList==nil) {
        _groupMessageList = [NSMutableArray new];
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
//    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
//    [params setValue:@"MessageGet" forKey:@"a"];
//
//    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
//
//    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
//        NSDictionary *dict = (NSDictionary *)json;
//        NSLog(@"MessageGet:%@", dict);
//
//        NSString *resp_id = dict[@"resp_id"];
//        if ([resp_id intValue]==0) {
//            NSDictionary *resp_data = dict[@"resp_data"];
//
//            int totalCnt =  [resp_data[@"total_count"] intValue];
//            if (totalCnt!=0) {
//                NSString *msglist = resp_data[@"message_list"];
//                if ([msglist isKindOfClass:[NSArray class]]) {
//                    NSMutableArray *msgArr = (NSMutableArray*)msglist;
//                    for (NSDictionary *dict in msgArr) {
//                        PrivateMessage *priMsg = [[PrivateMessage alloc] init];
//                        priMsg.remote_id      = dict[@"from_id"];
//                        priMsg.remote_name    = dict[@"nick_name"];
//                        priMsg.message_desc = dict[@"message_desc"];
//                        priMsg.add_time     = dict[@"add_time"];
//                        priMsg.status       = dict[@"status"];
//                        priMsg.message_type = dict[@"message_type"];
//                        
//                        
//                        UUMessage *msg = [[UUMessage alloc] init];
//                        
//                        
//                        //99为邀请类消息， from_id为0时为系统消息
//                        NSString *fromId = dict[@"from_id"];
//                        msg.strId = fromId;
//                        
//                        if ([fromId intValue]==0) {
//                            msg.type = UPMessageTypeSys;
//                        } else {
//                            int msgType = [dict[@"message_type"] intValue];
//                            if (msgType==99) {
//                                msg.type = UPMessageTypeInvite;
//                            } else {
//                                msg.type = UPMessageTypeNormal;
//                            }
//                        }
//                        
//                        msg.from = UUMessageFromOther;
//                        
//                        //后续需要完善，每次请求都需要考虑绑定用户id
//                        NSString *to_id = [UPDataManager shared].userInfo.ID;//
//                        msg.strToId = to_id;
//                        
//                        msg.strName = dict[@"nick_name"];
//                        msg.strContent = dict[@"message_desc"];
//                        msg.strTime = dict[@"add_time"];
//                        msg.status = dict[@"status"];
//                        
//                        UUMessage *message = [self msgInGroup:msg.strId andType:msg.type];
//                        if (message) {
//                            if ([message.strTime compare:msg.strTime]==NSOrderedAscending) {
//                                message.strContent = msg.strContent;
//                                message.strTime = msg.strTime;
//                                message.status = msg.status;
//                            }
//                        } else {
//                            [self.groupMessageList addObject:msg];
//                        }
//                        
//                        [self.messageList addObject:msg];
//                    }
//                    
//                    BOOL result = [self updateMessages];
//                    if (result) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierMessageComing object:self.messageList];
//                        [self.messageList removeAllObjects];
//                        NSLog(@"更新成功");
//                    }
//                    
//                    result = [self updateGroupMessage];
//                    if (result) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierMessageGroupUpdate object:self.groupMessageList];
//                        [self.groupMessageList removeAllObjects];
//                        NSLog(@"更新成功");
//                    }
//
//                    
//                }
//            }
//        }
//    } failture:^(id error) {
//        NSLog(@"%@",error);
//    }];
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
    [messageDb open];
    NSString *sql = @"insert into messages_detail (from_id, to_id, nick_name, message_desc, message_from, message_type, add_time, status) values(?,?,?,?,?,?,?,?)";
    BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, [NSNumber numberWithInt:msg.from], [NSNumber numberWithInt:msg.type], msg.strTime, msg.status ];
    [messageDb close];
    return a;
}


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
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId andType:(UUMessageType)msgType
{
    [messageDb open];
    
    long begin = range.location;
    long end = range.location+range.length;
    
    if (msgType==UPMessageTypeNormal) {
        NSString *to_id = [UPDataManager shared].userInfo.ID;
        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where from_id='%@' and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld",userId, to_id, UPMessageTypeNormal,begin, end];
        
        NSMutableArray *msglist = [NSMutableArray new];
        
        FMResultSet *s = [messageDb executeQuery:querySql];
        while (s.next) {
            UUMessage *msg = [[UUMessage alloc] init];
            
            msg.strId = [s stringForColumnIndex:1];
            msg.strToId = [s stringForColumnIndex:2];
            msg.strName = [s stringForColumnIndex:3];
            msg.strContent = [s stringForColumnIndex:4];
            msg.from = [s intForColumnIndex:5];
            msg.type = [s intForColumnIndex:6];
            msg.strTime = [s stringForColumnIndex:7];
            msg.status = [s stringForColumnIndex:8];
            
            msg.subType = UPMessageSubTypeText;
            
            [msglist addObject:msg];
        }
        [messageDb close];
        return msglist;
    } else if (msgType==UPMessageTypeInvite) {
        NSString *to_id = [UPDataManager shared].userInfo.ID;
        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld", to_id, UPMessageTypeInvite,begin, end];
        
        NSMutableArray *msglist = [NSMutableArray new];
        
        FMResultSet *s = [messageDb executeQuery:querySql];
        while (s.next) {
            UUMessage *msg = [[UUMessage alloc] init];
            
            msg.strId = [s stringForColumnIndex:1];
            msg.strToId = [s stringForColumnIndex:2];
            msg.strName = [s stringForColumnIndex:3];
            msg.strContent = [s stringForColumnIndex:4];
            msg.from = [s intForColumnIndex:5];
            msg.type = [s intForColumnIndex:6];
            msg.strTime = [s stringForColumnIndex:7];
            msg.status = [s stringForColumnIndex:8];
            
            msg.subType = UPMessageSubTypeText;
            
            [msglist addObject:msg];
        }
        [messageDb close];
        return msglist;
    } else if (msgType==UPMessageTypeSys) {
        NSString *to_id = [UPDataManager shared].userInfo.ID;
        NSString *querySql = [NSString stringWithFormat:@"select * from messages_detail where and to_id='%@'and message_type=%ld order by add_time desc limit %ld,%ld", to_id, UPMessageTypeSys,begin, end];
        
        NSMutableArray *msglist = [NSMutableArray new];
        
        FMResultSet *s = [messageDb executeQuery:querySql];
        while (s.next) {
            UUMessage *msg = [[UUMessage alloc] init];
            
            msg.strId = [s stringForColumnIndex:1];
            msg.strToId = [s stringForColumnIndex:2];
            msg.strName = [s stringForColumnIndex:3];
            msg.strContent = [s stringForColumnIndex:4];
            msg.from = [s intForColumnIndex:5];
            msg.type = [s intForColumnIndex:6];
            msg.strTime = [s stringForColumnIndex:7];
            msg.status = [s stringForColumnIndex:8];
            
            msg.subType = UPMessageSubTypeText;
            
            [msglist addObject:msg];
        }
        [messageDb close];
        return msglist;
    }
    return nil;
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
        for (UUMessage *msg in self.groupMessageList) {
            NSString *sql = @"insert or replace into messages_group (from_id, to_id, nick_name, newest_message, message_type, add_time, status) values(?,?,?,?,?,?,?)";

            BOOL a = [messageDb executeUpdate:sql, msg.strId, msg.strToId, msg.strName, msg.strContent, [NSNumber numberWithInt:msg.type], msg.strTime, msg.status ];
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
    
    NSString *to_id = [UPDataManager shared].userInfo.ID;
    NSString *querySql = [NSString stringWithFormat:@"select * from messages_group where to_id='%@' order by status asc, add_time desc", to_id];

    FMResultSet *s = [messageDb executeQuery:querySql];
    while ([s next]) {
        UUMessage *msg = [[UUMessage alloc] init];
        
        msg.strId = [s stringForColumnIndex:1];
        msg.strToId = [s stringForColumnIndex:2];
        msg.strName = [s stringForColumnIndex:3];
        msg.strContent = [s stringForColumnIndex:4];
        msg.type = [s intForColumnIndex:5];
        msg.strTime = [s stringForColumnIndex:6];
        msg.status = [s stringForColumnIndex:7];
        
        [messageGoup addObject:msg];
    }
    [messageDb close];
    return messageGoup;
}

/**
 *根据参数获取指定位置的记录
 */
- (NSMutableArray *)getMessageGroup:(NSRange)range
{
    [messageDb open];
    
    long begin = range.location;
    long end = range.location+range.length;

    GroupMessage *sysGroup = [[GroupMessage alloc] init];
    sysGroup.groupID = kGroupMsgSys;
    GroupMessage *invGroup = [[GroupMessage alloc] init];
    invGroup.groupID = kGroupMsgInv;
    GroupMessage *usrGroup = [[GroupMessage alloc] init];
    usrGroup.groupID = kGroupMsgUsr;
    
    NSMutableArray *msglist = [[NSMutableArray alloc] init];
    [msglist addObject:sysGroup];
    [msglist addObject:invGroup];
    [msglist addObject:usrGroup];
    
    NSString *to_id = [UPDataManager shared].userInfo.ID;
    NSString *querySql = [NSString stringWithFormat:@"select * from messages_group where to_id='%@' and order by status desc, add_time desc limit %ld,%ld", to_id, begin, end];
    
    FMResultSet *s = [messageDb executeQuery:querySql];
    while ([s next]) {
        
        UUMessage *msg = [[UUMessage alloc] init];
        
        msg.strId = [s stringForColumnIndex:1];
        msg.strToId = [s stringForColumnIndex:2];
        msg.strName = [s stringForColumnIndex:3];
        msg.strContent = [s stringForColumnIndex:4];
        msg.type = [s intForColumnIndex:5];
        msg.strTime = [s stringForColumnIndex:6];
        msg.status = [s stringForColumnIndex:7];
        
        switch (msg.type) {
            case UPMessageTypeSys:
                [sysGroup.messageList addObject:msg];
                break;
            case UPMessageTypeInvite:
                [invGroup.messageList addObject:msg];
                break;
            case UPMessageTypeNormal:
                [usrGroup.messageList addObject:msg];
                break;
        }
    }
    
    [messageDb close];
    return msglist;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)test:(NSString *)time
{
    [self.messageList removeAllObjects];
    [self.groupMessageList removeAllObjects];
    for (int i=0; i<10; i++) {
        UUMessage *msg = [[UUMessage alloc] init];
        msg.from = UUMessageFromOther;
        msg.type = UPMessageTypeNormal;
        msg.subType = UPMessageSubTypeText;
        msg.strId = [NSString stringWithFormat:@"%d", i+100];
        msg.strToId = [UPDataManager shared].userInfo.ID;
        msg.strName = [NSString stringWithFormat:@"name_%d", i+1000];
        msg.strContent = [NSString stringWithFormat:@"contentsfjsiefisjijsjffjief减肥法是否你是否是的发生你垫付未付金额覅是对方莫问面覅我分明的收费么偶IM法萨芬_%d", i+1000];
        msg.strTime = time;//@"20160825111111";
        msg.status = @"0";
        
        [self.messageList addObject:msg];
        
        UUMessage *message = [self msgInGroup:msg.strId andType:msg.type];
        if (message) {
            if ([message.strTime compare:msg.strTime]==NSOrderedAscending) {
                message.strContent = msg.strContent;
                message.strTime = msg.strTime;
                message.status = msg.status;
            }
        } else {
            [self.groupMessageList addObject:msg];
        }
    }
    BOOL result = [self updateMessages];
    result = [self updateGroupMessage];
    return result;
}
@end

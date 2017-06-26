//
//  MessageManager.h
//  Upper
//
//  Created by freshment on 16/7/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PrivateMessage.h"

//90~99系统文本消息，含以后可能的各类系统消息类型
//80~89活动类文本消息， 含邀请-80， 变更发起人-81
//10~19普通聊天类
typedef NS_ENUM(NSUInteger, UPServerMsgType) {
    ServerMsgTypeNormal         = 10,
    
    ServerMsgTypeInviteFriend   = 80,
    ServerMsgTypeChangeLauncher = 81,
    
    ServerMsgTypeSystem         = 90
};

#define SysMsgKey @"SysMsg"
#define ActMsgKey @"ActMsg"
#define UsrMsgKey @"UsrMsg"

@class UUMessage;
typedef NS_ENUM(NSUInteger, UPGroupMsgType){
    kGroupMsgSys = 0,
    kGroupMsgInv,
    kGroupMsgUsr
};

@interface GroupMessage : NSObject
@property (nonatomic) UPGroupMsgType groupID;
@property (nonatomic, retain) NSMutableArray *messageList;
@end


@interface MessageManager : NSObject
{
    SystemSoundID soundID;
}

+ (instancetype)shared;
- (void)startMessageTimer;
- (void)stopMessageTimer;
- (NSMutableArray *)getMessageGroup;
- (NSMutableArray *)getMessageGroup:(NSRange)range;
- (BOOL)updateGroupMessageStatus:(NSString *)user_id;
- (BOOL)updateOneMessage:(UUMessage *)msg;

- (NSArray<PrivateMessage *> *)getMessagesByType:(MessageType)type;
- (NSArray<PrivateMessage *> *)getMessagesByUser:(NSString *)userId;
- (BOOL)insertOneMessage:(PrivateMessage *)msg;
- (BOOL)updateMessageReadStatus:(PrivateMessage *)msg_key;
@end

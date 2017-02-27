//
//  MessageManager.h
//  Upper
//
//  Created by freshment on 16/7/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PrivateMessage.h"


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

+ (instancetype)shared;
//- (void)pullMessage;
- (NSMutableArray *)getMessageGroup;
- (void)initEnv;
- (NSMutableArray *)getMessageGroup:(NSRange)range;
- (BOOL)updateGropuMessageStatus:(NSString *)user_id;
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId;
- (BOOL)updateOneMessage:(UUMessage *)msg;

- (NSArray<PrivateMessage *> *)getMessagesByType:(MessageType)type;
- (NSArray<PrivateMessage *> *)getMessagesByUser:(NSString *)userId;

@end

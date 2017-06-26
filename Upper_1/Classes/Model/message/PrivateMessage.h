//
//  PrivateMessage.h
//  Upper
//
//  Created by 张永明 on 2017/2/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PrivateMessageSendStatus) {
    PrivateMessageStatusSendSucess = 0,
    PrivateMessageStatusSending,
    PrivateMessageStatusSendFail
};


typedef NS_ENUM(NSInteger, MessageType){
    MessageTypeSystem = 0,                      //系统消息（大类别）
    MessageTypeActivity,                        //活动消息（大类别，用于和 系统消息、普通聊天消息区分）
    MessageTypeCommon,                          //普通聊天消息（大类别）
    
    MessageTypeSystemGeneral=3,                   //系统消息中一般类消息（子类别,属于系统消息）
    MessageTypeActivityInvite=4,                  //活动消息中邀请类消息（子类别,属于活动消息）
    MessageTypeActivityChangeLauncher,          //活动消息中变更发起人（子类别,属于活动消息）
    MessageTypeCommonText=6,                      //普通文本消息（子类别,普通聊天消息）
    MessageTypeCommonImage,                     //普通文本图片（子类别,普通聊天消息）
    MessageTypeCommonMix,                       //普通文本混合（子类别,普通聊天消息）
};

typedef NS_ENUM(NSInteger, MessageSource) {
    MessageSourceMe     = 0,    //自己发的
    MessageSourceOther  = 1     //别人发得
};

@interface PrivateMessage : NSObject

@property (nonatomic, copy) NSString *local_id;     //本人user_id;
@property (nonatomic, copy) NSString *local_name;   //本人nick_name;
@property (nonatomic, copy) NSString *remote_id;    //对方user_id，配合source使用
@property (nonatomic, copy) NSString *remote_name;  //对方nick_name
@property (nonatomic, copy) NSString *msg_desc;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *message_type;//服务器标志

@property (nonatomic) MessageSource source;//消息来源
@property (nonatomic, assign) MessageType localMsgType;//本地区分标志

@property (assign, nonatomic) PrivateMessageSendStatus sendStatus;
@property (nonatomic, copy) NSString *msg_key;
@property (nonatomic, copy) NSString *read_status;//消息是否已读（未读：@“0” 已读：@“1”）

@property (nonatomic, assign) BOOL showDateLabel;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end

@interface PrivateMessages : NSObject

@end


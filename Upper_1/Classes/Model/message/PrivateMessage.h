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
    
    MessageTypeSystemGeneral,                   //系统消息中一般类消息（子类别,属于系统消息）
    MessageTypeActivityInvite,                  //活动消息中邀请类消息（子类别,属于活动消息）
    MessageTypeActivityChangeLauncher,          //活动消息中变更发起人（子类别,属于活动消息）
    MessageTypeCommonText,                      //普通文本消息（子类别,普通聊天消息）
    MessageTypeCommonImage,                     //普通文本图片（子类别,普通聊天消息）
    MessageTypeCommonMix,                       //普通文本混合（子类别,普通聊天消息）
};

@interface PrivateMessage : NSObject

@property (nonatomic, copy) NSString *fromId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *msgStatus;
@property (nonatomic, copy) NSString *msgType;//服务器标志

@property (nonatomic, assign) MessageType messageType;//本地标志

@property (assign, nonatomic) PrivateMessageSendStatus sendStatus;

@end

@interface PrivateMessages : NSObject

@end


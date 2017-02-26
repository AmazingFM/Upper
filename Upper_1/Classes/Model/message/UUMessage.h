//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageSubType) {
    UPMessageSubTypeText     = 0 , // 文字
    UPMessageSubTypePicture  = 1 , // 图片
    UPMessageSubTypeVoice    = 2 , // 语音
};

typedef NS_ENUM(NSInteger, UUMessageType) {
    UPMessageTypeNormal     = 0,    //普通消息类型
    UPMessageTypeInvite     = 1,    //活动邀请消息类
    UPMessageTypeSys        = 2,    //系统消息类
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe     = 0,    //自己发的
    UUMessageFromOther  = 1     //别人发得
};

@interface UUMessage : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;

@property (nonatomic, assign) UUMessageType type;
@property (nonatomic, assign) MessageFrom from;
@property (nonatomic, assign) MessageSubType subType;

@property (nonatomic, copy) NSString *strToId;

@property (nonatomic, assign) BOOL showDateLabel;

//- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end

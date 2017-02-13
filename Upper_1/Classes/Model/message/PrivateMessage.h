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

@interface PrivateMessage : NSObject

@property (nonatomic, copy) NSString *fromId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *msgStatus;
@property (nonatomic, copy) NSString *msgType;

@property (assign, nonatomic) PrivateMessageSendStatus sendStatus;

@end

@interface PrivateMessages : NSObject

@end


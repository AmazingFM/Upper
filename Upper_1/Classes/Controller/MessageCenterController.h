//
//  MessageCenterController.h
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class PrivateMessage;

@interface UserChatItem : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *recentMsg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *status;
@end

@interface ConversationCell : UITableViewCell
@property (nonatomic, retain) PrivateMessage *curPriMsg;

+ (CGFloat)cellHeight;
@end

typedef NS_ENUM(NSInteger, ToMessageType)
{
    ToMessageTypeSystemNotification=0,
    ToMessageTypeInvitation,
};

@interface ToMessageCell : UITableViewCell
@property (nonatomic, assign) ToMessageType type;
@property (nonatomic, retain) NSNumber *unreadCount;

+ (CGFloat)cellHeight;
@end

@interface MessageCenterController : UPBaseViewController

@end

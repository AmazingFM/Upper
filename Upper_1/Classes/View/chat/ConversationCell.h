//
//  ConversationCell.h
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrivateMessage;

@interface ConversationCell : UITableViewCell
@property (nonatomic, retain) PrivateMessage *curPriMsg;

+ (CGFloat)cellHeight;
@end

typedef NS_ENUM(NSInteger, ToMessageType)
{
    ToMessageTypeSystemNotification=0,
    ToMessageTypeInvitation           
};

@interface ToMessageCell : UITableViewCell
@property (nonatomic, retain) UILabel   *badgeLabel;
@property (nonatomic, assign) ToMessageType type;
@property (nonatomic, retain) NSNumber *unreadCount;
@property (nonatomic) BOOL showBadge;

+ (CGFloat)cellHeight;
@end

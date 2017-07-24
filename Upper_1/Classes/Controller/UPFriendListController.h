//
//  UPInviteFriendController.h
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//
#import "UPBaseViewController.h"

@class UPFriendItem;
@protocol UPFriendListDelegate <NSObject>

@optional
- (void)inviteFriends:(NSArray *)friendId;
- (void)changeLauncher:(UPFriendItem *)userItem;

@end

@interface UPFriendListController : UPBaseViewController
@property (nonatomic) int type;//0-我的好友，1-活动参与者
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, weak) id<UPFriendListDelegate> delegate;
@end

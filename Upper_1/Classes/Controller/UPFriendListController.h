//
//  UPInviteFriendController.h
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//
#import "UPBaseViewController.h"
@protocol UPFriendListDelegate <NSObject>

- (void)inviteFriends:(NSArray *)friendId;
- (void)changeLauncher:(NSString *)userId;

@end

@interface UPFriendListController : UPBaseViewController
@property (nonatomic) int type;//0-我的好友，1-活动参与者
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, weak) id<UPFriendListDelegate> delegate;
@end
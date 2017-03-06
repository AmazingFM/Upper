//
//  UPInviteFriendController.h
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//
#import "UPBaseViewController.h"
@protocol UPInviteFriendDelegate <NSObject>

- (void)inviteFriends:(NSArray *)friendId;

@end

@interface UPInviteFriendController : UPBaseViewController
@property (nonatomic, weak) id<UPInviteFriendDelegate> delegate;
@end

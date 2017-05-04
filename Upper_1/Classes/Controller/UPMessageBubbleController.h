//
//  UPMessageBubbleController.h
//  Upper
//
//  Created by 张永明 on 2017/2/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class PrivateMessage;
@interface UPMessageBubbleController : UPBaseViewController

@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName andUserIcon:(NSString *)userIcon;

- (void)addMessage:(PrivateMessage *)msg;

@end

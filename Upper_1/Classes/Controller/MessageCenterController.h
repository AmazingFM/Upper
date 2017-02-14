//
//  MessageCenterController.h
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@interface UserChatItem : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *recentMsg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *status;
@end

@interface MessageCenterController : UPBaseViewController

@end

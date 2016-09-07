//
//  ChatController.h
//  Upper
//
//  Created by freshment on 16/6/6.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "PersonalCenterController.h"
@interface ChatController : UPBaseViewController

@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, retain) UserData *userData;
@property (nonatomic, retain) OtherUserData *otherUserData;
@end

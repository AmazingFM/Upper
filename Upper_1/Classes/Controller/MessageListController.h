//
//  MessageListController.h
//  Upper
//
//  Created by 张永明 on 2017/2/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "PrivateMessage.h"

/**
 *展示系统消息、活动消息列表界面
 */
@interface MessageListController : UPBaseViewController
@property (nonatomic, assign) MessageType messageType;

@end

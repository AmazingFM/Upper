//
//  MessageBubbleViewController.h
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUMessage;
@interface MessageBubbleViewController : UIViewController

@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName;

- (void)addMessage:(UUMessage *)msg;

@end

//
//  MessageManager.h
//  Upper
//
//  Created by freshment on 16/7/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UUMessage;
@interface MessageManager : NSObject

+ (instancetype)shared;
//- (void)pullMessage;
- (NSMutableArray *)getMessageGroup;
- (void)initEnv;
- (NSMutableArray *)getMessageGroup:(NSRange)range;
- (BOOL)updateGropuMessageStatus:(NSString *)user_id;
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId;
- (BOOL)updateOneMessage:(UUMessage *)msg;

@end

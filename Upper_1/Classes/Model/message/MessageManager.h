//
//  MessageManager.h
//  Upper
//
//  Created by freshment on 16/7/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageManager : NSObject

+ (instancetype)shared;
//- (void)pullMessage;
- (NSMutableArray *)getMessageGroup;
- (void)initEnv;
- (NSMutableDictionary *)getMessageGroup:(NSRange)range;
- (BOOL)updateGropuMessageStatus:(NSString *)user_id;
- (NSMutableArray *)getMessages:(NSRange)range withUserId:(NSString *)userId;
@end

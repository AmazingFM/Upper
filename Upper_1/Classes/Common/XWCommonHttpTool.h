//
//  XWCommonHttpTool.h
//  新闻
//
//  Created by user on 15/10/1.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface XWCommonHttpTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTools;

@end

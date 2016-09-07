//
//  XWDataCacheTool.h
//  新闻
//
//  Created by user on 15/10/5.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWDataCacheTool : NSObject

+(void)addArr:(NSArray*)arr andId:(NSString*)idstr;
+(void)addDict:(NSDictionary*)dict andId:(NSString*)idstr;

+(NSArray*)dataWithID:(NSString*)ID;
+(void)deleteWidthId:(NSString*)ID;

@end

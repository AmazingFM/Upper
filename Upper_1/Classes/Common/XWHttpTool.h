//
//  XWHttpTool.h
//  新闻
//
//  Created by user on 15/10/1.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XWHttpTool : NSObject

//请求新闻列表的方法 这个是缓存的（下拉刷新）如果idStr有值得话就缓存，没值就不缓存。
+ (void)getWithUrl:(NSString*)str parms:(NSDictionary*)parms  idStr:(NSString*)idStr networkCount:(int)networkCount success:(void(^)(id json))success failture:(void(^)(id error))failture ;



//请求新闻内容的方法
+ (void)getDetailWithUrl:(NSString*)str parms:(NSDictionary*)parms success:(void(^)(id json))success failture:(void(^)(id error))failture ;

+ (void)postDetailWithUrl:(NSString *)str parms:(NSDictionary *)parms success:(void (^)(id json))success failture:(void (^)(id error))failture;
@end

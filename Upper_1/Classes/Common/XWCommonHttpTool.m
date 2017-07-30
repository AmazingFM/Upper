//
//  XWCommonHttpTool.m
//  新闻
//
//  Created by user on 15/10/1.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "XWCommonHttpTool.h"
#import "Info.h"

@implementation XWCommonHttpTool

+(instancetype)sharedNetworkTools
{
    static XWCommonHttpTool *httpTool;
    static dispatch_once_t onceToekn;
    //单例
    dispatch_once(&onceToekn, ^{
        NSURL *url = [NSURL URLWithString:kBaseURL];
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        httpTool=[[self alloc]initWithBaseURL:url sessionConfiguration:config];
        
        httpTool.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
    });
    
    return httpTool;
}

@end

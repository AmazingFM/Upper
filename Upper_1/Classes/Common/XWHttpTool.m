//
//  XWHttpTool.m
//  新闻
//
//  Created by user on 15/10/1.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "XWHttpTool.h"

@implementation XWHttpTool

//请求新闻列表的方法 这个是缓存的（下拉刷新）

+(void)getWithUrl:(NSString *)str parms:(NSDictionary *)parms idStr:(NSString *)idStr  networkCount:(int)networkCount success:(void (^)(id))success failture:(void (^)(id))failture
{
    
    //如果数据库里面有值就先读取数据库
    if(idStr.length>0 && networkCount<=1){
        NSArray *arr=[XWDataCacheTool dataWithID:idStr];
        if(arr.count>0){
            success(arr);
            return;
        }
    }
   
    //数据库里面没有直接发送网络请求
    [[XWCommonHttpTool sharedNetworkTools] GET:str parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict=(NSDictionary*)responseObject;
        NSString *key=[dict.keyEnumerator nextObject];
        NSArray *tempArr=dict[key];
        //如果idStr有值 表明是下拉刷新获取最新数据
        if(idStr.length>0){
            //发送网络请求获取最新数据  先清空旧的数据
            [XWDataCacheTool deleteWidthId:idStr];
            //做数据缓存
            [XWDataCacheTool addArr:tempArr andId:idStr];
        }
        
        if(success){
              success(tempArr);
        }
      
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failture){
            failture(error);
        }
    }];;
}

+(void)getDetailWithUrl:(NSString *)str parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    
    [[XWCommonHttpTool sharedNetworkTools] GET:str parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success){
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failture){
            failture(error);
        }
    }];;

}

+(void)postDetailWithUrl:(NSString *)str parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    
    [[XWCommonHttpTool sharedNetworkTools] POST:str parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success){
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failture){
            failture(error);
        }
    }];;
    
}


@end

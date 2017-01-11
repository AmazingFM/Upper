//
//  YMNetwork.m
//  Upper
//
//  Created by 张永明 on 16/12/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "YMNetwork.h"

static NSString *const YMBaseURL = @"https://api.app.net/";

@implementation YMNetwork

@end

@interface YMHttpNetwork ()

@property (nonatomic, retain) AFHTTPSessionManager          *sessionManager;

@end

@implementation YMHttpNetwork

+ (instancetype)sharedNetwork
{
    static YMHttpNetwork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YMHttpNetwork alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认是AFHTTPRequestSerialier, AFJSONResponseSerializer
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:YMBaseURL]];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.sessionManager = manager;
    }
    
    return self;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSURLSessionTask *sessionTaks = [self.sessionManager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    NSURLSessionTask *sessionTaks = [self.sessionManager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}




@end

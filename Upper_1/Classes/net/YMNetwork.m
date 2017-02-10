//
//  YMNetwork.m
//  Upper
//
//  Created by 张永明 on 16/12/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "YMNetwork.h"
#import "UPConfig.h"

#define kBaseURL @"http://api.qidianzhan.com.cn/AppServ/index.php"

@interface YMNetwork()
{
    @public
    UPConfig *config;
}
@end

@implementation YMNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        config = [[UPConfig alloc] init];
    }
    return self;
}

@end

@interface YMHttpNetwork ()

@property (nonatomic, retain) AFHTTPSessionManager *sessionManager;

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
        NSURL *url = [NSURL URLWithString:kBaseURL];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        //默认是AFHTTPRequestSerialier, AFJSONResponseSerializer
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:sessionConfig];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//针对https设置
        self.sessionManager = manager;
    }
    
    return self;
}

- (NSDictionary *)addDescParams:(NSDictionary *)parameters
{
    return nil;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *paramsDic = [self addDescParams:parameters];
    
    [self.sessionManager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    [self.sessionManager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}




@end

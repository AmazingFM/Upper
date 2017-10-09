//
//  YMNetwork.m
//  Upper
//
//  Created by 张永明 on 16/12/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "YMNetwork.h"
#import "UPConfig.h"
#import "UPDataManager.h"
#import "Info.h"
#import "UPGlobals.h"

@interface YMNetwork() <UIAlertViewDelegate>
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
        config = [UPConfig sharedInstance];
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
        self.sessionManager = manager;
    }
    return self;
}

- (NSDictionary *)addDescParams:(NSDictionary *)parameters
{
    NSString *uuid = config.uuid;
    NSString *currentDate = config.currentDate;
    NSString *reqSeq = config.newReqSeqStr;
    
    NSMutableDictionary *newParamsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"app_id":uuid, @"req_seq":reqSeq, @"time_stamp":currentDate}];

    NSString *actionName = parameters[@"a"];
    [newParamsDic addEntriesFromDictionary:parameters];
    [newParamsDic removeObjectForKey:@"a"];
    
    
    if ([UPDataManager shared].isLogin) {
        [newParamsDic setObject:[UPDataManager shared].token forKey:@"token"];
        
        NSString *user_id = newParamsDic[@"user_id"];
        if (user_id==nil || user_id.length==0) {
            [newParamsDic setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        }
    }
    
    NSString *md5Str = newParamsDic[@"sign"];
    
    if (md5Str==nil || md5Str.length==0) {
        NSArray *keys = newParamsDic.allKeys;
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableString *mStr = [NSMutableString stringWithString:@"upper"];
        for (int i=0; i<sortedKeys.count; i++) {
            [mStr appendFormat:@"%@%@", sortedKeys[i], newParamsDic[sortedKeys[i]]];
        }
        [mStr appendString:@"upper"];
        md5Str = [UPTools md5HexDigest:mStr];
        newParamsDic[@"sign"] = md5Str;
    }
    newParamsDic[@"a"] = actionName;
    return newParamsDic;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *paramsDic = [self addDescParams:parameters];
    
    [self.sessionManager GET:URLString parameters:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==9999) {
            //当前登录已经失效，请重新登录
            [self sessionExpired];
            
        } else {
            if (success) {
                success(responseObject);
            }
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

- (void)sessionExpired
{
    if ([UPDataManager shared].isLogin) {
        [UPDataManager shared].isLogin = NO;
//        [UPDataManager shared].userInfo = nil;//清楚用户信息
        [[UPDataManager shared] cleanUserDafult];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前登录已经失效，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierLogout object:nil];//发送登出通知
    [g_appDelegate setRootViewController];
}
@end

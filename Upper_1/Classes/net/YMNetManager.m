//
//  YMNetManager.m
//  Upper
//
//  Created by 张永明 on 16/12/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "YMNetManager.h"

#ifdef DEBUG
#define YMLog(fmt, ...) NSLog((@"%s [Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define YMLog(...)
#endif

@interface YMNetManager()

@property (nonatomic, retain) AFNetworkReachabilityManager  *reachabilityManager;

@end

@implementation YMNetManager

+ (instancetype)sharedManager
{
    static YMNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMNetManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startMonitoring];
    }
    
    return self;
}

- (void)startMonitoring
{
    NSNotificationCenter *notificatonCenter = [NSNotificationCenter defaultCenter];
    [notificatonCenter addObserver:self selector:@selector(netStatusChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.apple.com"];
    
    [self.reachabilityManager startMonitoring];
}

- (BOOL)isReachable
{
    return self.reachabilityManager.isReachable;
}

- (void)netStatusChange:(NSNotification *)notice
{
    NSDictionary *userInfo = notice.userInfo;
    AFNetworkReachabilityStatus netStatus= [[userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (netStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            self.netType = YMNetTypeNone;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.netType = YMNetTypeWIFI;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.netType = YMNetTypeWWAN;
            break;
        default:
            break;
    }
}

@end

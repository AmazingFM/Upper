//
//  YMNetwork.h
//  Upper
//
//  Created by 张永明 on 16/12/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMNetwork : NSObject

@end

@interface YMHttpNetwork : YMNetwork

+ (instancetype)sharedNetwork;

- (void)GET:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

@end

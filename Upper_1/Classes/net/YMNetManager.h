//
//  YMNetManager.h
//  Upper
//
//  Created by 张永明 on 16/12/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YMNetTypeNone,
    YMNetTypeWIFI,
    YMNetTypeWWAN,
}YMNetType;

@interface YMNetManager : NSObject

@property (nonatomic) YMNetType netType;

+ (instancetype)sharedManager;

@end

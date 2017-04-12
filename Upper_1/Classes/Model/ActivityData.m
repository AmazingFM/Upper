//
//  ActivityData.m
//  Upper
//
//  Created by freshment on 16/6/19.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "ActivityData.h"

@implementation ActivityData

- (NSDictionary *)attributeMapDictionary {
    return @{
             @"ID" : @"id",
             };
}

- (NSMutableArray *)join_list
{
    if (_join_list==nil) {
        _join_list = [NSMutableArray new];
    }
    return _join_list;
}

@end

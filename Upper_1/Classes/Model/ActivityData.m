//
//  ActivityData.m
//  Upper
//
//  Created by freshment on 16/6/19.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "ActivityData.h"


@implementation ActTypeInfo

- (instancetype) initWithDict:(NSDictionary *)aDict{
    self = [super init];
    if (self) {
        _actTypeName = aDict[@"Name"];
        _itemID = aDict[@"ItemID"];
        
        //夜店趴，家庭趴
        if ([_itemID isEqualToString:@"102"] ||
            [_itemID isEqualToString:@"105"]) {
            _femalFlag = YES;
        } else {
            _femalFlag = NO;
        }
    }
    return self;
}

@end

@implementation ActStatusInfo

- (instancetype) initWithDict:(NSDictionary *)aDict withID:(NSString *)itemID{
    self = [super init];
    if (self) {
        _actStatusName = aDict[@"desc"];
        _actStatusTitle = aDict[@"title"];
        _itemID = itemID;
    }
    return self;
}

@end

@implementation ActivityData

- (NSDictionary *)attributeMapDictionary {
    return @{
             @"ID" : @"id",
             };
}

@end

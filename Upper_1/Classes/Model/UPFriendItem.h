//
//  UPFriendItem.h
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPBaseModel.h"

#define kActivityPageSize 20

@interface UPFriendItem : UPBaseModel

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *relation_id;
@property (nonatomic, copy) NSString *sexual;
@property (nonatomic, copy) NSString *user_icon;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *group;

@end


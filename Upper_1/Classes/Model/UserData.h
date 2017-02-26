//
//  Person.h
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPBaseModel.h"

@interface UserData : UPBaseModel

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *industry_id;
@property (nonatomic,copy) NSString *industry_name;
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *node_id;
@property (nonatomic,copy) NSString *node_name;
@property (nonatomic,copy) NSString *sexual;
@property (nonatomic,copy) NSString *true_name;
@property (nonatomic,copy) NSString *user_icon;
@property (nonatomic,copy) NSString *user_image;
@property (nonatomic,copy) NSString *user_status;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *province_code;

@property (nonatomic,copy) NSString *token;

- (void)setWithUserData:(UserData *)userData;
@end

@interface OtherUserData : UPBaseModel

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *creator_coin;
@property (nonatomic, copy) NSString *creator_good_rate;
@property (nonatomic, copy) NSString *creator_group;
@property (nonatomic, copy) NSString *creator_level;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *industry_id;
@property (nonatomic, copy) NSString *industry_name;
@property (nonatomic, copy) NSString *join_coin;
@property (nonatomic, copy) NSString *join_good_rate;
@property (nonatomic, copy) NSString *join_group;
@property (nonatomic, copy) NSString *join_level;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *node_id;
@property (nonatomic, copy) NSString *node_name;
@property (nonatomic, copy) NSString *sexual;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *user_icon;
@end

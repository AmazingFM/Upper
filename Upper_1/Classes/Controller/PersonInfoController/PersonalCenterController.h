//
//  PersonalCenterController.h
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class UPBaseModel;
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

@interface PersonalCenterController : UPBaseViewController

@property (nonatomic, assign) int index;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, retain) OtherUserData *user;

@end

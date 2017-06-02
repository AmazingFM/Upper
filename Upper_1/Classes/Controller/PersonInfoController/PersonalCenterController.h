//
//  PersonalCenterController.h
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class OtherUserData;
@interface PersonalCenterController : UPBaseViewController

@property (nonatomic, assign) int index;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_icon;
@property (nonatomic, copy) NSString *nick_name;

@end

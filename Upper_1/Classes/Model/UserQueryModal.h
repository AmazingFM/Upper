//
//  UserQueryModal.h
//  Upper
//
//  Created by 张永明 on 16/5/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPBaseModel.h"

@interface UserQueryModal : UPBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *node_id;
@property (nonatomic, copy) NSString *industry_id;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *sexual;
@property (nonatomic, copy) NSString *user_icon;
@property (nonatomic, copy) NSString *join_icon;
@property (nonatomic, copy) NSString *creator_icon;
@property (nonatomic, copy) NSString *user_image;

@end

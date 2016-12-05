//
//  ActivityData.h
//  Upper
//
//  Created by freshment on 16/6/19.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseModel.h"

@interface Actv : NSObject

@end

@interface ActivityData : UPBaseModel

@property (nonatomic, copy) NSString *activity_desc;
@property (nonatomic, copy) NSString *activity_fee;
@property (nonatomic, copy) NSString *activity_image;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_place;
@property (nonatomic, copy) NSString *activity_place_code;
@property (nonatomic, copy) NSString *activity_status;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *clothes_need;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *industry_id;
@property (nonatomic, copy) NSString *is_prepaid;
@property (nonatomic, copy) NSString *limit_count;
@property (nonatomic, copy) NSString *part_count;
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *town_code;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *activity_class;
@end

//
//  ActivityData.h
//  Upper
//
//  Created by freshment on 16/6/19.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseModel.h"

/**
 {
 "activity_class" = 104;
 "activity_desc" = "xidan reading activity";
 "activity_fee" = "0.00";
 "activity_image" = "";
 "activity_name" = "xi dan";
 "activity_place" = xidan;
 "activity_place_code" = "-1";
 "activity_status" = 0;
 "begin_time" = 20170109215604;
 city = "\U5317\U4eac\U5e02";
 "city_code" = 000;
 "clothes_need" = 1;
 "create_time" = 20170109215605;
 "end_time" = 20170119235959;
 id = 5;
 "industry_id" = "-1";
 "is_prepaid" = 2;
 "limit_count" = 10;
 "nick_name" = "\U7528\U62371480388475";
 "part_count" = 0;
 province = "\U5317\U4eac\U5e02";
 "province_code" = 11;
 "start_time" = 20170127235959;
 "town_code" = "";

 */


@interface ActivityData : UPBaseModel
@property (nonatomic, copy) NSString *activity_class;
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
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *clothes_need;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *industry_id;
@property (nonatomic, copy) NSString *is_prepaid;
@property (nonatomic, copy) NSString *limit_count;
@property (nonatomic, copy) NSString *part_count;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *town_code;
@property (nonatomic, copy) NSString *nick_name;

//@property (nonatomic, copy) NSString *nick_name;

@end

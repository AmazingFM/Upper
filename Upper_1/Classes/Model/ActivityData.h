//
//  ActivityData.h
//  Upper
//
//  Created by freshment on 16/6/19.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseModel.h"

/**
 
 "activity_class" = 102;
 "activity_desc" = 11111111111111111112222222;
 "activity_fee" = "200.00";
 "activity_image" = "http://oss-cn-hangzhou.aliyuncs.com/upper/201703312036561452.ct?OSSAccessKeyId=FRmTx08qMq4jEks4&Expires=1494117416&Signature=r7c7JrF%2FrFRmZRgtJGo%2F2SUee6E%3D";
 "activity_name" = 123123;
 "activity_place" = 123123123;
 "activity_place_code" = 123123123;
 "activity_status" = 9;
 "begin_time" = 20170331204613;
 city = "\U4e0a\U6d77\U5e02";
 "city_code" = 071;
 "clothes_need" = 1;
 "create_time" = 20170331203656;
 "end_time" = 20170501235959;
 id = 34;
 "industry_id" = "-1";
 "is_prepaid" = 1;
 "limit_count" = 10;
 "nick_name" = "\U7528\U62371480925466";
 "part_count" = 0;
 province = "\U4e0a\U6d77\U5e02";
 "province_code" = 31;
 "start_time" = 20170502000000;
 "town_code" = "";
 "user_icon" = "http://oss-cn-hangzhou.aliyuncs.com/upper/tx29.png";
 */


@interface ActivityData : UPBaseModel
@property (nonatomic, copy) NSString *activity_class;
@property (nonatomic, copy) NSString *activity_desc;
@property (nonatomic, copy) NSString *activity_fee;
@property (nonatomic, copy) NSString *activity_image;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_addr;//活动地址
@property (nonatomic, copy) NSString *activity_place;//活动场所
@property (nonatomic, copy) NSString *activity_place_code;//场所代码
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
@property (nonatomic, copy) NSString *user_icon;

//详细信息
@property (nonatomic, copy) NSString *activity_type;
@property (nonatomic, copy) NSString *fmale_low;
@property (nonatomic, copy) NSString *fmale_part_count;
@property (nonatomic, copy) NSString *join_status;
@property (nonatomic, copy) NSString *limit_low;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSMutableArray *join_list;
@end

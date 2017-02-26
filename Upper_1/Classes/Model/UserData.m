//
//  Person.m
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (NSDictionary *)attributeMapDictionary {
    return @{
             @"ID" : @"id",
             };
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super init]) {
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _industry_id = [aDecoder decodeObjectForKey:@"industry_id"];
        _industry_name = [aDecoder decodeObjectForKey:@"industry_name"];
        _nick_name = [aDecoder decodeObjectForKey:@"nick_name"];
        _node_id = [aDecoder decodeObjectForKey:@"node_id"];
        _node_name = [aDecoder decodeObjectForKey:@"node_name"];
        _sexual = [aDecoder decodeObjectForKey:@"sexual"];
        _true_name = [aDecoder decodeObjectForKey:@"true_name"];
        _user_icon = [aDecoder decodeObjectForKey:@"user_icon"];
        _user_image = [aDecoder decodeObjectForKey:@"user_image"];
        _user_status = [aDecoder decodeObjectForKey:@"user_status"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _token = [aDecoder decodeObjectForKey:@"token"];
        _province_code = [aDecoder decodeObjectForKey:@"province_code"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ID forKey:@"ID"];
    [aCoder encodeObject:_industry_id forKey:@"industry_id"];
    [aCoder encodeObject:_industry_name forKey:@"industry_name"];
    [aCoder encodeObject:_nick_name forKey:@"nick_name"];
    [aCoder encodeObject:_node_id forKey:@"node_id"];
    [aCoder encodeObject:_node_name forKey:@"node_name"];
    [aCoder encodeObject:_sexual forKey:@"sexual"];
    [aCoder encodeObject:_true_name forKey:@"true_name"];
    [aCoder encodeObject:_user_icon forKey:@"user_icon"];
    [aCoder encodeObject:_user_image forKey:@"user_image"];
    [aCoder encodeObject:_user_status forKey:@"user_status"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_province_code forKey:@"province_code"];
}

- (void)setWithUserData:(UserData *)userData;
{
    if (self) {
        self.ID = userData.ID==nil?@"":userData.ID;
        self.industry_id = userData.industry_id==nil?@"":userData.industry_id;
        self.industry_name = userData.industry_name==nil?@"":userData.industry_name;
        self.nick_name = userData.nick_name==nil?@"":userData.nick_name;
        self.node_id = userData.node_id==nil?@"":userData.node_id;
        self.node_name = userData.node_name==nil?@"":userData.node_name;
        self.sexual = userData.sexual==nil?@"":userData.sexual;
        self.true_name = userData.true_name==nil?@"":userData.true_name;
        self.user_icon = userData.user_icon==nil?@"":userData.user_icon;
        self.user_image = userData.user_image==nil?@"":userData.user_image;
        self.user_status = userData.user_status==nil?@"":userData.user_status;
        self.birthday = userData.birthday==nil?@"":userData.birthday;
        self.token = userData.token==nil?@"":userData.token;
        self.province_code = userData.province_code==nil?@"":userData.province_code;
    }
}
@end



@implementation OtherUserData

- (NSDictionary *)attributeMapDictionary {
    return @{ @"ID" : @"id",};
}
@end


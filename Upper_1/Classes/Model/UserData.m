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
        _province_code = [aDecoder decodeObjectForKey:@"province_code"];
        _secret_flag = [aDecoder decodeObjectForKey:@"secret_flag"];
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
    [aCoder encodeObject:_province_code forKey:@"province_code"];
    [aCoder encodeObject:_secret_flag forKey:@"secret_flag"];
}

- (void)setWithUserData:(UserData *)userData;
{
    if (self) {
        _ID = userData.ID==nil?@"":userData.ID;
        _industry_id = userData.industry_id==nil?@"":userData.industry_id;
        _industry_name = userData.industry_name==nil?@"":userData.industry_name;
        _nick_name = userData.nick_name==nil?@"":userData.nick_name;
        _node_id = userData.node_id==nil?@"":userData.node_id;
        _node_name = userData.node_name==nil?@"":userData.node_name;
        _sexual = userData.sexual==nil?@"":userData.sexual;
        _true_name = userData.true_name==nil?@"":userData.true_name;
        _user_icon = userData.user_icon==nil?@"":userData.user_icon;
        _user_image = userData.user_image==nil?@"":userData.user_image;
        _user_status = userData.user_status==nil?@"":userData.user_status;
        _birthday = userData.birthday==nil?@"":userData.birthday;
        _province_code = userData.province_code==nil?@"":userData.province_code;
        _secret_flag = userData.secret_flag==nil?@"":userData.secret_flag;
    }
}

- (BOOL)companySecret
{
    if (self.secret_flag.length==4) {
        unichar companySecretFlag = [self.secret_flag characterAtIndex:0];
        if ((companySecretFlag-'0')==0) {
            return NO;
        } else
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)industrySecret
{
    if (self.secret_flag.length==4) {
        unichar industrySecretFlag = [self.secret_flag characterAtIndex:1];
        if ((industrySecretFlag-'0')==0) {
            return NO;
        } else
        {
            return YES;
        }
    }
    return NO;
}
@end



@implementation OtherUserData

- (NSDictionary *)attributeMapDictionary {
    return @{ @"ID" : @"id",};
}
@end


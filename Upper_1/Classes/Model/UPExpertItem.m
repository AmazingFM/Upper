//
//  UPExpertItem.m
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPExpertItem.h"

@implementation UPExpertItem

- (BOOL)isNSNullString:(id)strObj
{
    return [strObj isKindOfClass:[NSNull class]];
}

- (void)fillInfoWithDict:(NSDictionary *)dict
{
    NSString *result;
    result = dict[@"Id"];
    self.expertID = ([self isNSNullString:result])?@"":result;
    
    result = dict[@"Title"];
    self.expertTitle = ([self isNSNullString:result])?@"":result;
    
    result = dict[@"Name"];
    self.expertName = ([self isNSNullString:result])?@"":result;
    
    result = dict[@"Desc"];
    self.expertDesc = ([self isNSNullString:result])?@"":result;
    
    result = dict[@"Img"];
    self.expertImg = ([self isNSNullString:result])?@"":result;
    
    result = dict[@"PeopleCount"];
    self.peopleCount = ([self isNSNullString:result])?0:[result intValue];
}

@end

//
//  CompanyModel.h
//  Upper_1
//
//  Created by aries365.com on 16/1/15.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *node_name;
@property (nonatomic, copy) NSString *node_desc;
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *town_code;
@property (nonatomic, copy) NSString *node_address;
@property (nonatomic, copy) NSString *node_email_suffix;
@property (nonatomic, copy) NSString *industry_code;
@end

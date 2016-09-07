//
//  CityItem.h
//  Upper_1
//
//  Created by aries365.com on 15/12/15.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

///城市信息结构

#import <Foundation/Foundation.h>

@interface CityItem : NSObject

@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *town_code;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, copy) NSString *note;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) NSIndexPath *indexPath;

- (instancetype)initWithCityItem:(NSMutableDictionary *)cityItem;
+ (instancetype)initWithCityItem:(NSMutableDictionary *)cityItem;

@end

@interface ProvinceItem : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, retain) NSMutableArray *cityItems;

@end

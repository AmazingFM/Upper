//
//  CityItem.m
//  Upper_1
//
//  Created by aries365.com on 15/12/15.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "CityItem.h"

@implementation CityItem

- (instancetype)initWithCityItem:(NSMutableDictionary *)cityItemDict
{
    if (self = [super init]) {
        _province_code = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"province_code"]];
        _city_code = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"city_code"]];
        _town_code = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"town_code"]];
        _province = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"_province"]];
        _city = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"city"]];
        _town = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"town"]];
        _level = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"level"]];
        _first_letter = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"first_letter"]];
        _note = [NSString stringWithFormat:@"%@",[cityItemDict objectForKey:@"note"]];
    }
    return self;
}
+ (instancetype)initWithCityItem:(NSMutableDictionary *)cityItem
{
    return [[self alloc]initWithCityItem:cityItem];
}

@end

@implementation ProvinceItem

-(NSMutableArray *)cityItems
{
    if (_cityItems==nil) {
        _cityItems = [NSMutableArray array];
    }
    return _cityItems;
}
@end
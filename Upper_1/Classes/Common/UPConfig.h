//
//  UPConfig.h
//  Upper
//
//  Created by 张永明 on 2017/2/10.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPTools.h"

@class ActivityCategory;
@class ActivityType;
@class ActivityStatus;
@class BaseType;
@class CityContainer;

@interface UPConfig : NSObject
@property (nonatomic) BOOL hasLoadCityInfo;
@property (nonatomic) NSString *uuid;
@property (nonatomic) NSString *currentDate;
@property (nonatomic) int reqSeq;

@property (nonatomic, retain) CityContainer *cityContainer;

@property (nonatomic, retain) NSMutableArray<ActivityCategory *> *activityCategoryArr;
@property (nonatomic, retain) NSMutableArray<ActivityType *> *activityTypeArr;
@property (nonatomic, retain) NSMutableArray<ActivityStatus *> *activityStatusArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *clothTypeArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *payTypeArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *placeTypeArr;

@property (nonatomic, copy) void (^refreshBlock)(void);

+ (instancetype)sharedInstance;
- (BaseType *)getPayTypeByID:(NSString *)ID;
- (BaseType *)getClothTypeByID:(NSString *)ID;
- (BaseType *)getPlaceTypeByID:(NSString *)ID;
- (ActivityStatus *)getActivityStatusByID:(NSString *)ID;
- (ActivityType *)getActivityTypeByID:(NSString *)ID;

- (NSString *)newReqSeqStr;//获取递增后的request序列号

- (void)requestCityInfo;//获取城市信息
@end


@interface BaseType : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
- (instancetype) initWithDict:(NSDictionary *)aDict;
@end

@interface ActivityCategory : BaseType
@property (nonatomic, retain) NSMutableArray<ActivityType *> *activityTypeArr;
@end

@interface ActivityType : BaseType
@property (nonatomic) BOOL femaleFlag;//女性标志
@end

@interface ActivityStatus : BaseType
@property (nonatomic, copy) NSString *activityDescription;
@end

@interface CityInfo : NSObject
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *town_code;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, copy) NSString *note;

- (instancetype)initWithDict:(NSDictionary *)aDict;
@end

@interface ProvinceInfo : NSObject
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, retain) NSMutableArray<CityInfo *> *citylist;

- (void)addCityInfo:(CityInfo *)cityInfo;
@end

@interface AlphabetCityInfo : NSObject
@property (nonatomic, copy) NSString *firstLetter;
@property (nonatomic, retain) NSMutableArray<CityInfo *> *citylist;

- (void)addCityInfo:(CityInfo *)cityInfo;

@end

@interface CityContainer : NSObject
{
    NSString *localFilePath;
}

@property (nonatomic, retain) NSMutableArray<ProvinceInfo *> *provinceInfoArr;
@property (nonatomic, retain) NSMutableArray<AlphabetCityInfo *> *alphaCityInfoArr;
@property (nonatomic, retain) NSMutableArray<CityInfo *> *cityInfoArr;
@property (nonatomic, retain) NSMutableArray<CityInfo *> *hotCityInfoArr;

- (void)updateCityInfoArr:(NSArray *)cityArr;
- (void)updateHotCityInfoArr:(NSArray *)hotCityArr;
- (CityInfo *)getCityInfo:(NSString *)cityCode;
- (NSArray *)getHotCityInfo;
@end


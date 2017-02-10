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

@interface UPConfig : NSObject

@property (nonatomic) NSString *uuid;
@property (nonatomic) NSString *currentDate;
@property (nonatomic) int reqSeq;

@property (nonatomic, retain) NSMutableArray<ActivityCategory *> *activityCategoryArr;
@property (nonatomic, retain) NSMutableArray<ActivityType *> *activityTypeArr;
@property (nonatomic, retain) NSMutableArray<ActivityStatus *> *activityStatusArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *clothTypeArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *payTypeArr;
@property (nonatomic, retain) NSMutableArray<BaseType *> *placeTypeArr;

+ (instancetype)sharedInstance;
- (BaseType *)getPayTypeByID:(NSString *)ID;
- (BaseType *)getClothTypeByID:(NSString *)ID;
- (BaseType *)getPlaceTypeByID:(NSString *)ID;
- (ActivityStatus *)getActivityStatusByID:(NSString *)ID;
- (ActivityType *)getActivityTypeByID:(NSString *)ID;
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



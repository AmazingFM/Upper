//
//  UPConfig.m
//  Upper
//
//  Created by 张永明 on 2017/2/10.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPConfig.h"

@implementation UPConfig

+ (void)load
{
    //加载初始化信息，城市信息
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)sharedInstance
{
    static UPConfig *sharedInstance = nil;
    
    if (sharedInstance==nil) {
        sharedInstance = [[UPConfig alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        
        _activityCategoryArr = [NSMutableArray<ActivityCategory *> new];
        _activityTypeArr = [NSMutableArray<ActivityType *> new];;
        _activityStatusArr = [NSMutableArray<ActivityStatus *> new];;
        _clothTypeArr = [NSMutableArray<BaseType *> new];;
        _payTypeArr = [NSMutableArray<BaseType *> new];;
        _placeTypeArr = [NSMutableArray<BaseType *> new];;

        [self readActivityConfig];
    }
    return self;
}

- (void)readActivityConfig
{
    NSString *path = nil;
    NSMutableArray *tmpArr = nil;
    //读取活动类型
    path = [[NSBundle mainBundle] pathForResource:@"ActivityType" ofType:@"plist"];
    tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityCategory *actType = [[ActivityCategory alloc] initWithDict:obj];
        [self.activityCategoryArr addObject:actType];
        
        NSArray *detailTypeArr = obj[@"ActivityDetail"];
        for (NSDictionary *typeDic in detailTypeArr) {
            ActivityType *activityType = [[ActivityType alloc] initWithDict:typeDic];
            [self.activityTypeArr addObject:activityType];
        }
    }];
    
    //读取活动状态
    path= [[NSBundle mainBundle] pathForResource:@"ActivityStatus" ofType:@"plist"];
    tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityStatus *actStatus = [[ActivityStatus alloc] initWithDict:obj];
        [self.activityStatusArr addObject:actStatus];
    }];
    
    //读取着装类型
    path= [[NSBundle mainBundle] pathForResource:@"ClothType" ofType:@"plist"];
    tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseType *baseType = [[BaseType alloc] initWithDict:obj];
        [self.clothTypeArr addObject:baseType];
    }];

    //读取活动场所类型
    path= [[NSBundle mainBundle] pathForResource:@"PlaceType" ofType:@"plist"];
    tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseType *baseType = [[BaseType alloc] initWithDict:obj];
        [self.placeTypeArr addObject:baseType];
    }];
    
    //读取付款方式
    path= [[NSBundle mainBundle] pathForResource:@"PayType" ofType:@"plist"];
    tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseType *baseType = [[BaseType alloc] initWithDict:obj];
        [self.payTypeArr addObject:baseType];
    }];
}

- (BaseType *)getPayTypeByID:(NSString *)ID
{
    int index = [ID intValue]-1;
    if (index<self.payTypeArr.count) {
        return self.payTypeArr[index];
    }
    return nil;
}

- (BaseType *)getClothTypeByID:(NSString *)ID
{
    int index = [ID intValue]-1;
    if (index<self.clothTypeArr.count) {
        return self.clothTypeArr[index];
    }
    return nil;
}

- (BaseType *)getPlaceTypeByID:(NSString *)ID
{
    int index = [ID intValue]-1;
    if (index<self.placeTypeArr.count) {
        return self.placeTypeArr[index];
    }
    return nil;
}

- (ActivityStatus *)getActivityStatusByID:(NSString *)ID
{
    int index = [ID intValue];
    if (index<self.activityStatusArr.count) {
        return self.activityStatusArr[index];
    }
    return nil;
}

- (ActivityType *)getActivityTypeByID:(NSString *)ID
{
    for (ActivityType *actType in self.activityTypeArr) {
        if ([actType.ID isEqualToString:ID]) {
            return actType;
        }
    }
    return nil;
}


- (void)applicationWillEnterForeground
{
    [self readSeqFromDefaults];
}

- (void)applicationWillEnterBackground
{
    [self writeSeqToDefaults];
}

- (NSString *)uuid
{
    if (!_uuid) {
        _uuid = [UPTools getUPUUID];
    }
    return _uuid;
}

- (NSString *)currentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)reqSeqStr
{
    NSString *reqStr = [NSString stringWithFormat:@"%6d", _reqSeq];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@%@", today, reqStr];
}

- (void)readSeqFromDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *rq = [userDefaults stringForKey:@"reqSeq"];
    NSString *today = [UPTools dateString:[NSDate date] withFormat:@"yyyyMMdd"];
    if (rq!=nil && rq.length>0) {
        NSString * rqDate = [rq substringToIndex:8];
        if ([rqDate isEqualToString:today]) {
            NSString *rqNum = [rq substringWithRange:NSMakeRange(8, 6)];
            _reqSeq = [rqNum intValue];
        } else {
            _reqSeq = 0;
        }
    } else {
        _reqSeq = 0;
    }
}

- (void)writeSeqToDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *reqSeq = [self reqSeqStr];
    [userDefaults setObject:reqSeq forKey:@"reqSeq"];
    [userDefaults synchronize];
}

@end

@implementation BaseType

- (instancetype) initWithDict:(NSDictionary *)aDict
{
    self = [super init];
    if (self) {
        self.ID = aDict[@"ID"];
        self.name = aDict[@"Name"];
    }
    return self;
}

@end

@implementation ActivityCategory

- (instancetype) initWithDict:(NSDictionary *)aDict
{
    self = [super init];
    if (self) {
        self.ID = aDict[@"ID"];
        self.name = aDict[@"ActivityCategory"];
        
        NSArray *detailTypeArr = aDict[@"ActivityDetail"];
        for (NSDictionary *typeDic in detailTypeArr) {
            ActivityType *activityType = [[ActivityType alloc] initWithDict:typeDic];
            [self.activityTypeArr addObject:activityType];
        }
    }
    return self;
}

- (NSMutableArray<ActivityType *> *)activityTypeArr
{
    if (_activityTypeArr==nil) {
        _activityTypeArr = [NSMutableArray<ActivityType *> new];
    }
    return _activityTypeArr;
}

@end

@implementation ActivityType

- (instancetype) initWithDict:(NSDictionary *)aDict{
    self = [super init];
    if (self) {
        self.ID = aDict[@"ItemID"];
        self.name = aDict[@"Name"];
        
        //夜店趴，家庭趴
        if ([self.ID isEqualToString:@"102"] ||
            [self.ID isEqualToString:@"105"]) {
            self.femaleFlag = YES;
        } else {
            self.femaleFlag = NO;
        }
    }
    return self;
}

@end

@implementation ActivityStatus

- (instancetype) initWithDict:(NSDictionary *)aDict{
    self = [super init];
    if (self) {
        self.ID = aDict[@"ID"];
        self.activityDescription = aDict[@"Description"];
        
        NSString *title = aDict[@"Title"];
        if (title.length==0) {
            self.name=@"none";
        } else {
            self.name = aDict[@"Title"];
        }
    }
    return self;
}

@end

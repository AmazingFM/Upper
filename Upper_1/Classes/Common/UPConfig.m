//
//  UPConfig.m
//  Upper
//
//  Created by 张永明 on 2017/2/10.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPConfig.h"
#import "YMNetwork.h"

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
        _placeTypeArr = [NSMutableArray<BaseType *> new];
        
        _cityContainer = [[CityContainer alloc] init];
        
        self.hasLoadCityInfo = NO;
        [self readActivityConfig];
        
        [self performSelectorInBackground:@selector(requestCityInfo) withObject:nil];
    }
    return self;
}

- (void)requestCityInfo
{
    if (!self.hasLoadCityInfo) {
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:@{@"a":@"CityQuery"} success:^(id responseObject) {
            NSDictionary *respDict = (NSDictionary *)responseObject;
            
            if ([respDict[@"resp_id"] intValue]==0) {
                NSArray *cityArr = respDict[@"resp_data"][@"city_list"];
                NSArray *hotCityArr = respDict[@"resp_data"][@"city_hot"];
                [self.cityContainer updateCityInfoArr:cityArr];
                [self.cityContainer updateHotCityInfoArr:hotCityArr];
                
                self.hasLoadCityInfo = YES;
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
            }
        } failure:^(NSError *error) {
            self.hasLoadCityInfo = NO;
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
    } else {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
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
    if (ID==nil) {
        return nil;
    }
    
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

- (NSString *)newReqSeqStr
{
    NSString *reqStr = [NSString stringWithFormat:@"%06d", ++_reqSeq];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@%@", today, reqStr];
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

@implementation CityInfo

- (instancetype)initWithDict:(NSDictionary *)aDict
{
    if (self = [super init]) {
        _province_code = [aDict objectForKey:@"province_code"];
        _city_code = [aDict objectForKey:@"city_code"];
        _town_code = [aDict objectForKey:@"town_code"];
        _province = [aDict objectForKey:@"province"];
        _city = [aDict objectForKey:@"city"];
        _town = [aDict objectForKey:@"town"];
        _level = [aDict objectForKey:@"level"];
        _first_letter = [aDict objectForKey:@"first_letter"];
        _note = [aDict objectForKey:@"note"];
    }
    return self;
}

@end


@implementation ProvinceInfo

- (instancetype)initWithDict:(NSDictionary *)aDict
{
    if (self=[super init]) {
        
    }
    return self;
}

- (NSMutableArray<CityInfo *> *)citylist
{
    if (_citylist==nil) {
        _citylist = [NSMutableArray<CityInfo *> new];
    }
    return _citylist;
}

- (void)addCityInfo:(CityInfo *)cityInfo
{
    self.province_code = cityInfo.province_code;
    self.province = cityInfo.province;
    [self.citylist addObject:cityInfo];
}
@end

@implementation AlphabetCityInfo
- (NSMutableArray<CityInfo *> *)citylist
{
    if (_citylist==nil) {
        _citylist = [NSMutableArray<CityInfo *> new];
    }
    return _citylist;
}

- (void)addCityInfo:(CityInfo *)cityInfo
{
    self.firstLetter = cityInfo.first_letter;
    [self.citylist addObject:cityInfo];
}
@end

#define CityInfoFileName @"cityInfo.json"

@implementation CityContainer

- (instancetype)init
{
    if (self=[super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = paths[0];
        localFilePath = [documentPath stringByAppendingPathComponent:CityInfoFileName];

        _cityInfoArr = [NSMutableArray<CityInfo *> new];
        _provinceInfoArr = [NSMutableArray<ProvinceInfo *> new];
        _alphaCityInfoArr = [NSMutableArray<AlphabetCityInfo *> new];
        _hotCityInfoArr = [NSMutableArray<CityInfo *> new];
        [self loadLocalCityInfo];
    }
    return self;
}

- (void)loadLocalCityInfo
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        NSArray *cityArr = [UPTools loadBundleFile:CityInfoFileName];
        [self loadCityInfoArr:cityArr];
        [self saveToLocalFile:cityArr];
    } else  {
        NSArray *cityArr = [UPTools loadLocalDataWithName:CityInfoFileName];
        [self loadCityInfoArr:cityArr];
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *hotCityArrStr = [userDefaults objectForKey:@"HotCityKey"];
        if (hotCityArrStr.length>0) {
            NSArray *hotCityArr = (NSArray *)[UPTools JSONFromString:hotCityArrStr];
            [self loadHotCityInfoArr:hotCityArr];
        }
    }
}

- (void)saveToLocalFile:(NSArray *)cityArr
{
    //保存到document目录下
    NSString *cityArrStr = [UPTools stringFromJSON:cityArr];
    [cityArrStr writeToFile:localFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)updateCityInfoArr:(NSArray *)cityArr
{
    [self saveToLocalFile:cityArr];
    [self loadCityInfoArr:cityArr];
}

- (void)updateHotCityInfoArr:(NSArray *)hotCityArr
{
    NSString *hotCityArrStr = [UPTools stringFromJSON:hotCityArr];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:hotCityArrStr forKey:@"HotCityKey"];
    [userDefaults synchronize];
    
    [self loadHotCityInfoArr:hotCityArr];
}

- (void)loadHotCityInfoArr:(NSArray *)hotCityArr
{
    [self.hotCityInfoArr removeAllObjects];
    for (NSDictionary *cityDic in hotCityArr) {
        CityInfo *cityInfo = [[CityInfo alloc] initWithDict:cityDic];
        [self.hotCityInfoArr addObject:cityInfo];
    }
}

- (void)clearAllInfo
{
    [self.cityInfoArr removeAllObjects];
    [self.provinceInfoArr removeAllObjects];
    [self.alphaCityInfoArr removeAllObjects];
}

- (void)loadCityInfoArr:(NSArray *)cityArr
{
    [self clearAllInfo];
    for (NSDictionary *cityDic in cityArr) {
        CityInfo *cityInfo = [[CityInfo alloc] initWithDict:cityDic];
        [self.cityInfoArr addObject:cityInfo];
        
        [self addCityToAlphabet:cityInfo];
        [self addCityToProvince:cityInfo];
    }
}

- (void)addCityToAlphabet:(CityInfo *)cityInfo
{
    AlphabetCityInfo *alphabetCityInfo = [self getAlphabetCityInfo:cityInfo.first_letter];
    [alphabetCityInfo addCityInfo:cityInfo];
}

- (void)addCityToProvince:(CityInfo *)cityInfo
{
    ProvinceInfo *provinceInfo = [self getProvinceInfo:cityInfo.province_code];
    [provinceInfo addCityInfo:cityInfo];
}

- (AlphabetCityInfo *)getAlphabetCityInfo:(NSString *)firstLetter
{
    __block AlphabetCityInfo *alphabetCityInfo = nil;
    [self.alphaCityInfoArr enumerateObjectsUsingBlock:^(AlphabetCityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.firstLetter isEqualToString:firstLetter]) {
            alphabetCityInfo = obj;
            *stop = YES;
        }
    }];
    
    if (alphabetCityInfo==nil) {
        alphabetCityInfo = [[AlphabetCityInfo alloc] init];
        [self.alphaCityInfoArr addObject:alphabetCityInfo];
    }
    return alphabetCityInfo;
}

- (ProvinceInfo *)getProvinceInfo:(NSString *)proviceCode
{
    __block ProvinceInfo *provinceInfo = nil;
    [self.provinceInfoArr enumerateObjectsUsingBlock:^(ProvinceInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.province_code isEqualToString:proviceCode]) {
            provinceInfo = obj;
            *stop = YES;
        }
    }];
    
    if (provinceInfo==nil) {
        provinceInfo = [[ProvinceInfo alloc] init];
        [self.provinceInfoArr addObject:provinceInfo];
    }
    return provinceInfo;
}

- (CityInfo *)getCityInfo:(NSString *)cityCode
{
    __block CityInfo *cityInfo = nil;
    [self.cityInfoArr enumerateObjectsUsingBlock:^(CityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.city_code isEqualToString:cityCode]) {
            cityInfo = obj;
            *stop = YES;
        }
    }];
    
    return cityInfo;
}

- (NSArray *)getHotCityInfo
{
    if (self.hotCityInfoArr.count>0) {
        return self.hotCityInfoArr;
    }
    return @[];
}

@end

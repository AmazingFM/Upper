//
//  UPDataManager.m
//  Upper
//
//  Created by freshment on 16/5/23.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPDataManager.h"
#import "UPTools.h"
#import "CityItem.h"
#import "Info.h"

NSString * const g_loginFileName = @"login.plist";
@implementation UPDataManager

+ (instancetype)shared
{
    static UPDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UPDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLogin = NO;
        _reqSeq = 0;
        _hasLoadCities = NO;
    }
    return self;
}

- (void)writeToDefaults:(UserData *)userData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userData];
    
    [userDefaults setObject:data forKey:@"user"];
    [userDefaults setBool:YES forKey:@"hasLogin"];
    
    
    [userDefaults synchronize];
}

- (void)cleanUserDafult
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"hasLogin"];
    [userDefaults synchronize];
    
    _userInfo = nil;
    _isLogin = NO;
}

- (void)setUserInfo:(UserData *)userInfo
{
    UserData *user = [[UserData alloc] init];
    [user setWithUserData:userInfo];
    _userInfo = user;
}

- (void)readFromDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data =  [userDefaults objectForKey:@"user"];
    
    if(data) {
        [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        UserData *userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(userData!=nil) {
            _userInfo = userData;
        }
    }
    _isLogin = [userDefaults boolForKey:@"hasLogin"];
    
    if (_isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierLogin object:nil];
    }
}

- (NSMutableArray *)cityList
{
    if (_cityList==nil) {
        _cityList = [[NSMutableArray alloc] init];
    }
    return _cityList;
}

-(NSMutableDictionary *)provinceDict
{
    if (_provinceDict==nil) {
        _provinceDict = [NSMutableDictionary dictionary];
    }
    return _provinceDict;
}

//-(NSMutableArray *)messageList
//{
//    if (_messageList==nil) {
//        _messageList = [[NSMutableArray alloc] init];
//    }
//    return _messageList;
//}

-(NSMutableArray *)activityList
{
    if (_activityList==nil) {
        _activityList = [[NSMutableArray alloc] init];
    }
    return _activityList;
}




- (void)initWithCityItems:(NSArray *)cityArr
{
    self.hasLoadCities = YES;
    [cityArr enumerateObjectsUsingBlock: ^(CityItem *obj,NSUInteger idx, BOOL *stop)
    {
        if (obj.province&&obj.province.length>0) {
            if (![self.provinceDict objectForKey:obj.province]) {
                NSMutableArray *cityArr = [NSMutableArray array];
                [self.provinceDict setObject:cityArr forKey:obj.province];
            }
            [[self.provinceDict objectForKey:obj.province] addObject:obj];
        }
    }];
    
    [self.cityList removeAllObjects];
    [self.cityList addObjectsFromArray:cityArr];
}

//- (void)initWithMessageItems:(NSArray *)msgArr
//{
//    [self.messageList addObjectsFromArray:msgArr];
//}


- (NSString *)uuid
{
    if (_uuid==nil) {
        _uuid = [UPTools getUPUUID];
    }
    return _uuid;
}

- (NSString *)currentDate
{
    return [UPTools dateString:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
}

- (int)reqSeq
{
    return _reqSeq++;
}

- (NSDictionary *)getHeadParams
{
    NSString *uuid = self.uuid;
    NSString *currentDate = self.currentDate;
    NSString *reqSeq = [NSString stringWithFormat:@"%d", self.reqSeq];
    NSString *md5Str = [UPTools md5HexDigest:[NSString stringWithFormat:@"upper%@%@%@upper", uuid, reqSeq, currentDate]];
    return @{@"app_id":uuid, @"req_seq":reqSeq, @"time_stamp":currentDate, @"sign":md5Str};
}

@end

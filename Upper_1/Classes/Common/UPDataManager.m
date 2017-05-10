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

@interface UPDataManager()
{
}

@end
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
    [userDefaults setObject:nil forKey:@"user"];
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

-(NSMutableArray *)activityList
{
    if (_activityList==nil) {
        _activityList = [[NSMutableArray alloc] init];
    }
    return _activityList;
}

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

- (NSString *)reqSeqStr
{
    int bitCount = 1;
    int num = _reqSeq;
    while (num/10) {
        bitCount++;
        num = num/10;
    }
    
    NSMutableString *mStr = [NSMutableString stringWithString:@"000000"];
    [mStr replaceCharactersInRange:NSMakeRange(6-bitCount, bitCount) withString:[NSString stringWithFormat:@"%d", _reqSeq]];
    
    return [NSString stringWithFormat:@"%@%@", [UPTools dateString:[NSDate date] withFormat:@"yyyyMMdd"],mStr];
}
//
- (NSDictionary *)getHeadParams
{
    NSString *uuid = self.uuid;
    NSString *currentDate = self.currentDate;
    
    _reqSeq++;
    NSString *reqSeq = [self reqSeqStr];
    NSString *md5Str = [UPTools md5HexDigest:[NSString stringWithFormat:@"upper%@%@%@upper", uuid, reqSeq, currentDate]];
    return @{@"app_id":uuid, @"req_seq":reqSeq, @"time_stamp":currentDate, @"sign":md5Str};
}

@end

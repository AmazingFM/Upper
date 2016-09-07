//
//  UPDataManager.h
//  Upper
//
//  Created by freshment on 16/5/23.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "CityItem.h"



@interface UPDataManager : NSObject

@property (nonatomic) BOOL isLogin;
@property (nonatomic) NSString *uuid;
@property (nonatomic) NSString *currentDate;
@property (nonatomic) int reqSeq;
@property (nonatomic) BOOL hasLoadCities;

@property (nonatomic, retain) UserData *userInfo;
@property (nonatomic, retain) NSMutableArray *cityList;
@property (nonatomic, retain) NSMutableDictionary *provinceDict;
//@property (nonatomic, retain) NSMutableArray *messageList;
@property (nonatomic, retain) NSMutableArray *activityList;

+ (instancetype)shared;
- (NSDictionary *)getHeadParams;
- (void)initWithCityItems:(NSArray *)cityArr;
- (void)initWithMessageItems:(NSArray *)msgArr;
- (void)writeToDefaults:(UserData *)userData;
- (void)readFromDefaults;
- (void)cleanUserDafult;
@end

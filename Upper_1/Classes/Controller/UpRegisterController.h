//
//  UpRegisterController.h
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "NSObject+MJKeyValue.h"

@interface UpRegisterController : UPBaseViewController

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *emailSuffix;

@property (nonatomic, copy) NSString *provCode;
@property (nonatomic, copy) NSString *townCode;
@property (nonatomic, copy) NSString *cityCode;

@end

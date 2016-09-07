//
//  ActivityItem.h
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityItem : NSObject

@property (nonatomic, copy) NSString *actId;
@property (nonatomic, copy) NSString *actTitle;
@property (nonatomic, copy) NSString *actContent;
@property (nonatomic, copy) NSString *actHost;
@property (nonatomic, copy) NSString *actBeginTime;
@property (nonatomic, copy) NSString *actEndTime;
@property (nonatomic, copy) NSString *actLocation;
@property (nonatomic, copy) NSString *actType;
@property (nonatomic, copy) NSString *actDress;
@property (nonatomic) BOOL *prepay;
@property (nonatomic) int *actFee;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSData *imageData;

@property (nonatomic, copy) NSString *actPersonCount;
@end

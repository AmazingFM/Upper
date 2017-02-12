//
//  CityItem.h
//  Upper_1
//
//  Created by aries365.com on 15/12/15.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

///城市信息结构

#import <Foundation/Foundation.h>
#import "UPConfig.h"
@interface CityItem : NSObject

@property (nonatomic, retain) CityInfo *cityInfo;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) NSIndexPath *indexPath;

@end

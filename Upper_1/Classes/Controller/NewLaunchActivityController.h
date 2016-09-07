//
//  NewLaunchActivityController.h
//  Upper
//
//  Created by 张永明 on 16/8/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class CityItem;
@protocol CitySelectDelegate <NSObject>

- (void)cityDidSelect:(CityItem *)cityItem;

@end
@interface UPCitySelectController : UPBaseViewController
@property (nonatomic, weak) id<CitySelectDelegate> delegate;
@end

@interface NewLaunchActivityController : UPBaseViewController <CitySelectDelegate>

@end

//
//  NewLaunchActivityController.h
//  Upper
//
//  Created by 张永明 on 16/8/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@class CityInfo;
@class ActivityData;
@protocol CitySelectDelegate <NSObject>

- (void)cityDidSelect:(CityInfo *)cityInfo;

@end
@interface UPCitySelectController : UPBaseViewController
@property (nonatomic, weak) id<CitySelectDelegate> delegate;
@end

@interface NewLaunchActivityController : UPBaseViewController <CitySelectDelegate>
@property (nonatomic, retain) ActivityData *actData;
@end

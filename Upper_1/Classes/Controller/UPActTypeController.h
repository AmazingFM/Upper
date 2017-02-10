//
//  UPActTypeController.h
//  Upper
//
//  Created by 张永明 on 16/11/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

#import "ActivityData.h"
#import "UPConfig.h"

@protocol UPActTypeSelectDelegate <NSObject>

- (void)actionTypeDidSelect:(ActivityType *)actType;

@end


@interface UPActTypeController : UPBaseViewController

@property (nonatomic, weak) id<UPActTypeSelectDelegate> delegate;

@end

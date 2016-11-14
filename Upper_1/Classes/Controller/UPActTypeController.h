//
//  UPActTypeController.h
//  Upper
//
//  Created by 张永明 on 16/11/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@protocol UPActTypeSelectDelegate <NSObject>

- (void)actionTypeDidSelect:(int)typeCode andTypeName:(NSString *)typeName;

@end

@interface UPActTypeController : UPBaseViewController

@property (nonatomic, weak) id<UPActTypeSelectDelegate> delegate;

@end

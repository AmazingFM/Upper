//
//  UPActTypeController.h
//  Upper
//
//  Created by 张永明 on 16/11/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@interface ActInfo : NSObject

@property (nonatomic, retain) NSString *itemID;
@property (nonatomic, retain) NSString *actName;
@property (nonatomic) BOOL femalFlag;//女性标志

@end


@protocol UPActTypeSelectDelegate <NSObject>

- (void)actionTypeDidSelect:(ActInfo *)actInfo;

@end


@interface UPActTypeController : UPBaseViewController

@property (nonatomic, weak) id<UPActTypeSelectDelegate> delegate;

@end

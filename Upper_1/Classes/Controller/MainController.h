//
//  UpHomeController.h
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UPGlobals.h"
#import "UPDataManager.h"
#import "Info.h"
#import "UPBaseViewController.h"

@interface MainController : UPBaseViewController

- (void)OnAction:(id)mself withType:(ActionType)actionType toView:(ViewType)viewType withArg:(id)arg;
- (void)rightClick;
@end

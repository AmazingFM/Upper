//
//  SexSelectController.h
//  Upper_1
//
//  Created by aries365.com on 16/1/29.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoController.h"

@interface SexSelectController : UIViewController

@property (nonatomic, assign) int sexIndex;
@property (nonatomic, weak) PersonInfoController *parentController;
@end

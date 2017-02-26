//
//  BottomBarViewController.h
//  iosapp
//
//  Created by ChanAetern on 11/19/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPBaseViewController.h"
#import "EditingBar.h"
#import "OperationBar.h"

@interface BottomBarViewController : UPBaseViewController

@property (nonatomic, strong) EditingBar *editingBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;
- (void)sendContent;
- (void)updateInputBarHeight;

@end

//
//  AppDelegate.h
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSMutableArray *actTypeArr;
@property (nonatomic, retain) NSMutableDictionary *actStatusDict;

- (void)setRootViewController;
- (void)setRootViewControllerWithMain;

@end


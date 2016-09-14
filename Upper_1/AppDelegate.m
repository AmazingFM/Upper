//
//  AppDelegate.m
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UPGuideViewController.h"
#import "UPGlobals.h"
#import "UPTools.h"

#import "MessageManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /************ 控件外观设置 **************/
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    initialize();
    g_appDelegate = self;
    
    [self setRootViewController];
    
    g_mainWindow=self.window;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setRootViewController
{
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用GuideViewController (用户引导页面) 作为根视图
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        UPGuideViewController *guideViewController = [[UPGuideViewController alloc] init];
        self.window.rootViewController = guideViewController;
    }
    else
    {
        NSLog(@"不是第一次启动");        
        //如果不是第一次启动的话,使用LoginViewController作为根视图
//        YMRootViewController *rootViewController = [[YMRootViewController alloc] init];
//        g_sideController = rootViewController;
        UPRootViewController *rootViewController = [[UPRootViewController alloc] init];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}
@end

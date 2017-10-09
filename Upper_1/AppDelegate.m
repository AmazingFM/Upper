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
#import "ActivityData.h"
#import "CRNavigationController.h"

#import "MessageManager.h"
#import "WXApiManager.h"



#pragma mark ForTest
#import "UPAwardGuideController.h"
#import "GetPasswordController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /************ 控件外观设置 **************/
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    initialize();
    [WXApi registerApp:@"wx7ad66aed3e6a5a75"];
    
    g_appDelegate = self;
    
    [self setRootViewController];
    
    g_mainWindow=self.window;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[MessageManager shared] startMessageTimer];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[MessageManager shared] stopMessageTimer];
}

- (void)setRootViewController
{
//    [self testViewController];
//    return;
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用GuideViewController (用户引导页面) 作为根视图
        UPGuideViewController *guideViewController = [[UPGuideViewController alloc] init];
        self.window.rootViewController = guideViewController;
    }
    else
    {
        NSLog(@"不是第一次启动");
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        if (![UPDataManager shared].isLogin) {
            UpLoginController *login = [[UpLoginController alloc] init];
            CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:login];

            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
        } else {
            //此处应该增加登陆校验
            [self setRootViewControllerWithMain];
        }
    }
}

- (void)setRootViewControllerWithMain
{
    YMRootViewController *mainController = [[YMRootViewController alloc] init];
    g_sideController = mainController;
    self.window.rootViewController=mainController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
#define ChouJiangURL(u,t) [NSString stringWithFormat:@"http://121.40.167.50:8099/?u=%@&t=%@", u, t]
- (void)testViewController
{
    NSString *name = @"amazing";
    UPBaseWebViewController *webController = [[UPBaseWebViewController alloc] init];
    webController.title = @"抽奖";
    NSString *md5Key = [UPTools md5HexDigest:[NSString stringWithFormat:@"%@_0",name]];
    webController.urlString = ChouJiangURL(name, md5Key);
    CRNavigationController *nav1 = [[CRNavigationController alloc] initWithRootViewController:webController];
    self.window.rootViewController = nav1;
}
@end

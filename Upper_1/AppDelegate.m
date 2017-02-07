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

#import "MessageManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /************ 控件外观设置 **************/
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    initialize();
    
    [self readConfig];
    
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
        UPGuideViewController *guideViewController = [[UPGuideViewController alloc] init];
        self.window.rootViewController = guideViewController;
    }
    else
    {
        NSLog(@"不是第一次启动");
        
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        if (![UPDataManager shared].isLogin) {
            UpLoginController *login = [[UpLoginController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
            nav.navigationBar.shadowImage = [[UIImage alloc] init];
            
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

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UPDataManager shared] readSeqFromDefaults];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UPDataManager shared] writeSeqToDefaults];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}

- (void)readConfig
{
    NSString *actInfoPath = [[NSBundle mainBundle] pathForResource:@"ActInfo" ofType:@"plist"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithContentsOfFile:actInfoPath];
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *actTypeDict = (NSDictionary *)obj;
        ActTypeInfo *actType = [[ActTypeInfo alloc] initWithDict:actTypeDict];
        [self.actTypeArr addObject:actType];
    }];
    
    NSDictionary *actDict = [UPTools loadBundleFile:@"ActStatus.json"];
    
    [actDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *actStatusDict = (NSDictionary *)obj;
        ActStatusInfo *actStatus = [[ActStatusInfo alloc] initWithDict:actStatusDict withID:key];
        
        [self.actStatusDict setObject:actStatus forKey:key];
    }];
}

- (NSMutableDictionary *)actStatusDict
{
    if (_actStatusDict==nil) {
        _actStatusDict = [NSMutableDictionary new];
    }
    return _actStatusDict;
}

- (NSMutableArray *)actTypeArr
{
    if(_actTypeArr==nil) {
        _actTypeArr = [NSMutableArray new];
    }
    return _actTypeArr;
}

@end

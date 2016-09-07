//
//  UpNavController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpNavController.h"

@interface UpNavController ()

@end

@implementation UpNavController

+(void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];

    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
    //2.设置导航栏barButton上面文字的颜色
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [navBar setBackgroundImage:[UIImage imageNamed:@"back_shadow.png"] forBarMetrics:UIBarMetricsDefault];
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setTranslucent:YES];
    
    
}


@end

//
//  UPMainMenuController.m
//  Upper
//
//  Created by 张永明 on 16/11/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMainMenuController.h"

#import "UpperController.h"
#import "MainController.h"
#import "NewLaunchActivityController.h"
#import "UPMyFriendsViewController.h"
#import "UpMyActivityController.h"

#import "UpExpertController.h"

@interface UPMainMenuController ()

@property (nonatomic) NSInteger selectedIndex;

@end

@implementation UPMainMenuController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    UpperController *upperVC = [[UpperController alloc] init];
    MainController *hallVC = [[MainController alloc] init];
//    UpExpertController *expertVC = [[UpExpertController alloc] init];
    NewLaunchActivityController *launchVC = [[NewLaunchActivityController alloc] init];
    UPMyFriendsViewController *friendVC = [[UPMyFriendsViewController alloc] init];
    UpMyActivityViewController *myActVC = [[UpMyActivityViewController alloc] init];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:upperVC];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:hallVC];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:expertVC];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:launchVC];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:friendVC];
    UINavigationController *nav6 = [[UINavigationController alloc] initWithRootViewController:myActVC];
    
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
//    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
    [self addChildViewController:nav5];
    [self addChildViewController:nav6];
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
    
    [self.view addSubview:self.childViewControllers[self.selectedIndex].view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    g_sideController.needSwipeShowMenu = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    g_sideController.needSwipeShowMenu = NO;
}

- (void)switchController:(NSInteger)index
{
    if (index>=self.childViewControllers.count) {
        return;
    }
    
    if (index!=self.selectedIndex) {
        [self transitionFromViewController:self.childViewControllers[self.selectedIndex] toViewController:self.childViewControllers[index] duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            if (finished) {
                 [self.childViewControllers[index] didMoveToParentViewController:self];
            }
            self.selectedIndex = index;
        }];
    }
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}


@end

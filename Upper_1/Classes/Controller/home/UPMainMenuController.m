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
#import "UPRulesController.h"
#import "UpExpertController.h"
#import "CRNavigationController.h"

@interface UPMainMenuController ()
{
    NSMutableArray<UPBaseViewController *> *viewControllers;
    BOOL toMyLaunch;
}

@property (nonatomic) NSInteger selectedIndex;

@end

@implementation UPMainMenuController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedIndex = 1;
        toMyLaunch = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    UpperController *upperVC = [[UpperController alloc] init];
    MainController *hallVC = [[MainController alloc] init];
    NewLaunchActivityController *launchVC = [[NewLaunchActivityController alloc] init];
    UPMyFriendsViewController *friendVC = [[UPMyFriendsViewController alloc] init];
    UpMyActivityViewController *myActVC = [[UpMyActivityViewController alloc] init];
    UPRulesController *ruleVC = [[UPRulesController alloc] init];
    viewControllers = [NSMutableArray arrayWithCapacity:6];
    [viewControllers addObject:upperVC];
    [viewControllers addObject:hallVC];
    [viewControllers addObject:launchVC];
    [viewControllers addObject:friendVC];
    [viewControllers addObject:myActVC];
    [viewControllers addObject:ruleVC];
    
    CRNavigationController *nav1 = [[CRNavigationController alloc] initWithRootViewController:upperVC];
    CRNavigationController *nav2 = [[CRNavigationController alloc] initWithRootViewController:hallVC];
    CRNavigationController *nav4 = [[CRNavigationController alloc] initWithRootViewController:launchVC];
    CRNavigationController *nav5 = [[CRNavigationController alloc] initWithRootViewController:friendVC];
    CRNavigationController *nav6 = [[CRNavigationController alloc] initWithRootViewController:myActVC];
    CRNavigationController *nav7 = [[CRNavigationController alloc] initWithRootViewController:ruleVC];
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav4];
    [self addChildViewController:nav5];
    [self addChildViewController:nav6];
    [self addChildViewController:nav7];
    
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

- (void)switchToMyLaunchController
{
    toMyLaunch = YES;
    [self switchController:4];
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
        
        if(index==1 || index==4) //切换到大厅和我的活动时刷新
        {
            if (toMyLaunch && index==4) {
                UpMyActivityViewController *myActVC = (UpMyActivityViewController *)viewControllers[index];
                [myActVC switchToMyLaunch];
                [myActVC refresh];
                toMyLaunch = NO;
            } else {
                UPBaseViewController *viewController = viewControllers[index];
                [viewController refresh];
            }
        }
    }
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)enterSlideView
{
    UPBaseViewController *viewController = viewControllers[self.selectedIndex];
    [viewController willShowSlideView];
}

@end

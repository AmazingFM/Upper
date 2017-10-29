//
//  UpMyActivityViewController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//
#import "UpMyActivityController.h"
#import "MainController.h"
#import "UpMyActView.h"
#import "XWHttpTool.h"
#import "Info.h"
#import "UPGlobals.h"
#import "UPMyLaunchViewController.h"
#import "UPMyAnticipateViewController.h"


@interface UpMyActivityViewController () <UIScrollViewDelegate>
{
    UISegmentedControl *segmentedControl;
    
    UPMyLaunchViewController *myLaunch;
    UPMyAnticipateViewController *myAnticipate;
}

@property (nonatomic) int selectedIndex;
- (void)leftClick;
@end

@implementation UpMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSegmentedControl];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    myLaunch = [[UPMyLaunchViewController alloc] init];
    myLaunch.view.frame = CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight);
    [self addChildViewController:myLaunch];
    
    myAnticipate = [[UPMyAnticipateViewController alloc] init];
    myAnticipate.view.frame = CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight);
    [self addChildViewController:myAnticipate];


    [self.view addSubview:self.childViewControllers[_selectedIndex].view];
}

- (void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)switchToMyLaunch
{
    segmentedControl.selectedSegmentIndex = 0;
    [self segmentAction:segmentedControl];
}

- (void)initSegmentedControl
{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"我发起的",@"我参与的", nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(0, 0, 30, 30);
    segmentedControl.layer.cornerRadius = 4.f;
    segmentedControl.layer.masksToBounds = YES;
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = kUPThemeMainColor;
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    _selectedIndex = (int)segmentedControl.selectedSegmentIndex;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:kUPThemeMainColor] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:kUPThemeMainColor forKey:NSForegroundColorAttributeName];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)segmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex!=_selectedIndex) {
        [self transitionFromViewController:self.childViewControllers[_selectedIndex] toViewController:self.childViewControllers[sender.selectedSegmentIndex] duration:0.3 options:UIViewAnimationOptionAutoreverse animations:nil completion:^(BOOL finished) {
            _selectedIndex = (int)sender.selectedSegmentIndex;
        }];
    }
}

- (void)refresh
{
    if (_selectedIndex==0) {
        [myLaunch refresh];
    } else {
        [myAnticipate refresh];
    }
}

@end

//
//  UpMyActivityViewController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//
#import "UpMyActivityController.h"
#import "MainController.h"
#import "MyActCell.h"
#import "UpMyActView.h"
#import "XWHttpTool.h"
#import "UIBarButtonItem+Badge.h"
#import "Info.h"
#import "UPGlobals.h"
#import "UPMyLaunchViewController.h"
#import "UPMyAnticipateViewController.h"


@interface UpMyActivityViewController () <UIScrollViewDelegate>

@property (nonatomic) int selectedIndex;
- (void)leftClick;
@end

@implementation UpMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"我的活动";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self initSegmentedControl];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"back" highIcon:@"" target:self action:@selector(leftClick)];

    CGFloat y = FirstLabelHeight+20;
    
    UIButton *tipsButton = [[UIButton alloc]initWithFrame:CGRectMake(20, y, ScreenWidth-20*2, 17)];
    // 设置按钮的内容左对齐
    tipsButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    // 设置间距
    [tipsButton setTitle:@"我共发起了32项主题活动，慢慢地成就感" forState:UIControlStateNormal];
    [tipsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tipsButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    tipsButton.backgroundColor = [UIColor redColor];
    tipsButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    UPMyLaunchViewController *myLaunch = [[UPMyLaunchViewController alloc] init];
    myLaunch.parentController = self;
    myLaunch.view.frame = CGRectMake(0, CGRectGetMaxY(tipsButton.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(tipsButton.frame));
    [self addChildViewController:myLaunch];
    
    UPMyAnticipateViewController *myAnticipate = [[UPMyAnticipateViewController alloc] init];
    myAnticipate.parentController = self;
    myAnticipate.view.frame = CGRectMake(0, CGRectGetMaxY(tipsButton.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(tipsButton.frame));
    [self addChildViewController:myAnticipate];
    
    [self.view addSubview:tipsButton];
    [self.view addSubview:self.childViewControllers[_selectedIndex].view];
}

- (void)initSegmentedControl
{
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"我发起的",@"我参与的", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    _selectedIndex = (int)segmentedControl.selectedSegmentIndex;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)segmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex!=_selectedIndex) {
        [self transitionFromViewController:self.childViewControllers[_selectedIndex] toViewController:self.childViewControllers[sender.selectedSegmentIndex] duration:0.3 options:UIViewAnimationOptionAutoreverse animations:nil completion:^(BOOL finished) {
            _selectedIndex = sender.selectedSegmentIndex;
        }];
    }
}

- (void)leftClick
 {
     [self.navigationController popViewControllerAnimated:YES];
 }

@end

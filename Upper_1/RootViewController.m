//
//  ViewController.m
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "RootViewController.h"
#import "MainController.h"
#import "UPMainMenuController.h"
#import "UPRulesController.h"
#import "XWHttpTool.h"
#import "UUMessage.h"
#import "UserData.h"

#import "UPTools.h"
#import "UPDataManager.h"
#import "NSObject+MJKeyValue.h"

//定义左边菜单栏的宽、高 y
#define LeftMenuW   ScreenWidth*0.65

#define Timer 0.25
//覆盖层按钮的tag
#define buttonTag 1200


#define kYMMainMenuBarItemTag 3000
#define kYMSlideControllerWidth 200
#define kYMSlideMenuItems 6

@interface YMRootViewController()
@end

@implementation YMRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UPMainMenuController *mainMenuVC = [[UPMainMenuController alloc] init];
        self.rootViewController = mainMenuVC;
        self.leftViewController = [[YMSlideViewController alloc] init];
        self.leftViewShowWidth = kYMSlideControllerWidth;
        self.needSwipeShowMenu = YES;
        self.panMovingRightOrLeft = NO;
        g_homeMenu = mainMenuVC;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
}

- (void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)showLeftViewController:(BOOL)animated
{
    [super showLeftViewController:animated];
    [g_homeMenu enterSlideView];
}


- (BOOL)prefersStatusBarHidden

{
    return NO; // 是否隐藏状态栏
}

@end

@interface YMSlideViewController() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIImageView *_logoView;
    
    UIButton *_loginBtn;
    UIButton *_personIcon;
    
    float _menuRowHeight;
}

@end

@implementation YMSlideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuRowHeight = 60;
    if (ScreenHeight<500) {
        _menuRowHeight = 40;
    } else if (ScreenHeight<600) {
        _menuRowHeight = 44;
    }
    
    UIImageView* logoIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoIcon.frame=CGRectMake((kYMSlideControllerWidth-185)/2,40,185,75);

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    imageView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,100+(ScreenHeight-160-kYMSlideMenuItems*_menuRowHeight)/2, kYMSlideControllerWidth, kYMSlideMenuItems*_menuRowHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;

    [self.view addSubview:imageView];
    [self.view addSubview:logoIcon];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kYMSlideMenuItems;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _menuRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    NSArray *menuTitles = @[@"Upper", @"活动大厅", @"发起活动",@"我的好友", @"我的活动", @"活动规则"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.imageView setImage:[UPTools imageWithColor:RGBCOLOR(200, 0, 0) size:CGSizeMake(3, 15)]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = menuTitles[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = kUPThemeNormalFont;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [g_homeMenu switchController:indexPath.row];
    [g_sideController hideSideViewController:YES];
}

@end


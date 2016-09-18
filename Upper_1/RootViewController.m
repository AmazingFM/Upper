//
//  ViewController.m
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "RootViewController.h"
#import "MainController.h"
#import "MessageManager.h"
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

@interface UPRootViewController()

@property (nonatomic, retain) UpLoginController *loginController;
@property (nonatomic, retain) YMRootViewController *mainSideController;
@property (nonatomic, retain) UIViewController *currentVC;

//

@end

@implementation UPRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainController) name:kNotifierLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginController) name:kNotifierLogout object:nil];
    
    [self cityInfoRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)addChildControllers
{
    self.loginController = [[UpLoginController alloc] init];
    [self addChildViewController:self.loginController];
    
    self.mainSideController = [[YMRootViewController alloc] init];
    
    [self addChildViewController:self.mainSideController];
    g_sideController = self.mainSideController;
    
    self.loginController.view.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight-20);
    self.mainSideController.view.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight-20);
    
    if ([UPDataManager shared].isLogin) {
        [self.view addSubview:self.mainSideController.view];
        self.currentVC = self.mainSideController;
    } else {
        [self.view addSubview:self.loginController.view];
        self.currentVC = self.loginController;
    }
}

- (void)showLoginController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginController) name:kNotifierLogout object:nil];
    
    if (self.currentVC!=self.loginController) {
        [self transitionFromViewController:self.currentVC toViewController:self.loginController duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            if (finished) {
                self.currentVC = self.loginController;
            }
        }];
    }
}

- (void)showMainController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainController) name:kNotifierLogin object:nil];
    
    if (self.currentVC!=self.mainSideController) {
        [self transitionFromViewController:self.currentVC toViewController:self.mainSideController duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            if (finished) {
                self.currentVC = self.mainSideController;
            }
        }];
    }
}

-(void)cityInfoRequest
{
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setValue:@"CityQuery" forKey:@"a"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *respData = dict[@"resp_data"];
            
            NSMutableArray *allCities = respData[@"city_list"];
            NSArray<CityItem *> *cityArr = [CityItem objectArrayWithKeyValuesArray:allCities];
            [[UPDataManager shared] initWithCityItems:cityArr];
        }
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@interface YMRootViewController()
{
    MainController *_mainViewController;
}
@end

@implementation YMRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainViewController = [[MainController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
        nav.navigationBar.shadowImage = [[UIImage alloc] init];
        nav.interactivePopGestureRecognizer.enabled = NO;

        self.rootViewController = nav;
        self.leftViewController = [[YMSlideViewController alloc] init];
        self.leftViewShowWidth = kYMSlideControllerWidth;
        self.needSwipeShowMenu = YES;
        
        g_mainMenu = _mainViewController;
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
    NSArray *menuTitles = @[@"Upper", @"活动大厅", @"专家社区", @"发起活动",@"我的位置", @"我的活动"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.imageView setImage:[UPTools imageWithColor:[UIColor redColor] size:CGSizeMake(5, 20)]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = menuTitles[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [g_mainMenu OnAction:nil withType:LEFT_MENU_CHANGE toView:indexPath.row+1 withArg:nil];
    
    
    [g_sideController hideSideViewController:YES];
}
@end


//
//  UpHomeController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "MainController.h"
#import "UpExpertController.h"
#import "UpMyActivityController.h"
#import "UpSettingController.h"
#import "ActivityData.h"
#import "UpRegisterController.h"
#import "LaunchActivityController.h"
#import "NewLaunchActivityController.h"
#import "PersonalCenterController.h"
#import "EnrollPeopleController.h"
#import "UpActDetailController.h"
#import "GetPasswordController.h"
#import "UpperController.h"
#import "UPQRViewController.h"
#import "QRCodeController.h"
#import "ChatController.h"
#import "MessageCenterController.h"

#import "UPActivityAssistantController.h"
#import "UpActView.h"
#import "Info.h"
#import "XWTopMenu.h"
#import "XWHttpTool.h"
#import "UPTheme.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UPCells.h"

#import "UPActivityCell.h"

#import "ActivityData.h"
#import "ActivityItem.h"

#import "UPBaseItem.h"


#import "UPDataManager.h"
#import "XWHttpTool.h"
#import "UPActivityCellItem.h"
#import "ZouMaDengView.h"

#define kActivityPageSize 20
#define kActivityAssitantTag 100
@interface MainController ()<UIGestureRecognizerDelegate,XWTopMenuDelegate, UITableViewDelegate, UITableViewDataSource,UPItemButtonDelegate>
{
    MJRefreshComponent *myRefreshView;
    int pageNum;
    BOOL lastPage;
    NoticeBoard *noticeBoard;
    
    BOOL isLoaded;
}

@property (nonatomic, retain) XWTopMenu *topMenu;
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray<UPActivityCellItem *> *actArray;

//@property (nonatomic, retain) NSMutableArray *listArray;

- (void)leftClick;
- (void)makeAction:(id)sender;
- (void)handleTap:(UITapGestureRecognizer *)sender;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.tag = kActivityAssitantTag;
    [titleButton setTitle:@"活动助手" forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    isLoaded = NO;
    lastPage = NO;
    
    noticeBoard = [[NoticeBoard alloc] initWithFrame:CGRectMake(LeftRightPadding,44, ScreenWidth-LeftRightPadding*2, 17)];
    [noticeBoard setNoticeMessage:@[@"Yeoman Zhang发起了一个活动",@"总冠军狂喜之夜",@"帅哥、美女high翻天"]];
    [self.view addSubview:noticeBoard];
    
    [self addSelectMenu];
    
    [self.view addSubview:self.mainTable];
    [self.view addSubview:self.topMenu];
    
    [self viewWillAppear:YES];

    myActController = [[UpMyActivityViewController alloc]init];
    myActController.parentController = self;
    
    expertController = [[UpExpertController alloc]init];
    expertController.parentController = self;
        
    settingController = [[UpSettingController alloc]init];
    settingController.parentController = self;
    
    registerController = [[UpRegisterController alloc]init];
    registerController.parentController = self;
    
    launchActController = [[LaunchActivityController alloc]init];
    launchActController.parentController = self;
    
    newLaunchActController = [[NewLaunchActivityController alloc]init];
    newLaunchActController.parentController = self;
    
    personalCenterController = [[PersonalCenterController alloc]init];
    personalCenterController.parentController = self;
    
    enrollController = [[EnrollPeopleController alloc]init];
    enrollController.parentController = self;
    
    getPasswordController = [[GetPasswordController alloc]init];
    getPasswordController.parentController = self;
    
    upperController = [[UpperController alloc]init];
    upperController.parentController = self;
    
    qrController = [[UPQRViewController alloc] init];
    qrController.parentController = self;
        
    qrCodeController = [[QRCodeController alloc] init];
    qrCodeController.parentController = self;
    
    msgCenterController = [[MessageCenterController alloc] init];
    msgCenterController.parentController = self;
    
    chatController = [[ChatController alloc] init];
    chatController.parentController = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [noticeBoard startAnimate];
    
    if (![UPDataManager shared].isLogin) {
        //        [self showLogin];
    } else {
        if (!isLoaded) {
            [_mainTable.header beginRefreshing];
            isLoaded = YES;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [noticeBoard stopAnimate];
}

- (UITableView *)mainTable
{
    if (!_mainTable) {
        CGRect bounds = CGRectMake(0, _topMenu.origin.y+_topMenu.height, ScreenWidth, ScreenHeight-_topMenu.origin.y-_topMenu.height-kUPMainStatusBarHeight);
        _mainTable = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
        _mainTable.separatorColor = [UIColor grayColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTable.separatorColor = [UIColor lightGrayColor];
        
        if([_mainTable respondsToSelector:@selector(setSeparatorInset:)]){
            [_mainTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_mainTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        //..下拉刷新
        _mainTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (lastPage) {
                [_mainTable.footer resetNoMoreData];
            }
            lastPage = NO;
            pageNum = 1;
            myRefreshView = _mainTable.header;
            [_mainTable.footer endRefreshing];
            [self loadData];
        }];
        
        //..上拉刷新
        _mainTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            myRefreshView = _mainTable.footer;
            if (!lastPage) {
                pageNum++;
            }
            
            [_mainTable.header endRefreshing];
            [self loadData];
        }];
    }
    return _mainTable;
}

- (NSMutableArray *)actArray
{
    if (_actArray==nil) {
        _actArray = [[NSMutableArray alloc] init];
    }
    return _actArray;
}

#pragma mark - 请求活动列表
- (void)loadData
{
    [self checkNetStatus];
    
    // 上海31， 071， “”
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%d", pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", kActivityPageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:@""forKey:@"activity_class"];
    //    [params setObject:[UPDataManager shared].userInfo.industry_id forKey:@"industry_id"];
    [params setObject:@"4" forKey:@"industry_id"];
    [params setObject:@"" forKey:@"start_begin_time"];
    [params setObject:@"" forKey:@"province_code"];
    [params setObject:@"" forKey:@"city_code"];
    [params setObject:@""forKey:@"town_code"];
    [params setObject:@""forKey:@"creator_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            NSString *resp_desc = dict[@"resp_desc"];
            NSLog(@"%@", resp_desc);
            /***************/
            NSMutableDictionary *pageNav = resp_data[@"page_nav"];
            
            PageItem *pageItem = [[PageItem alloc] init];
            pageItem.current_page = [pageNav[@"current_page"] intValue];
            pageItem.page_size = [pageNav[@"page_size"] intValue];
            pageItem.total_num = [pageNav[@"total_num"] intValue];
            pageItem.total_page = [pageNav[@"total_page"] intValue];
            
            if (pageItem.current_page==pageItem.total_page) {
                lastPage = YES;
            }
            
            
            NSArray *activityList;
            if (pageItem.total_num>0 && pageItem.page_size>0) {
                activityList  = [ActivityData objectArrayWithJsonArray: resp_data[@"activity_list"]];
            }
            
            
            NSMutableArray *arrayM = [NSMutableArray array];
            
            if (activityList!=nil) {
                for (int i=0; i<activityList.count; i++)
                {
                    UPActivityCellItem *actCellItem = [[UPActivityCellItem alloc] init];
                    actCellItem.cellWidth = ScreenWidth;
                    actCellItem.cellHeight = 100;
                    actCellItem.itemData = activityList[i];
                    actCellItem.style = UPItemStyleActNone;
                    [arrayM addObject:actCellItem];
                }
            }
            
            /***************/
            //..下拉刷新
            if (myRefreshView == _mainTable.header) {
                self.actArray = arrayM;
                _mainTable.footer.hidden = lastPage;
                [_mainTable reloadData];
                [myRefreshView endRefreshing];
                
            } else if (myRefreshView == _mainTable.footer) {
                [self.actArray addObjectsFromArray:arrayM];
                [_mainTable reloadData];
                [myRefreshView endRefreshing];
                if (lastPage) {
                    [_mainTable.footer noticeNoMoreData];
                }
            }
        }
        else
        {
            NSLog(@"%@", @"获取失败");
            [myRefreshView endRefreshing];
        }
        
    } failture:^(id error) {
        NSLog(@"%@",error);
        [myRefreshView endRefreshing];
        
    }];
}

-(void)addSelectMenu
{
    NSArray *menuTitleArray = [[NSArray alloc]initWithObjects:@"类型", @"时间", @"区域", nil];
    NSArray *firstArr = [NSArray arrayWithObjects:@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动", @"郊游、徒步", nil];
    NSArray *twoArr = [NSArray arrayWithObjects:@"不限", @"最近1天", @"最近2天", @"最近1周", @"最近1月", nil];
    NSArray *threeArr = [NSArray arrayWithObjects:@"不限", @"上海市", @"北京市", @"广州市", @"深圳市", nil];
    
    NSArray *dataArr = [NSArray arrayWithObjects:firstArr,twoArr,threeArr,nil];
    
    
    XWTopMenu *topMenu=[[XWTopMenu alloc]init];
    topMenu.delegate = self;
    
    CGFloat menuH=selectMenuH;
    CGFloat menuW=ScreenWidth;
    CGFloat menuY=noticeBoard.origin.y+noticeBoard.height+10;
    CGFloat menuX=(ScreenWidth-menuW)*0.5;
    
    topMenu.frame=CGRectMake(menuX, menuY, menuW, menuH);
    topMenu.layer.cornerRadius = 5.0f;
    //    [self.view addSubview:topMenu];
    self.topMenu=topMenu;
    
    [topMenu createMenuTitleArray:menuTitleArray dataSource:dataArr];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    UpActView *actV = (UpActView *)recognizer.view;
    
    NSLog(@"tag:%d\n%@\n%@\n%@\n%@",actV.tag, actV.actTitle, actV.actContent, actV.actLocation, actV.actBeginTime);
    
    [self makeAction:actV];
}

- (void)makeAction:(id)sender
{
    if ([sender isKindOfClass:[UpActView class]]) {
        UpActView *actView = (UpActView *)sender;
        [self.parentController OnAction:self withType:CHANGE_VIEW toView:ACTIVITY_DETAIL_VIEW withArg:actView];
    }
}

#pragma mark 头像下面菜单的点击代理
-(void)topMenu:(XWTopMenu*)topMenu menuType:(NSInteger)menuType andDetailIndex:(NSInteger)detailIndex;
{
    switch (menuType) {
        case 0:
        case 1:
        case 2:
        case 3:
        {
            //
            
        }
            break;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UPActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UPActivityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [cell setActivityItems:(self.actArray[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.actArray[indexPath.row];
    //跳转到详情页面
    UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
    actDetailController.actData = actCellItem.itemData;
    actDetailController.sourceType = SourceTypeDaTing;
    [self.navigationController pushViewController:actDetailController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (BOOL) isStack:(UIViewController *)p
{
    NSArray *array = [self.navigationController viewControllers];
    for (int i=0; i<array.count; i++) {
        if ([array objectAtIndex:i] == p) {
            return YES;
        }
    }
    return NO;
}
- (void) OnAction:(id)mself withType:(ActionType)actionType toView:(ViewType)viewType withArg:(id)arg
{
    switch (actionType) {
        case LEFT_MENU_CHANGE:
        {
            int nIndex = viewType;
            switch (nIndex) {
                case UPPER_VIEW:
                {
                    
                    if ([self isStack:upperController]) {
                        [self.navigationController popToViewController:upperController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:upperController animated:YES];
                    }
                    [upperController setTitle:@"Upper"];
                    break;
                }
                case EXPERT_VIEW:
                {
                    if ([self isStack:expertController]) {
                        [self.navigationController popToViewController:expertController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:expertController animated:YES];
                    }
                    [expertController setTitle:@"专家社区"];
                    break;
                }
                case LAUNCH_ACTIVITY_VIEW:
                {
                    
                    if ([self isStack:newLaunchActController]) {
                        [self.navigationController popToViewController:newLaunchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:newLaunchActController animated:YES];
                    }

                }
                    break;
                case MY_LOCATION_VIEW:
                {
                    if ([self isStack:launchActController]) {
                        [self.navigationController popToViewController:launchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:launchActController animated:YES];
                    }
                }
                    break;
                case MY_ACTIVITY_VIEW:
                {
                    if ([self isStack:myActController]) {
                        [self.navigationController popToViewController:myActController  animated:NO];
                    } else {
                        [self.navigationController pushViewController:myActController animated:YES];
                    }
                }
                    break;
            }
        }
            break;
        case CHANGE_VIEW:
        {
            int nIndex = viewType;
            switch (nIndex) {
                case REGISTER_VIEW:
                {
                    if ([self isStack:registerController]) {
                        [self.navigationController popToViewController:registerController animated:YES];
                    } else {
                        [self.navigationController pushViewController:registerController animated:YES];
                    }
                }
                    break;
                case SETTING_VIEW:
                {
                    if ([self isStack:settingController]) {
                        [self.navigationController popToViewController:settingController animated:YES];
                    }
                    else {
                        [self.navigationController pushViewController:settingController animated:YES];
                    }
                    [settingController setTitle:@"设置"];
                    break;
                }
                case PERSON_CENTER_VIEW:
                {
                    if (arg!=nil) {
                        personalCenterController.index = (int)[(NSString*)arg integerValue];
                    }
                    if ([self isStack:personalCenterController]) {
                        [self.navigationController popToViewController:personalCenterController animated:YES];
                    } else {
                        [self.navigationController pushViewController:personalCenterController animated:YES];
                    }
                }
                    break;
                case ENROLL_PEOPLE_VIEW:
                {
                    if ([self isStack:enrollController]) {
                        [self.navigationController popToViewController:enrollController animated:YES];
                    } else {
                        [self.navigationController pushViewController:enrollController animated:YES];
                    }
                }
                    break;
                case GET_PASSWORD_VIEW:
                {
                    if ([self isStack:getPasswordController]) {
                        [self.navigationController popToViewController:getPasswordController animated:YES];
                    } else {
                        [self.navigationController pushViewController:getPasswordController animated:YES];
                    }
                    break;
                }
                case MYACT_VIEW:
                {
                    if ([self isStack:myActController]) {
                        [self.navigationController popToViewController:myActController animated:YES];
                    }
                    else {
                        [self.navigationController pushViewController:myActController animated:YES];
                    }
                    [myActController setTitle:@"我的活动"];
                    break;
                }
                case QR_VIEW:
                {
                    if ([self isStack:qrController]) {
                        [self.navigationController popToViewController:qrController animated:NO];
                    } else {
                        [self.navigationController pushViewController:qrController animated:YES];
                    }
                    [qrController setTitle:@"我的二维码"];
                }
                    break;
                case QR_SCAN_VIEW:
                {
                    if ([self isStack:qrCodeController]) {
                        [self.navigationController popToViewController:qrCodeController animated:NO];
                    } else {
                        [self.navigationController pushViewController:qrCodeController animated:YES];
                    }
                    [qrCodeController setTitle:@"扫描"];
                }
                    break;
                case LAUNCH_ACTIVITY_VIEW:
                {
                    if ([self isStack:launchActController]) {
                        [self.navigationController popToViewController:launchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:launchActController animated:YES];
                    }
                }
                    break;
                case CHAT_VIEW:
                {
                    if ([self isStack:chatController]) {
                        [self.navigationController popToViewController:chatController animated:YES];
                    } else {
                        [self.navigationController pushViewController:chatController animated:YES];
                    }
                }
                    break;
                case MESSAGE_CENTER_VIEW:
                {
                    if ([self isStack:msgCenterController]) {
                        [self.navigationController popToViewController:msgCenterController animated:YES];
                    } else {
                        [self.navigationController pushViewController:msgCenterController animated:YES];
                    }
                }
                    break;
                case UPPER_VIEW:
                {
                    if ([self isStack:upperController]) {
                        [self.navigationController popToViewController:upperController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:upperController animated:YES];
                    }
                    [upperController setTitle:@"Upper"];
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)rightClick
{
    [self OnAction:self withType:CHANGE_VIEW toView:PERSON_CENTER_VIEW withArg:nil];
}

- (void)onButtonClick:(UIButton *)sender
{
    if (sender.tag == kActivityAssitantTag) {
        UPActivityAssistantController *assistantController = [[UPActivityAssistantController alloc] init];
        assistantController.title = @"活动助手";
        [self.navigationController pushViewController:assistantController animated:YES];
    }
}


@end

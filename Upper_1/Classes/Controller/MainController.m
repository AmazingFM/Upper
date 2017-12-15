//
//  UpHomeController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "MainController.h"
#import "MessageCenterController.h"
#import "UPActivityAssistantController.h"
#import "UPActAsistDetailController.h"
#import "UpActView.h"
#import "Info.h"

#import "XWTopMenu.h"
#import "JSDropDownMenu.h"

#import "XWHttpTool.h"
#import "YMImageButton.h"

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
#import "UIButton+Badge.h"
#import "UIBarButtonItem+Badge.h"
#import "UPConfig.h"
#import "YMNetwork.h"

#import "HTScrollCell.h"
#import "UPTextAlertView.h"

#define kActivityPageSize 20
#define kMainButtonTag 1000

static int kMsgCount = 0;

@interface MainController ()<UIGestureRecognizerDelegate,XWTopMenuDelegate, UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate, HTConfigCellDelegate,UPTextAlertViewDelegate>
{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1RightIndex;
    NSInteger _currentData2RightIndex;

    MJRefreshComponent *myRefreshView;
    int pageNum;
    BOOL lastPage;
    
    BOOL hasLoad;
    
    YMImageButton *msgBtn;
    UIBarButtonItem *messageItem;
    
    HTConfigCollectItem *collectItem;
}

@property (nonatomic, retain) XWTopMenu *topMenu;
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray<UPActivityCellItem *> *actArray;

- (void)leftClick;
- (void)makeAction:(id)sender;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    hasLoad = NO;
    
    [self loadCollectItem];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title;
#ifdef UPPER_DEBUG
    title = @"活动大厅(测试版)";
#elif UPPER_DEBUG_REAL
    title = @"活动大厅(生产版)";
#else
    title = @"活动大厅";
#endif
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    self.navigationItem.rightBarButtonItems = [self rightNavButtonItems];

    lastPage = NO;
    
    
    _currentData1Index = 0;
    _currentData2Index = 0;
    _currentData3Index = 0;
    _currentData1RightIndex = 0;
    _currentData2RightIndex = 0;
    
    [self.view addSubview:self.mainTable];
    
    _data1 = [NSMutableArray new];
    NSDictionary *nolimitOne = @{@"title":@"不限", @"data":@[@"本地",@"全部"]};
    [_data1 addObject:nolimitOne];
    for (ProvinceInfo *provinceInfo in [UPConfig sharedInstance].cityContainer.provinceInfoArr) {
        NSMutableArray *cityNames = [NSMutableArray new];
        [provinceInfo.citylist enumerateObjectsUsingBlock:^(CityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cityNames addObject:obj.city];
        }];
        NSDictionary *menuOne = @{@"title":provinceInfo.province, @"data":cityNames};
        [_data1 addObject:menuOne];
    }

    _data2 = [NSMutableArray new];
    nolimitOne = @{@"title":@"不限", @"data":@[@"不限"]};
    [_data2 addObject:nolimitOne];
    for (ActivityCategory *actCategory in [UPConfig sharedInstance].activityCategoryArr) {
        NSMutableArray *actTypeNames = [NSMutableArray new];
        [actCategory.activityTypeArr enumerateObjectsUsingBlock:^(ActivityType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [actTypeNames addObject:obj.name];
        }];
        NSDictionary *menuOne = @{@"title":actCategory.name, @"data":actTypeNames};
        [_data2 addObject:menuOne];
    }
    
    _data3 = [NSMutableArray new];
    _data3 = [NSMutableArray arrayWithObjects:@"不限时间", @"三天内", @"一周内", @"一个月内", nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, FirstLabelHeight) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(showMessageBadge:) name:kNotifierMessageComing object:nil];
    
    [UPConfig sharedInstance].refreshBlock = ^{
        [self.mainTable reloadData];
    };
    [[UPConfig sharedInstance] requestCityInfo];
}

- (void)loadCollectItem
{
    NSArray *imgArr = @[@"jhsj", @"xqsj", @"zysj"];
    NSArray *titleArr = @[@"聚会社交", @"兴趣社交", @"专业社交"];
    
    if (collectItem==nil) {
        collectItem = [[HTConfigCollectItem alloc] init];
        
        for (int i=0; i<titleArr.count; i++) {
            HTConfigInfoItem *infoItem = [[HTConfigInfoItem alloc] init];
            infoItem.title = titleArr[i];
            infoItem.localImage = imgArr[i];
            [collectItem.subItems addObject:infoItem];
        }
    }
}

- (NSArray *)rightNavButtonItems
{
    msgBtn = [[YMImageButton alloc] initWithFrame:CGRectMake(0,0,35,35)];
    [msgBtn setImage:[UIImage imageNamed:@"message"] andTitle:@"消息"];
    msgBtn.tag = kMainButtonTag;
    [msgBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    YMImageButton *asisBtn = [[YMImageButton alloc] initWithFrame:CGRectMake(0,0,35,35)];
    [asisBtn setImage:[UIImage imageNamed:@"asistant"] andTitle:@"活动助手"];
    asisBtn.tag = kMainButtonTag+1;
    [asisBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    messageItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    UIBarButtonItem *asisItem = [[UIBarButtonItem alloc] initWithCustomView:asisBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width-=15;
    
    return @[spaceItem, messageItem, asisItem];
}

- (void)onButtonClick:(UIButton *)sender
{
    if (sender.tag==kMainButtonTag) { //消息
        [self hideMessageBadge];
        
        MessageCenterController *msgCenterController = [[MessageCenterController alloc] init];
        [self.navigationController pushViewController:msgCenterController animated:YES];
    } else if (sender.tag==kMainButtonTag+1)//活动助手
    {
        UPActivityAssistantController *assistantController = [[UPActivityAssistantController alloc] init];
        assistantController.title = @"活动助手";
        [self.navigationController pushViewController:assistantController animated:YES];
    }
}

- (void)showMessageBadge:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *msgGroupDict = notification.userInfo;
        
        if (msgGroupDict!=nil)
            [messageItem showBadgeAt:26 andY:-3];
        else {
            [self hideMessageBadge];
        }
    });
}

- (void)hideMessageBadge
{
    [messageItem hideBadge];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![UPDataManager shared].isLogin) {
        
    } else {
        if (!hasLoad) {
            [_mainTable.header beginRefreshing];
        }
    }
}

- (void)showAgreementAlert
{
    NSString *title = @"用户协议";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@""];
    NSString *msgContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    UPTextAlertView *alertView = [[UPTextAlertView alloc] initWithTitle:title message:msgContent delegate:self cancelButtonTitle:@"确定"];
    [alertView show];
}

- (void)textAlertView:(UPTextAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"showAgreement"];
    [userDefaults synchronize];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UPConfig sharedInstance].refreshBlock = nil;
}

- (void)refresh {
    [_mainTable.header beginRefreshing];
}

- (UITableView *)mainTable
{
    if (!_mainTable) {
        CGRect bounds = CGRectMake(0, FirstLabelHeight+45, ScreenWidth, ScreenHeight-FirstLabelHeight-45);
        _mainTable = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_mainTable registerClass:[HTScrollCell class] forCellReuseIdentifier:@"scrollCellId"];
        [_mainTable registerClass:[HTActivityCell class] forCellReuseIdentifier:@"activityCellId"];
        
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
            
            [self loadActivityList];
        }];
        
        //..上拉刷新
        _mainTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            myRefreshView = _mainTable.footer;
            if (!lastPage) {
                pageNum++;
            }
            
            [_mainTable.header endRefreshing];
            
            [self loadActivityList];
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

- (void)loadActivityList
{
    NSDictionary *params = [self createParameters];
    [self loadData:params];
}


- (NSDictionary *)createParameters
{
    // 上海31， 071， “”
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%d", pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", kActivityPageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:[UPDataManager shared].userInfo.industry_id forKey:@"industry_id"];
//    [params setObject:@""forKey:@"creator_id"];
    
    //复合条件查询
    if (_currentData1Index==0){
        if (_currentData1RightIndex==0) {
            [params setObject:[UPDataManager shared].userInfo.province_code forKey:@"province_code"];
        } else {
            [params setObject:@"" forKey:@"province_code"];
        }
        [params setObject:@"" forKey:@"city_code"];
        [params setObject:@""forKey:@"town_code"];
    } else {
        ProvinceInfo *provinceInfo = [UPConfig sharedInstance].cityContainer.provinceInfoArr[_currentData1Index-1];
        CityInfo *cityInfo = provinceInfo.citylist[_currentData1RightIndex];
        
        [params setObject:cityInfo.province_code forKey:@"province_code"];
        [params setObject:cityInfo.city_code forKey:@"city_code"];
        [params setObject:cityInfo.town_code forKey:@"town_code"];
    }
    
    if (_currentData2Index==0) {
        [params setObject:@""forKey:@"activity_class"];
    } else {
        ActivityCategory *activityCategory = [UPConfig sharedInstance].activityCategoryArr[_currentData2Index-1];
        ActivityType *activityType = activityCategory.activityTypeArr[_currentData2RightIndex];
        
        [params setObject:activityType.ID forKey:@"activity_class"];
    }
    
    if (_currentData3Index==0) {
        [params setObject:@"" forKey:@"start_begin_time"];
    } else {
        //@"不限时间", @"三天内", @"一周内", @"一个月内"
        NSDate *startDate = [NSDate date];
        NSString *startTime = [UPTools dateString:startDate withFormat:@"yyyyMMddHHmmss"];
        
        int intervalDays = 1;
        if (_currentData3Index==1) {
            intervalDays = 3;
        } else if (_currentData3Index==2) {
            intervalDays = 7;
        } else if (_currentData3Index==3) {
            intervalDays = 30;
        }
        NSDate *endDate = [startDate dateByAddingTimeInterval:24*3600*intervalDays];
        
        NSString *endTime = [UPTools dateString:endDate withFormat:@"yyyyMMddHHmmss"];
        
        [params setObject:startTime forKey:@"start_begin_time"];
        [params setObject:endTime forKey:@"start_end_time"];
    }
    
    return params;
}

- (void)loadData:(NSDictionary *)params
{
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
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
                    actCellItem.cellHeight = 30*2+60+10;
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
            
            hasLoad = YES;
        }
        else
        {
            [myRefreshView endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [myRefreshView endRefreshing];
        
    }];
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
        }
            break;
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-10, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = kUPThemeSmallFont;
    label.textColor = [UIColor grayColor];
    
    if (section==0) {
        label.text = @"热门类型";
    } else if (section==1) {
        label.text = @"最新活动";
    }
    [bgView addSubview:label];
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    } else {
        return self.actArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return kImageButtonHeight;
    } else if (indexPath.section==1) {
        UPActivityCellItem *item = self.actArray[indexPath.row];
        return item.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    if (indexPath.section==0) {
        HTScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scrollCellId"];
        cell.delegate = self;
        [cell setConfigItem:collectItem];

        tableCell = cell;
    } else if (indexPath.section==1) {
        HTActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCellId"];
        [cell setActivityItems:(self.actArray[indexPath.row])];
        
        tableCell = cell;
    }
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.actArray[indexPath.row];
    //跳转到详情页面
    UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
    actDetailController.actData = actCellItem.itemData;
    actDetailController.sourceType = SourceTypeDaTing;
    actDetailController.preController = self;
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

#pragma mark JSDropDownMenuDatasource, JSDropDownMenuDelegate

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column==0) {
        if (leftOrRight==0) {
            return _data1.count;
        } else {
            NSDictionary *menuDict = [_data1 objectAtIndex:leftRow];
            return [[menuDict objectForKey:@"data"] count];
        }
    } else if (column==1) {
        if (leftOrRight==0) {
            return _data2.count;
        } else {
            NSDictionary *menuDict = [_data2 objectAtIndex:leftRow];
            return [[menuDict objectForKey:@"data"] count];
        }
    } else if (column==2) {
        return _data3.count;
    }
    return 0;
}



- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data2 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else {
        return _data3[indexPath.row];
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column atIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else {
            if (indexPath.leftRow==0 && indexPath.row==0) {
                return @"城市";
            }
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data2 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else {
            if (indexPath.leftRow==0 && indexPath.row==0) {
                return @"活动类型";
            }

            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else {
        if (indexPath.row==0){
            return @"时间";
        }
        
        return _data3[indexPath.row];
    }}
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    if (column==0 || column==1) {
        return 0.3;
    }
    return 1;
}

/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    if (column==0 ||column==1) {
        return YES;
    }
    
    return NO;
}

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    if (column==0) {
        return _currentData1Index;
    }
    
    if (column==1) {
        return _currentData2Index;
    }
    
    return 0;
}

//default value is 1
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return 3;
}

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    if (column==2) {
        return YES;
    }
    
    return NO;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            _currentData1Index = indexPath.row;
            return;
        } else {
            _currentData1RightIndex = indexPath.row;
        }
    } else if(indexPath.column == 1){
        if(indexPath.leftOrRight==0){
            _currentData2Index = indexPath.row;
            return;
        } else {
            _currentData2RightIndex = indexPath.row;
        }
    } else{
        _currentData3Index = indexPath.row;
    }
    
    [self.mainTable.header beginRefreshing];//刷新
}

#pragma mark HTConfigCellDelegate
-(void)configItemSelected:(HTConfigItem*)item
{
//    NSMutableArray *itemsArr = [[NSMutableArray alloc] initWithCapacity:3];
//    
//    NSDictionary *actDict = [UPTools loadBundleFile:@"introduce.json"];
//    
//    for (NSString *key in @[@"jhsj", @"xqsj", @"zysj"]) {
//        NSArray *tmpArr = actDict[key];
//        NSMutableArray *infoItemArr = [NSMutableArray new];
//        for (NSDictionary *dict in tmpArr) {
//            UPInfoCellItem *item = [UPInfoCellItem new];
//            item.title = dict[@"name"];
//            item.detail = dict[@"desc"];
//            
//            NSString *place = [NSString stringWithFormat:@"推荐场所：%@", dict[@"place"]];
//            NSString *tips = [NSString stringWithFormat:@"小贴士：%@",dict[@"tips"]];
//            item.tips = [NSString stringWithFormat:@"%@\n%@", tips, place];
//            
//            [infoItemArr addObject:item];
//        }
//        [itemsArr addObject:infoItemArr];
//    }
    UPActAsistDetailController *detailVC;
    
    HTConfigInfoItem *infoItem = (HTConfigInfoItem *)item;
    
    UPActType type;
    if ([infoItem.title isEqualToString:@"聚会社交"]) {
        type = UPActTypeJuhui;
    } else if ([infoItem.title isEqualToString:@"兴趣社交"]) {
        type = UPActTypeXinqu;
    } else if ([infoItem.title isEqualToString:@"专业社交"]) {
        type = UPActTypeZhuanye;
    }
    detailVC= [[UPActAsistDetailController alloc] initWithType:type];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end

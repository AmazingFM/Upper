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
#import "UpActView.h"
#import "Info.h"
#import "XWTopMenu.h"
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
#import "UIBarButtonItem+Badge.h"

#import "YMNetwork.h"
#define kActivityPageSize 20
#define kMainButtonTag 1000

static int kMsgCount = 0;

@interface MainController ()<UIGestureRecognizerDelegate,XWTopMenuDelegate, UITableViewDelegate, UITableViewDataSource,UPItemButtonDelegate>
{
    MJRefreshComponent *myRefreshView;
    int pageNum;
    BOOL lastPage;
    NoticeBoard *noticeBoard;
    
    BOOL isLoaded;
    
    UIBarButtonItem *messageItem;
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
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    messageItem = [UIBarButtonItem itemWithRightIcon:@"" highIcon:nil target:self action:@selector(jumpToMessage)];
    messageItem.badgeValue = kMsgCount==0?@"":[NSString stringWithFormat:@"%d", kMsgCount];
    messageItem.badgeBGColor = [UIColor redColor];
    messageItem.badgeOriginX=25;
    messageItem.badgeOriginY=5;
    self.navigationItem.rightBarButtonItem=messageItem;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setTitle:@"活动大厅" forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    self.navigationItem.rightBarButtonItems = [self rightNavButtonItems];
    
    isLoaded = NO;
    lastPage = NO;
    
    noticeBoard = [[NoticeBoard alloc] initWithFrame:CGRectMake(LeftRightPadding,FirstLabelHeight, ScreenWidth-LeftRightPadding*2, 17)];
    [noticeBoard setNoticeMessage:@[@"Yeoman Zhang发起了一个活动",@"总冠军狂喜之夜",@"帅哥、美女high翻天"]];
    [self.view addSubview:noticeBoard];
    
    [self addSelectMenu];
    
    [self.view addSubview:self.mainTable];
    [self.view addSubview:self.topMenu];
    
    [self viewWillAppear:YES];
}

- (NSArray *)rightNavButtonItems
{
    YMImageButton *msgBtn = [[YMImageButton alloc] initWithFrame:CGRectMake(0,0,35,35)];
    [msgBtn setImage:[UIImage imageNamed:@"message"] andTitle:@"消息"];
    msgBtn.tag = kMainButtonTag;
    [msgBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    YMImageButton *asisBtn = [[YMImageButton alloc] initWithFrame:CGRectMake(0,0,35,35)];
    [asisBtn setImage:[UIImage imageNamed:@"asistant"] andTitle:@"活动助手"];
    asisBtn.tag = kMainButtonTag+1;
    [asisBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    UIBarButtonItem *asisItem = [[UIBarButtonItem alloc] initWithCustomView:asisBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width-=15;
    
    return @[spaceItem, msgItem, asisItem];
}

- (void)onButtonClick:(UIButton *)sender
{
    if (sender.tag==kMainButtonTag) { //消息
        MessageCenterController *msgCenterController = [[MessageCenterController alloc] init];
        [self.navigationController pushViewController:msgCenterController animated:YES];
    } else if (sender.tag==kMainButtonTag+1)//活动助手
    {
        UPActivityAssistantController *assistantController = [[UPActivityAssistantController alloc] init];
        assistantController.title = @"活动助手";
        [self.navigationController pushViewController:assistantController animated:YES];
    }
}

- (void)addBadgeValue:(NSNotification *)notification
{
    NSArray *msgArr = notification.object;
    long addCount = msgArr.count;
    kMsgCount += addCount;
    
    messageItem.badgeValue = [NSString stringWithFormat:@"%d", kMsgCount];
}

- (void)setBadgeValue:(int)newValue
{
    messageItem.badgeValue = newValue==0?@"":[NSString stringWithFormat:@"%d", newValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [noticeBoard startAnimate];
    
    if (![UPDataManager shared].isLogin) {
//                [self showLogin];
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
        CGRect bounds = CGRectMake(0, _topMenu.origin.y+_topMenu.height, ScreenWidth, ScreenHeight-_topMenu.origin.y-_topMenu.height);
        _mainTable = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
        _mainTable.separatorColor = [UIColor grayColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTable.separatorColor = [UIColor lightGrayColor];
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
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
    [params setObject:@"4" forKey:@"industry_id"];
    [params setObject:@"" forKey:@"start_begin_time"];
    [params setObject:@"" forKey:@"province_code"];
    [params setObject:@"" forKey:@"city_code"];
    [params setObject:@""forKey:@"town_code"];
    [params setObject:@""forKey:@"creator_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [[YMHttpNetwork sharedNetwork] GET:kUPBaseURL parameters:params success:^(id json) {
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
        
    } failure:^(NSError *error) {
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
@end

//
//  UPMyFriendsViewController.m
//  Upper
//
//  Created by 张永明 on 16/10/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMyFriendsViewController.h"
#import "UPAddFriendViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UPBaseItem.h"

#define kActivityPageSize 20

@implementation UPFriendItem

@end
@interface UPMyFriendsViewController() <UITableViewDelegate, UITableViewDataSource>
{
    MJRefreshComponent *myRefreshView;
    int pageNum;
    BOOL lastPage;
    
    UILabel *tipsLabel;
}
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray *friendlist;
@end

@implementation UPMyFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的好友";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:nil target:self action:@selector(leftClick)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.view addSubview:self.mainTable];
    
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    searchBtn.frame=CGRectMake(0, 0, 35, 35);
    UIImage *image = [UIImage imageNamed:@"add"];
    UIImage *stretchableButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [searchBtn setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:searchBtn];

    tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 100)];
    tipsLabel.text = @"暂无好友";
    tipsLabel.hidden = YES;
    tipsLabel.font = [UIFont systemFontOfSize:20.f];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tipsLabel];
    tipsLabel.centerY = self.view.height/2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mainTable.header beginRefreshing];
}

- (void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)addFriendAction
{
    UPAddFriendViewController *addFriend = [[UPAddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFriend animated:YES];
}

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
        _mainTable.separatorColor = [UIColor grayColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTable.separatorColor = [UIColor lightGrayColor];
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, CGFLOAT_MIN)];
        
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

- (NSMutableArray *)friendlist
{
    if (_friendlist==nil) {
        _friendlist = [[NSMutableArray alloc] init];
    }
    return _friendlist;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPFriendItem *item = self.friendlist[indexPath.row];
    
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:item.user_icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *detailImg = [UIImage imageWithData:_decodedImageData];

    cell.imageView.image = detailImg;
    
    cell.textLabel.text = item.nick_name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - 请求活动列表
- (void)loadData
{
    [self checkNetStatus];
    
    // 上海31， 071， “”
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"FriendsList"forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%d", pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", kActivityPageSize] forKey:@"page_size"];
    
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            
            if (resp_data) {
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
                
                NSArray *arrayM = [UPFriendItem objectArrayWithJsonArray:resp_data[@"friends_list"]];
                
                /***************/
                //..下拉刷新
                if (myRefreshView == _mainTable.header) {
                    [self.friendlist removeAllObjects];
                    [self.friendlist addObjectsFromArray:arrayM];
                    _mainTable.footer.hidden = lastPage;
                    [_mainTable reloadData];
                    [myRefreshView endRefreshing];
                    
                } else if (myRefreshView == _mainTable.footer) {
                    [self.friendlist addObjectsFromArray:arrayM];
                    [_mainTable reloadData];
                    [myRefreshView endRefreshing];
                    if (lastPage) {
                        [_mainTable.footer noticeNoMoreData];
                    }
                }
                self.mainTable.hidden = NO;
                tipsLabel.hidden = YES;
            } else {
                [myRefreshView endRefreshing];
                self.mainTable.hidden = YES;
                tipsLabel.hidden = NO;
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

@end

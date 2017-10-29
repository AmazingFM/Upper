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

#import "UPChatViewController.h"
#import "PrivateMessage.h"
#import "UPFriendItem.h"
#import "YMNetwork.h"
#import "UIImageView+WebCache.h"
#import "PersonalCenterController.h"


#define kDescHeight 44

@interface UPMyFriendsViewController() <UITableViewDelegate, UITableViewDataSource, UPAddFriendDelegate>
{
    MJRefreshComponent *myRefreshView;
    int pageNum;
    BOOL lastPage;
    
    UILabel *tipsLabel;
    
    UIButton *addFriendButton;
    BOOL hasLoad;
}
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray *friendlist;
@property (nonatomic, retain) NSMutableArray<NSMutableArray *> *friendGroups;


@end

@implementation UPMyFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasLoad = NO;
    self.navigationItem.title = @"我的好友";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:nil target:self action:@selector(leftClick)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.view addSubview:self.mainTable];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,ScreenHeight-FirstLabelHeight-kDescHeight,ScreenWidth-20, kDescHeight)];
    descLabel.text = @"可以在活动现场通过扫描对方用户二维码来添加";
    descLabel.font = [UIFont systemFontOfSize:15.f];
    descLabel.adjustsFontSizeToFitWidth = YES;
    descLabel.minimumScaleFactor = 0.6;
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:descLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-FirstLabelHeight-kDescHeight+1, ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayColor];
    [backView addSubview:lineView];
    
    addFriendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    addFriendButton.frame=CGRectMake(0, 0, 35, 35);
    UIImage *image = [UIImage imageNamed:@"add"];
    UIImage *stretchableButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [addFriendButton setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [addFriendButton addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:addFriendButton];

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
    addFriendButton.enabled = YES;
    if (!hasLoad) {
        [self.mainTable.header beginRefreshing];
    }
}

- (void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)addFriendAction:(UIButton *)sender
{
    sender.enabled = NO;
    
    UPAddFriendViewController *addFriend = [[UPAddFriendViewController alloc] init];
    addFriend.delegate = self;
    [self.navigationController pushViewController:addFriend animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    addFriendButton.enabled = YES;
}

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight-kDescHeight) style:UITableViewStylePlain];
        _mainTable.separatorColor = [UIColor grayColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTable.separatorColor = kUPThemeLineColor;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, CGFLOAT_MIN)];
        
        UIEdgeInsets separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _mainTable.separatorInset = separatorInsets;
        
        if ([_mainTable respondsToSelector:@selector(setLayoutMargins:)]) {
            _mainTable.layoutMargins = separatorInsets;
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

- (NSMutableArray *)friendlist
{
    if (_friendlist==nil) {
        _friendlist = [[NSMutableArray alloc] init];
    }
    return _friendlist;
}

- (NSMutableArray<NSMutableArray *> *)friendGroups
{
    if (_friendGroups==nil) {
        _friendGroups = [[NSMutableArray alloc] initWithCapacity:2];
        
        NSMutableArray *group1 = [NSMutableArray new];
        NSMutableArray *group2 = [NSMutableArray new];
        [_friendGroups addObject:group1];
        [_friendGroups addObject:group2];
    }
    return _friendGroups;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30.0)];
    view.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30.0)];
    groupLabel.backgroundColor = [UIColor clearColor];
    groupLabel.text = section==0?@"好友":@"黑名单";
    groupLabel.font = kUPThemeSmallFont;
    
    [view addSubview:groupLabel];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friendGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<self.friendGroups.count) {
        NSMutableArray *friendGroup = self.friendGroups[section];
        if (friendGroup.count==0) {
            return 1;
        } else {
            return friendGroup.count;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *friendGroup = self.friendGroups[indexPath.section];
    if (friendGroup.count==0) {
        NSString *cellId = @"noFriendID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        if (indexPath.section==0) {
            cell.textLabel.text = @"您暂时还没有好友哦，快去添加吧~";
        } else{
            cell.textLabel.text = @"黑名单为空";
        }
        return cell;
    } else {
        
        UPFriendItem *item = friendGroup[indexPath.row];
        
        NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.user_icon] placeholderImage:[UIImage imageNamed:@"activity_user_icon"]];
        
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.textLabel.text = item.nick_name;
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIEdgeInsets separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    cell.separatorInset = separatorInsets;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = separatorInsets;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPFriendItem *friend = self.friendlist[indexPath.row];

    PersonalCenterController *personalCenter = [[PersonalCenterController alloc] init];
    personalCenter.index = 0;
    personalCenter.user_id = friend.relation_id;
    personalCenter.nick_name = friend.nick_name;
    personalCenter.user_icon = friend.user_icon;
    [self.navigationController pushViewController:personalCenter animated:YES];
}

#pragma mark - 请求活动列表
- (void)loadData
{
    [self checkNetStatus];
    
    // 上海31， 071， “”
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"FriendsList"forKey:@"a"];
    [params setObject:@"1"forKey:@"is_sys"];
    [params setObject:[NSString stringWithFormat:@"%d", pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", kActivityPageSize] forKey:@"page_size"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
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
                    [myRefreshView endRefreshing];
                    
                } else if (myRefreshView == _mainTable.footer) {
                    [self.friendlist addObjectsFromArray:arrayM];
                    [myRefreshView endRefreshing];
                    if (lastPage) {
                        [_mainTable.footer noticeNoMoreData];
                    }
                }
                
                [self reloadFriendList];
                
                self.mainTable.hidden = NO;
                tipsLabel.hidden = YES;
                
            } else {
                [myRefreshView endRefreshing];
                self.mainTable.hidden = YES;
                tipsLabel.hidden = NO;
            }
            
            hasLoad = YES;
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

- (void)reloadFriendList
{
    for (NSMutableArray *friendGroup in self.friendGroups) {
        [friendGroup removeAllObjects];
    }
    
    for (int i=0; i<self.friendlist.count; i++) {
        UPFriendItem *friendItem = self.friendlist[i];
        
        switch ([friendItem.group intValue]) {
            case 0:
            {
                [self.friendGroups[0] addObject:friendItem];
            }
                break;
            case 9: //黑名单
            {
                [self.friendGroups[1] addObject:friendItem];
                break;
            }
            default:
                break;
        }
    }
    
    [_mainTable reloadData];
}

#pragma mark UPAddFriendDelegate
- (void)addFriendSuccess
{
    [self.mainTable.header beginRefreshing];//刷新
}
@end

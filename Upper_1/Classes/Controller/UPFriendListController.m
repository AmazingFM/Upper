//
//  UPInviteFriendController.m
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPFriendListController.h"
#import "UPFriendItem.h"
#import "UPBaseItem.h"
#import "YMNetwork.h"

@interface UPFriendListController () <UITableViewDelegate, UITableViewDataSource>
{
    int pageNum;
    BOOL lastPage;
    
    NSMutableArray *selectStatus;
    NSInteger index;
}
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray<UPFriendItem *> *friendlist;

@end

@implementation UPFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type==0) {
        self.navigationItem.title = @"邀请好友";
    } else if (self.type==1) {
        self.navigationItem.title = @"参与者";
    }
    index = -1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    selectStatus = [NSMutableArray new];
    _friendlist = [NSMutableArray new];
    
    self.navigationItem.rightBarButtonItem = createBarItemTitle(@"取消",self, @selector(dismiss));

    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight,ScreenWidth, ScreenHeight-FirstLabelHeight-10-44) style:UITableViewStylePlain];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.showsHorizontalScrollIndicator = NO;
    _mainTable.tableFooterView = [[UIView alloc] init];
    _mainTable.allowsMultipleSelection = (self.type==0)?YES:NO;
    _mainTable.backgroundColor = [UIColor clearColor];
    
    UIButton *confirm = [[UIButton alloc]init];
    [confirm setSize:CGSizeMake(ScreenWidth/2, 40)];
    [confirm setCenter:CGPointMake(ScreenWidth/2, ScreenHeight-22)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    confirm.layer.cornerRadius = 5.f;
    confirm.layer.masksToBounds = YES;
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor redColor];
    confirm.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_mainTable];
    [self.view addSubview:confirm];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.type==0) {
        [self loadFriends];
    } else if (self.type==1) {
        [self loadAnticipator];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSelectStatus
{
    for (int i=0; i<self.friendlist.count; i++) {
        [selectStatus addObject:@(NO)];
    }
}

- (void)confirm:(UIButton *)sender
{
    if (self.type==0) {
        NSMutableArray *selectedFriends = [NSMutableArray new];
        for (int i=0; i<selectStatus.count; i++) {
            if ([selectStatus[i] boolValue]) {
                [selectedFriends addObject:self.friendlist[i].relation_id];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFriends:)]) {
            [self.delegate inviteFriends:selectedFriends];
        }
    } else if (self.type==1) {
        if (index!=-1) {
            UPFriendItem *item = self.friendlist[index];
//            NSString *userID = item.relation_id;
            if (self.delegate && [self.delegate respondsToSelector:@selector(changeLauncher:)]) {
                [self.delegate changeLauncher:item];
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView delegate UITableViewDatasource
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
        cell.tintColor = [UIColor redColor];
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
    
    if ([selectStatus[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    selectStatus[indexPath.row] = @(YES);
    index = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    selectStatus[indexPath.row] = @(NO);
}

- (void)loadFriends
{
    lastPage = NO;
    pageNum = 1;

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
                [self.friendlist addObjectsFromArray:arrayM];
                [_mainTable reloadData];
                
                [self initSelectStatus];
            }
        }
        else
        {
            NSLog(@"%@", @"获取失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadAnticipator
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityJoinInfo"forKey:@"a"];
    
    [params setObject:self.activityId forKey:@"activity_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        NSString *resp_desc = dict[@"resp_desc"];
        
        NSLog(@"%@:%@", resp_id, resp_desc);
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            int totalCount = [resp_data[@"total_count"] intValue];
            if (totalCount>0) {
                NSString *userList = resp_data[@"user_list"];
                
                [self.friendlist removeAllObjects];
                
                if ([userList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *userDict in (NSArray *)userList) {
                        UPFriendItem *user = [[UPFriendItem alloc] init];
                        user.relation_id = userDict[@"user_id"];
                        user.nick_name = userDict[@"nick_name"];
                        user.sexual = userDict[@"sexual"];
                        user.user_icon = userDict[@"user_icon"];
                        
                        [self.friendlist addObject:user];
                    }
                }
                [_mainTable reloadData];
                [self initSelectStatus];
            } else{
                //目前还没有参与者
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该活动目前无人参加，赶紧报名吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end

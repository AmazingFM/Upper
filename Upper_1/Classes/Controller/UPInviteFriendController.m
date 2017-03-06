//
//  UPInviteFriendController.m
//  Upper
//
//  Created by 张永明 on 2017/3/6.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPInviteFriendController.h"
#import "UPFriendItem.h"
#import "UPBaseItem.h"

@interface UPInviteFriendController () <UITableViewDelegate, UITableViewDataSource>
{
    int pageNum;
    BOOL lastPage;
    
    NSMutableArray *selectStatus;
}
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray<UPFriendItem *> *friendlist;
@end

@implementation UPInviteFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请好友";
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
    _mainTable.allowsMultipleSelection = YES;
    _mainTable.backgroundColor = [UIColor clearColor];
    
    UIButton *confirm = [[UIButton alloc]init];
    [confirm setSize:CGSizeMake(ScreenWidth/2-90, 44)];
    [confirm setCenter:CGPointMake(ScreenWidth/2, ScreenHeight-22)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor clearColor];
    confirm.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_mainTable];
    [self.view addSubview:confirm];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
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
    NSMutableArray *selectedFriends = [NSMutableArray new];
    for (int i=0; i<selectStatus.count; i++) {
        if ([selectStatus[i] boolValue]) {
            [selectedFriends addObject:self.friendlist[i]];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFriends:)]) {
        [self.delegate inviteFriends:selectedFriends];
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
    
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:item.user_icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *detailImg = [UIImage imageWithData:_decodedImageData];
    
    cell.imageView.image = detailImg;
    
    cell.textLabel.text = item.nick_name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    selectStatus[indexPath.row] = @(NO);
}

- (void)loadData
{
    lastPage = NO;
    pageNum = 1;

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
                [self.friendlist addObjectsFromArray:arrayM];
                [_mainTable reloadData];
                
                [self initSelectStatus];
            }
        }
        else
        {
            NSLog(@"%@", @"获取失败");
        }
        
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];
}

@end

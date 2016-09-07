//
//  UPRefreshTableViewController.m
//  Upper
//
//  Created by freshment on 16/7/2.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPRefreshTableViewController.h"
#import "UPActivityCell.h"

@interface UPRefreshTableViewController () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isLoaded;
}
@end

@implementation UPRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.lastPage = NO;
    isLoaded = NO;
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = [UIColor clearColor];
    _mainTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _mainTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    [self.view addSubview:_mainTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isLoaded) {
        [self refresh];
    }
}

- (void)refresh
{
    self.myRefreshView = self.mainTable.header;
    
    if (self.lastPage) {
        [self.mainTable.footer resetNoMoreData];
    }
    self.lastPage = NO;
    self.pageNum = 1;
    [self startRequest];
}

- (void)startRequest {}

- (void)loadMoreData{}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
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
    } else {
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    
    [cell setActivityItems:(self.itemArray[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.itemArray[indexPath.row];
//    //跳转到详情页面
//    UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
//    actDetailController.actData = actCellItem.itemData;
//    actDetailController.style = actCellItem.style;
//    [((UPBaseViewController *)self.parentController).navigationController pushViewController:actDetailController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

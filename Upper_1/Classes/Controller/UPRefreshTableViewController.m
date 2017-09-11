//
//  UPRefreshTableViewController.m
//  Upper
//
//  Created by freshment on 16/7/2.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPRefreshTableViewController.h"

@interface UPRefreshTableViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation UPRefreshTableViewController

- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.lastPage = NO;
    self.hasLoad = NO;
    
    _tipsLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipsLabel.size = CGSizeMake(100, 44);
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.font = kUPThemeBigFont;
    _tipsLabel.textColor = [UIColor blackColor];
    _tipsLabel.text = @"没有活动";
    _tipsLabel.hidden = YES;
//    [self.view addSubview:_tipsLabel];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    _mainTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _mainTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:_mainTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.hasLoad) {
        [self refresh];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _mainTable.frame = CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height);
    _tipsLabel.center = _mainTable.center;
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
    if (self.itemArray==nil ||
        self.itemArray.count==0) {
        _tipsLabel.hidden = NO;
    } else {
        _tipsLabel.hidden = YES;
    }
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *item = self.itemArray[indexPath.row];
    return item.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    HTActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HTActivityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
//    else {
//        for (UIView *view in [cell.contentView subviews]) {
//            [view removeFromSuperview];
//        }
//    }
    
    [cell setActivityItems:(self.itemArray[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.itemArray[indexPath.row];
    if (self.clickBlock) {
        self.clickBlock(actCellItem);
    }
}

@end

//
//  UpSettingController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//
#import "UpSettingController.h"
#import "CRNavigationBar.h"

@interface UpSettingController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *itemList;
    
    UITableView *mainTable;
}
@end

@implementation UpSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@(%@)", infoDict[@"CFBundleShortVersionString"],infoDict[@"CFBundleVersion"]] ;
    
#ifdef UPPER_DEBUG
    version = [NSString stringWithFormat:@"测试版%@", version];
#endif
    
    [itemList addObject:@{@"title":@"版本", @"value":version}];
}

- (void)initialize
{
    itemList = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor = [UIColor whiteColor];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = kUPThemeMainColor;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    NSDictionary *item = itemList[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.text = item[@"value"];
    cell.detailTextLabel.font = kUPThemeSmallFont;
    
    return cell;
}
@end

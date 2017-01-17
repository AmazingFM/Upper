//
//  UPLaunchActivityControllerViewController.m
//  Upper
//
//  Created by 张永明 on 2017/1/12.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPLaunchActivityController.h"
#import "UPGlobals.h"

@interface UPLaunchActivityController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *cellIDs;
}

@property (nonatomic, retain) UITableView *tableView;

@end


@implementation UPLaunchActivityController

- (instancetype)init{
    self = [super init];
    if (self) {
        cellIDs = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [self barBtnWithIcon:@""];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellIDs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDs[indexPath.row]];
    if (cell==nil) {
        NSString *cellId = cellIDs[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        

    }
    
    return cell;
}

- (UIBarButtonItem *)barBtnWithIcon:(NSString *)iconName
{
    UIBarButtonItem* barItem=nil;//
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0,0,32,32);
    [btn addTarget:self action:@selector(showSideController) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

- (void)showSideController
{
    [g_sideController showLeftViewController:YES];
}
@end

//
//  UPRefreshTableViewController.m
//  Upper
//
//  Created by freshment on 16/7/2.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPRefreshTableViewController.h"

#import "UPCommentController.h"

@interface UPRefreshTableViewController () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isLoaded;
    
    UILabel *_tipsLabel;
}
@end

@implementation UPRefreshTableViewController

- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.lastPage = NO;
    isLoaded = NO;
    
    _tipsLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.font = kUPThemeBigFont;
    _tipsLabel.textColor = [UIColor blackColor];
    _tipsLabel.text = @"没有活动";
    _tipsLabel.hidden = YES;
    [self.view addSubview:_tipsLabel];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _mainTable.frame = self.view.bounds;
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
        cell.delegate = self;
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

-(void)onButtonSelected:(UPActivityCellItem *)cellItem withType:(int)type
{
    if (type==kUPActReviewTag) {
        //发布回顾
        UPCommentController *commentController = [[UPCommentController alloc]init];
        commentController.actID = cellItem.itemData.ID;
        commentController.title=@"我要回顾";
        commentController.type = 0;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
        //2.设置导航栏barButton上面文字的颜色
        UIBarButtonItem *item=[UIBarButtonItem appearance];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [nav.navigationBar setTranslucent:YES];
        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (type==kUPActCommentTag) {
        //发布评论
        UPCommentController *commentController = [[UPCommentController alloc]init];
        commentController.actID = cellItem.itemData.ID;
        commentController.title=@"我要评论";
        commentController.type = 1;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
        //2.设置导航栏barButton上面文字的颜色
        UIBarButtonItem *item=[UIBarButtonItem appearance];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [nav.navigationBar setTranslucent:YES];
        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:nav animated:YES completion:nil];

    }
}

@end

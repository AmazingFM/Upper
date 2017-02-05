//
//  UPRulesController.m
//  Upper
//
//  Created by 张永明 on 2017/2/3.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRulesController.h"
#import "UPGlobals.h"
#import "UPTools.h"

@interface UPRulesController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *contentArr;
    NSMutableArray *titleArr;
}
@property (nonatomic, retain) UITableView *mainTable;
@end

@implementation UPRulesController

- (instancetype)init
{
    self = [super init];
    if (self) {
        contentArr = [NSMutableArray new];
        titleArr = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动规则";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    
    [titleArr addObject:@"取消规则"];
    [titleArr addObject:@"退出规则"];
    [titleArr addObject:@"投诉和缺席"];
    
    NSString *rule1 = @"    1、募集中的活动，随时可取消，一年内满十次，封停账号一个月（不可发起 可参与）；\
    \n    2、募集成功的活动，如果发起者不能参加，建议先尝试寻找接替的发起人，将活动发起者身份转交给新的发起人。无法找到接替者也可以取消，一年满3次，封停账号半年； \
    \n    3、可以点击“更改发起人”按钮，向目前报名人员发送站内信，发送接受链接。可以在发送之前通过站内短信和参与人员沟通接收意向。\n";
    
    NSString *rule2 = @"    1、募集中的活动，参与者随时可退出，一年内满十次，封停账号一个月（不可发起 不可参与）；\
    \n    2、成功的活动，参与者随时可退出，一年满三次，封停账号3个月。\n";
    
    NSString *rule3 = @"    发起者未出现，任一参与者三天内可投诉，提供现场照片，人工确认后，永久封号参与者缺席，系统记录未签到状态。缺席两次则封停账号3个月。\n";
    
    [contentArr addObject:rule1];
    [contentArr addObject:rule2];
    [contentArr addObject:rule3];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.bounces = NO;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_mainTable];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, 30.f)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, ScreenWidth-LeftRightPadding, 30.f)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    titleLabel.text = titleArr[section];
    
    [bgView addSubview:titleLabel];
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *curRule = contentArr[indexPath.section];
    
    CGSize size = [UPTools sizeOfString:curRule withWidth:ScreenWidth-3*LeftRightPadding font:[UIFont systemFontOfSize:17.f]];
    
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *ruleLabel = [cell viewWithTag:100];
    if (ruleLabel==nil) {
        ruleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        ruleLabel.textAlignment = NSTextAlignmentLeft;
        ruleLabel.textColor = [UIColor blackColor];
        ruleLabel.font = [UIFont systemFontOfSize:17.f];
        ruleLabel.numberOfLines = 0;
        ruleLabel.tag = 100;
        [cell addSubview:ruleLabel];
    }
    ruleLabel.text = contentArr[indexPath.section];
    ruleLabel.frame = CGRectMake(2*LeftRightPadding, 0, ScreenWidth-3*LeftRightPadding, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    return cell;
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

@end

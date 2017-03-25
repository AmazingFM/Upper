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
#import "UPCells.h"

@interface UPRulesController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray<UPInfoCellItem *> *rulesArr;
}
@property (nonatomic, retain) UITableView *mainTable;
@end

@implementation UPRulesController

- (instancetype)init
{
    self = [super init];
    if (self) {
        rulesArr = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动规则";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];

    NSString *rule1 = @"1、募集中的活动，随时可取消，一年内满十次，封停账号一个月（不可发起 可参与）；\
    \n2、募集成功的活动，如果发起者不能参加，建议先尝试寻找接替的发起人，将活动发起者身份转交给新的发起人。无法找到接替者也可以取消，一年满3次，封停账号半年； \
    \n3、可以点击“更改发起人”按钮，向目前报名人员发送站内信，发送接受链接。可以在发送之前通过站内短信和参与人员沟通接收意向。";
    
    NSString *rule2 = @"1、募集中的活动，参与者随时可退出，一年内满十次，封停账号一个月（不可发起 不可参与）；\
    \n2、成功的活动，参与者随时可退出，一年满三次，封停账号3个月。";
    
    NSString *rule3 = @"发起者未出现，任一参与者三天内可投诉，提供现场照片，人工确认后，永久封号参与者缺席，系统记录未签到状态。缺席两次则封停账号3个月。";
    
    UPInfoCellItem *infoItem1 = [[UPInfoCellItem alloc] init];
    infoItem1.title = @"取消规则";
    infoItem1.detail = rule1;
    
    UPInfoCellItem *infoItem2 = [[UPInfoCellItem alloc] init];
    infoItem2.title = @"退出规则";
    infoItem2.detail = rule2;

    UPInfoCellItem *infoItem3 = [[UPInfoCellItem alloc] init];
    infoItem3.title = @"投诉和缺席";
    infoItem3.detail = rule3;

    [rulesArr addObject:infoItem1];
    [rulesArr addObject:infoItem2];
    [rulesArr addObject:infoItem3];
    
    [rulesArr enumerateObjectsUsingBlock:^(UPInfoCellItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cellWidth = ScreenWidth;
        
        CGFloat offsety = 30;
        
        CGFloat hMargin = 10;
        CGFloat vMargin = 5;
        CGSize size = [UPTools sizeOfString:obj.detail withWidth:ScreenWidth-2*hMargin font:[UIFont systemFontOfSize:13]];
        
        offsety += vMargin+size.height;
        obj.cellHeight = offsety+5;
    }];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStyleGrouped];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.bounces = NO;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = RGBCOLOR(245, 245, 245);
    [_mainTable registerClass:[UPInfoCell class] forCellReuseIdentifier:@"cellId"];
    
    [self.view addSubview:_mainTable];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return rulesArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPInfoCellItem *infoItem = rulesArr[indexPath.section];
    return infoItem.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    UPInfoCellItem *infoItem = rulesArr[indexPath.section];
    cell.item = infoItem;
    return cell;
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

@end

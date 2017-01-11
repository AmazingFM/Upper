//
//  UPActTypeController.m
//  Upper
//
//  Created by 张永明 on 16/11/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActTypeController.h"
#import "UPGlobals.h"
#import "AppDelegate.h"

#define kRowHeight 40
#define kSectionHeight 30

@interface UPActTypeController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    
    NSArray *titles;
    NSMutableArray *subTitles;
    
    NSMutableArray *foldArr;
}

@end

@implementation UPActTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动类型";
    
    self.navigationItem.rightBarButtonItem = createBarItemTitle(@"取消",self, @selector(dismiss));
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorColor = [UIColor lightGrayColor];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.scrollEnabled = YES;
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    if([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]){
        [_mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_mainTableView];
    
    titles = @[@"聚会社交", @"体育运动", @"休闲娱乐", @"文化艺术", @"专业社交"];
    subTitles = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        [subTitles addObject:[NSMutableArray new]];
    }
    
    [g_appDelegate.actTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActTypeInfo *actInfo = (ActTypeInfo *)obj;
        
        unichar firstC = [actInfo.itemID characterAtIndex:0];
        
        if (firstC>='1' && firstC<='5') {
            NSMutableArray *arr = subTitles[firstC-'1'];
            [arr addObject:actInfo];
        }
        
        *stop = NO;
    }];
    
    
    foldArr = [NSMutableArray array];
    for (int i = 0; i < [titles count]; i++){
        [foldArr addObject:[NSNumber numberWithBool:i==0?NO:YES]];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, kSectionHeight)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.tag = 100+section;
    titleButton.frame = CGRectMake(5, 0, ScreenWidth-5, kSectionHeight);
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [titleButton setTitle:titles[section] forState:UIControlStateNormal];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [titleButton addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:titleButton];
    return bgView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *foldState = foldArr[section];
    if ([foldState boolValue]) {
        return 0;
    } else {
        NSArray *subArr = subTitles[section];
        return subArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *label = [cell viewWithTag:1000];
    if (label==nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, kRowHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag =1000;
        [cell addSubview:label];
    }
    NSArray *subArr = subTitles[indexPath.section];
    label.textColor = [UIColor lightGrayColor];
    ActTypeInfo *actInfo = subArr[indexPath.row];
       
    label.text = actInfo.actTypeName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(actionTypeDidSelect:)]) {
        
        NSArray *subArr = subTitles[indexPath.section];
        [self.delegate actionTypeDidSelect:subArr[indexPath.row]];
    }
    [self dismiss];
}

- (void)sectionClick:(UIButton *)sender
{
    int section = sender.tag-100;
    NSNumber *foldState = [foldArr objectAtIndex:section];
    
    [foldArr replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:![foldState boolValue]]];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([foldState boolValue]) {
        [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end

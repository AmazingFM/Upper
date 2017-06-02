//
//  SexSelectController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/29.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "SexSelectController.h"

@interface SexSelectController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sexList;
@end

@implementation SexSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"性别"];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.sexList = [NSArray arrayWithObjects:@"男",@"女",nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 74, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sexList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    if (self.sexIndex == row) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = self.sexList[row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSUInteger row = [indexPath row];
//    [self.parentController setDetail:[NSString stringWithFormat:@"%d", row] key:@"xingbie"];
//    [self.navigationController popViewControllerAnimated:YES];
}


@end

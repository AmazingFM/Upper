//
//  PersonInfoController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "PersonInfoController.h"
#import "SexSelectController.h"
#import "UpSettingController.h"

@interface PersonInfoController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *infoDict;
@end

/**
 @property (nonatomic, copy) NSString *birthday;
 @property (nonatomic, copy) NSString *creator_coin;
 @property (nonatomic, copy) NSString *creator_good_rate;
 @property (nonatomic, copy) NSString *creator_group;
 @property (nonatomic, copy) NSString *creator_level;
 @property (nonatomic, copy) NSString *ID;
 @property (nonatomic, copy) NSString *industry_id;
 @property (nonatomic, copy) NSString *industry_name;
 @property (nonatomic, copy) NSString *join_coin;
 @property (nonatomic, copy) NSString *join_good_rate;
 @property (nonatomic, copy) NSString *join_group;
 @property (nonatomic, copy) NSString *join_level;
 @property (nonatomic, copy) NSString *nick_name;
 @property (nonatomic, copy) NSString *node_id;
 @property (nonatomic, copy) NSString *node_name;
 @property (nonatomic, copy) NSString *sexual;
 @property (nonatomic, copy) NSString *true_name;
 @property (nonatomic, copy) NSString *user_icon;
 */

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"昵称",@"性别",@"发起者积分",@"发起者级别",@"发起者好评率",@"参与者积分",@"参与者级别",@"参与者好评率",@"行业",@"公司"];
    self.keys = @[@"nick_name",@"sexual",@"creator_coin",@"creator_group",@"creator_good_rate",@"join_coin",@"join_group",@"join_good_rate",@"industry_name",@"node_name"];
    self.infoDict = [NSMutableDictionary dictionary];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (self.userData==nil) {
        return cell;
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = self.titles[row];
    
    NSString * keyValue= [self.userData valueForKey:self.keys[row]];
    if (keyValue==nil || keyValue.length==0) {
        cell.detailTextLabel.text = @"";
    } else {
        if (row == 1) {//sex
            cell.detailTextLabel.text = [keyValue intValue]==0? @"男":@"女";
        }
        else{
            cell.detailTextLabel.text = keyValue;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

}

- (void)setDetail:(NSString *)value key:(NSString *)key
{
    [self.infoDict setObject:value forKey:key];
    [self.tableView reloadData];
}

- (void)setUserData:(OtherUserData *)userData
{
    _userData = userData;
    [self.tableView reloadData];
}

@end

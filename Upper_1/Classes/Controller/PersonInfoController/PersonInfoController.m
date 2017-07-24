//
//  PersonInfoController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "PersonInfoController.h"
#import "UpSettingController.h"

@interface PersonInfoController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *infoDict;
@end

/**
 @property (nonatomic, copy) NSString *birthday;
 @property (nonatomic, copy) NSString *city;
 @property (nonatomic, copy) NSString *city_code;
 @property (nonatomic, copy) NSString *creator_coin;
 @property (nonatomic, copy) NSString *creator_good_rate;
 @property (nonatomic, copy) NSString *creator_group;
 @property (nonatomic, copy) NSString *creator_level;
 @property (nonatomic, copy) NSString *ID;
 @property (nonatomic, copy) NSString *industry_id;
 @property (nonatomic, copy) NSString *industry_name;
 @property (nonatomic, copy) NSString *join_bad_sum;
 @property (nonatomic, copy) NSString *join_coin;
 @property (nonatomic, copy) NSString *join_good_rate;
 @property (nonatomic, copy) NSString *join_good_sum;
 @property (nonatomic, copy) NSString *join_group;
 @property (nonatomic, copy) NSString *join_level;
 @property (nonatomic, copy) NSString *nick_name;
 @property (nonatomic, copy) NSString *node_id;
 @property (nonatomic, copy) NSString *node_name;
 @property (nonatomic, copy) NSString *province;
 @property (nonatomic, copy) NSString *province_code;
 @property (nonatomic, copy) NSString *secret_flag;
 @property (nonatomic, copy) NSString *sexual;
 @property (nonatomic, copy) NSString *true_name;
 @property (nonatomic, copy) NSString *user_desc;
 @property (nonatomic, copy) NSString *user_icon;

 */

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    //@[@"性别",@"所在地", @"个人简介", @"所属行业", @"单位名称", @"发起人级别",@"好评率",@"参与者级别",@"参与者赞", @"参与者踩"]
    self.titles = @[@"性别",@"所在地", @"个人简介", @"所属行业", @"单位名称", @"发起人级别",@"参与者级别"];
    self.keys = @[@"sexual", @"city", @"user_desc", @"industry_name", @"node_name", @"creator_group",@"join_group"];
    self.infoDict = [NSMutableDictionary dictionary];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
#define kRowHeight 44
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellId";
    if (indexPath.row<5) {
        cellIdentifier = @"cellIdentifier_1";
    } else {
        cellIdentifier = @"cellIdentifier_2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([cellIdentifier isEqualToString:@"cellIdentifier_1"]) { //
            CGFloat titleWidth = 100;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleWidth, kRowHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.tag = 101;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = kUPThemeNormalFont;
            
            CGFloat detailX = CGRectGetMaxX(titleLabel.frame);
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailX, 0, ScreenWidth-detailX, kRowHeight)];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.tag = 102;
            detailLabel.textAlignment = NSTextAlignmentLeft;
            detailLabel.numberOfLines = 2;
            detailLabel.font = kUPThemeNormalFont;
            detailLabel.textColor = kUPThemeMainColor;

            [cell addSubview:titleLabel];
            [cell addSubview:detailLabel];
        } else if ([cellIdentifier isEqualToString:@"cellIdentifier_2"]) {
            CGFloat titleWidth = 100;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleWidth, kRowHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.tag = 201;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = kUPThemeNormalFont;
            
            CGFloat detailX = CGRectGetMaxX(titleLabel.frame);
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailX, 0, ScreenWidth/2-detailX, kRowHeight)];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.tag = 202;
            detailLabel.textAlignment = NSTextAlignmentLeft;
            detailLabel.font = kUPThemeNormalFont;
            detailLabel.textColor = kUPThemeMainColor;
            
            UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, kRowHeight)];
            rightTitleLabel.backgroundColor = [UIColor clearColor];
            rightTitleLabel.tag = 203;
            rightTitleLabel.textAlignment = NSTextAlignmentLeft;
            rightTitleLabel.font = kUPThemeNormalFont;
            rightTitleLabel.textColor = [UIColor blackColor];
            
            detailX = ScreenWidth/2+70;
            UILabel *rightDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailX, 0, ScreenWidth-detailX, kRowHeight)];
            rightDetailLabel.backgroundColor = [UIColor clearColor];
            rightDetailLabel.tag = 204;
            rightDetailLabel.textAlignment = NSTextAlignmentLeft;
            rightDetailLabel.font = kUPThemeNormalFont;
            rightDetailLabel.textColor = kUPThemeMainColor;

            [cell addSubview:titleLabel];
            [cell addSubview:detailLabel];
            [cell addSubview:rightTitleLabel];
            [cell addSubview:rightDetailLabel];
        }
    }
    if (self.userData==nil) {
        return cell;
    }

    NSInteger rowNum = indexPath.row;
    if (rowNum<5) {
        UILabel *titleLabel = [cell viewWithTag:101];
        titleLabel.text = self.titles[rowNum];
        
        UILabel *detailLabel = [cell viewWithTag:102];
        if (rowNum==0) {
            NSString *sexual = [self.userData valueForKey:self.keys[rowNum]];
            detailLabel.text = ([sexual intValue]==1)?@"男":@"女";
        } else  {
            detailLabel.text = [self.userData valueForKey:self.keys[rowNum]];
        }
    } else {
        UILabel *titleLabel = [cell viewWithTag:201];
        UILabel *detailLabel = [cell viewWithTag:202];
        
        titleLabel.text = self.titles[rowNum];
        detailLabel.text = [self.userData valueForKey:self.keys[rowNum]];
        
        UILabel *rightTitleLabel = [cell viewWithTag:203];
        UILabel *rightDetailLabel = [cell viewWithTag:204];
        if (rowNum==5) {
            rightTitleLabel.text = @"好评率";
            rightTitleLabel.textColor = [UIColor blackColor];
            NSString *creator_good_rate = [self.userData valueForKey:@"creator_good_rate"];
            rightDetailLabel.text = [UPTools percentNum:creator_good_rate];
            rightDetailLabel.textColor = kUPThemeMainColor;
        } else if (rowNum==6) {
            rightTitleLabel.text = [NSString stringWithFormat:@"👍(%@)👎(%@)", self.userData.join_good_sum, self.userData.join_bad_sum];
            rightTitleLabel.textColor = kUPThemeMainColor;
        }

    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

}

//- (void)setDetail:(NSString *)value key:(NSString *)key
//{
//    [self.infoDict setObject:value forKey:key];
//    [self.tableView reloadData];
//}

- (void)setUserData:(OtherUserData *)userData
{
    _userData = userData;
    [self.tableView reloadData];
}

@end

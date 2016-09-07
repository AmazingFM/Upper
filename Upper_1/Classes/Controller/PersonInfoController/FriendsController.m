//
//  FriendsController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "FriendsController.h"
#import "FriendCell.h"
@interface FriendsController ()

@property (nonatomic, retain) NSArray *tmpStr;
@end

@implementation FriendsController


static NSString *ID = @"FriendCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _tmpStr = [NSArray arrayWithObjects:@"sdfsadsfasf",@"水电费水电费撒地方",@"说的涩味发生的氛围为对方撒额服务的收费为啥地方额外的身份3位",@"史蒂夫违法苏打粉微风微风访问俄晚饭啊阿凡提会谈态度  突然很认同 ",@"玩儿分额挖掘；我哦啊我今儿颇为看发动机啊分就哦 i 我耳机的身份", nil];
    
    //注册表单元
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    NSUInteger row = [indexPath row];
    cell.nameLabel.text = @"李大霄";
    cell.sayLabel.text = _tmpStr[row];
    //@"李大霄报名参加了‘超级女生’";
    cell.headPic.image = [UIImage imageNamed:@"me"];
    cell.supposeLabel.text = @"赞";
    cell.activityPic.image = [UIImage imageNamed:@"act"];
    return cell;
}

/*
 返回每一行的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell layoutIfNeeded];
        
    CGFloat y=cell.sayLabel.y;
    CGFloat h=cell.sayLabel.height;
    
    NSLog(@"row:%d,%f,%f,%f", [indexPath row], y,h,cell.activityPic.height);
        
        
    return y + h+ 16+cell.activityPic.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
        {
            break;
        }
        case 1:
        {

            break;
        }
        case 2:
            //
            break;
        case 3:
            //
            break;
        default:
            break;
    }
    
}


@end

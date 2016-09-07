//
//  EnrollPeopleController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "EnrollPeopleController.h"
#import "PersonalCenterController.h"
#import "ChatController.h"
#import "UserData.h"
#import "Info.h"

#define EnrollCellFont [UIFont systemFontOfSize:15.0f]
static int const kCellHeight = 44;
static int const kPadding = 5;

@implementation EnrollCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15, kPadding, kCellHeight-kPadding*2, kCellHeight-kPadding*2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.cornerRadius = kCellHeight/2-kPadding;
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 0, ScreenWidth-kCellHeight, kCellHeight);
}

@end

@interface EnrollPeopleController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UILabel *noDataLabel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray<UserData *> *userArr;

@end

@implementation EnrollPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"参与人"];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startRequest];
}

- (NSMutableArray *)userArr
{
    if (_userArr==nil) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

- (void)initHeaderView
{
    UILabel *headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.text = @"活动参与人";
    _tableView.tableHeaderView = headerView;
}

#pragma mark-tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (cell == nil) {
        cell = [[EnrollCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
        
        UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chatButton.tag = 10;
        chatButton.frame = CGRectMake(0, 0, 80, kCellHeight-10);
        chatButton.backgroundColor = [UIColor redColor];
        [chatButton setTitle:@"发起聊天" forState:UIControlStateNormal];
        [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        chatButton.titleLabel.font = EnrollCellFont;
        [chatButton addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = chatButton;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.tag = indexPath.row;
    
    UserData *user= self.userArr[[indexPath row]];
    cell.textLabel.text = user.nick_name;
    cell.textLabel.font = EnrollCellFont;
    
    NSString *imageData = self.userArr[[indexPath row]].user_icon;
    UIImage *image = nil;
    if (imageData==nil || imageData.length==0) {
        image = [UIImage imageNamed:@"head"];
    } else {
        NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:imageData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image = [UIImage imageWithData:_decodedImageData];

    }
    cell.imageView.image = image;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PersonalCenterController *personalCenter = [[PersonalCenterController alloc] init];
    personalCenter.index = 0;
    
    OtherUserData *userData = [[OtherUserData alloc] init];
    userData.ID = ((UserData *)self.userArr[indexPath.row]).ID;
    userData.user_icon = ((UserData *)self.userArr[indexPath.row]).user_icon;
    userData.nick_name = ((UserData *)self.userArr[indexPath.row]).nick_name;
    personalCenter.user = userData;
    
    [self.navigationController pushViewController:personalCenter animated:YES];
}

- (void)startRequest
{
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoinInfo"forKey:@"a"];
    
    [params setObject:self.activityId forKey:@"activity_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        NSString *resp_desc = dict[@"resp_desc"];

        NSLog(@"%@:%@", resp_id, resp_desc);
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            int totalCount = [resp_data[@"total_count"] intValue];
            if (totalCount>0) {
                NSString *userList = resp_data[@"user_list"];
                
                if ([userList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *userDict in (NSArray *)userList) {
                        UserData *user = [[UserData alloc] init];
                        user.ID = userDict[@"user_id"];
                        user.nick_name = userDict[@"nick_name"];
                        user.sexual = userDict[@"sexual"];
                        user.user_icon = userDict[@"user_icon"];
                        
                        [self.userArr addObject:user];
                    }
                }
                [self.tableView reloadData];
            } else{
                //目前还没有参与者
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该活动目前无人参加，赶紧报名吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onBtnClick:(UIButton *)sender
{
    NSInteger row = ((UITableViewCell *)[sender superview]).tag;
    
    ChatController *chatController = [[ChatController alloc] init];
    chatController.userData = self.userArr[row];
    [self.navigationController pushViewController:chatController animated:YES];
}
@end
